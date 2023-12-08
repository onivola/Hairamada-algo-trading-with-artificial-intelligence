//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, anddycabrera@gmail.com."
#property link      "https://www.mql5.com/en/users/waygrow"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>        //include the library for execution of trades
#include <Trade\PositionInfo.mqh> //include the library for obtaining information on positions
#include <DeepNeuralNetwork.mqh> 

int            iMA5_handle;
int            iMA55_handle;
double            iMA5_buf[];   // array for storing inputs //MA5
double            iMA55_buf[];  // array for storing inputs //MA55
int numInput=40;
int numHiddenA = 4;
int numHiddenB = 5;
int numOutput=3;

DeepNeuralNetwork dnn(numInput,numHiddenA,numHiddenB,numOutput);

//--- weight values
input double w0=1.0;
input double w1=1.0;
input double w2=1.0;
input double w3=1.0;
input double w4=1.0;
input double w5=1.0;
input double w6=1.0;
input double w7=1.0;
input double w8=1.0;
input double w9=1.0;
input double w10=1.0;
input double w11=1.0;
input double w12=1.0;
input double w13=1.0;
input double w14=1.0;
input double w15=1.0;
input double w16=1.0;
input double w17=1.0;
input double w18=1.0;
input double w19=1.0;
input double w20=1.0;
input double w21=1.0;
input double w22=1.0;
input double w23=1.0;
input double w24=1.0;
input double w25=1.0;
input double w26=1.0;
input double w27=1.0;
input double w28=1.0;
input double w29=1.0;
input double w30=1.0;
input double w31=1.0;
input double w32=1.0;
input double w33=1.0;
input double w34=1.0;
input double w35=1.0;
input double w36=1.0;
input double w37=1.0;
input double w38=1.0;
input double w39=1.0;
input double w40=1.0;
input double w41=1.0;
input double w42=1.0;
input double w43=1.0;
input double w44=1.0;
input double w45=1.0;
input double w46=1.0;
input double w47=1.0;
input double w48=1.0;
input double w49=1.0;
input double w50=1.0;
input double w51=1.0;
input double w52=1.0;
input double w53=1.0;
input double w54=1.0;
input double w55=1.0;
input double w56=1.0;
input double w57=1.0;
input double w58=1.0;
input double w59=1.0;
input double w60=1.0;
input double w61=1.0;
input double w62=1.0;
input double w63=1.0;
input double w64=1.0;
input double w65=1.0;
input double w66=1.0;
input double w67=1.0;
input double w68=1.0;
input double w69=1.0;
input double w70=1.0;
input double w71=1.0;
input double w72=1.0;
input double w73=1.0;
input double w74=1.0;
input double w75=1.0;
input double w76=1.0;
input double w77=1.0;
input double w78=1.0;
input double w79=1.0;
input double w80=1.0;
input double w81=1.0;
input double w82=1.0;
input double w83=1.0;
input double w84=1.0;
input double w85=1.0;
input double w86=1.0;
input double w87=1.0;
input double w88=1.0;
input double w89=1.0;
input double w90=1.0;
input double w91=1.0;
input double w92=1.0;
input double w93=1.0;
input double w94=1.0;
input double w95=1.0;
input double w96=1.0;
input double w97=1.0;
input double w98=1.0;
input double w99=1.0;
input double w100=1.0;
input double w101=1.0;
input double w102=1.0;
input double w103=1.0;
input double w104=1.0;
input double w105=1.0;
input double w106=1.0;
input double w107=1.0;
input double w108=1.0;
input double w109=1.0;
input double w110=1.0;
input double w111=1.0;
input double w112=1.0;
input double w113=1.0;
input double w114=1.0;
input double w115=1.0;
input double w116=1.0;
input double w117=1.0;
input double w118=1.0;
input double w119=1.0;
input double w120=1.0;
input double w121=1.0;
input double w122=1.0;
input double w123=1.0;
input double w124=1.0;
input double w125=1.0;
input double w126=1.0;
input double w127=1.0;
input double w128=1.0;
input double w129=1.0;
input double w130=1.0;
input double w131=1.0;
input double w132=1.0;
input double w133=1.0;
input double w134=1.0;
input double w135=1.0;
input double w136=1.0;
input double w137=1.0;
input double w138=1.0;
input double w139=1.0;
input double w140=1.0;
input double w141=1.0;
input double w142=1.0;
input double w143=1.0;
input double w144=1.0;
input double w145=1.0;
input double w146=1.0;
input double w147=1.0;
input double w148=1.0;
input double w149=1.0;
input double w150=1.0;
input double w151=1.0;
input double w152=1.0;
input double w153=1.0;
input double w154=1.0;
input double w155=1.0;
input double w156=1.0;
input double w157=1.0;
input double w158=1.0;
input double w159=1.0;
input double w160=1.0;
input double w161=1.0;
input double w162=1.0;
input double w163=1.0;
input double w164=1.0;
input double w165=1.0;
input double w166=1.0;
input double w167=1.0;
input double w168=1.0;
input double w169=1.0;
input double w170=1.0;
input double w171=1.0;
input double w172=1.0;
input double w173=1.0;
input double w174=1.0;
input double w175=1.0;
input double w176=1.0;
input double w177=1.0;
input double w178=1.0;
input double w179=1.0;
input double w180=1.0;
input double w181=1.0;
input double w182=1.0;
input double w183=1.0;
input double w184=1.0;
input double w185=1.0;
input double w186=1.0;
input double w187=1.0;
input double w188=1.0;
input double w189=1.0;
input double w190=1.0;
input double w191=1.0;
input double w192=1.0;
input double w193=1.0;
input double w194=1.0;


