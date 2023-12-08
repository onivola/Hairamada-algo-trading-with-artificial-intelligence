import pyautogui
import time
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
from datetime import datetime

import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from sklearn.preprocessing import MinMaxScaler
from keras.models import Sequential
from keras.layers import Dense
from keras.layers import LSTM
from keras.layers import Dropout
#import pyautogui
lstm = ModelLSTM("datasetLSTM.csv") 
login=129927
password="@Aa!!12@"
Server="JustForex-Demo"
log = lstm.MQL5Login(login,password,Server)

def Get_Curent_time(SYMBOL,TIMEFRAME):
    start_dt = datetime(2022, 4, 14)
    print(start_dt)
    bars = mt5.copy_rates_from_pos(SYMBOL, TIMEFRAME, 0,1)

    df = pd.DataFrame(bars)[['time', 'open', 'high', 'low', 'close']]
    df['time'] = pd.to_datetime(df['time'], unit='s')

    print(df)
    print(df['time'][0])
    return df['time'][0]
    
def DFdataset_fromnow(SYMBOL,TIMEFRAME,sy,sm,sd):
    start_dt = datetime(sy, sm, sd)
    end_dt =  Get_Curent_time(SYMBOL,TIMEFRAME)
    #print(end_dt)
    # request ohlc data a save them in a pandas DataFrame
    bars = mt5.copy_rates_range(SYMBOL, TIMEFRAME, start_dt, end_dt)

    df = pd.DataFrame(bars)[['time', 'open', 'high', 'low', 'close']]
    df['time'] = pd.to_datetime(df['time'], unit='s')
    return df 

lstm = ModelLSTM("datasetLSTM.csv") 

#Loading the Dataset
SYMBOL = "EURUSD.m"
TIMEFRAME = mt5.TIMEFRAME_M1
dataset_train  = lstm.DFdataset_1(SYMBOL,TIMEFRAME,2022,3,15,2022,4,14)
print(dataset_train)
training_set = dataset_train.iloc[:, 1:2].values
print(training_set)

#Feature Scaling
sc = MinMaxScaler(feature_range = (0, 1))
training_set_scaled = sc.fit_transform(training_set)

print(training_set_scaled)

#Creating Data with Timesteps
X_train = []
y_train = []
for i in range(60, len(training_set_scaled)):
    X_train.append(training_set_scaled[i-60:i, 0])
    y_train.append(training_set_scaled[i, 0])
X_train, y_train = np.array(X_train), np.array(y_train)

X_train = np.reshape(X_train, (X_train.shape[0], X_train.shape[1], 1))

print(X_train)




#Predicting Future Stock using the Test Set
dataset_test = DFdataset_fromnow(SYMBOL,TIMEFRAME,2022,4,14)
print(dataset_test)
real_stock_price = dataset_test.iloc[0:100, 1:2].values

#Building the LSTM
lstm.fit_LSTM(X_train,y_train,200)
modelx = Model("LSTMolymp.model")
regressor = tf.keras.models.load_model("LSTM40.model")
#Creating Data
def CreatData(dataset_train,dataset_test,nb):
    dataset_test = dataset_test['open']
    print(dataset_test[1:len(dataset_test)])
    print(dataset_test[0])
    #dataset_test = dataset_test[1:len(dataset_test)]
    dataset_total = pd.concat((dataset_train['open'], dataset_test), axis = 0)
    inputs = dataset_total[len(dataset_total) - len(dataset_test) - 59:].values
    test = []
    #print(inputs)
    test.append(inputs[:60])
    print(test)
    print(inputs[1:61])
    print(inputs[0])
    print(inputs[58])
    inputs = inputs.reshape(-1,1)
    inputs = sc.transform(inputs)
    X_test = []

    for i in range(60, 60+nb):
        X_test.append(inputs[i-60:i, 0])
    print(X_test)
    X_test = np.array(X_test)
    
    X_test = np.reshape(X_test, (X_test.shape[0], X_test.shape[1], 1))
    predicted_stock_price = regressor.predict(X_test)
    predicted_stock_price = sc.inverse_transform(predicted_stock_price)

    print(predicted_stock_price)
    return predicted_stock_price
predicted_stock_price = CreatData(dataset_train,dataset_test,100)
lstm.plot_predict(real_stock_price,predicted_stock_price)
lstm.plot_predict2(training_set,training_set)