//+------------------------------------------------------------------+
//|                                               RL gmdh trader.mq5 |
//|                                 Copyright 2018, Max Dmitrievskiy |
//|                        https://www.mql5.com/ru/users/dmitrievsky |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, Max Dmitrievskiy"
#property link      "https://www.mql5.com/ru/users/dmitrievsky"
#property version   "1.00"

#include <RL gmdh.mqh>
#include <Trade\AccountInfo.mqh>

sinput bool     learn=false;
sinput double   regularize=0.6;
sinput double   MaximumRisk=0.01;
sinput double   CustomLot=0;
sinput int      OrderMagic=666;
double step = -1;
static datetime last_time=0;
CRLAgents *ag1=new CRLAgents("RlExp1iter",3,1000,10,regularize,learn); //создали 1 RL агента 
double sig1;

//+------------------------------------------------------------------
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
void AroonIndicatorProcessor()
   {

     

      //https://www.mql5.com/en/docs/series/copybuffer
      // Aroon_handle represent information captured from Icustom 
      // 0 represent first, 1 represent second buffer as it is arranged in your indicator code section >>>As for my indicator there are only two outputs as there are only 2 buffers
      // 0 represent start position 
      // 3 represent buffer 0, 1 & 2 copy 
      // AroonBull reprenet declared array created to indicator output values
       CopyBuffer(Handle,0,0,1000,RSIBuffer);
      CopyBuffer(Handle,1,0,1000,RSIOnMABuffer);
     
      CopyBuffer(Handle,2,0,1000,MAOnRSIBuffer);
      calcSignal();
   placeOrders();
      //return true;
  
      
   }

void OnTick()
  {
  
 if(!isNewBar())
     {
      return;
     }
   AroonIndicatorProcessor();
   
   
  
 }
//+------------------------------------------------------------------+
void calcSignal()
  {
   sig1=0;
   //double arr[];
   //CopyBuffer(zigzag,0,0,2000,arr);
    double inpt[];
   ArrayResize(inpt,600);
   ArraySetAsSeries(RSIBuffer,true);
   normalizeArrays(RSIBuffer);
    normalizeArrays(RSIOnMABuffer);
     normalizeArrays(MAOnRSIBuffer);
   int j =0;
   Print("size====");
   Print(ArraySize(ag1.agent));
  
   /*for(int x = 0;x<600;x++) {
    //Print(x);
      inpt[x] = MAOnRSIBuffer[j];
      inpt[x+1] = RSIBuffer[j];
      inpt[x+2] = RSIOnMABuffer[j];
      x = x+2;
      j = j +1;
      //Print(x)
   }
   //normalizeArrays01(inpt);
   Print(j);
   j = 0;
  /*for(int k = 100;k<100;k++) {
      
      j = j +1;
   }*/
   /*Print(inpt[199]);
   Print(inpt[199]);*/
   /*j = 0;
    for(int x = 400;x<600;x++) {
      inpt[x] = RSIOnMABuffer[j];
       j = j +1;
   }*/
   //normalizeArrays(inpt);
     
      ArrayCopy(ag1.agent[0].inpVector,MAOnRSIBuffer,0,0,ArraySize(ag1.agent[0].inpVector));
      
      ArrayCopy(ag1.agent[1].inpVector,RSIBuffer,0,0,ArraySize(ag1.agent[1].inpVector));
      ArrayCopy(ag1.agent[2].inpVector,RSIOnMABuffer,0,0,ArraySize(ag1.agent[2].inpVector));
       Print(ag1.agent[0].inpVector[99]);
   Print(ag1.agent[1].inpVector[99]);
   Print(ag1.agent[2].inpVector[99]);
     
   sig1=ag1.getTradeSignal();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void placeOrders()
  {
   if(countOrders(0)!=0 || countOrders(1)!=0)
     {
      for(int b=OrdersTotal()-1; b>=0; b--)
         if(OrderSelect(b,SELECT_BY_POS)==true)
            switch(OrderType())
              {
               case OP_BUY:
                  if(sig1>0.5)
                  if(OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),0,Red))
                     ag1.updateRewards();

                  break;

               case OP_SELL:
                  if(sig1<0.5)
                  if(OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),0,Red))
                     ag1.updateRewards();

                  break;
              }
      return;
     }

   if(sig1<0.5 && (OrderSend(Symbol(),OP_BUY,lotsOptimized(),SymbolInfoDouble(_Symbol,SYMBOL_ASK),0,0,0,NULL,OrderMagic,INT_MIN)>0))
     {
      ag1.updatePolicies(sig1);
     }

   else if(sig1>0.5 && (OrderSend(Symbol(),OP_SELL,lotsOptimized(),SymbolInfoDouble(_Symbol,SYMBOL_BID),0,0,0,NULL,OrderMagic,INT_MIN)>0))
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
  bool isNewBarStep()
  {
   datetime lastbar_time=datetime(SeriesInfoInteger(Symbol(),_Period,SERIES_LASTBAR_DATE));
   //Print(step);
   if(last_time==0)
     {
      last_time=lastbar_time;
      return(false);
     }
     if(last_time!=lastbar_time && (step<10)) {
        last_time=lastbar_time;
         step = step+1;
         return(false);
     }
   if(last_time!=lastbar_time && (step>=10 || step==-1))
     {
      last_time=lastbar_time;
      step = 0;
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
   double x_min=0;
   double x_max=100;
   for(int i=0;i<ArraySize(a);i++)
     {
      a[i]=(((a[i]-x_min)*(d2-d1))/(x_max-x_min))+d1;
     }
  }
  void normalizeArrays01(double &a[])
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
