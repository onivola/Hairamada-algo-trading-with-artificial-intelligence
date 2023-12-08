//+------------------------------------------------------------------+
//|                                             Indicator_export.mq5 |
//|                                               Vasileios Zografos |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//--- show the window of input parameters when launching the script
#property script_show_inputs
//--- parameters for receiving data from the terminal
input string             InpSymbolName="Crash 500 Index";           // currency pair
input ENUM_TIMEFRAMES    InpSymbolPeriod=PERIOD_M30;        // time frame
input int                InpFastEMAPeriod=12;              // fast EMA period
input int                InpSlowEMAPeriod=26;              // slow EMA period
input int                InpSignalPeriod=9;                // difference averaging period
input ENUM_APPLIED_PRICE InpAppliedPrice=PRICE_CLOSE;      // price type
input datetime           InpDateStart=D'2022.01.01 00:00'; 

//--- parameters for writing data to file
input string             InpFileName="ma0202.csv";  // file name
input string             InpDirectoryName="Data"; // directory name
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+

float iMA(int n,ENUM_TIMEFRAMES periode,int ma_period,ENUM_MA_METHOD ma_method) {
   
   int signal;
   double myPriceArray[];
   int iACDefinition = iMA(_Symbol,periode,ma_period,0,ma_method,PRICE_CLOSE);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,0,0,30,myPriceArray); 
    //Print(myPriceArray[2]);
   float iACValue = myPriceArray[n];
   return iACValue;
}

int IMAHandle(ENUM_TIMEFRAMES periode,int ma_period,ENUM_MA_METHOD ma_method) {
   int ma_handle12=iMA(_Symbol,periode,ma_period,0,ma_method,PRICE_CLOSE);
   if(ma_handle12==INVALID_HANDLE)
   {
      //--- failed to receive indicator handle
      PrintFormat("Error when receiving indicator handle. Error code = %d",GetLastError());
      return 0;  
   }
   //--- being in the loop until the indicator calculates all its values
   while(BarsCalculated(ma_handle12)==-1)
      Sleep(10); // pause to allow the indicator to calculate all its values
   return ma_handle12;
}
int RSIAHandle() {
   int rsi_handle12=iRSI(_Symbol,PERIOD_M1,5,PRICE_CLOSE);
   if(rsi_handle12==INVALID_HANDLE)
   {
      //--- failed to receive indicator handle
      PrintFormat("Error when receiving indicator handle. Error code = %d",GetLastError());
      return 0;  
   }
   //--- being in the loop until the indicator calculates all its values
   while(BarsCalculated(rsi_handle12)==-1)
      Sleep(10); // pause to allow the indicator to calculate all its values
   return rsi_handle12;
}

void OnStart()
  {

   bool     sign_buff[]; // signal array (true - buy, false - sell)
   datetime time_buff[]; // array of signals' arrival time
   int      sign_size=0; // signal array size
   double   ma_buff5[]; // array of indicator values
    double   ma_buff12[]; // array of indicator values
    double   rsi_buff5[]; // array of indicator values
   datetime date_buff[]; // array of indicator dates
   int      ma_size=0; // size of indicator arrays
//--- end time is the current time
   datetime date_finish=TimeCurrent();
   Print(date_finish);
//--- receive MACD indicator handle
   ResetLastError();
   

   
   int ma_handle5 = IMAHandle(PERIOD_M1,5,MODE_LWMA);
   int ma_handle12 = IMAHandle(PERIOD_M1,12,MODE_LWMA);
   ResetLastError();
   if(CopyBuffer(ma_handle5,0,InpDateStart,date_finish,ma_buff5)==-1)
     {
      PrintFormat("Failed to copy indicator values. Error code = %d",GetLastError());
      return;
     }
     ResetLastError();
      if(CopyBuffer(ma_handle12,0,InpDateStart,date_finish,ma_buff12)==-1)
     {
      PrintFormat("Failed to copy indicator values. Error code = %d",GetLastError());
      return;
     }
     ResetLastError();
//--- free the memory occupied by the indicator
   IndicatorRelease(ma_handle5);
    IndicatorRelease(ma_handle12);

//--- open the file for writing the indicator values (if the file is absent, it will be created automatically)
   ResetLastError();
   
   
    
   int rsi_handle5 = RSIAHandle();
   ResetLastError();
   if(CopyBuffer(rsi_handle5,0,InpDateStart,date_finish,rsi_buff5)==-1)
     {
      PrintFormat("Failed to copy indicator values. Error code = %d",GetLastError());
      return;
     }
     ResetLastError();
    IndicatorRelease(rsi_handle5);

//--- open the file for writing the indicator values (if the file is absent, it will be created automatically)
   ResetLastError();
   
   
   
   int file_handle=FileOpen(InpDirectoryName+"//"+InpFileName,FILE_READ|FILE_WRITE|FILE_CSV);
   if(file_handle!=INVALID_HANDLE)
     {
      PrintFormat("%s file is available for writing",InpFileName);
      PrintFormat("File path: %s\\Files\\",TerminalInfoString(TERMINAL_DATA_PATH));
      //--- first, write the number of signals
      FileWrite(file_handle,"i,MA5,MA12,RSI");
      //--- write the time and values of signals to the file
      for(int i=0;i<ArraySize(ma_buff12);i++)
         FileWrite(file_handle,i+","+ma_buff5[i]+","+ma_buff12[i]+","+rsi_buff5[i]);
      //--- close the file
      FileClose(file_handle);
      PrintFormat("Data is written, %s file is closed",InpFileName);
     }
   else
      PrintFormat("Failed to open %s file, Error code = %d",InpFileName,GetLastError());
  }
  
 