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



lstm = ModelLSTM("datasetLSTM.csv") 

#Loading the Dataset
SYMBOL = "EURUSD.m"
TIMEFRAME = mt5.TIMEFRAME_M1
dataset_train  = lstm.DFdataset_1(SYMBOL,TIMEFRAME,2022,2,7,2022,2,9)
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
for i in range(60, 2035):
    X_train.append(training_set_scaled[i-60:i, 0])
    y_train.append(training_set_scaled[i, 0])
X_train, y_train = np.array(X_train), np.array(y_train)

X_train = np.reshape(X_train, (X_train.shape[0], X_train.shape[1], 1))

print(X_train)
#Building the LSTM
#lstm.fit_LSTM(X_train,y_train,200)
modelx = Model("LSTM40.model")

regressor = tf.keras.models.load_model("LSTM40.model")

#Predicting Future Stock using the Test Set
dataset_test = lstm.DFdataset_1(SYMBOL,TIMEFRAME,2022,2,9,2022,2,10)
print(dataset_test)
real_stock_price = dataset_test.iloc[:28, 1:2].values

#Creating Data
dataset_total = pd.concat((dataset_train['open'], dataset_test['open']), axis = 0)
inputs = dataset_total[len(dataset_total) - len(dataset_test) - 59:].values
inputs = inputs.reshape(-1,1)
inputs = sc.transform(inputs)
X_test = []
for i in range(60, 60+28):
    X_test.append(inputs[i-60:i, 0])
X_test = np.array(X_test)
X_test = np.reshape(X_test, (X_test.shape[0], X_test.shape[1], 1))
predicted_stock_price = regressor.predict(X_test)
predicted_stock_price = sc.inverse_transform(predicted_stock_price)

print(predicted_stock_price)

lstm.plot_predict(real_stock_price,predicted_stock_price)
lstm.plot_predict2(training_set,training_set)