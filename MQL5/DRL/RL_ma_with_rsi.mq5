//+------------------------------------------------------------------+
//|                                                    spikeback.mq5 |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Trade\Trade.mqh>
#include <Hairabot\Utils.mq5>

#include <RL gmdh.mqh>
#include <Trade\AccountInfo.mqh>
double lasttime = 0;
input double slb = 10;
input double tpb = 10;
input double sls = 10;
input double tps = 10;


input double EnterSell = 80;
input double EnterBuy = 20;
input double Lot = 0.2;

int pos = 2;
static datetime last_time=0;

double sig1;
int Handle;

double RSIBuffer[];
double RSIOnMABuffer[];
double MAOnRSIBuffer[];
double spickArray[];
input ENUM_TIMEFRAMES      InpWorkingPeriod     = PERIOD_M1; // Working timeframe
//input ushort               InpSignalsFrequency  = 10;             // Search signals, in seconds (< "10" -> only on a new bar)
input group             "Position size management (lot calculation)"
input double               InpVolumeLotOrRisk   = 3.0;            // The value for "Money management"
input group             "RSIOnMAOnRSI"
input int                  Inp_MA_ma_period     = 21;          // MA: averaging period
input int                  Inp_MA_ma_shift      = 0;           // MA: horizontal shift
input ENUM_MA_METHOD       Inp_MA_ma_method     = MODE_SMA;    // MA: smoothing type
input ENUM_APPLIED_PRICE   Inp_MA_applied_price = PRICE_CLOSE; // MA: type of price
input int                  Inp_RSI_ma_period    = 14;          // RSI: averaging period
input color                Inp_RSI_Level_Color  = clrDimGray;  // Color line Levels
input double               Inp_RSI_Level_Down   = 20.0;        // Value Level Down
input double               Inp_RSI_Level_Middle = 50.0;        // Value Level Middle
input double               Inp_RSI_Level_Up     = 80.0;        // Value Level Up
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   ArrayResize(RSIBuffer,200);
      ArraySetAsSeries(RSIBuffer,true);
       ArrayResize(RSIOnMABuffer,200);
      ArraySetAsSeries(RSIOnMABuffer,true);
       ArrayResize(MAOnRSIBuffer,200);
      ArraySetAsSeries(MAOnRSIBuffer,true);
   ArrayResize(spickArray,3);
   spickArray[0]=0;
   spickArray[1]=0;
   spickArray[2]=0;
  
   Handle = iCustom(_Symbol,InpWorkingPeriod,"RSIOnMAOnRSI",
                          Inp_MA_ma_period,
                          Inp_MA_ma_shift,
                          Inp_MA_ma_method,
                          Inp_MA_applied_price,
                          Inp_RSI_ma_period,
                          Inp_RSI_Level_Color,
                          Inp_RSI_Level_Down,
                          Inp_RSI_Level_Middle,
                          Inp_RSI_Level_Up);
   if(Handle == INVALID_HANDLE){
      return(INIT_FAILED);
   }
 
   return(INIT_SUCCEEDED);
  }
  
  void AroonIndicatorProcessor()
   {

     

      //https://www.mql5.com/en/docs/series/copybuffer
      // Aroon_handle represent information captured from Icustom 
      // 0 represent first, 1 represent second buffer as it is arranged in your indicator code section >>>As for my indicator there are only two outputs as there are only 2 buffers
      // 0 represent start position 
      // 3 represent buffer 0, 1 & 2 copy 
      // AroonBull reprenet declared array created to indicator output values
       CopyBuffer(Handle,0,0,300,RSIBuffer);
      CopyBuffer(Handle,1,0,300,RSIOnMABuffer);
     
      CopyBuffer(Handle,2,0,300,MAOnRSIBuffer);
     // calcSignal();
  // placeOrders();
      //return true;
  
      
   }
  
//+------------------------------------------------------------------+
//| Expert ontester function                                         |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
double GetTmpPrice() {
   MqlTick Latest_Price; // Structure to get the latest prices      
   SymbolInfoTick(Symbol() ,Latest_Price); // Assign current prices to structure 

// The BID price.
   static double dBid_Price; 

// The ASK price.
   static double dAsk_Price; 

   dBid_Price = Latest_Price.bid;  // Current Bid price.
   dAsk_Price = Latest_Price.ask;  // Current Ask price.
   
   
   //Print("dBid_Price="+(string)dBid_Price);
   //Print("dAsk_Price="+(string)dAsk_Price);
   
   return dBid_Price;
}

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+


bool BuyPosition() {
   CTrade trade;
   double current = GetTmpPrice();
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
     if(trade.Buy(Lot,_Symbol,0,current-slb,current+tpb)){
      int code = (int)trade.ResultRetcode();
      ulong ticket = trade.ResultOrder();
      Print("Code:"+(string)code);
      Print("Ticket:"+(string)ticket);  
      return true;
   }
  return false ;
 }
 
void close1(string symbolName){   

   CTrade trade;

   if(PositionSelectByTicket(getLastTicket(symbolName))){

      trade.PositionClose(PositionGetInteger(POSITION_TICKET));

   }
}
bool SellPosition() {
   CTrade trade;
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
    double current = GetTmpPrice();
   
  
   //globSellSL = current +4000;
   if(trade.Sell(Lot,_Symbol,0,current+sls,current-tps)){
      int code = (int)trade.ResultRetcode();
      ulong ticket = trade.ResultOrder();
      Print("Code:"+(string)code);
      Print("Ticket:"+(string)ticket);  
      return true ;
   }
   return false;

}
void OnTick()
  {


  int posTotal = getSymbolPositionTotal(_Symbol);
    AroonIndicatorProcessor();
    Print(RSIOnMABuffer[0]);
  if( posTotal<=0 && RSIOnMABuffer[0]<EnterBuy) {
       BuyPosition();
     
      
  }
  if(posTotal<=0 && RSIOnMABuffer[0]>EnterSell) {
       
     SellPosition();
      
  }
  /* double profit = AccountInfoDouble(ACCOUNT_PROFIT);
  if(second>=58 && posTotal>0) {
      close1(_Symbol);
      isspike = false;
  }*/
//---
   
  }
//+------------------------------------------------------------------+
