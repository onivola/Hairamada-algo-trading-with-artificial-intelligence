//+------------------------------------------------------------------+
//|                                                StrategySpike.mq5 |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Trade\Trade.mqh>
#include "\..\..\Experts\FANN\include\volume.mqh"
CTrade trade;
double MIN5 = 0;
double MAX5 =0;

double MIN2 = 0;
double MAX2 =0;

double MIN50 = 0;
double MAX50 =0;

double MINT = 0;
double MAXT =0;
int isbuy = false;
int spike =0;
bool converge=false;
bool position=false;
double spike1 = 0;
double spike2 = 0;
input double zoom = 47;

double QBUY = 0;
double QSELL = 0;

input double TP_BUY=20;
input double SL_BUY=20;
input double cstBuyA = 0;
input double cstBuyB = -200;
input double cstBuyA2 = 0;
input double cstBuyB2 = 200;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   GetQuantite(QBUY,QSELL);
//---
   return(INIT_SUCCEEDED);
  }

bool BuyPosition(double Lot,double SL,double TP) { //buy sl tp
   CTrade trade;
   double  price = GetTmpPrice();
   if(trade.Buy(Lot,_Symbol,0,price-SL,price+TP)){
      int code = (int)trade.ResultRetcode();
      double ticket = trade.ResultOrder();
      return true ;
   }
   return false;

}
bool SellPosition(double Lot,double SL,double TP) { //sell sl tp
   CTrade trade;
   double  price = GetTmpPrice();
   if(trade.Sell(Lot,_Symbol,0,price+SL,price-TP)){
      int code = (int)trade.ResultRetcode();
      double ticket = trade.ResultOrder();
      return true ;
   }
   return false;

}
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
void Ichimoku(int n,double &TENKANSEN[]){
         int Ichi = iIchimoku(_Symbol,PERIOD_M1,9,26,52);
          ArraySetAsSeries(TENKANSEN,false);
         CopyBuffer(Ichi,0,0,n,TENKANSEN);
 }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void MovingAverage_Zoom(double &ma[],int ma_period,ENUM_TIMEFRAMES periode,ENUM_MA_METHOD ma_method) {


   int iACDefinition = iMA(_Symbol,periode,ma_period,0,ma_method,PRICE_CLOSE);
   ArraySetAsSeries(ma,false);
   CopyBuffer(iACDefinition,0,0,zoom+1,ma); 
   //Print("MACD="+macd[0]);
  // Print(macd[n]);
}
void Get_Min_Max(double &MAX,double &MIN,int ma_period,ENUM_TIMEFRAMES periode,ENUM_MA_METHOD ma_method) {
   double MovingAverage[];
    ArrayResize(MovingAverage,zoom+1);

  MovingAverage_Zoom(MovingAverage, ma_period,periode, ma_method);
   
   
int max = ArrayMaximum(MovingAverage,4,0);
int min = ArrayMinimum(MovingAverage,4,0);
MIN = MovingAverage[min];
MAX = MovingAverage[max];
//Print("ma max= "+MAX);
//Print("ma min= "+MIN);

}

void Get_Min_Max_tekensen(double &MAX,double &MIN) {
   double tekensen[];
    ArrayResize(tekensen,zoom+1);

  //(tekensen, ma_period,periode, ma_method);
  Ichimoku(zoom+1,tekensen);
   
   
int max = ArrayMaximum(tekensen,4,0);
int min = ArrayMinimum(tekensen,4,0);
MIN = tekensen[min];
MAX = tekensen[max];
//Print("ma max= "+MAX);
//Print("ma min= "+MIN);

}
double GetMovingAverage(int n,ENUM_TIMEFRAMES periode,int ma_period,ENUM_MA_METHOD ma_method) {


  int signal;
   double myPriceArray[];
   int iACDefinition = iMA(_Symbol,periode,ma_period,0,ma_method,PRICE_CLOSE);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,0,0,zoom+1,myPriceArray); 
   //Print(myPriceArray[2]);
   double iACValue = myPriceArray[n];
   return iACValue;

}
double MovingAverageToRSI(double x,double &MIN,double &MAX) {
   double a = 0;
   double b = 0;
   
   //a = (80-MIN)/(MAX-(2*MIN));
   //b = 10-(MIN*a);
   
   a = (91.6)/(MAX-MIN);
   b = (8.4)-(MIN*a);
   
   
   return (a*x)+b;
   
}
void check_converge(double rsi50,double rsi5,double rsi2,double rsit){
   if(rsi50 <= 10 && rsi5 <= 10 && rsi2 <= 10 && rsit <=10){
      converge=true;
   }
}

bool check_tenkesen(double tenkesen) {
   double price = GetTmpPrice();
   Print("tenkesen="+tenkesen);
   if(price<=tenkesen) {
      return true;
   }
   return false;
}
bool getChandelierbyIndice(string symbolName, ENUM_TIMEFRAMES timeframe, int nbPeriod, double& result[],int Indice){
   double min = 0.0;
      double max = 0.0;
   MqlRates rates[];

   ArrayResize(result, 4);
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
      return true;

   }
  
   return false;


}
double CheckSpike(double diff) {
   double chandel[];
   getChandelierbyIndice(_Symbol,PERIOD_M1, 10,chandel,0);
   
   double CHSpike = chandel[2]-chandel[3];
   //Print(CHSpike);
   spike=0;
   if(CHSpike<=diff) { //spike at 2n chandel
      spike=1;
      return CHSpike;
   }
   return 0;

}


