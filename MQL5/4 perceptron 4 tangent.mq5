#property copyright   "2022, Roman Poshtar"
#property link        "https://www.mql5.com/en/users/romanuch"
#property strict
#property version   "1.0"

enum Sym
  {
   Fixed_lot=0,
   Percent_lot=1,
  };
  
input string N1 = "------------Open settings----------------";
input int    x1 = 1;
input int    x2 = 1;
input int    x3 = 1;

input int    y1 = 1;
input int    y2 = 1;
input int    y3 = 1;
input int    y4 = 1;

input int    z1 = 1;
input int    z2 = 1;
input int    z3 = 1;
input int    z4 = 1;

input int    f1 = 1;
input int    f2 = 1;
input int    f3 = 1;
input int    f4 = 1;

input int TakeProfit = 60;
input int StopLoss = 600;
input string N2 = "------------Lots settings----------------";
input Sym SetFixLotOrPercent = 0;
input double LotsOrPercent = 0.01;
input string N3 = "------------Other settings---------------";
input int MaxSpread = 50;
input int Slippage = 10;
input int Magic = 111111;
input string EAComment = "Perceptron";
   
//--- Enable the standard trading library
#include <Trade\Trade.mqh>;
#include <Trade\PositionInfo.mqh>
#include <Trade\OrderInfo.mqh>
#include <Trade\SymbolInfo.mqh>
#include <Trade\DealInfo.mqh>

CTrade trade;
CDealInfo deal;
CPositionInfo position;
COrderInfo order;
CSymbolInfo symbolS1; 

int handle_In1S1; 
int handle_In2S1; 

double LotsXSell=0.0; 
double LotsXBuy=0.0; 

double AskS1=0.0;
double BidS1=0.0;
double PointS1=0.0;
int SpreadS1=0.0;
int DigS1=0.0;
   
   double ind_In1[];
   double ind_In2[];

