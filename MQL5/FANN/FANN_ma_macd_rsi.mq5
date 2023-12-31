// We include the Fann2MQl library
#include <Fann2MQL.mqh>
#include <Trade\Trade.mqh>
#property copyright "Copyright © 2009, Julien Loutre"
#property link      "http://www.forexcomm.com"
#include "\..\..\Experts\FANN\include\ann.mqh"

#include <Hairabot\Utils.mq5>
// When the indicator is removed, we delete all the neuronal networks from the memory of the computer.

double iMACD(ENUM_TIMEFRAMES period, int n) {

   double macd[];
   int iACDefinition = iMACD(_Symbol,period,8,10,8,PRICE_LOW);
   ArraySetAsSeries(macd,false);
   CopyBuffer(iACDefinition,0,0,10,macd); 
   Print("MACD="+macd[0]);
   Print(macd[n]);
   if(macd[n]>0) {
      return 0;
   }
   return 2;
}

void iMA_SHORT(double& myPriceArray[],double n,ENUM_TIMEFRAMES periode,int ma_period,ENUM_MA_METHOD ma_method) {
  
   int iACDefinition = iMA(_Symbol,periode,ma_period,0,ma_method,PRICE_CLOSE);
   ArraySetAsSeries(myPriceArray,true);
   //CopyBuffer(iACDefinition,0,0,n,myPriceArray); 
   
   datetime start_time = D'2022.01.02 00:00';
   datetime stop_time = D'2022.01.03 00:00';
   Print(CopyBuffer(iACDefinition,0,0,n,myPriceArray)); //recent[0] ->encien[n]
    Print(myPriceArray[2]);
    Print(myPriceArray[(int)n-1]);
}
void iMA_LONG(double& myPriceArray[],ENUM_TIMEFRAMES periode,int ma_period,ENUM_MA_METHOD ma_method) {
  
   int iACDefinition = iMA(_Symbol,periode,ma_period,0,ma_method,PRICE_CLOSE);
   ArraySetAsSeries(myPriceArray,true);
   //CopyBuffer(iACDefinition,0,0,n,myPriceArray); 
   
   datetime start_time = D'2022.01.02 00:00';
   datetime stop_time = D'2022.01.03 00:00';
   Print(CopyBuffer(iACDefinition,0,0,1441,myPriceArray)); //recent[0] ->encien[n]
    Print(myPriceArray[2]);
}
/****************************************************************Get RSI**********************************************************************************************/
float GetRSI(int n) {
   
    //int signal;
   double myPriceArray[];
   int iACDefinition = iRSI(_Symbol,PERIOD_M1,5,PRICE_CLOSE);
   ArraySetAsSeries(myPriceArray,true);
   //CopyBuffer(iACDefinition,0,0,50,myPriceArray);
   datetime start_time =D'2022.01.01 00:00';
   datetime stop_time =D'2022.02.01 00:00';
   CopyBuffer(iACDefinition,0,start_time,stop_time,myPriceArray);
    //Print(myPriceArray[2]);
   float iACValue = myPriceArray[n];
   return iACValue;
}
bool BuyPosition(double lot) {
   CTrade trade;
   if(trade.Buy(lot,_Symbol,0,0,0)){
      int code = (int)trade.ResultRetcode();
      ulong ticket = trade.ResultOrder();
      Print("Code:"+(string)code);
      Print("Ticket:"+(string)ticket);  
      return true ;
   }
  return false ;
 }
 bool SellPosition(double lot) {
   CTrade trade; 
   if(trade.Sell(lot,_Symbol,0,0,0)){
      int code = (int)trade.ResultRetcode();
      ulong ticket = trade.ResultOrder();
      Print("Code:"+(string)code);
      Print("Ticket:"+(string)ticket);  
      return true ;
   }
   return false;

}
void close(string symbolName){   

   CTrade trade;

   if(PositionSelectByTicket(getLastTicket(symbolName))){

      trade.PositionClose(PositionGetInteger(POSITION_TICKET));

   }
}
void OnTick() {
      /*double MA12[];
      double MA5[];
     iMA_LONG(MA12,PERIOD_M1,12,MODE_LWMA);
     iMA_LONG(MA5,PERIOD_M1,5,MODE_LWMA);
      Print(MA12[0]);
       Print(MA5[0]);*/
     //Print("55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555");
     double profit = AccountInfoDouble(ACCOUNT_PROFIT);
      int posTotal = getSymbolPositionTotal(_Symbol);
     double XY[];
      double MA12[];
      double MA5[];
      double MA1[];
      double MA444[];
      iMA_SHORT(MA12,26,PERIOD_M1,12,MODE_LWMA);
      iMA_SHORT(MA5,26,PERIOD_M1,5,MODE_LWMA);
      iMA_SHORT(MA1,26,PERIOD_M1,1,MODE_LWMA);
      iMA_SHORT(MA444,1441,PERIOD_M1,1,MODE_LWMA);
      int nbx = 0;
      double xy[];
      if(MA5[0]>MA12[0] && (MA5[1]<=MA12[1] || MA5[2]<=MA12[2]) && posTotal<=0) {
          //Print("iiiiiiiiiiiiiiiiiiiiiiiiin");
          //Print(MA1[i]);
          
          for(int x=0+1;x<=0+25;x++) {
            nbx = nbx + 1;
            ArrayResize(XY,nbx);
            XY[nbx-1] = MA1[x];
            //Print(XY[nbx-1]);
          }
          nbx = nbx + 1;
          ArrayResize(XY,nbx);
          XY[nbx-1] = 1;
          if(MA1[5]<MA1[0]) {
           XY[nbx-1]=0;
          }
          //Print(XY[nbx-1]);
          
          
          Print("++++++++++++XY+++++++++++++");
          ArrayFree(xy);
          double out = -1;
          nbx = 0;
         for(int i=0;i<ArraySize(XY);i++) {
            //Print(XY[i]);
            nbx = nbx+1;
            ArrayResize(xy,nbx);
            xy[nbx-1] = XY[i];
            //Print(xy[nbx-1]);
            if(xy[nbx-1]==0 || xy[nbx-1]==1) {
               //Print(ArraySize(xy));
               Normalize(xy);
                double out = ComputXYData("compute",xy,0);
                Print(out);
                if(out>0.5 && xy[nbx-1]==1) {
                 // Print("gain");
                  BuyPosition(0.2);
                }
                if(out<0.5 && xy[nbx-1]==0) {
                  //Print("gain");
                  SellPosition(0.2);
                } 
                nbx = 0;
                //Print(2);
                ArrayFree(xy);
                //return;
            }
            
            //Print(2);
         }
        
         Print("++++++++++++XY+++++++++++++");
      }
      
      

         if(posTotal>0 && (profit>=0.8 || profit<=-1)) {
            close(_Symbol);
         }
}
void Get_XY(double& XY[],double& MA12[],double& MA5[],double& MA1[]) {

   Print(MA12[0]);
   Print(MA5[0]);
   Print("sizzzzzzzzz");
   Print(ArraySize(MA12));
   int nbx = 0;
   for(int i=6;i<ArraySize(MA12)-25;i++) {
      //Print(MA1[i]);
      if(MA5[i]>MA12[i] && (MA5[i+1]<=MA12[i+1] || MA5[i+2]<=MA12[i+2])) {
          //Print("iiiiiiiiiiiiiiiiiiiiiiiiin");
          //Print(MA1[i]);
          
          for(int x=i+1;x<=i+25;x++) {
            nbx = nbx + 1;
            ArrayResize(XY,nbx);
            XY[nbx-1] = MA1[x];
            //Print(XY[nbx-1]);
          }
          nbx = nbx + 1;
          ArrayResize(XY,nbx);
          XY[nbx-1] = 1;
          if(MA1[i-5]<MA1[i]) {
           XY[nbx-1]=0;
          }
          //Print(XY[nbx-1]);
          i = i+2;
      }
   }

}
void Normalize(double& xy[]) {
   double max = xy[ArrayMaximum(xy,0,ArraySize(xy)-2)];
   double min = xy[ArrayMinimum(xy,0,ArraySize(xy)-2)];

   for(int i=0;i<ArraySize(xy);i++) {
   //Print(min);
    //Print(max);
        xy[i] = NormalizePrice(xy[i],min,max);
        //Print(xy[i]);
   }  


}
double NormalizePrice(double val, double min, double max)
{
     //Shift to positive to avoid issues when crossing the 0 line
     if(min < 0){
       max += 0 - min;
       val += 0 - min;
       min = 0;
     }
     //Shift values from 0 - max
     val = val - min;
     max = max - min;
     //return Math.max(0, Math.min(1, val / max));
      return MathMax(0,MathMin(1, val / max));
}
void OnInit() {
   double MA12[];
   double MA5[];
   double MA1[];
   iMA_LONG(MA12,PERIOD_M1,12,MODE_LWMA);
   iMA_LONG(MA5,PERIOD_M1,5,MODE_LWMA);
   iMA_LONG(MA1,PERIOD_M1,1,MODE_LWMA);
   double XY[];
   Get_XY(XY,MA12,MA5,MA1);
   Print("size");
   Print(ArraySize(XY));
   Print("size");
   int i;
   double MSE;
   
   Print("=================================== START EXECUTION ================================");
   
  
   
   // We resize the trainingData array, so we can use it.
   // We're gonna change its size one size at a time.
   ArrayResize(trainingData,1);
   
   Print("##### INIT #####");
   
   // We create a new neuronal networks
   ann = f2M_create_standard(nn_layer, nn_input, nn_hidden1, nn_hidden2, nn_output);
   
   // we check if it was created successfully. 0 = OK, -1 = error
   debug("f2M_create_standard()",ann);
   
   // We set the activation function. Don't worry about that. Just do it.
	f2M_set_act_function_hidden (ann, FANN_SIGMOID_SYMMETRIC_STEPWISE);
	f2M_set_act_function_output (ann, FANN_SIGMOID_SYMMETRIC_STEPWISE);
	
	// Some studies show that statistically, the best results are reached using this range; but you can try to change and see is it gets better or worst
	f2M_randomize_weights (ann, -0.77, 0.77);
	
	// I just print to the console the number of input and output neurones. Just to check. Just for debug purpose.
   debug("f2M_get_num_input(ann)",f2M_get_num_input(ann));
   debug("f2M_get_num_output(ann)",f2M_get_num_output(ann));
	
   
   Print("##### REGISTER DATA #####");
   
   // Now we prepare some data examples (with expected output) and we add them to the training set.
   // Once we have add all the examples we want, we're gonna send this training data set to the neurones, so they can learn.
   // prepareData() has a few arguments:
   // - Action to do (train or compute)
   // - the data (here, 3 data per set)
   // - the last argument is the expected output.
   // Here, this function takes the example data and the expected output, and add them to the learning set.
   // Check the comment associated with this function to get more details.
   //
   // here is the pattern we're going to teach:
   // There is 3 numbers. Let's call them a, b and c.
   // You can think of those numbers as being vector coordinates for example (vector going up or down)
   // if a < b && b < c then output = 1
   // if a < b && b > c then output = 0
   // if a > b && b > c then output = 0
   // if a > b && b < c then output = 1
    Print("++++++++++++XY+++++++++++++");
    double xy[];
    double out = -1;
    int nbx = 0;
   for(int i=0;i<ArraySize(XY);i++) {
      //Print(XY[i]);
      nbx = nbx+1;
      ArrayResize(xy,nbx);
      xy[nbx-1] = XY[i];
      Print(xy[nbx-1]);
      if(xy[nbx-1]==0 || xy[nbx-1]==1) {
         //Print(ArraySize(xy));
         
           Normalize(xy);
          prepareXYData("train",xy,0);
          nbx = 0;
          //Print(2);
          ArrayFree(xy);
          //return;
      }
      //Print(2);
   }
  
   Print("++++++++++++XY+++++++++++++");
   
   
  /*
   // UP UP = UP / if a < b && b < c then output = 1
   prepareData("train",1,2,3,1);
   prepareData("train",8,12,20,1);
   prepareData("train",4,6,8,1);
   prepareData("train",0,5,11,1);

   // UP DOWN = DOWN / if a < b && b > c then output = 0
   prepareData("train",1,2,1,0);
   prepareData("train",8,10,7,0);
   prepareData("train",7,10,7,0);
   prepareData("train",2,3,1,0);

   // DOWN DOWN = DOWN / if a > b && b > c then output = 0
   prepareData("train",8,7,6,0);
   prepareData("train",20,10,1,0);
   prepareData("train",3,2,1,0);
   prepareData("train",9,4,3,0);
   prepareData("train",7,6,5,0);

   // DOWN UP = UP / if a > b && b < c then output = 1
   prepareData("train",5,4,5,1);
   prepareData("train",2,1,6,1);
   prepareData("train",20,12,18,1);
   prepareData("train",8,2,10,1);
   */
   // Now we print the full training set to the console, to check how it looks like.
   // this is just for debug purpose.
   printDataArray();
   
   
   Print("##### TRAINING #####");
   
   // We need to train the neurones many time in order for them to be good at what we ask them to do.
   // Here I will train them with the same data (our examples) over and over again, 
   // until they fully understand the rules we are trying to teach them, or until the training has been repeated 'maxTraining' number of time (in this case maxTraining = 500)
   // The better they understand the rule, the lower their mean-Square Error will be.
   // the teach() function returns this mean-Square Error (or MSE)
   // 0.1 or lower is a sufficient number for simple rules
   // 0.02 or lower is better for complex rules like the one we are trying to teach them (it's a patttern recognition. not so easy.)
   for (i=0;i<maxTraining;i++) {
      MSE = teach(); // everytime the loop run, the teach() function is activated. Check the comments associated to this function to understand more.
      Print(MSE);
      if (MSE < 0.002) { // if the MSE is lower than what we defined (here targetMSE = 0.02)
         debug("training finished. Trainings ",i+1); // then we print in the console how many training it took them to understand
         i = maxTraining; // and we go out of this loop
      }
   }
   
   // we print to the console the MSE value once the training is completed
   debug("MSE",f2M_get_MSE(ann));
   
   
   Print("##### RUNNING #####");
   
    Print("++++++++++++XY+++++++++++++");
    ArrayFree(xy);
    out = -1;
    nbx = 0;
    double gain = 0;
    double perte = 0;
   for(int i=0;i<ArraySize(XY);i++) {
      //Print(XY[i]);
      nbx = nbx+1;
      ArrayResize(xy,nbx);
      xy[nbx-1] = XY[i];
      //Print(xy[nbx-1]);
      if(xy[nbx-1]==0 || xy[nbx-1]==1) {
         //Print(ArraySize(xy));
         Normalize(xy);
          double out = ComputXYData("compute",xy,0);
          Print(out);
          if(out>0.5 && xy[nbx-1]==1) {
           // Print("gain");
            gain = gain+1;
          }
          if(out<0.5 && xy[nbx-1]==0) {
            //Print("gain");
            gain = gain+1;
          } else {
          perte = perte+1;
          }
          nbx = 0;
          //Print(2);
          ArrayFree(xy);
          //return;
      }
      
      //Print(2);
   }
   Print("gain = "+gain);
   Print("perte = "+perte);
  
   Print("++++++++++++XY+++++++++++++");
   // And now we can ask the neurone to analyse new data that they never saw.
   // Will they recognize the patterns correctly?
   // You can see that I used the same prepareData() function here, with the first argument set to "compute".
   // The last argument which was dedicated to the expected output when we used this function for registering examples earlier,
   // is now useless, so we leave it to zero.
   // if you prefer, you can call directly the compute() function.
   // In this case, the structure is compute(inputVector[]);
   // So instead of prepareData("compute",1,3,1,0); you would do something like:
   //    double inputVector[]; // declare a new array
   //    ArrayResize(inputVector,f2M_get_num_input(ann)); // resize the array to the number of neuronal input
   //    inputVector[0] = 1; // add in the array the data
   //    inputVector[1] = 3;
   //    inputVector[2] = 1;
   //    result = compute(inputVector); // call the compute() function, with the input array.
   // the prepareData() function call the compute() function, which print the result to the console, se we can check if the neurones were right or not.
   /*debug("1,3,1 = UP DOWN = DOWN. Should output 0.","");
   prepareData("compute",1,3,1,0);
   
   debug("1,2,3 = UP UP = UP. Should output 1.","");
   prepareData("compute",1,2,3,0);
   
   debug("3,2,1 = DOWN DOWN = DOWN. Should output 0.","");
   prepareData("compute",3,2,1,0);
   
   debug("45,2,89 = DOWN UP = UP. Should output 1.","");
   prepareData("compute",45,2,89,0);
   
   debug("1,3,23 = UP UP = UP. Should output 1.","");
   prepareData("compute",1,3,23,0);
   
   debug("7,5,6 = DOWN UP = UP. Should output 1.","");
   prepareData("compute",7,5,6,0);
   
   debug("2,8,9 = UP UP = UP. Should output 1.","");
   prepareData("compute",2,8,9,0);
   
   Print("=================================== END EXECUTION ================================");*/
   return;
}
