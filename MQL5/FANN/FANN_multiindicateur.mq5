// We include the Fann2MQl library
#include <Fann2MQL.mqh>
#property copyright "Copyright © 2009, Julien Loutre"
#property link      "http://www.forexcomm.com"
#include <Trade\Trade.mqh>
#include "include/Indicateur.mqh"
int Handle;
bool fit = false;
double RSIBuffer200[];
double RSIBuffer100[];
double RSIBuffer50[];
double RSIBuffer14[];
double MACDBuffer[];
double MAOnRSIBuffer[];


double RSIBuffer2002[];
double RSIBuffer1002[];
double RSIBuffer502[];
double RSIBuffer142[];
double MACDBuffer2[];
double MAOnRSIBuffer2[];
double spickArray[];
input ENUM_TIMEFRAMES periode = PERIOD_M1;

input int RSI_period = 14;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
input int learnDay = 2;
input int nb_y = 10;
input double RSI_UP = 80;
input double RSI_DOWN = 20;
int nb_chandel = 0;
bool count = false;
int nb_test = 1441*learnDay;
// the total number of layers. here, there is one input layer, 2 hidden layers, and one output layer = 4 layers.
int nn_layer = 4;
int nn_input = 801; // Number of input neurones. Our pattern is made of 3 numbers, so that means 3 input neurones.
int nn_hidden1 = 50; // Number of neurones on the first hidden layer
int nn_hidden2 = 50; // number on the second hidden layer
int nn_output = 1; // number of outputs

// trainingData[][] will contain the examples we're gonna use to teach the rules to the neurones.
double      trainingData[][802];  // IMPORTANT! size = nn_input + nn_output


int maxTraining = 500;  // maximun number of time we will train the neurones with some examples
double targetMSE =  0.0002; // the Mean-Square Error of the neurones we should get at most (you will understand this lower in the code)

int ann; // This var will be the identifier of the neuronal network.

// When the indicator is removed, we delete all the neuronal networks from the memory of the computer.
int OnInit() {
   MathSrand(1);
   return 0;
}
int deinit() {
   
   f2M_destroy_all_anns();
   return(0);
}
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

  
  void AroonIndicatorProcessor()
   {

     

      //https://www.mql5.com/en/docs/series/copybuffer
      // Aroon_handle represent information captured from Icustom 
      // 0 represent first, 1 represent second buffer as it is arranged in your indicator code section >>>As for my indicator there are only two outputs as there are only 2 buffers
      // 0 represent start position 
      // 3 represent buffer 0, 1 & 2 copy 
      // AroonBull reprenet declared array created to indicator output values
       GetiRSIArray(nb_test,periode,14,RSIBuffer14);
       GetiRSIArray(nb_test,periode,200,RSIBuffer200);
       GetiRSIArray(nb_test,periode,100,RSIBuffer100);
       GetiRSIArray(nb_test,periode,50,RSIBuffer50);
       
     //updateReward();
   
      //return true;
  
      
   }
    void AroonIndicatorProcessorRun()
   {

     

      //https://www.mql5.com/en/docs/series/copybuffer
      // Aroon_handle represent information captured from Icustom 
      // 0 represent first, 1 represent second buffer as it is arranged in your indicator code section >>>As for my indicator there are only two outputs as there are only 2 buffers
      // 0 represent start position 
      // 3 represent buffer 0, 1 & 2 copy 
      // AroonBull reprenet declared array created to indicator output values
    GetiRSIArray(201,periode,14,RSIBuffer142);
       GetiRSIArray(201,periode,200,RSIBuffer2002);
       GetiRSIArray(201,periode,100,RSIBuffer1002);
       GetiRSIArray(201,periode,50,RSIBuffer502);
     //updateReward();
   
      //return true;
  
      
   }