int OnInit()
  {
TesterHideIndicators(true); 

if(!symbolS1.Name(Symbol())) // sets symbol name
   return(INIT_FAILED);
RefreshRatesS1();

   handle_In1S1=iMA(symbolS1.Name(),PERIOD_CURRENT,1,0,MODE_SMA,PRICE_CLOSE);
//--- if the handle is not created 
   if(handle_In1S1==INVALID_HANDLE)
     {
      return(INIT_FAILED);
     }
//---

   handle_In2S1=iMA(symbolS1.Name(),PERIOD_CURRENT,24,0,MODE_SMA,PRICE_CLOSE);
//--- if the handle is not created 
   if(handle_In2S1==INVALID_HANDLE)
     {
      return(INIT_FAILED);
     }
//---

trade.SetExpertMagicNumber(Magic);
trade.SetDeviationInPoints(Slippage);
trade.SetTypeFillingBySymbol(symbolS1.Name());

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//----

//----
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
  
if (isNewBar()==true){

   if(!RefreshRatesS1())
   return;  
   
AskS1=SymbolInfoDouble(symbolS1.Name(),SYMBOL_ASK); 
BidS1=SymbolInfoDouble(symbolS1.Name(),SYMBOL_BID);
PointS1=SymbolInfoDouble(symbolS1.Name(),SYMBOL_POINT);   
SpreadS1=(int)SymbolInfoInteger(symbolS1.Name(), SYMBOL_SPREAD);
DigS1=(int)SymbolInfoInteger(symbolS1.Name(), SYMBOL_DIGITS);

//--- get data from the three buffers of the i-Regr indicator
   ArraySetAsSeries(ind_In1,true);
   if(!iGetArray(handle_In1S1,0,0,20,ind_In1))//MA
     {
      return;
     }
//---  

//--- get data from the three buffers of the i-Regr indicator
   ArraySetAsSeries(ind_In2,true);
   if(!iGetArray(handle_In2S1,0,0,20,ind_In2))//MA
     {
      return;
     }
//---  

if (CalculateAllPositions(symbolS1.Name(), Magic, EAComment)==0){ 

if (SetFixLotOrPercent==0){LotsXSell=NormalizeDouble(LotsOrPercent,2); LotsXBuy=NormalizeDouble(LotsOrPercent,2);}
if (SetFixLotOrPercent==1){
LotsXSell=NormalizeDouble((AccountInfoDouble(ACCOUNT_EQUITY)*((LotsOrPercent/100)/100)),2);
LotsXBuy=NormalizeDouble((AccountInfoDouble(ACCOUNT_EQUITY)*((LotsOrPercent/100)/100)),2);
}

if (LotsXSell>=SymbolInfoDouble(symbolS1.Name(),SYMBOL_VOLUME_MAX)){LotsXSell=NormalizeDouble(SymbolInfoDouble(symbolS1.Name(),SYMBOL_VOLUME_MAX)-SymbolInfoDouble(symbolS1.Name(),SYMBOL_VOLUME_MIN),2);}  
if (LotsXSell<SymbolInfoDouble(symbolS1.Name(),SYMBOL_VOLUME_MIN)){LotsXSell=NormalizeDouble(SymbolInfoDouble(symbolS1.Name(),SYMBOL_VOLUME_MIN),2);} 
if (LotsXBuy>=SymbolInfoDouble(symbolS1.Name(),SYMBOL_VOLUME_MAX)){LotsXBuy=NormalizeDouble(SymbolInfoDouble(symbolS1.Name(),SYMBOL_VOLUME_MAX)-SymbolInfoDouble(symbolS1.Name(),SYMBOL_VOLUME_MIN),2);}  
if (LotsXBuy<SymbolInfoDouble(symbolS1.Name(),SYMBOL_VOLUME_MIN)){LotsXBuy=NormalizeDouble(SymbolInfoDouble(symbolS1.Name(),SYMBOL_VOLUME_MIN),2);} 

}

//SELL++++++++++++++++++++++++++++++++++++++++++++++++

if ((CalculatePositions(symbolS1.Name(), Magic, POSITION_TYPE_SELL, EAComment)==0) && (ind_In1[1]>ind_In2[1]) && (perceptront1()<0) && (perceptront2()<0) && (perceptront3()<0) && (perceptront4()<0) && (SpreadS1<=MaxSpread)){//v1
  OpenSell(symbolS1.Name(), LotsXSell, TakeProfit, StopLoss, EAComment);
}

//BUY++++++++++++++++++++++++++++++++++++++++++++++++

if ((CalculatePositions(symbolS1.Name(), Magic, POSITION_TYPE_BUY, EAComment)==0) && (ind_In1[1]<ind_In2[1]) && (perceptront1()>0) && (perceptront2()>0) && (perceptront3()>0) && (perceptront4()>0) && (SpreadS1<=MaxSpread)){//v1
  OpenBuy(symbolS1.Name(), LotsXBuy, TakeProfit, StopLoss, EAComment);
}

  
}

}

//+------------------------------------------------------------------+
//|  The PERCEPRRON - a perceiving and recognizing function          |
//+------------------------------------------------------------------+
double perceptront1() 
  {
   double w1 = x1 - 100.0;
   double w2 = x2 - 100.0;
   double w3 = x3 - 100.0;
   
   double a1 = (ind_In1[1]-ind_In1[4])/4;
   double a2 = (ind_In1[1]-ind_In1[7])/7;
   double a3 = (ind_In1[1]-ind_In1[10])/10;

   return (w1 * a1 + w2 * a2 + w3 * a3);
  }
  
//+------------------------------------------------------------------+
//|  The PERCEPRRON - a perceiving and recognizing function          |
//+------------------------------------------------------------------+
double perceptront2() 
  {
   double w1 = y1 - 100.0;
   double w2 = y2 - 100.0;
   double w3 = y3 - 100.0;
   double w4 = y4 - 100.0;
   
   double a1 = (ind_In1[1]-ind_In1[5])/5;
   double a2 = (ind_In1[1]-ind_In1[10])/10;
   double a3 = (ind_In2[1]-ind_In2[5])/5;
   double a4 = (ind_In2[1]-ind_In2[10])/10;
   
   return (w1 * a1 + w2 * a2 + w3 * a3 + w4 * a4);
  }
  
