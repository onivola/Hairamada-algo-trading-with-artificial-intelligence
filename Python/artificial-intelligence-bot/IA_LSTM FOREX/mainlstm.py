from Dataset import Dataset
from Model import Model
from Working import Working
from ModelLSTM import ModelLSTM
import time
from threading import Thread
from time import sleep
import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'
from tensorflow import keras 
import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Dropout, Activation, Flatten
import MetaTrader5 as mt5
import MetaTrader5 as mt
def run(name,file_data,file_predict):
    modelx = Model(name)
    work = Working(name)
    #modelx.LoadModel(name)
    modelxx = tf.keras.models.load_model(name)
    last_nb = -1
    last_predict = -10
    while(1):
        dc = work.open_dataset(file_data)
        time.sleep(5)
        if 'MA5' in dc:
            #print(dc)
            new_nb = float(dc['MA5'][15])
            #print(last_nb)
            if(new_nb>last_nb):
                XTEST = work.CSVGet_X(dc)
                print(XTEST)
                res = modelxx.predict(XTEST) #predict
                print(res)
                res = round(float(res[0]),4)
                if(res==last_predict):
                    last_predict = res
                    res = res+0.001
                if(res!=last_predict):
                    last_predict = res
                
                    
                while(work.Write_Predect(res,file_predict)==False): #write predict value
                    e = 1
                last_nb=new_nb

def Get_position(last_predict,predict):
    if(last_predict<predict):
        return 1
    else:
        return -1
"""
modellstmx = tf.keras.models.load_model("lstm.model")
lstm = ModelLSTM("datasetLSTM.csv") 
workk = Working("datasetLSTM.csv")
df = workk.open_dataset_backtest("datasetLSTM.csv")
training = df[:60]

x = lstm.get_x(df)

print(x)

y = modellstmx.predict(x)
print(y) 
print(Get_position(x,y))
"""
def run_demo(name,file_data,file_predict):
    modelx = Model(name)
    work = Working(name)
    lstm = ModelLSTM(name) 
    #modelx.LoadModel(name)
    modelxx = tf.keras.models.load_model(name)
    last_nb = -1
    last_predict = -1
    buy = 0
    sell =0
    while(1):
        dc = work.open_dataset_backtest(file_data)
        print(dc)
        time.sleep(1)
        if 'VALUE' in dc:
            #print(dc)
            new_nb = float(dc['VALUE'][60])
            print(last_nb)
            if(new_nb!=last_nb):
                pos = 0
                XTEST =  lstm.get_x(dc)
                print(XTEST)
                res = modelxx.predict(XTEST) #predict
                restemp = res
                if(last_predict==-1):
                    last_predict =  XTEST[0][0][len(XTEST[0][0])-1]
                print(res)
                res = Get_position(last_predict,res)
                if(res==1):
                    buy = buy+1
                    pos = buy
                if(res==-1):
                    sell = sell-1
                    pos = sell
                while(work.Write_Predect_backtest(pos,file_predict)==False): #write predict value
                    e = 1
                last_nb=new_nb
                last_predict = restemp
def run_reel(name,file_data,file_predict):
    modelx = Model(name)
    work = Working(name)
    lstm = ModelLSTM(name) 
    #modelx.LoadModel(name)
    modelxx = tf.keras.models.load_model(name)
    last_nb = -1
    last_predict = -1
    buy = 0
    sell =0
    while(1):
        dc = work.open_dataset(file_data)
        print(dc)
        time.sleep(1)
        if 'VALUE' in dc:
            #print(dc)
            new_nb = float(dc['VALUE'][60])
            print(last_nb)
            if(new_nb!=last_nb):
                pos = 0
                XTEST =  lstm.get_x(dc)
                print(XTEST)
                res = modelxx.predict(XTEST) #predict
                restemp = res
                if(last_predict==-1):
                    last_predict =  XTEST[0][0][len(XTEST[0][0])-1]
                print(res)
                res = Get_position(last_predict,res)
                if(res==1):
                    buy = buy+1
                    pos = buy
                if(res==-1):
                    sell = sell-1
                    pos = sell
                while(work.Write_Predect(pos,file_predict)==False): #write predict value
                    e = 1
                last_nb=new_nb
                last_predict = restemp


Chrash500_file_data = "datasettest1.csv"
Chrash500_file_predict = "predict1.csv"


Chrash1000_file_data = "datasettest2.csv"
Chrash1000_file_predict = "predict2.csv"

lstmvolatil_file_data = "datasetLSTM.csv"
lstmvolatil_file_predict = "predictLSTM.csv"


#run_reel_rsi("chrash500marsi.model",Chrash500_file_data,Chrash500_file_predict)
#run_demo("LSTM40.model",lstmvolatil_file_data,lstmvolatil_file_predict)
run_reel("LSTM40.model",lstmvolatil_file_data,lstmvolatil_file_predict)

#work = Working("sdf")
#dc = work.open_dataset_backtest(lstmvolatil_file_data)
#print(dc)
#workk = Working("datasetLSTM.csv")
#df = workk.open_dataset_backtest("datasetLSTM.csv")
def Get_df(sy,sm,sd,ey,em,ed):
    lstm = ModelLSTM("datasetLSTM.csv") 
    login=3939327
    password="Alikagasy01"
    Server="Deriv-Demo"

    log = lstm.MQL5Login(login,password,Server)
    print(log)

    df = lstm.DFdataset(sy,sm,sd,ey,em,ed)
    return df

def Fit_model():
    lstm = ModelLSTM("datasetLSTM.csv") 
    login=129927
    password="@Aa!!12@"
    Server="JustForex-Demo"
    
    log = lstm.MQL5Login(login,password,Server)
    print(log)
    #SYMBOL = "Volatility 75 Index"
    SYMBOL = "EURUSD.m"
    TIMEFRAME = mt5.TIMEFRAME_M1
    df = lstm.DFdataset(SYMBOL,TIMEFRAME,2022,1,5,2022,1,12)
    print(df)
    training_test = lstm.Iloc_df(df)
    print(training_test)
    training_set_scaled = lstm.fitTransform(training_test)

    XY = lstm.Get_xtrain_ytrain(training_set_scaled)

    X_train = XY[0]
    
    y_train = XY[1]

    lstm.fit_LSTM(X_train,y_train,50)
 



#Fit_model()
#lstm = ModelLSTM("datasetLSTM.csv") 
#modellstmx = tf.keras.models.load_model("lstm.model")
#dataset_train =  Get_df(2022,1,1,2022,1,2)
#dataset_test =  Get_df(2022,1,2,2022,1,3)
#print(dataset_train)
#print(dataset_test)

#real_stock_price = dataset_test.iloc[:, 1:2].values
#print(real_stock_price)

#predicted_stock_price = lstm.get_inputs(dataset_train,dataset_test,modellstmx)
 

#lstm.plot_predict(real_stock_price,predicted_stock_price)
#get_inputs(self,dataset_train,dataset_test)

"""
lstm = ModelLSTM("datasetLSTM.csv") 

X_test = lstm.get_x(df)      
regressor = tf.keras.models.load_model("lstm.model")
predicted_stock_price = regressor.predict(X_test) 
print(predicted_stock_price) 

"""
"""T=Thread(target=run,args=("Chrash500.model",Chrash500_file_data,Chrash500_file_predict))
T1=Thread(target=run,args=("Chrash1000.model",Chrash1000_file_data,Chrash1000_file_predict))

T.start()
T1.start()
T.join()
T1.join()"""