void Get_XY(double& XY[],double &iy[]) {
   double ResEnter[];
   double ResY[];
   
   for(int i=nb_y;i<ArraySize(RSIBuffer14)-201;i++) {
      //Print(RSIOnMABuffer[i]);
      if((RSIBuffer14[i]>=RSI_UP || RSIBuffer14[i]<=RSI_DOWN) && i <ArraySize(RSIBuffer14)-201) {
         double XYnorm[];
         getChandelierbyIndice(_Symbol,PERIOD_M1, nb_test,ResEnter,i);
         for(int x=i;x<i+200;x++) {
            ArrayResize(XYnorm,ArraySize(XYnorm)+1);
            //Print(ArraySize(XYnorm));
            XYnorm[ArraySize(XYnorm)-1]=RSIBuffer200[x];
            ArrayResize(XYnorm,ArraySize(XYnorm)+1);
            //Print(ArraySize(XYnorm));
            XYnorm[ArraySize(XYnorm)-1]=RSIBuffer100[x];
            ArrayResize(XYnorm,ArraySize(XYnorm)+1);
            //Print(ArraySize(XYnorm));
            XYnorm[ArraySize(XYnorm)-1]=RSIBuffer50[x];
            ArrayResize(XYnorm,ArraySize(XYnorm)+1);
            //Print(ArraySize(XYnorm));
            XYnorm[ArraySize(XYnorm)-1]=RSIBuffer14[x];
         }
         normalizeArrays(XYnorm);
         for(int x=0;x<ArraySize(XYnorm);x++) {
            ArrayResize(XY,ArraySize(XY)+1);
            XY[ArraySize(XY)-1]=XYnorm[x];
         }
         getChandelierbyIndice(_Symbol,PERIOD_M1, nb_test,ResY,i+nb_y);
         ArrayResize(XY,ArraySize(XY)+1);
         ArrayResize(iy,ArraySize(iy)+1);
         XY[ArraySize(XY)-1]=1;
         if(ResY[3]<ResEnter[2]) {
            XY[ArraySize(XY)-1]=0;
            
         }
         iy[ArraySize(iy)-1] = ArraySize(XY)-1;
         
         //i = i+20;
      }
      
   }

}
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
bool checkValue(double value,double& array[]) {
    for(int i=0;i<ArraySize(array);i++) {
      if(array[i]==value) {
         return true;
      }
    
    }
    return false;
}
void prepareXYData(string action, double& XY[],double output) {
   double inputVector[];
   double outputVector[];
   //Print(f2M_get_num_input(ann));
   //Print("55555555555555555555");
   // we resize the arrays to the right size
  ArrayResize(inputVector,f2M_get_num_input(ann));
   ArrayResize(outputVector,f2M_get_num_output(ann));
   
   Print("ininin");
   Print(ArraySize(inputVector));
   Print(ArraySize(XY));
   Print(ArraySize(outputVector));
   for(int i=0; i<ArraySize(XY)-1;i++) {
       inputVector[i] = XY[i];
       //Print(inputVector[i]);
   }
   outputVector[0] =  output;
   Print("outoutoutout");
    Print(outputVector[0]);
   if (action == "train") {
      addTrainingData(inputVector,outputVector);
   }
   if (action == "compute") {
      compute(inputVector);
   }
   // if you have more input than 3, just change the structure of this function.
}
int getSymbolPositionTotal(string symbolName){
   
   int total = 0;
   
   for(int i = 0; i < PositionsTotal(); i += 1){
   
      if(PositionGetSymbol(i) == symbolName){
         total += 1;
      }
   }
   
   return total;

}
double GetTmpPrice() { //Get current price
   MqlTick Latest_Price; // Structure to get the latest prices      
   SymbolInfoTick(Symbol() ,Latest_Price); // Assign current prices to structure 
   static double dBid_Price; 

   static double dAsk_Price; 

   dBid_Price = Latest_Price.bid;  // Current Bid price.
   dAsk_Price = Latest_Price.ask;  // Current Ask price.
   
   return dBid_Price;
}
int Seconds()
{
  datetime time = (uint)TimeCurrent();
  return((int)time % 60);
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
void close(string symbolName){   

   CTrade trade;

   if(PositionSelectByTicket(getLastTicket(symbolName))){

      trade.PositionClose(PositionGetInteger(POSITION_TICKET));

   }
}
void OnTick() {
   if(fit==false) {
         if(fit()==true) {
             fit=true;
         }
        
   }
   if(fit==true) {
   
   
   
   int posTotal = getSymbolPositionTotal(_Symbol);
   AroonIndicatorProcessorRun();
   int sec = Seconds();
   if(posTotal>0 && sec<=5 && count==false) {
      nb_chandel = nb_chandel+1;
      count=true;
   }
   if(sec>10) {
      count=false;
   }
   
   if(posTotal<=0  && (RSIBuffer142[0]>=RSI_UP || RSIBuffer142[0]<=RSI_DOWN)) {
      //normalizeArrays(RSIBuffer2);
      //Print(ArraySize(RSIBuffer2));
      
      
      
      double XYnorm[];
         
         for(int x=0;x<200;x++) {
            ArrayResize(XYnorm,ArraySize(XYnorm)+1);
            //Print(ArraySize(XYnorm));
            XYnorm[ArraySize(XYnorm)-1]=RSIBuffer2002[x];
            ArrayResize(XYnorm,ArraySize(XYnorm)+1);
            //Print(ArraySize(XYnorm));
            XYnorm[ArraySize(XYnorm)-1]=RSIBuffer1002[x];
            ArrayResize(XYnorm,ArraySize(XYnorm)+1);
            //Print(ArraySize(XYnorm));
            XYnorm[ArraySize(XYnorm)-1]=RSIBuffer502[x];
            ArrayResize(XYnorm,ArraySize(XYnorm)+1);
            //Print(ArraySize(XYnorm));
            XYnorm[ArraySize(XYnorm)-1]=RSIBuffer142[x];
         }
         normalizeArrays(XYnorm);
      
      
      
      double out = compute(XYnorm);
      Print(out);
      //Print(RSIOnMABuffer2[0]);
       //Print(RSIOnMABuffer2[200]);
      //Print(ArraySize(RSIOnMABuffer2));
      if(out<0.5) {
         SellPosition(0.2,10,10);
      }
      else {
          BuyPosition(0.2,10,10);
      }
      
   }
   if(posTotal>0 && nb_chandel>=nb_y) {
      close(_Symbol);
      nb_chandel = 0;
   }
   
   }

}
bool BuyPosition(double Lot,double SL,double TP) { //buy sl tp
   CTrade trade;
   double  price = GetTmpPrice();
   if(trade.Buy(Lot,_Symbol,0,0,0)){
      int code = (int)trade.ResultRetcode();
      double ticket = trade.ResultOrder();
      return true ;
   }
   /*if(trade.Buy(Lot,_Symbol,0,price-SL,price+TP)){
      int code = (int)trade.ResultRetcode();
      double ticket = trade.ResultOrder();
      return true ;
   }*/
   return false;

}
bool SellPosition(double Lot,double SL,double TP) { //sell sl tp
   CTrade trade;
   double  price = GetTmpPrice();
   if(trade.Sell(Lot,_Symbol,0,0,0)){
      int code = (int)trade.ResultRetcode();
      return true ;
   }
   /*if(trade.Sell(Lot,_Symbol,0,price+SL,price-TP)){
      int code = (int)trade.ResultRetcode();
      return true ;
   }*/
   
   return false;

}

bool fit() {
   //initIndicator();
   AroonIndicatorProcessor();
   double XY[];
   double iy[];
   Get_XY(XY,iy);
   Print("size");
   Print(ArraySize(XY));
   int nb = 0;
   double Xtrain[];
  
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
   
    for(int i=0;i<ArraySize(XY);i++) {
      //nb = nb+1;
      ArrayResize(Xtrain,ArraySize(Xtrain)+1);
      Xtrain[ArraySize(Xtrain)-1] = XY[i];
      if(XY[i]==1 && checkValue(i,iy)){
         Print(XY[i]);
         prepareXYData("train",Xtrain,1);
         ArrayResize(Xtrain,0);
         //nb=0;
      }
      if(XY[i]==0 && checkValue(i,iy)){
         Print(XY[i]);
         prepareXYData("train",Xtrain,0);
        ArrayResize(Xtrain,0);
         //nb=0;
      }
   }
  
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
      if (MSE < targetMSE) { // if the MSE is lower than what we defined (here targetMSE = 0.02)
         debug("training finished. Trainings ",i+1); // then we print in the console how many training it took them to understand
         i = maxTraining; // and we go out of this loop
      }
   }
   
   // we print to the console the MSE value once the training is completed
   debug("MSE",f2M_get_MSE(ann));
   
   
   Print("##### RUNNING #####");
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
  /* debug("1,3,1 = UP DOWN = DOWN. Should output 0.","");
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
   */
   
   
   Print("=================================== END EXECUTION ================================");
   return true;
}