//+------------------------------------------------------------------+
//|  The PERCEPRRON - a perceiving and recognizing function          |
//+------------------------------------------------------------------+
double perceptront3() 
  {
   double w1 = z1 - 100.0;
   double w2 = z2 - 100.0;
   double w3 = z3 - 100.0;
   double w4 = z4 - 100.0;
   
   double a1 = (ind_In1[1]-ind_In1[10])/10;
   double a2 = (ind_In2[1]-ind_In1[4])/4;
   double a3 = (ind_In2[1]-ind_In1[7])/7;
   double a4 = (ind_In2[1]-ind_In1[10])/10;
   
   return (w1 * a1 + w2 * a2 + w3 * a3 + w4 * a4);
  }
  
//+------------------------------------------------------------------+
//|  The PERCEPRRON - a perceiving and recognizing function          |
//+------------------------------------------------------------------+
double perceptront4() 
  {
   double w1 = f1 - 100.0;
   double w2 = f2 - 100.0;
   double w3 = f3 - 100.0;
   double w4 = f4 - 100.0;
   
   double a1 = (ind_In1[1]-ind_In1[10])/10;
   double a2 = (ind_In2[1]-ind_In1[10])/10;
   double a3 = (ind_In1[1]-ind_In1[10])/10;
   double a4 = (ind_In2[1]-ind_In2[10])/10;
   
   return (w1 * a1 + w2 * a2 + w3 * a3 + w4 * a4);
  }

//+------------------------------------------------------------------+
//| Returns true if a new bar has appeared for a symbol/period pair  |
//+------------------------------------------------------------------+
bool isNewBar()
  {
//--- memorize the time of opening of the last bar in the static variable
   static datetime last_time=0;
//--- current time
   datetime lastbar_time=int(SeriesInfoInteger(symbolS1.Name(),PERIOD_CURRENT,SERIES_LASTBAR_DATE));

//--- if it is the first call of the function
   if(last_time==0)
     {
      //--- set the time and exit 
      last_time=lastbar_time;
      return(false);
     }

//--- if the time differs
   if(last_time!=lastbar_time)
     {
      //--- memorize the time and return true
      last_time=lastbar_time;
      return(true);
     }
//--- if we passed to this line, then the bar is not new; return false
   return(false);
  }
  
//+------------------------------------------------------------------+
//| Get value of buffers                                             |
//+------------------------------------------------------------------+
double iGetArray(const int handle,const int buffer,const int start_pos,const int count,double &arr_buffer[])
  {
   bool result=true;
   if(!ArrayIsDynamic(arr_buffer))
     {
      Print("This a no dynamic array!");
      return(false);
     }
   ArrayFree(arr_buffer);
//--- reset error code 
   ResetLastError();
//--- fill a part of the iBands array with values from the indicator buffer
   int copied=CopyBuffer(handle,buffer,start_pos,count,arr_buffer);
   if(copied!=count)
     {
      //--- if the copying fails, tell the error code 
      PrintFormat("Failed to copy data from the indicator.");
      //--- quit with zero result - it means that the indicator is considered as not calculated 
      return(false);
     }
   return(result);
  }

//+------------------------------------------------------------------+
//| Open Buy position                                                |
//+------------------------------------------------------------------+
void OpenBuy(string sumb, double lots, double tpp, double slp, string com)
  {
   double dStopLoss = 0.0, dTakeProfit = 0.0; 
   
double Ask=SymbolInfoDouble(sumb, SYMBOL_ASK);  
double Bid=SymbolInfoDouble(sumb, SYMBOL_BID); 
double SymPoint=SymbolInfoDouble(sumb, SYMBOL_POINT); 
int Spread=(int)SymbolInfoInteger(sumb, SYMBOL_SPREAD);
int Dig=(int)SymbolInfoInteger(sumb, SYMBOL_DIGITS); 

   if (slp > 0)
     dStopLoss = Ask-slp*SymPoint;
   
   if (tpp > 0)
     dTakeProfit = Ask+tpp*SymPoint; 
 
if ((CheckVolumeValue(NormalizeDouble(lots,2),sumb)==true) && (CheckMoneyForTrade(sumb, NormalizeDouble(lots,2), ORDER_TYPE_BUY)==true)){
if ((IsNewOrderAllowed()==true) && (CheckVolumeLimit(NormalizeDouble(lots,2),sumb)==true)){  
         if(trade.Buy(NormalizeDouble(lots,2),sumb,Ask,NormalizeDouble(dStopLoss,Dig), NormalizeDouble(dTakeProfit,Dig),com))
           {
            if(trade.ResultDeal()==0)
              {
                if(trade.ResultRetcode()==10009) // trade order went to the exchange
                 {

                 }
               else
                 {

                  Print(__FILE__," ",__FUNCTION__,", ERROR: ","#1 Buy -> false. Result Retcode: ",trade.ResultRetcode(),
                        ", description of result: ",trade.ResultRetcodeDescription());
                 }
              }
            else
              {
               if(trade.ResultRetcode()==10009)
                 {

                 }
               else
                 {

                  Print(__FILE__," ",__FUNCTION__,", OK: ","#2 Buy -> true. Result Retcode: ",trade.ResultRetcode(),
                        ", description of result: ",trade.ResultRetcodeDescription());
                 }
              }
           }
         else
           {

            Print(__FILE__," ",__FUNCTION__,", ERROR: ","#3 Buy -> false. Result Retcode: ",trade.ResultRetcode(),
                  ", description of result: ",trade.ResultRetcodeDescription());
           }
    }}
  }

