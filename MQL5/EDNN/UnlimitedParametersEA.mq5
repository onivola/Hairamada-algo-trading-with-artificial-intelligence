//+------------------------------------------------------------------+
//|                                        UnlimitedParametersEA.mq5 |
//|            Copyright 2013, https://login.mql5.com/ru/users/tol64 |
//|                                  Site, http://tol64.blogspot.com |
//+------------------------------------------------------------------+
#property copyright   "Copyright 2013, http://tol64.blogspot.com"
#property link        "http://tol64.blogspot.com"
#property description "email: hello.tol64@gmail.com"
#property version     "1.0"
//--- Name of the Expert Advisor
#define EXPERT_NAME MQL5InfoString(MQL5_PROGRAM_NAME)
//--- Number of tested/optimized parameters
#define TESTED_PARAMETERS_COUNT 8
//--- Include a class of the Standard Library
#include <Trade/Trade.mqh>
//--- Load the class
CTrade   trade;
//--- Include custom libraries
#include <Enums.mqh>
#include <InitializeArrays.mqh>
#include <Errors.mqh>
#include <FileFunctions.mqh>
#include <TradeSignals.mqh>
#include <TradeFunctions.mqh>
#include <ToString.mqh>
#include <Auxiliary.mqh>
//--- External parameters of the Expert Advisor
sinput long                      MagicNumber          =777;      // Magic number
sinput int                       Deviation            =10;       // Slippage
sinput string                    delimeter_00=""; // --------------------------------
sinput int                       SymbolNumber         =1;        // Number of the tested symbol
sinput bool                      RewriteParameters    =false;    // Rewriting parameters
sinput ENUM_INPUTS_READING_MODE  ParametersReadingMode=FILE;     // Parameter reading mode
sinput string                    delimeter_01=""; // --------------------------------
input  int                       IndicatorPeriod      =5;        // Indicator period
input  double                    TakeProfit           =100;      // Take Profit
input  double                    StopLoss             =50;       // Stop Loss
input  double                    TrailingStop         =10;       // Trailing Stop
input  bool                      Reverse              =true;     // Position reversal
input  double                    Lot                  =0.1;      // Lot
input  double                    VolumeIncrease       =0.1;      // Position volume increase
input  double                    VolumeIncreaseStep   =10;       // Volume increase step
//--- Number of traded symbols. It is calculated and depends on the testing mode and the number of symbols in the file
int SYMBOLS_COUNT=0;

//--- Arrays of input parameters
string InputSymbols[];            // Symbol names
//---
int    InputIndicatorPeriod[];    // Indicator periods
double InputTakeProfit[];         // Take Profit values
double InputStopLoss[];           // Stop Loss values
double InputTrailingStop[];       // Trailing Stop values
bool   InputReverse[];            // Values of position reversal flags
double InputLot[];                // Lot values
double InputVolumeIncrease[];     // Position volume increases
double InputVolumeIncreaseStep[]; // Volume increase steps
//--- Array of indicator agent handles
int spy_indicator_handles[];
//--- Array of signal indicator handles
int signal_indicator_handles[];
//--- Data arrays for checking trading conditions
struct PriceData
  {
   double            value[];
  };
PriceData open[];      // Opening price of the bar
PriceData high[];      // High price of the bar
PriceData low[];       // Low price of the bar
PriceData close[];     // Closing price of the bar
PriceData indicator[]; // Array of indicator values
//--- Arrays for getting the opening time of the current bar
struct Datetime
  {
   datetime          time[];
  };
Datetime lastbar_time[];
//--- Array for checking the new bar for each symbol
datetime new_bar[];
//--- Array of input parameter names for writing to the file
string input_parameters_names[TESTED_PARAMETERS_COUNT]=
  {
   "IndicatorPeriod",   // Indicator period
   "TakeProfit",        // Take Profit
   "StopLoss",          // Stop Loss
   "TrailingStop",      // Trailing Stop
   "Reverse",           // Position reversal
   "Lot",               // Lot
   "VolumeIncrease",    // Position volume increase
   "VolumeIncreaseStep" // Volume increase step
  };
//--- Array for untested symbols
string temporary_symbols[];
//--- Array for storing input parameters from the file of the symbol selected for testing or trading
double tested_parameters_from_file[];
//--- Array of input parameter values for writing to the file
double tested_parameters_values[TESTED_PARAMETERS_COUNT];
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
void OnInit()
  {
//--- Initialize the array of tested input parameters for writing to the file
   InitializeTestedParametersValues();
//--- Fill the array of symbol names
   InitializeInputSymbols();
//--- Set the size of arrays of input parameters
   ResizeInputParametersArrays();
//--- Initialize arrays of indicator handles
   InitializeIndicatorHandlesArrays();
//--- Initialize arrays of input parameters depending on the operation mode of the Expert Advisor
   InitializeInputParametersArrays();
//--- Get agent handles from the "EventsSpy.ex5" indicator
   GetSpyHandles();
//--- Get indicator handles
   GetIndicatorHandles();
//--- Initialize the new bar
   InitializeNewBarArray();
//--- Initialize price arrays and indicator buffers
   ResizeDataArrays();
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- Print the deinitialization reason to the journal
   Print(GetDeinitReasonText(reason));
//--- When deleting from the chart
   if(reason==REASON_REMOVE)
     {
      //--- Delete the indicator handles
      for(int s=0; s<SYMBOLS_COUNT; s++)
        {
         IndicatorRelease(spy_indicator_handles[s]);
         IndicatorRelease(signal_indicator_handles[s]);
        }
     }
  }
//+------------------------------------------------------------------+
//| Chart events handler                                             |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,         // Event identifier
                  const long &lparam,   // Long type event parameter
                  const double &dparam, // Double type event parameter
                  const string &sparam) // String type event parameter
  {
//--- If this is a custom event
   if(id>=CHARTEVENT_CUSTOM)
     {
      //--- Exit if trading is not allowed
      if(CheckTradingPermission()>0)
         return;
      //--- If there was a tick event
      if(lparam==CHARTEVENT_TICK)
        {
         //--- Check signals and trade on them
         CheckSignalsAndTrade();
         return;
        }
     }
  }
//+------------------------------------------------------------------+
//| Checking signals and trading based on the new bar event          |
//+------------------------------------------------------------------+
void CheckSignalsAndTrade()
  {
//--- Iterate over all specified symbols
   for(int s=0; s<SYMBOLS_COUNT; s++)
     {
      //--- If the symbol name is correct
      if(InputSymbols[s]!="")
        {
         //--- If the bar is not new, proceed to the next symbol
         if(!CheckNewBar(s))
            continue;
         //--- If there is a new bar
         else
           {
            //--- Get indicator data. If there is no data, proceed to the next symbol
            if(!GetDataIndicators(s))
               continue;
            //--- Get bar data               
            GetBarsData(s);
            //--- Check the conditions and trade
            TradingBlock(s);
            //--- Trailing Stop
            ModifyTrailingStop(s);
           }
        }
     }
  }
//+------------------------------------------------------------------+