input double b0=1.0;
input double b1=1.0;
input double b2=1.0;
input double b3=1.0;
input double b4=1.0;
input double b5=1.0;
input double b6=1.0;
input double b7=1.0;
input double b8=1.0;
input double b9=1.0;
input double b10=1.0;
input double b11=1.0;

input double Lot=0.001;


input long order_magic=55555;//MagicNumber

double            _xValues[40];   // array for storing inputs
double            weight[207];   // array for storing weights
int               iRSI_handle;  // variable for storing the indicator handle
double            iRSI_buf[];   // dynamic array for storing indicator values


double            out;          // variable for storing the output of the neuron

string            my_symbol;    // variable for storing the symbol
ENUM_TIMEFRAMES   my_timeframe; // variable for storing the time frame
double            lot_size;     // variable for storing the minimum lot size of the transaction to be performed

CTrade            m_Trade;      // entity for execution of trades
CPositionInfo     m_Position;   // entity for obtaining information on positions
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   my_symbol=Symbol();
   my_timeframe=PERIOD_CURRENT;
   lot_size=Lot;
   m_Trade.SetExpertMagicNumber(order_magic);
weight[0]=w0;
weight[1]=w1;
weight[2]=w2;
weight[3]=w3;
weight[4]=w4;
weight[5]=w5;
weight[6]=w6;
weight[7]=w7;
weight[8]=w8;
weight[9]=w9;
weight[10]=w10;
weight[11]=w11;
weight[12]=w12;
weight[13]=w13;
weight[14]=w14;
weight[15]=w15;
weight[16]=w16;
weight[17]=w17;
weight[18]=w18;
weight[19]=w19;
weight[20]=w20;
weight[21]=w21;
weight[22]=w22;
weight[23]=w23;
weight[24]=w24;
weight[25]=w25;
weight[26]=w26;
weight[27]=w27;
weight[28]=w28;
weight[29]=w29;
weight[30]=w30;
weight[31]=w31;
weight[32]=w32;
weight[33]=w33;
weight[34]=w34;
weight[35]=w35;
weight[36]=w36;
weight[37]=w37;
weight[38]=w38;
weight[39]=w39;
weight[40]=w40;
weight[41]=w41;
weight[42]=w42;
weight[43]=w43;
weight[44]=w44;
weight[45]=w45;
weight[46]=w46;
weight[47]=w47;
weight[48]=w48;
weight[49]=w49;
weight[50]=w50;
weight[51]=w51;
weight[52]=w52;
weight[53]=w53;
weight[54]=w54;
weight[55]=w55;
weight[56]=w56;
weight[57]=w57;
weight[58]=w58;
weight[59]=w59;
weight[60]=w60;
weight[61]=w61;
weight[62]=w62;
weight[63]=w63;
weight[64]=w64;
weight[65]=w65;
weight[66]=w66;
weight[67]=w67;
weight[68]=w68;
weight[69]=w69;
weight[70]=w70;
weight[71]=w71;
weight[72]=w72;
weight[73]=w73;
weight[74]=w74;
weight[75]=w75;
weight[76]=w76;
weight[77]=w77;
weight[78]=w78;
weight[79]=w79;
weight[80]=w80;
weight[81]=w81;
weight[82]=w82;
weight[83]=w83;
weight[84]=w84;
weight[85]=w85;
weight[86]=w86;
weight[87]=w87;
weight[88]=w88;
weight[89]=w89;
weight[90]=w90;
weight[91]=w91;
weight[92]=w92;
weight[93]=w93;
weight[94]=w94;
weight[95]=w95;
weight[96]=w96;
weight[97]=w97;
weight[98]=w98;
weight[99]=w99;
weight[100]=w100;
weight[101]=w101;
weight[102]=w102;
weight[103]=w103;
weight[104]=w104;
weight[105]=w105;
weight[106]=w106;
weight[107]=w107;
weight[108]=w108;
weight[109]=w109;
weight[110]=w110;
weight[111]=w111;
weight[112]=w112;
weight[113]=w113;
weight[114]=w114;
weight[115]=w115;
weight[116]=w116;
weight[117]=w117;
weight[118]=w118;
weight[119]=w119;
weight[120]=w120;
weight[121]=w121;
weight[122]=w122;
weight[123]=w123;
weight[124]=w124;
weight[125]=w125;
weight[126]=w126;
weight[127]=w127;
weight[128]=w128;
weight[129]=w129;
weight[130]=w130;
weight[131]=w131;
weight[132]=w132;
weight[133]=w133;
weight[134]=w134;
weight[135]=w135;
weight[136]=w136;
weight[137]=w137;
weight[138]=w138;
weight[139]=w139;
weight[140]=w140;
weight[141]=w141;
weight[142]=w142;
weight[143]=w143;
weight[144]=w144;
weight[145]=w145;
weight[146]=w146;
weight[147]=w147;
weight[148]=w148;
weight[149]=w149;
weight[150]=w150;
weight[151]=w151;
weight[152]=w152;
weight[153]=w153;
weight[154]=w154;
weight[155]=w155;
weight[156]=w156;
weight[157]=w157;
weight[158]=w158;
weight[159]=w159;
   weight[160]=b0;
   weight[161]=b1;
   weight[162]=b2;
   weight[163]=b3;
   //layer A
  weight[164]=w160;