//+------------------------------------------------------------------+
//| Open Sell position                                               |
//+------------------------------------------------------------------+
void OpenSell(string sumb, double lots, double tpp, double slp, string com)
  {
   double dStopLoss = 0.0, dTakeProfit = 0.0;
   
double Ask=SymbolInfoDouble(sumb, SYMBOL_ASK);  
double Bid=SymbolInfoDouble(sumb, SYMBOL_BID); 
double SymPoint=SymbolInfoDouble(sumb, SYMBOL_POINT); 
int Spread=(int)SymbolInfoInteger(sumb, SYMBOL_SPREAD);
int Dig=(int)SymbolInfoInteger(sumb, SYMBOL_DIGITS);

   if (slp > 0)
     dStopLoss = Bid+slp*SymPoint;
   
   if (tpp > 0)
     dTakeProfit = Bid-tpp*SymPoint; 
   
if ((CheckVolumeValue(NormalizeDouble(lots,2),sumb)==true) && (CheckMoneyForTrade(sumb, NormalizeDouble(lots,2), ORDER_TYPE_SELL)==true)){
if ((IsNewOrderAllowed()==true) && (CheckVolumeLimit(NormalizeDouble(lots,2),sumb)==true)){  
         if(trade.Sell(NormalizeDouble(lots,2),sumb,Bid,NormalizeDouble(dStopLoss,Dig), NormalizeDouble(dTakeProfit,Dig),com))
           {
            if(trade.ResultDeal()==0)
              {
               if(trade.ResultRetcode()==10009) // trade order went to the exchange
                 {

                 }
               else
                 {

                  Print(__FILE__," ",__FUNCTION__,", ERROR: ","#1 Sell -> false. Result Retcode: ",trade.ResultRetcode(),
                        ", description of result: ",trade.ResultRetcodeDescription());
                 }
              }
            else
              {
               if(trade.ResultRetcode()==10009)
                 {

                 }
               else
                 {

                  Print(__FILE__," ",__FUNCTION__,", OK: ","#2 Sell -> true. Result Retcode: ",trade.ResultRetcode(),
                        ", description of result: ",trade.ResultRetcodeDescription());
                 }
              }
           }
         else
           {

            Print(__FILE__," ",__FUNCTION__,", ERROR: ","#3 Sell -> false. Result Retcode: ",trade.ResultRetcode(),
                  ", description of result: ",trade.ResultRetcodeDescription());
           }
    }}
  }  
  
//+------------------------------------------------------------------+
//| Calculate Positions                                              |
//+------------------------------------------------------------------+
int CalculatePositions(string symb, ulong mag, ENUM_POSITION_TYPE type, string com)
  {
   int total=0;

   for(int i=PositionsTotal()-1;i>=0;i--)
      if(position.SelectByIndex(i)) // selects the position by index for further access to its properties
         if(position.Symbol()==symb && position.Magic()==mag && position.PositionType()==type && position.Comment()==com)
            total++;
//---
   return(total);
  }
  