int start() {
   return(0);
}

/*************************
** printDataArray()
** Print the datas used for training the neurones
** This is useless. Just created for debug purpose.
*************************/
void printDataArray() {
   int i,j;
   int bufferSize = ArraySize(trainingData)/(f2M_get_num_input(ann)+f2M_get_num_output(ann))-1;
   string lineBuffer = "";
   for (i=0;i<bufferSize;i++) {
      for (j=0;j<(f2M_get_num_input(ann)+f2M_get_num_output(ann));j++) {
         lineBuffer = StringConcatenate(lineBuffer, trainingData[i][j], ",");
      }
      debug("DataArray["+i+"]", lineBuffer);
      lineBuffer = "";
   }
}


/*************************
** prepareData()
** Prepare the data for either training or computing.
** It takes the data, put them in an array, and send them to the training or running function
** Update according to the number of input/output your code needs.
*************************/
void prepareData(string action, double a, double b, double c, double output) {
   double inputVector[];
   double outputVector[];
   // we resize the arrays to the right size
   ArrayResize(inputVector,f2M_get_num_input(ann));
   ArrayResize(outputVector,f2M_get_num_output(ann));
   
   inputVector[0] = a;
   inputVector[1] = b;
   inputVector[2] = c;
   outputVector[0] = output;
   if (action == "train") {
      addTrainingData(inputVector,outputVector);
   }
   if (action == "compute") {
      compute(inputVector);
   }
   // if you have more input than 3, just change the structure of this function.
}