void OnTick()
  {
      
      double tekensen[];
      Ichimoku(1,tekensen);
      Get_Min_Max(MAX50,MIN50,50,PERIOD_M1,MODE_EMA);
      Get_Min_Max(MAX5,MIN5,5,PERIOD_M1,MODE_SMA);
      Get_Min_Max(MAX2,MIN2,2,PERIOD_M1,MODE_EMA);
      Get_Min_Max_tekensen(MAXT,MINT);
      GetMovingAverage(0,PERIOD_M5,50,MODE_EMA);
      GetMovingAverage(0,PERIOD_M6,50,MODE_EMA);
      GetMovingAverage(0,PERIOD_M15,50,MODE_EMA);
      GetMovingAverage(0,PERIOD_H1,50,MODE_EMA);
      double ma50 = GetMovingAverage(0,PERIOD_M1,50,MODE_EMA);
      double ma5 = GetMovingAverage(0,PERIOD_M1,5,MODE_SMA);
      double ma2 = GetMovingAverage(0,PERIOD_M1,2,MODE_EMA);
      double ma2n1 = GetMovingAverage(0,PERIOD_M1,2,MODE_EMA);

      
      double RSI50= MovingAverageToRSI(ma50,MIN50,MAX50);
      double RSI5= MovingAverageToRSI(ma5,MIN5,MAX5);
      double RSI2= MovingAverageToRSI(ma2,MIN2,MAX2);
      double RSIt= MovingAverageToRSI(tekensen[0],MINT,MAXT);
      
      double RSI2n1= MovingAverageToRSI(ma2n1,MIN2,MAX2);
      int posTotal =  PositionsTotal();
      double profit = AccountInfoDouble(ACCOUNT_PROFIT);
      check_converge(RSI50,RSI5,RSI2,RSIt);
      
     Print("RSI50 = " + RSI50);
     Print("RSI5 = " + RSI5);
     Print("RSI2 = " + RSI2);
     Print("RSItekensen = " + RSIt);
     Print("converge = "+converge);
     Print("spike="+spike);
     
   
   if(converge==true) {
      spike1 = CheckSpike(-5);
      
      if(spike==1) {
         position = true;
         converge=false;
      }
   
   }
   Print("position="+position);
   Print("tekensen="+tekensen[0]);
   
   updateQuantity(QBUY,QSELL);
   Print("QBUY="+QBUY);
   Print("QSELL="+QSELL);
   Print("DIFF="+(QBUY+QSELL));
   Print(nb);
   double diff = QBUY+QSELL;
   
   
   if(position==true && ((diff<=cstBuyA && diff>=cstBuyB) || (diff<=cstBuyA2 && diff>=cstBuyB2))) {
      bool check = check_tenkesen(tekensen[0]);
      if(check==true && posTotal<=0) {
         BuyPosition(0.2,SL_BUY,TP_BUY);
         isbuy=true;
         spike = 0;
      }
      spike2 = CheckSpike(0);
      if(spike1 !=spike2 && spike2<0) { //no position
         spike= 0;
         spike1 = 0;
         spike2=0;
         position=false;
         converge=false;
      }
   }
     /*if(spike==2) {
      bool check = check_tenkesen(tekensen[0]);
         if(check==true) {
            BuyPosition(0.2,SL_BUY,TP_BUY);
            spike = 0;
         }
     }*/
     
     
     /*if(posTotal==0  && RSI50<=10 && RSI5<=10 && RSI2<=10 && RSI2n1>15) {
         BuyPosition(0.2,SL_BUY,TP_BUY);
      } */
      
      /*if(posTotal==0 && isbuy==true) {
       spike=0;
            spike1 = 0;
            spike2 = 0;
            position = false;
            converge = false;
            isbuy = false;
      }*/
      if(posTotal>0) {
         CheckSpike(0);
         if(profit>0) {
            close(_Symbol);
            spike=0;
            spike1 = 0;
            spike2 = 0;
            position = false;
            converge = false;
         }
      }
  }
  void close(string symbolName){   

   CTrade trade;

   if(PositionSelectByTicket(getLastTicket(symbolName))){

      trade.PositionClose(PositionGetInteger(POSITION_TICKET));

   }
}

ulong getLastTicket(string symbolName){
   
   datetime maxTimeOpen = 0;
   ulong ticket = 0;
   
   for(int i = 0; i < PositionsTotal(); i += 1){
      
      if(PositionGetSymbol(i) == symbolName){
          
          if(PositionSelectByTicket(PositionGetTicket(i))){
               
            datetime posTimeOpen = (datetime)PositionGetInteger(POSITION_TIME);
            
            if(maxTimeOpen < posTimeOpen){
            
               maxTimeOpen = posTimeOpen;
               ticket = PositionGetTicket(i);
               
            }
         }
      }
   }
   
   return ticket;

}
//+------------------------------------------------------------------+
