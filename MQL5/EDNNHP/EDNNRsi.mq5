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
#include <Hairabot\Utils.mq5>
int            iMA5_handle;
int            iMA55_handle;
double            iMA5_buf[];   // array for storing inputs //MA5
double            iMA55_buf[];  // array for storing inputs //MA55

int numInput=14;
int numHiddenA = 4;
int numHiddenB = 5;
int numOutput=3;

DeepNeuralNetwork dnn(numInput,numHiddenA,numHiddenB,numOutput);
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

double            _xValues[14];   // array for storing inputs
double            weight[103];   // array for storing weights
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
weight[56]=b0;
weight[57]=b1;
weight[58]=b2;
weight[59]=b3;
weight[60]=w56;
weight[61]=w57;
weight[62]=w58;
weight[63]=w59;
weight[64]=w60;
weight[65]=w61;
weight[66]=w62;
weight[67]=w63;
weight[68]=w64;
weight[69]=w65;
weight[70]=w66;
weight[71]=w67;
weight[72]=w68;
weight[73]=w69;
weight[74]=w70;
weight[75]=w71;
weight[76]=w72;
weight[77]=w73;
weight[78]=w74;

weight[79]=b4;
weight[80]=b5;
weight[81]=b6;
weight[82]=b7;
weight[83]=b8;
weight[84]=w75;
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
bool BuyPosition() {
   CTrade trade;
     double current = GetTmpPrice();
   double stoploss = current-4000;
   double takeprofit =  current+4000;

   if(trade.Buy(0.001,_Symbol,0,stoploss,takeprofit)){
      int code = (int)trade.ResultRetcode();
      ulong ticket = trade.ResultOrder();
      Print("Code:"+(string)code);
      Print("Ticket:"+(string)ticket);  
      return true ;
   }
  return false ;
 }
 
bool SellPosition() {
   CTrade trade;
    double current = GetTmpPrice();
  double stoploss = current+4000;
   double takeprofit =  current-4000;
   if(trade.Sell(0.001,_Symbol,0,takeprofit,stoploss)){
      int code = (int)trade.ResultRetcode();
      ulong ticket = trade.ResultOrder();
      Print("Code:"+(string)code);
      Print("Ticket:"+(string)ticket);  
      return true ;
   }
   return false;

}
void OnTick()
  {

   
    CopyBuffer(iMA55_handle,0,0,10,iMA55_buf); 
  CopyBuffer(iMA5_handle,0,0,10,iMA5_buf); 
  
   MqlRates rates[];
   ArraySetAsSeries(rates,true);
   int copied=CopyRates(_Symbol,0,1,5,rates);
int error=CandlePatterns(rates[0].high,rates[0].low,rates[0].open,rates[0].close,rates[0].close-rates[0].open,_xValues);


   if(error<0)return;

   dnn.SetWeights(weight);

   double yValues[];
   dnn.ComputeOutputs(_xValues,yValues);
  
 //if((iMA55_buf[0] > iMA5_buf[0] && iMA55_buf[3] < iMA5_buf[3]) || (iMA55_buf[0] < iMA5_buf[0] && iMA55_buf[3] > iMA5_buf[3])) {
     
     double second = Seconds();
    // if(second<=2 && PositionsTotal()<=0) {
//--- if the output value of the neuron is mare than 60%
  //--- if the output value of the neuron is mare than 60%
   if(yValues[0]>0.6)
     {
      if(m_Position.Select(my_symbol))//check if there is an open position
        {
         if(m_Position.PositionType()==POSITION_TYPE_SELL) m_Trade.PositionClose(my_symbol);//Close the opposite position if exists
         if(m_Position.PositionType()==POSITION_TYPE_BUY) return;
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
      
     
   //}
  
    //  }
      /* double profit =PositionGetDouble(POSITION_PROFIT);
      if(PositionsTotal()>0 && (profit>=1 ||profit <=-1)) {
         close(my_symbol);
      }*/
  }
  void close(string symbolName){   

   CTrade trade;

   if(PositionSelectByTicket(getLastTicket(symbolName))){

      trade.PositionClose(PositionGetInteger(POSITION_TICKET));

   }
}
//+------------------------------------------------------------------+
//|percentage of each part of the candle respecting total size       |
//+------------------------------------------------------------------+

int CandlePatterns(double high,double low,double open,double close,double uod,double &xInputs[])
  {

   
   double p100=high-low;
   double highPer=0;
   double lowPer=0;
   double bodyPer=0;
   double trend=0;
   
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
   
   //--- save the current chart symbol for further operation of the EA on this very symbol
   my_symbol=Symbol();
//--- save the current time frame of the chart for further operation of the EA on this very time frame
   my_timeframe=PERIOD_CURRENT;
//--- save the minimum lot of the transaction to be performed
   lot_size=SymbolInfoDouble(my_symbol,SYMBOL_VOLUME_MIN);
//--- apply the indicator and get its handle
   iRSI_handle=iRSI(my_symbol,my_timeframe,14,PRICE_CLOSE);
//--- check the availability of the indicator handle
 int err1=0;
  if(iRSI_handle==INVALID_HANDLE)
     {
      //--- no handle obtained, print the error message into the log file, complete handling the error
      Print("Failed to get the indicator handle");
      return(-1);
     }
//--- copy data from the indicator array to the iRSI_buf dynamic array for further work with them
   err1=CopyBuffer(iRSI_handle,0,1,14,iRSI_buf);
   if(err1<0)
     {
      Print("Failed to copy data from the indicator buffer");
      return -1;
     }
//--- add the indicator to the price chart
   ChartIndicatorAdd(ChartID(),0,iRSI_handle);
//--- set the iRSI_buf array indexing as time series
   ArraySetAsSeries(iRSI_buf,true);
  double d1=0.0;                                 //lower limit of the normalization range
   double d2=1.0;                                 //upper limit of the normalization range
   double x_min=iRSI_buf[ArrayMinimum(iRSI_buf)]; //minimum value over the range
   double x_max=iRSI_buf[ArrayMaximum(iRSI_buf)]; //maximum value over the range
   
   
     int j = 0;
   int i = 0;

             while(j<14)
     {
      xInputs[j]=(((iRSI_buf[i]-x_min)*(d2-d1))/(x_max-x_min))+d1;
      i = i + 1;
      j = j+1;
     }
     
     
   return(1);

  }
//+------------------------------------------------------------------+