weight[165]=w161;
weight[166]=w162;
weight[167]=w163;
weight[168]=w164;
weight[169]=w165;
weight[170]=w166;
weight[171]=w167;
weight[172]=w168;
weight[173]=w169;
weight[174]=w170;
weight[175]=w171;
weight[176]=w172;
weight[177]=w173;
weight[178]=w174;
weight[179]=w175;
weight[180]=w176;
weight[181]=w177;
weight[182]=w178;
weight[183]=w179;
   weight[184]=b4;
   weight[185]=b5;
   weight[186]=b6;
   weight[187]=b7;
   weight[188]=b8;
   //lqyer B
weight[189]=w180;
weight[190]=w181;
weight[191]=w182;
weight[192]=w183;
weight[193]=w184;
weight[194]=w185;
weight[195]=w186;
weight[196]=w187;
weight[197]=w188;
weight[198]=w189;
weight[199]=w190;
weight[200]=w191;
weight[201]=w192;
weight[202]=w193;
weight[203]=w194;
   weight[204]=b9;
   weight[205]=b10;
   weight[206]=b11;
   
  /* weight[75]=w71;
   weight[76]=w72;
   weight[77]=w73;
   weight[78]=w74;
   weight[79]=w75;
   
   weight[80]=b4;
   weight[81]=b5;
   weight[82]=b6;
   weight[83]=b7;
   weight[84]=b8;
   weight[85]=w76;
   weight[86]=w77;
   weight[87]=w78;
   weight[88]=w79;
   weight[89]=w80;
   weight[90]=w81;
   weight[91]=w82;
   weight[92]=w83;
   weight[93]=w84;
   weight[94]=w85;
   weight[95]=w86;
   weight[96]=w87;
   weight[97]=w88;
   weight[98]=w89;
   weight[99]=w90;
   weight[100]=b9;
   weight[101]=b10;
   weight[102]=b11;
*/
   iMA55_handle = iMA(_Symbol,my_timeframe,55,5,MODE_EMA,PRICE_CLOSE);
   ArraySetAsSeries(iMA55_buf,true);
 
   iMA5_handle = iMA(_Symbol,my_timeframe,5,5,MODE_EMA,PRICE_CLOSE);
   ArraySetAsSeries(iMA5_buf,true);
   

//--- return 0, initialization complete
   return(0);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+

void OnDeinit(const int reason)
  {
//--- delete the indicator handle and deallocate the memory space it occupies
   IndicatorRelease(iRSI_handle);
//--- free the iRSI_buf dynamic array of data
   ArrayFree(iRSI_buf);
  }
int Seconds()
{
  datetime time = (uint)TimeCurrent();
  return((int)time % 60);
}

