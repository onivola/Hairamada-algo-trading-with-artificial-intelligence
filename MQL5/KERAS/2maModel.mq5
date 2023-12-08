//+------------------------------------------------------------------+
//|                                                          2ma.mq5 |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
ENUM_TIMEFRAMES PERIOD = PERIOD_M1;
#include <Hairabot\Utils.mq5>
#include <Trade\Trade.mqh>
input string             InpDirectoryName="Data"; // directory name
input string             InpSymbolName="Crash 500 Index";  
input string             InpFileName="datasettest.csv";
input string             InpFileName2="dataset.txt";

input string             InpFilePredict="predict.csv";
double nb_pos = 0;
float iMA(int n,ENUM_TIMEFRAMES periode,int ma_period,ENUM_MA_METHOD ma_method) {
   
   int signal;
   double myPriceArray[];
   int iACDefinition = iMA(_Symbol,periode,ma_period,0,ma_method,PRICE_CLOSE);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,0,0,50,myPriceArray); 
    //Print(myPriceArray[2]);
   float iACValue = myPriceArray[n];
   return iACValue;
}
int CheckEMA(ENUM_TIMEFRAMES periode,double ema01,double ema02,double ema1,double ema2) {

   if(ema01>ema02 && ema1<ema2) {
      return 0;
   } else if(ema01<ema02 && ema1>ema2) {
      return 1;
    }
   return 2;
}

double Read_Predict()
{
   
  //--- open the file
   ResetLastError();
   int file_handle=FileOpen(InpDirectoryName+"//"+InpFileName,FILE_READ|FILE_BIN|FILE_ANSI|FILE_COMMON);
   if(file_handle!=INVALID_HANDLE)
     {
      PrintFormat("%s file is available for reading",InpFileName);
      PrintFormat("File path: %s\\Files\\",TerminalInfoString(TERMINAL_DATA_PATH));
      //--- additional variables
      int    str_size;
      string str;
      //--- read data from the file
      while(!FileIsEnding(file_handle))
        {
         //--- find out how many symbols are used for writing the time
         str_size=FileReadInteger(file_handle,INT_VALUE);
         //--- read the string
         str=FileReadString(file_handle,str_size);
         //--- print the string
         PrintFormat(str);
        }
      //--- close the file
      FileClose(file_handle);
      PrintFormat("Data is read, %s file is closed",InpFileName);
     }
   else
      PrintFormat("Failed to open %s file, Error code = %d",InpFileName,GetLastError());
   return 1;
}
  int OnInit()
  {
//---
    string res = Read_Predict();
//---
   return(INIT_SUCCEEDED);
  }
void OnTick()
  {
     
      double ema05 = iMA(0,PERIOD,5,MODE_LWMA);
      double ema012 = iMA(0,PERIOD,12,MODE_LWMA);
      double ema15 = iMA(1,PERIOD,5,MODE_LWMA);
      double ema112 = iMA(1,PERIOD,12,MODE_LWMA);
      double ma_buff5[];
      double ma_buff12[];
      int posTotal = getSymbolPositionTotal(_Symbol);
      bool isdataset = BuildDataset(ma_buff5,ma_buff12,15);
      if(posTotal<=0 && isdataset) {
         //BuyPosition();
         nb_pos = nb_pos+1;
         Print("nb_pos"+nb_pos);
         SaveDataset(ma_buff5,ma_buff12,nb_pos);

           
      }
      
      double profit = AccountInfoDouble(ACCOUNT_PROFIT);
      if(posTotal>0 && profit>=0.2*4 || profit<=-1) {
         close(_Symbol);
      }
  }
  
 double GetPredict() {
   int file_handle=FileOpen(InpFilePredict,FILE_ANSI|FILE_READ|FILE_CSV|FILE_COMMON,',');
   if(file_handle!=INVALID_HANDLE)
     {
      PrintFormat("%s file is available for reading",InpFilePredict);
      PrintFormat("File path: %s\\Files\\",TerminalInfoString(TERMINAL_DATA_PATH));
      //--- additional variables
      int    str_size;
      string str;
      //--- read data from the file
      while(!FileIsEnding(file_handle))
        {
         //--- find out how many symbols are used for writing the time
         str_size=FileReadInteger(file_handle,INT_VALUE);
         //--- read the string
         str=FileReadString(file_handle,str_size);
         //--- print the string
         PrintFormat(str);
         FileClose(file_handle);
        
        }
      //--- close the file
       return double(str);
      PrintFormat("Data is read, %s file is closed",InpFilePredict);
     }
   else
      PrintFormat("Failed to open %s file, Error code = %d",InpFilePredict,GetLastError());
   return -1;
}
bool BuildDataset(double& ma_buff5[],double& ma_buff12[],double size) {
   ArrayResize(ma_buff5,size);
   ArrayResize(ma_buff12,size);
   //Print(ArraySize(ma_buff12));
   double ma_5 = iMA(0,PERIOD,5,MODE_LWMA);
    double ma_12 = iMA(0,PERIOD,12,MODE_LWMA);
     double ma1_5 = iMA(1,PERIOD,5,MODE_LWMA);
   double ma1_12 = iMA(1,PERIOD,12,MODE_LWMA);
   if(ma_5 > ma_12 && ma1_5 <= ma1_12) {
      for(int i=0;i<size;i++) {
         ma_buff5[i] = iMA(i,PERIOD,5,MODE_LWMA);
         ma_buff12[i] = iMA(i,PERIOD,12,MODE_LWMA);
         Print(ma_buff12[i]);
      }
      return true;
   }
   return false;
   
   
}
bool SaveDataset(double& ma_buff5[],double& ma_buff12[],double nb_pos) {

    int file_handle=FileOpen(InpFileName,FILE_READ|FILE_WRITE|FILE_CSV|FILE_COMMON,',');
   //int file_handle=FileOpen(InpDirectoryName+"//"+InpFileName,FILE_READ|FILE_WRITE|FILE_CSV);
   if(file_handle!=INVALID_HANDLE)
     {
      PrintFormat("%s file is available for writing",InpFileName);
      PrintFormat("File path: %s\\Files\\",TerminalInfoString(TERMINAL_DATA_PATH));
      //--- first, write the number of signals
      FileWrite(file_handle,"i,MA5,MA12");
      //--- write the time and values of signals to the file
      for(int i=0;i<ArraySize(ma_buff12);i++)
         FileWrite(file_handle,i+","+ma_buff5[i]+","+ma_buff12[i]);
      //--- close the file
      FileWrite(file_handle,"nb_post,"+nb_pos+","+nb_pos);
      FileClose(file_handle);
      PrintFormat("Data is written, %s file is closed",InpFileName);
     }
   else
      PrintFormat("Failed to open %s file, Error code = %d",InpFileName,GetLastError());

   return true;
}

//+------------------------------------------------------------------+

void close(string symbolName){   

   CTrade trade;

   if(PositionSelectByTicket(getLastTicket(symbolName))){

      trade.PositionClose(PositionGetInteger(POSITION_TICKET));

   }
}
bool BuyPosition() {
   CTrade trade;

   if(trade.Sell(0.2,_Symbol,0,0,0)){ 
      return true;
   }
  return false;
}
 bool SellPosition() {
   CTrade trade;
   if(trade.Sell(0.2,_Symbol,0,0,0)){  
      return true;
   }
   return false;

}
int Seconds()
{
  datetime time = (uint)TimeCurrent();
  return((int)time % 60);
}