//+------------------------------------------------------------------+
//| Calculate Positions                                              |
//+------------------------------------------------------------------+
int CalculateAllPositions(string symb, ulong mag, string com)
  {
   int total=0;

   for(int i=PositionsTotal()-1;i>=0;i--)
      if(position.SelectByIndex(i)) // selects the position by index for further access to its properties
         if(position.Symbol()==symb && position.Magic()==mag && position.Comment()==com)
            total++;
//---
   return(total);
  }

//+------------------------------------------------------------------+
//| Refreshes the symbol quotes data                                 |
//+------------------------------------------------------------------+
bool RefreshRatesS1()
  {
//--- refresh rates
   if(!symbolS1.RefreshRates())
      return(false);
//--- protection against the return value of "zero"
   if(symbolS1.Ask()==0 || symbolS1.Bid()==0)
      return(false);
//---
   return(true);
  }
  
//+------------------------------------------------------------------+
//|  Check the correctness of the order volume                       |
//+------------------------------------------------------------------+
bool CheckVolumeLimit(double vol,string ss){

double volume=SymbolInfoDouble(ss,SYMBOL_VOLUME_LIMIT);
if(volume==0){volume=SymbolInfoDouble(ss,SYMBOL_VOLUME_MAX);}

   double volume_cize=0;
   for(int i=PositionsTotal()-1;i>=0;i--)
      if(position.SelectByIndex(i)){
         if (position.Symbol()==ss){
            volume_cize+=position.Volume();
         }
      }
if ((volume_cize+vol)<volume){return(true);}else{
return(false);
}

}
  
//+------------------------------------------------------------------+
//| check if another order can be placed                             |
//+------------------------------------------------------------------+
bool IsNewOrderAllowed()
  {
//--- get the number of pending orders allowed on the account
   int max_allowed_orders=(int)AccountInfoInteger(ACCOUNT_LIMIT_ORDERS);

//--- if there is no limitation, return true; you can send an order
   if(max_allowed_orders==0) return(true);

//--- if we passed to this line, then there is a limitation; find out how many orders are already placed
   int orders=OrdersTotal();

//--- return the result of comparing
   return(orders<max_allowed_orders);
  }

//+------------------------------------------------------------------+
//|  Check the correctness of the order volume                       |
//+------------------------------------------------------------------+
bool CheckVolumeValue(double volume,string ss)
  {
//--- minimal allowed volume for trade operations
   double min_volume=SymbolInfoDouble(ss,SYMBOL_VOLUME_MIN);
   if(volume<min_volume)
     {
      return(false);
     }

//--- maximal allowed volume of trade operations
   double max_volume=SymbolInfoDouble(ss,SYMBOL_VOLUME_MAX);
   if(volume>max_volume)
     {
      return(false);
     }

//--- get minimal step of volume changing
   double volume_step=SymbolInfoDouble(ss,SYMBOL_VOLUME_STEP);

   int ratio=(int)MathRound(volume/volume_step);
   if(MathAbs(ratio*volume_step-volume)>0.0000001)
     {
      return(false);
     }
   return(true);
  }

//+------------------------------------------------------------------+
//|  Check if there is enough money                                  |
//+------------------------------------------------------------------+
bool CheckMoneyForTrade(string symb,double lots,ENUM_ORDER_TYPE type)
  {
//--- get the open price
   MqlTick mqltick;
   SymbolInfoTick(symb,mqltick);
   double price=mqltick.ask;
   if(type==ORDER_TYPE_SELL)
      price=mqltick.bid;
//--- values of the required and free margin
   double margin,free_margin=(AccountInfoDouble(ACCOUNT_MARGIN_FREE));
   //--- call the verification function
   if(!OrderCalcMargin(type,symb,lots,price,margin))
     {
      //--- something is wrong, report and return 'false'
      Print("Error in ",__FUNCTION__," code=",GetLastError());
      return(false);
     }
   //--- if there are insufficient funds to perform the operation
   if(margin>free_margin)
     {
      //--- report the error and return 'false'
      //Print("Not enough money for ",EnumToString(type)," ",lots," ",symb," Error code=",GetLastError());
      return(false);
     }
//--- verification successful
   return(true);
  }