void OnTick()
  {
    

//compute the percent of the upper shadow, lower shadow and body in base of sum 100%
   int error=dataset(_xValues);

   if(error<0)return;

   dnn.SetWeights(weight);

   double yValues[];
   dnn.ComputeOutputs(_xValues,yValues);
  
 //if((iMA55_buf[0] > iMA5_buf[0] && iMA55_buf[3] < iMA5_buf[3]) || (iMA55_buf[0] < iMA5_buf[0] && iMA55_buf[3] > iMA5_buf[3])) {
     
//--- if the output value of the neuron is mare than 60%
 
//--- if the output value of the neuron is mare than 60%
   if(yValues[0]>0.6)
     {
      if(m_Position.Select(my_symbol))//check if there is an open position
        {
         if(m_Position.PositionType()==POSITION_TYPE_SELL) m_Trade.PositionClose(my_symbol);//Close the opposite position if exists
         if(m_Position.PositionType()==POSITION_TYPE_BUY)   return;//open a Long position;
        }
      m_Trade.Buy(lot_size,my_symbol);//open a Long position
     }
//--- if the output value of the neuron is mare than 60%
   if(yValues[1]>0.6)
     {
      if(m_Position.Select(my_symbol))//check if there is an open position
        {
         if(m_Position.PositionType()==POSITION_TYPE_BUY) m_Trade.PositionClose(my_symbol);//Close the opposite position if exists
         if(m_Position.PositionType()==POSITION_TYPE_SELL) return;
        }
      m_Trade.Sell(lot_size,my_symbol);//open a Short position
     }

   if(yValues[2]>0.6)
     {
      m_Trade.PositionClose(my_symbol);//close any position

     }
      
    
  // }
  
      
      /* double profit =PositionGetDouble(POSITION_PROFIT);
      if(PositionsTotal()>0 && (profit>=1 ||profit <=-1)) {
         close(my_symbol);
      }*/
      /* double profit =PositionGetDouble(POSITION_PROFIT);
      if(PositionsTotal()>0 && (profit>=1 ||profit <=-1)) {
         close(my_symbol);
      }*/
  }

//+------------------------------------------------------------------+
//|percentage of each part of the candle respecting total size       |
//+------------------------------------------------------------------+
 int dataset(double& xInputs[])
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
      //ArrayResize(chandel0, 4);
       //ArrayResize(xInputs, 4);
     int c0 =  getChandelierbyIndice(_Symbol,my_timeframe, 20,chandel0,0);
     int c1 =  getChandelierbyIndice(_Symbol,my_timeframe, 20,chandel1,1);
    int c2 =  getChandelierbyIndice(_Symbol,my_timeframe, 20,chandel2,2);
    int c3 =  getChandelierbyIndice(_Symbol,my_timeframe, 20,chandel3,3);
    int c4 =  getChandelierbyIndice(_Symbol,my_timeframe, 20,chandel4,4);
    int c5 =  getChandelierbyIndice(_Symbol,my_timeframe, 20,chandel5,5);
    int c6 =  getChandelierbyIndice(_Symbol,my_timeframe, 20,chandel6,6);
    int c7 =  getChandelierbyIndice(_Symbol,my_timeframe, 20,chandel7,7);
    int c8 =  getChandelierbyIndice(_Symbol,my_timeframe, 20,chandel8,8);
    int c9 =  getChandelierbyIndice(_Symbol,my_timeframe, 20,chandel9,9);
    //int c10 =  getChandelierbyIndice(_Symbol,my_timeframe, 20,chandel3,3);
     /*xInputs[0]=1;
       xInputs[1]=1;
         xInputs[2]=1;
           xInputs[3]=1;*/
    if(c0==1 && c1==1 && c2 ==1 && c3==1 && c4==1 && c5 ==1 && c6==1 && c7==1 && c8 ==1 && c9==1) {
         int j = 0;
         for(int i=0; i<4;i++){
            xInputs[i]=chandel0[j];
            j = j+1;
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
         return 1;
         j = 0;
         for(int i=16; i<20;i++){
            xInputs[i]=chandel4[j];
            j = j+1;
         }
         return 1;
         j = 0;
         for(int i=20; i<24;i++){
            xInputs[i]=chandel5[j];
            j = j+1;
         }
         return 1;
         j = 0;
         for(int i=24; i<28;i++){
            xInputs[i]=chandel6[j];
            j = j+1;
         }
         return 1;
         j = 0;
         for(int i=28; i<32;i++){
            xInputs[i]=chandel7[j];
            j = j+1;
         }
         return 1;
         j = 0;
         for(int i=32; i<36;i++){
            xInputs[i]=chandel8[j];
            j = j+1;
         }
         return 1;
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
     
    /* xInputs[0] = low;
      xInputs[1] = high;
       xInputs[2] = open;
      xInputs[3] = close*/
      
      
      
      
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
      if(p100==0) return -1;
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



  
//+------------------------------------------------------------------+
