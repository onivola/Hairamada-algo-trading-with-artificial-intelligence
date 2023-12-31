// We include the Fann2MQl library
#include <Fann2MQL.mqh>

#property copyright "Copyright © 2009, Julien Loutre"
#property link      "http://www.forexcomm.com"



// the total number of layers. here, there is one input layer, 2 hidden layers, and one output layer = 4 layers.
int nn_layer = 4;
int nn_input = 2; // Number of input neurones. Our pattern is made of 3 numbers, so that means 3 input neurones.
int nn_hidden1 = 8; // Number of neurones on the first hidden layer
int nn_hidden2 = 5; // number on the second hidden layer
int nn_output = 1; // number of outputs

// trainingData[][] will contain the examples we're gonna use to teach the rules to the neurones.
double      trainingData[][3];  // IMPORTANT! size = nn_input + nn_output


int maxTraining = 20000;  // maximun number of time we will train the neurones with some examples
double targetMSE = 0.0002; // the Mean-Square Error of the neurones we should get at most (you will understand this lower in the code)

int ann; // This var will be the identifier of the neuronal network.

// When the indicator is removed, we delete all the neuronal networks from the memory of the computer.
int deinit() {
   f2M_destroy_all_anns();
   return(0);
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
double ComputXYData(string action, double& XY[],double output) {
   double inputVector[];
   double outputVector[];
   //Print(f2M_get_num_input(ann));
   // we resize the arrays to the right size
  ArrayResize(inputVector,f2M_get_num_input(ann));
   ArrayResize(outputVector,f2M_get_num_output(ann));
   
   Print("ininin");
   Print(ArraySize(XY)-1);
   for(int i=0; i<ArraySize(XY)-1;i++) {
       inputVector[i] = XY[i];
       //Print(inputVector[i]);
   }
   outputVector[0] =  output;
   //Print("outoutoutout");
    //Print(outputVector[0]);
      return compute(inputVector);
   // if you have more input than 3, just change the structure of this function.
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
   for(int i=0; i<ArraySize(XY)-1;i++) {
       inputVector[i] = XY[i];
       //Print(inputVector[i]);
   }
   Print("num input"+f2M_get_num_input(ann));
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
   //Print(f2M_get_num_input(ann));
   //Print(f2M_get_num_output(ann));
   int i,j;
   double MSE;
   double inputVector[];
   double outputVector[];
    
   ArrayResize(inputVector,f2M_get_num_input(ann));
   ArrayResize(outputVector,f2M_get_num_output(ann));
   int call;
   int bufferSize = ArraySize(trainingData)/(f2M_get_num_input(ann)+f2M_get_num_output(ann))-1;
   
   //Print(f2M_get_num_input(ann));
   //Print(bufferSize);
  
   
   for (i=0;i<bufferSize;i++) {
      for (j=0;j<f2M_get_num_input(ann);j++) {
         inputVector[j] = trainingData[i][j];
      }
      outputVector[0] = trainingData[i][2];
      //Print("output-----------");
      //Print(outputVector[0]);
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