/*************************
** addTrainingData()
** Add a single set of training data (data example + expected output) to the global training set
*************************/
void addTrainingData(double& inputArray[], double& outputArray[]) {
   int j;
   int bufferSize = ArraySize(trainingData)/(f2M_get_num_input(ann)+f2M_get_num_output(ann))-1;
   
   //register the input data to the main array
   for (j=0;j<f2M_get_num_input(ann);j++) {
      trainingData[bufferSize][j] = inputArray[j];
   }
   for (j=0;j<f2M_get_num_output(ann);j++) {
      trainingData[bufferSize][f2M_get_num_input(ann)+j] = outputArray[j];
   }
   
   ArrayResize(trainingData,bufferSize+2);
}


/*************************
** teach()
** Get all the trainign data and use them to train the neurones one time.
** In order to properly train the neurones, you need to run this function many time,
** until the Mean-Square Error get low enough.
*************************/
double teach() {
   int i,j;
   double MSE;
   double inputVector[];
   double outputVector[];
   ArrayResize(inputVector,f2M_get_num_input(ann));
   ArrayResize(outputVector,f2M_get_num_output(ann));
   int call;
   int bufferSize = ArraySize(trainingData)/(f2M_get_num_input(ann)+f2M_get_num_output(ann))-1;
   for (i=0;i<bufferSize;i++) {
      for (j=0;j<f2M_get_num_input(ann);j++) {
         inputVector[j] = trainingData[i][j];
      }
      outputVector[0] = trainingData[i][3];
      //f2M_train() is showing the neurones only one example at a time.
      call = f2M_train(ann, inputVector, outputVector);
   }
   // Once we have show them an example, we check if how good they are by checking their MSE. If it's low, they learn good!
   MSE = f2M_get_MSE(ann);
   return(MSE);
}


/*************************
** compute()
** Compute a set of data and returns the computed result
*************************/
double compute(double &inputVector[]) {
   int j;
   int out;
   double output;
   ArrayResize(inputVector,f2M_get_num_input(ann));
   
   // We sent new data to the neurones.
   out = f2M_run(ann, inputVector);
   // and check what they say about it using f2M_get_output().
   output = f2M_get_output(ann, 0);
   debug("Computing()",MathRound(output));
   return(output);
}


/*************************
** debug()
** Print data to the console
*************************/
void debug(string a, string b) {
   Print(a+" ==> "+b);
}

