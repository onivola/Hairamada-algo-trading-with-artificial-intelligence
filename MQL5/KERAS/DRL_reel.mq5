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
input string             InpSymbolName="Volatility 75 Index";  
input string             InpFileName="datasetDRL.csv";
input string             InpFileName2="datasetDRL.txt";

input string             InpFilePredict="predictDRL.csv";
double nb_pos = 0;
double last_predict = -10;
double predict = 0;
bool pas = false;
int isbuy = 2;
bool ebuy = false;
 double saved = false;
 input double Lot = 0.2;
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
   int file_handle=FileOpen(InpDirectoryName+"//"+InpFilePredict,FILE_ANSI|FILE_READ|FILE_CSV);
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
bool getChandelierbyIndiceDRL(string symbolName, ENUM_TIMEFRAMES timeframe, int nbPeriod, double& result[],int Indice){
   double min = 0.0;
      double max = 0.0;
   MqlRates rates[];

   ArrayResize(result, 5);
   ArraySetAsSeries(rates, true);
   
   if(CopyRates(symbolName, timeframe, 1, nbPeriod, rates) == nbPeriod){

      min = rates[Indice].low;
      max = rates[Indice].high;
      double open = rates[Indice].open;
      double close = rates[Indice].close;
      double diffPrice = MathAbs(min-max);
 //Print("SSSSSSSSSSSSSSSSSSSSSSSSSSSSSS="+(string)ArraySize(rates));
      //Print(rates[Indice].time);
      //Print(rates[19].low);
      result[0] = min;
      result[1] = max;
       result[2] = open;
      result[3] = close;
      result[4] = rates[Indice].tick_volume;
      //time = rates[Indice].time;
      return true;

   }
  
   return false;


}
bool is_saved() {
   double result[];
   bool datasave = SaveDataset(result);
   if(datasave==true) { //dataset insert
      return true;
   }
   return false;
   
}
void OnTick()
  {
      double second = Seconds(60);
      int posTotal = getSymbolPositionTotal(_Symbol);
      
       if(second>=0 && second<=2 && saved == false) {
           if(is_saved()) {
               saved = true;
           }
       }
       if(saved==true  && second>2) {
         while(saved==true) {
         predict = GetPredict();
         Print(predict);
         if(predict!=last_predict && predict!=-1) {
            if(predict>=1 && predict<10000000) {
               if(posTotal<=1  && (isbuy==0 || isbuy==2)) {
                  CloseAll(_Symbol);
                  BuyPosition();
               }
            
            isbuy =1;
           }
            if(predict<=-1) {
               if(posTotal<=1  && (isbuy==1 || isbuy==2)) {
                  CloseAll(_Symbol);
                  SellPosition();
               
               }
               isbuy=0;
            }
            if(predict>=10000000) {
               Print("close");
               CloseAll(_Symbol);
               isbuy = 2;
            }
            last_predict = predict;
            saved = false;
            return;
       }
       }
         
         }
         
       
       
       
       
      
     Print(second);
     

      //double profit = AccountInfoDouble(ACCOUNT_PROFIT);
      /*if((second>=178)) {
         //close(_Symbol);
         //pas = false;
      }*/
  }
  
 double GetPredict() {
   int file_handle=FileOpen(InpDirectoryName+"//"+InpFilePredict,FILE_ANSI|FILE_READ|FILE_CSV);
   if(file_handle!=INVALID_HANDLE)
     {
      PrintFormat("%s file is available for reading",InpFilePredict);
      PrintFormat("File path: %s\\Files\\",TerminalInfoString(TERMINAL_DATA_PATH));
      //--- additional variables
      int    str_size;
      string str=-1;
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
        FileDelete(InpFilePredict);
      //--- close the file
       return double(str);
      PrintFormat("Data is read, %s file is closed",InpFilePredict);
     }
   else
      PrintFormat("Failed to open %s file, Error code = %d",InpFilePredict,GetLastError());
   return -1;
}

bool SaveDataset(double& data[]) {

     int file_handle=FileOpen(InpDirectoryName+"//"+InpFileName,FILE_READ|FILE_WRITE|FILE_CSV);
   //int file_handle=FileOpen(InpDirectoryName+"//"+InpFileName,FILE_READ|FILE_WRITE|FILE_CSV);
   if(file_handle!=INVALID_HANDLE)
     {
      nb_pos = nb_pos+1;
            Print("nb_pos"+nb_pos);
      PrintFormat("%s file is available for writing",InpFileName);
      PrintFormat("File path: %s\\Files\\",TerminalInfoString(TERMINAL_DATA_PATH));
      //--- first, write the number of signals
      FileWrite(file_handle,"i,open,high,low,close,tick_volume");
      //--- write the time and values of signals to the file
      double result[];
      for(int i=0;i<200;i++) {
         getChandelierbyIndiceDRL(_Symbol, PERIOD_M1, 300,result,i);
         FileWrite(file_handle,i+","+result[2]+","+result[1]+","+result[0]+","+result[3]+","+result[4]);
      }
      //--- close the file
      FileWrite(file_handle,"nb_post,"+nb_pos);
      FileClose(file_handle);
      //PrintFormat("Data is written, %s file is closed",InpFileName);
      return true;
     }
   else {
      //PrintFormat("Failed to open %s file, Error code = %d",InpFileName,GetLastError());
      return false;
   }
      
}

//+------------------------------------------------------------------+
 bool CloseAll(string symbolName){   

     int Positionsforthissymbol=0;
   
   for(int i=PositionsTotal()-1; i>=0; i--)
   {
      string symbol=PositionGetSymbol(i);

         if(Symbol()==symbol)
           {
            Positionsforthissymbol+=1;
           }
   }
   
double profit[];
 ArrayResize(profit,20);
if(Positionsforthissymbol>0)
   {
      for(int i=0; i<Positionsforthissymbol; i++)
      {
         if(PositionSelect(_Symbol)==true)
         {
          
               close(_Symbol);
            
         }
      }
   }
   return true;
}
void close(string symbolName){   

   CTrade trade;

       if(PositionSelectByTicket(getLastTicket(symbolName))){

            trade.PositionClose(PositionGetInteger(POSITION_TICKET));
      
         }

  
}
bool SellPosition() {
   CTrade trade;

   if(trade.Sell(Lot,_Symbol,0,0,0)){ 
      return true;
   }
  return false;
}
bool BuyPosition() {
   CTrade trade;

   if(trade.Buy(Lot,_Symbol,0,0,0)){ 
      return true;
   }
  return false;
}

int Seconds(double second)
{
  datetime time = (uint)TimeCurrent();
  return((int)time % (360));
}
