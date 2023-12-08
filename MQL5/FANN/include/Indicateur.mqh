//iBands
void  GetiBands(ENUM_TIMEFRAMES period,double BPeriode, double BDecal,double BDeviation,double& result[])
  {
   double MiddleBandArray[];
   double UpperBandArray[];
   double LowerBandArray[];

   ArraySetAsSeries(MiddleBandArray,true);
   ArraySetAsSeries(UpperBandArray,true);
   ArraySetAsSeries(LowerBandArray,true);

   int BolligerBandsDefinition = iBands(_Symbol,period,BPeriode,BDecal,  BDeviation,PRICE_CLOSE);
   ArrayResize(result,3);
   CopyBuffer(BolligerBandsDefinition,0,0,3,MiddleBandArray);
   CopyBuffer(BolligerBandsDefinition,1,0,3,UpperBandArray);
   CopyBuffer(BolligerBandsDefinition,2,0,3,LowerBandArray);

   double myMiddleBandValue = MiddleBandArray[0];
   double myUpperBandValue = UpperBandArray[0];
   double myLowerBandValue = LowerBandArray[0];


   result[0] = myUpperBandValue;
   result[1] = myMiddleBandValue;
   result[2] = myLowerBandValue;

  }
//iStochastic
double GetiStochK(int n,ENUM_TIMEFRAMES periode,int Kperiod,int Dperiod,int slowing)   //BLEU
  {
   int signal;
   double KArray[];
   double DArray[];
//int slowing = 3;
   int iACDefinition = iStochastic(_Symbol,periode,Kperiod,Dperiod,slowing,MODE_SMA,STO_LOWHIGH);
   ArraySetAsSeries(KArray,true);
   ArraySetAsSeries(DArray,true);
   CopyBuffer(iACDefinition,0,0,3,KArray);
   float iACValue = KArray[n];
   return iACValue;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
float GetiStochD(int n,ENUM_TIMEFRAMES periode,int Kperiod,int Dperiod,int slowing)   //RED
  {
   int signal;
   double KArray[];
   double DArray[];
//int slowing = 3;
   int iACDefinition = iStochastic(_Symbol,periode,Kperiod,Dperiod,slowing,MODE_SMA,STO_LOWHIGH);
   ArraySetAsSeries(DArray,true);
   CopyBuffer(iACDefinition,1,0,3,DArray);
   float iACValue = DArray[n];
   return iACValue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool GetiStochArrayK(ENUM_TIMEFRAMES periode,int Kperiod,int Dperiod,int slowing,int n,double& result[])   //BLEU
  {
   int iACDefinition = iStochastic(_Symbol,periode,Kperiod,Dperiod,slowing,MODE_SMA,STO_LOWHIGH);
   ArraySetAsSeries(result,true);
   CopyBuffer(iACDefinition,0,0,n,result);
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool GetiStochArrayD(ENUM_TIMEFRAMES periode,int Kperiod,int Dperiod,int slowing,int n,double& result[])   //RED
  {
   int iACDefinition = iStochastic(_Symbol,periode,Kperiod,Dperiod,slowing,MODE_SMA,STO_LOWHIGH);
   ArraySetAsSeries(result,true);
   CopyBuffer(iACDefinition,1,0,n,result);
   return true;
  }

//iRSI
bool GetiRSIArray(int n,ENUM_TIMEFRAMES periode,int ma_period,double& result[])
  {
   int iACDefinition = iRSI(_Symbol,periode,ma_period,PRICE_CLOSE);
   ArraySetAsSeries(result,true);
   CopyBuffer(iACDefinition,0,0,n,result);
   return true;

  }
double GetiRSI(int n,ENUM_TIMEFRAMES periode,int ma_period)
  {
   int signal;
   double myPriceArray[];
   int iACDefinition = iRSI(_Symbol,periode,ma_period,PRICE_CLOSE);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,0,0,5,myPriceArray);
   float iACValue = myPriceArray[n];
   return iACValue;
  }
//iMACD
bool GetiMACDArray(int n,ENUM_TIMEFRAMES period,double& result[])
  {
   int iACDefinition = iMACD(_Symbol,period,8,10,8,PRICE_LOW);
   ArraySetAsSeries(result,false);
   CopyBuffer(iACDefinition,0,0,n,result);
   return true;
  }
double GetiMACD(ENUM_TIMEFRAMES period, int n)
  {

   double macd[];
   int iACDefinition = iMACD(_Symbol,period,8,10,8,PRICE_LOW);
   ArraySetAsSeries(macd,false);
   CopyBuffer(iACDefinition,0,0,10,macd);
   Print("MACD="+macd[0]);
   Print(macd[n]);
   if(macd[n]>0)
     {
      return 0;
     }
   return 2;
  }
//iMA
double GetiMA(int n,ENUM_TIMEFRAMES periode,int ma_period,ENUM_MA_METHOD ma_method)
  {

   int signal;
   double myPriceArray[];
   int iACDefinition = iMA(_Symbol,periode,ma_period,0,ma_method,PRICE_CLOSE);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,0,0,50,myPriceArray);
//Print(myPriceArray[2]);
   float iACValue = myPriceArray[n];
   return iACValue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool GetiMAArray(ENUM_TIMEFRAMES periode,int ma_period,ENUM_MA_METHOD ma_method,int n,double& result[])
  {

   int signal;
   double myPriceArray[];
   int iACDefinition = iMA(_Symbol,periode,ma_period,0,ma_method,PRICE_CLOSE);
   ArraySetAsSeries(result,true);
   CopyBuffer(iACDefinition,0,0,n,result);
   return true;
  }
//ADX
double GetAdx(int n,ENUM_TIMEFRAMES  period,int adx_period)
  {


   int signal;
   double myPriceArray[];
   int iACDefinition = iADX(_Symbol,period,adx_period);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,0,0,50,myPriceArray);
//Print(myPriceArray[2]);
   float iACValue = myPriceArray[n];
   return iACValue;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double  GetMomentum(int n, ENUM_TIMEFRAMES period,int mom_period, ENUM_APPLIED_PRICE applied_price)
  {
   int signal;
   double myPriceArray[];
   int iACDefinition = iMomentum(_Symbol,period,mom_period,PRICE_CLOSE);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,0,0,50,myPriceArray);
//Print(myPriceArray[2]);
   float iACValue = myPriceArray[n];
   return iACValue;

  }
//+------------------------------------------------------------------+
