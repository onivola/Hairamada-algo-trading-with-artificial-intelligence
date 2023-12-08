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
import numpy as np
def Fit_model():
    lstm = ModelLSTM("datasetLSTM.csv") 
    login=3939327
    password="Alikagasy01"
    Server="Deriv-Demo"

    log = lstm.MQL5Login(login,password,Server)
    print(log)
    SYMBOL = "Volatility 75 Index"
    #SYMBOL = "Crash 500 Index"
    TIMEFRAME = mt5.TIMEFRAME_M1
    df = lstm.DFdataset(SYMBOL,TIMEFRAME,2022,1,1,2022,1,7)
    print(df)
    training_test = lstm.Iloc_df(df)
    training_set_scaled = lstm.fitTransform(training_test)

    XY = lstm.Get_xtrain_ytrain(training_set_scaled)

    X_train = XY[0]

    y_train = XY[1]

    lstm.fit_LSTM(X_train,y_train,50)
 


dataset = Dataset("marsimacd", 36)
lstm = ModelLSTM("marsimacd.csv") 
df = dataset.GetCSVData("marsimacd.csv")
print(df)

#training_set =lstm.Iloc_df(df)
#print(training_set)

training_set_scaleMA1 = lstm.fitTransform(df,1,2)
training_set_scaleMA15 = lstm.fitTransform(df,2,3)
training_set_scaleMA12 = lstm.fitTransform(df,3,4)
training_set_scaleRSI = lstm.fitTransform(df,4,5)
training_set_scaleMACD = lstm.fitTransform(df,5,6)
print(training_set_scaleMA1)
print(len(training_set_scaleMA1))
""""print(len(training_set_scaleMA1))
print(training_set_scaleMA15)
print(len(training_set_scaleMA15))
print(training_set_scaleMA12)
print(len(training_set_scaleMA12))
print(training_set_scaleRSI)
print(len(training_set_scaleRSI))
print(training_set_scaleMACD)
print(len(training_set_scaleMACD))
"""
print(training_set_scaleMACD[0][0])

XY = dataset.Get_XY_rsi_macd(training_set_scaleMA1,training_set_scaleMA15,training_set_scaleMA12,training_set_scaleRSI,training_set_scaleMACD,15,5)
X = XY[0]
Y = XY[1]
print(X[0])
print(len(X[0]))
print(len(Y))

X_train, y_train = np.array(X), np.array(Y)

X_train = np.reshape(X_train, (X_train.shape[0], X_train.shape[1], 1))

print(len(X_train))
print(X_train[0])
print(len(X_train[0]))

modelxx = tf.keras.models.load_model("LSTM.model")
#lstm.fit_LSTM(X_train,y_train,150)

predicted_stock_price = modelxx.predict(X_train[0])
print("predict")
print(predicted_stock_price)
    #break
#model.fitModel("chrash500",4000,X,Y,15*3,0.001)
"""XY = dataset.Get_XY_rsi(df,15,5)
X = XY[0]
Y = XY[1]
print(X[0])
print(len(X[0]))
model = Model("model")"""
#model.fitModel("chrash500",4000,X,Y,15*3,0.001)

     

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