#include <Trade\Trade.mqh>
ENUM_TIMEFRAMES   my_timeframe; // variable for storing the time frame
CTrade            m_Trade;  
double            _xValues[40];   // array for storing inputs
 int i = 0;

  void PrintArray(int b, int e,double& array[]) {
      for(int i=b;i<e;i++) {
         Print(array[i]);
      
      }
  }
  void OnTick()
  {

      dataset(_xValues);
      PrintArray(0,ArraySize(_xValues),_xValues);
     Sleep(200000);
    
  }
  int dataset(double &xInputs[])
  {
      double chandel0[];
      double chandel1[];
      double chandel2[];
      double chandel3[];
      double chandel4[];
      double chandel5[];
      double chandel6[];
      double chandel7[];
      double chandel8[];
      double chandel9[];
      int c0 =  getChandelierbyIndice(_Symbol,my_timeframe, 20,chandel0,0);
       int c1 =getChandelierbyIndice(_Symbol,my_timeframe, 20,chandel1,1);
       int c2 =getChandelierbyIndice(_Symbol,my_timeframe, 20,chandel2,2);
       int c3 =getChandelierbyIndice(_Symbol,my_timeframe, 20,chandel3,3);
       int c4 =getChandelierbyIndice(_Symbol,my_timeframe, 20,chandel4,4);
       int c5 =getChandelierbyIndice(_Symbol,my_timeframe, 20,chandel5,5);
       int c6 =getChandelierbyIndice(_Symbol,my_timeframe, 20,chandel6,6);
       int c7 =getChandelierbyIndice(_Symbol,my_timeframe, 20,chandel7,7);
       int c8 =getChandelierbyIndice(_Symbol,my_timeframe, 20,chandel8,8);
       int c9 =getChandelierbyIndice(_Symbol,my_timeframe, 20,chandel9,9);
      
      
     // PrintArray(0,ArraySize(chandel0),chandel0);
      //PrintArray(0,ArraySize(chandel1),chandel1);
     if(c0==1 && c1==1 && c2==1 && c3==1 && c4==1 && c5==1 && c6==1 && c7==1 && c8==1 && c9==1) { 
     
       int j = 0;
      for(int i=0; i<4;i++){
         xInputs[i]=chandel0[i];
      }
      j = 0;
       for(int i=4; i<8;i++){
         xInputs[i]=chandel1[j];
         j = j+1;
      }
      
       j = 0;
       for(int i=8; i<12;i++){
         xInputs[i]=chandel2[j];
         j = j+1;
      }
       j = 0;
       for(int i=12; i<16;i++){
         xInputs[i]=chandel3[j];
         j = j+1;
      }
      j = 0;
       for(int i=16; i<20;i++){
         xInputs[i]=chandel4[j];
         j = j+1;
      } 
      j = 0;
       for(int i=20; i<24;i++){
         xInputs[i]=chandel5[j];
         j = j+1;
      }
       j = 0;
       for(int i=24; i<28;i++){
         xInputs[i]=chandel6[j];
         j = j+1;
      }
       j = 0;
       for(int i=28; i<32;i++){
         xInputs[i]=chandel7[j];
         j = j+1;
      }
       j = 0;
       for(int i=32; i<36;i++){
         xInputs[i]=chandel8[j];
         j = j+1;
      }
       j = 0;
       for(int i=36; i<40;i++){
         xInputs[i]=chandel9[j];
         j = j+1;
      }
      return 1;
     
     
     }
     return -1;
      
     
      
  }
  int getChandelierbyIndice(string symbolName, ENUM_TIMEFRAMES timeframe, int nbPeriod, double& xInputs[],int Indice){
   double low = 0.0;
      double high = 0.0;
   MqlRates rates[];

   ArrayResize(xInputs, 4);
   ArraySetAsSeries(rates, true);
   
   if(CopyRates(symbolName, timeframe, 1, nbPeriod, rates) == nbPeriod){

      low = rates[Indice].low;
      high = rates[Indice].high;
      double open = rates[Indice].open;
      double close = rates[Indice].close;
     
     xInputs[0] = low;
      xInputs[1] = high;
       xInputs[2] = open;
      xInputs[3] = close;
      
      
      
      
       double p100=high-low;
      double highPer=0;
      double lowPer=0;
      double bodyPer=0;
      double trend=0;
      double uod = rates[0].close-rates[0].open;
      if(uod>0)
        {
         highPer=high-close;
         lowPer=open-low;
         bodyPer=close-open;
         trend=1;
   
        }
      else
        {
         highPer=high-open;
         lowPer=close-low;
         bodyPer=open-close;
         trend=0;
        }
      if(p100==0)return(-1);
      xInputs[0]=highPer/p100;
      xInputs[1]=lowPer/p100;
      xInputs[2]=bodyPer/p100;
      xInputs[3]=trend;
      //time = rates[Indice].time;
      
      //int error=CandlePatterns(rates[0].high,rates[0].low,rates[0].open,rates[0].close,rates[0].close-rates[0].open,result);

   //if(error<0)return false;
      return 1;

   }
  
   return -1;


}