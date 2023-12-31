//+------------------------------------------------------------------+
//|                                               RL gmdh trader.mq5 |
//|                                 Copyright 2018, Max Dmitrievskiy |
//|                        https://www.mql5.com/ru/users/dmitrievsky |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, Max Dmitrievskiy"
#property link      "https://www.mql5.com/ru/users/dmitrievsky"
#property version   "1.00"
#include <Hairabot\Utils.mq5>
#include <RL gmdh.mqh>
#include <Trade\AccountInfo.mqh>

sinput bool     learn=false;
sinput double   regularize=0.6;
sinput double   MaximumRisk=0.01;
sinput double   CustomLot=0;
sinput int      OrderMagic=666;
input double slb = 1;
input double tpb = 52;
input double sls = 4;
input double tps = 99;
input double Lot = 0.2;
static datetime last_time=0;
CRLAgents *ag1=new CRLAgents("RlExp1iter",1,200,50,regularize,learn); //создали 1 RL агента 
input int ma1 =  12;
input int ma2 =  50;
input ENUM_TIMEFRAMES Periode = PERIOD_M1;
double sig1;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   return(INIT_SUCCEEDED);
  }
  
//+------------------------------------------------------------------+
//| Expert ontester function                                         |
//+------------------------------------------------------------------+
double OnTester()
  {
   delete ag1;
   return 0;
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   //delete ag1;
   if(MQLInfoInteger(MQL_TESTER)==false)
     {
      delete ag1;
     }
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   double ema0_ma1 = iMA(0,Periode,ma1,MODE_SMMA);
   double ema0_ma2 = iMA(0,Periode,ma2,MODE_EMA);
   double ema1_ma1 = iMA(1,Periode,ma1,MODE_SMMA);
   double ema1_ma2 = iMA(1,Periode,ma2,MODE_EMA);
   double ema2_ma1 = iMA(2,Periode,ma1,MODE_SMMA);
   double ema2_ma2 = iMA(2,Periode,ma2,MODE_EMA);
   double ema3_ma1 = iMA(3,Periode,ma1,MODE_SMMA);
   double ema3_ma2 = iMA(3,Periode,ma2,MODE_EMA);
   double ema4_ma1 = iMA(4,Periode,ma1,MODE_SMMA);
   double ema4_ma2 = iMA(4,Periode,ma2,MODE_EMA);
   double ema5_ma1 = iMA(5,Periode,ma1,MODE_SMMA);
   double ema5_ma2 = iMA(5,Periode,ma2,MODE_EMA);
   double ema6_ma1 = iMA(6,Periode,ma1,MODE_SMMA);
   double ema6_ma2 = iMA(6,Periode,ma2,MODE_EMA);
    int posTotal = getSymbolPositionTotal(_Symbol);
   if(posTotal <= 0 && (ema0_ma1>ema0_ma2 && (ema1_ma1<ema1_ma2 || ema2_ma1<ema2_ma2 || ema3_ma1<ema3_ma2 || ema4_ma1<ema4_ma2 || ema5_ma1<ema5_ma2))){
         calcSignal();
   placeOrdersBuy();
      }
        if(posTotal <= 0 && (ema0_ma1<ema0_ma2 && (ema1_ma1>ema1_ma2 || ema2_ma1>ema2_ma2 || ema3_ma1>ema3_ma2 || ema4_ma1>ema4_ma2 || ema5_ma1>ema5_ma2))){
         calcSignal();
         placeOrdersSell();
      }
      return;
   
  }
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
 void iMAbuff(int n,ENUM_TIMEFRAMES periode,int ma_period,ENUM_MA_METHOD ma_method,double& arr[]) {
   
    int signal;
   double myPriceArray[];
   int iACDefinition = iMA(_Symbol,periode,ma_period,0,ma_method,PRICE_CLOSE);
   ArraySetAsSeries(arr,true);
   CopyBuffer(iACDefinition,0,0,n,arr); 
    //Print(myPriceArray[2]);

}
//+------------------------------------------------------------------+
void calcSignal()
  {
   sig1=0;
   double arr[];
   double arr2[];
   double inpt[];
   ArraySetAsSeries(arr,true);
   ArraySetAsSeries(arr2,true);
   ArrayResize(inpt,200);
   iMAbuff(10000,Periode,ma1,MODE_SMMA,arr);
   iMAbuff(10000,Periode,ma2,MODE_EMA,arr2); 

   int j =0;
   Print("size====");
   Print(ArraySize(ag1.agent));
   for(int x = 0;x<100;x++) {
      inpt[x] = arr[j];
      j = x;
   }
   Print(j);
  for(int x = 100;x<200;x++) {
      inpt[x] = arr2[j];
   }
   normalizeArrays(inpt);
   Print(j);
   for(int i=0;i<ArraySize(ag1.agent);i++)
     {   
      ArrayCopy(ag1.agent[i].inpVector,inpt,0,0,ArraySize(ag1.agent[i].inpVector));
      Print(ag1.agent[0].inpVector[0]);
      Print(ag1.agent[0].inpVector[199]);
     }
   sig1=ag1.getTradeSignal();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void placeOrdersBuy()
  {
  double current = GetTmpPrice();
   if(countOrders(0)!=0 || countOrders(1)!=0)
     {
      for(int b=OrdersTotal()-1; b>=0; b--)
         if(OrderSelect(b,SELECT_BY_POS)==true)
            switch(OrderType())
              {
               case OP_BUY:
                  if(OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),0,Red))
                     ag1.updateRewards();

                  break;

               case OP_SELL:
                  if(OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),0,Red))
                     ag1.updateRewards();

                  break;
              }
      return;
     }
 
   if(sig1<0.5 && (OrderSend(Symbol(),OP_BUY,lotsOptimized(),SymbolInfoDouble(_Symbol,SYMBOL_ASK),0,current-slb,current+tpb,NULL,OrderMagic,INT_MIN)>0))
     {
      ag1.updatePolicies(sig1);
     }
  }
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
void placeOrdersSell()
  {
  double current = GetTmpPrice();
   if(countOrders(0)!=0 || countOrders(1)!=0)
     {
      for(int b=OrdersTotal()-1; b>=0; b--)
         if(OrderSelect(b,SELECT_BY_POS)==true)
            switch(OrderType())
              {
               case OP_BUY:
                  if(OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),0,Red))
                     ag1.updateRewards();

                  break;

               case OP_SELL:
                  if(OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),0,Red))
                     ag1.updateRewards();

                  break;
              }
      return;
     }
     
   else if(sig1>0.5 && (OrderSend(Symbol(),OP_SELL,lotsOptimized(),SymbolInfoDouble(_Symbol,SYMBOL_BID),0,current+sls,current-tps,NULL,OrderMagic,INT_MIN)>0))
     {
      ag1.updatePolicies(sig1);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int countOrders(int a)
  {
   int result=0;
   for(int k=0; k<OrdersTotal(); k++)
     {
      if(OrderSelect(k,SELECT_BY_POS,MODE_TRADES)==true)
         if(OrderType()==a && OrderMagicNumber()==OrderMagic)
            result++;
     }
   return(result);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double lotsOptimized()
  {
   double lot;

   if(MQLInfoInteger(MQL_OPTIMIZATION)==true)
     {
      lot=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MIN);
      return lot;
     }
   CAccountInfo myaccount; SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_STEP);

   lot=NormalizeDouble(myaccount.FreeMargin()*MaximumRisk/1000.0,2);
   if(CustomLot!=0.0) lot=CustomLot;

   double volume_step=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_STEP);
   int ratio=(int)MathRound(lot/volume_step);
   if(MathAbs(ratio*volume_step-lot)>0.0000001)
      lot=ratio*volume_step;

   if(lot<SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MIN)) lot=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MIN);
   if(lot>SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MAX)) lot=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MAX);
   return(lot);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isNewBar()
  {
   datetime lastbar_time=datetime(SeriesInfoInteger(Symbol(),_Period,SERIES_LASTBAR_DATE));
   if(last_time==0)
     {
      last_time=lastbar_time;
      return(false);
     }
   if(last_time!=lastbar_time)
     {
      last_time=lastbar_time;
      return(true);
     }
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void normalizeArrays(double &a[])
  {
   double d1=0.0;
   double d2=1.0;
   double x_min=a[ArrayMinimum(a)];
   double x_max=a[ArrayMaximum(a)];
   for(int i=0;i<ArraySize(a);i++)
     {
      a[i]=(((a[i]-x_min)*(d2-d1))/(x_max-x_min))+d1;
     }
  }
//+------------------------------------------------------------------+
