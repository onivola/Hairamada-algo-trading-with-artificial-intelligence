
input double nb_chandel = 1440;
double next=true;
double nb = 0;
input double refresh=1441;

#include <Trade\Trade.mqh>

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
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
/*int OnInit()
  {
//---
   GetQuantite();
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }*/
  void updateQuantity(double& QBUY,double& QSELL) {
   double sec = Seconds();
   if(nb==refresh) {
      QBUY=0;
      QSELL=0;
      Print("REFRESH="+nb);
      GetQuantite(QBUY,QSELL);
      nb=0;
   }
   if(sec>=0 && sec<=5 && next ==true) {
     
       double chandel[];
      getChandelierbyIndice2(_Symbol,PERIOD_M1, 10,chandel,0);
       double open = chandel[2];
      double close = chandel[3];
      double diff = open-close; //open-close
      if(diff>0) { //green chandel
         QBUY = QBUY + diff;
      }
      else { //red chandel
       
         QSELL = QSELL + diff;
       }
        next==false;
        nb = nb+1;
   }
   else {
      next =true;
   }
   double secday = SecondsDay();
   /*if(secday>=0 && secday<=5 && next ==true) {
      
   }*/
  }

int Seconds()
{
  datetime time = (uint)TimeCurrent();
  return((int)time % 60);
}
int SecondsDay()
{
  datetime time = (uint)TimeCurrent();
  return((int)time % 60*60*24);
}

void GetQuantite(double QBUY,double QSELL) {
  MqlRates chandel[];
  getChandelierbyIndice1(_Symbol,PERIOD_M1, nb_chandel,chandel);
   for(int i=0;i<nb_chandel;i++) {
      
      
      double open = chandel[i].open;
      double close = chandel[i].close;
      double diff = open-close; //open-close
      if(diff>0) { //green chandel
         QBUY = QBUY + diff;
      }
      else { //red chandel
         QSELL = QSELL + diff;
      }
   }
   
}
bool getChandelierbyIndice2(string symbolName, ENUM_TIMEFRAMES timeframe, int nbPeriod, double& result[],int Indice){
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
bool getChandelierbyIndice1(string symbolName, ENUM_TIMEFRAMES timeframe, int nbPeriod, MqlRates& rates[]){
   double min = 0.0;
      double max = 0.0;
   

   //ArrayResize(result, 4);
   ArraySetAsSeries(rates, true);
   
   if(CopyRates(symbolName, timeframe, 1, nbPeriod, rates) == nbPeriod){

      /*min = rates[Indice].low;
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
      result[3] = close;*/
      return true;

   }
  
   return false;


}