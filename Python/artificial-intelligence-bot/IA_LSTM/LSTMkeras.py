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
login=3939327
password="Alikagasy01"
Server="Deriv-Demo"
log = lstm.MQL5Login(login,password,Server)
print(log)


lstm = ModelLSTM("datasetLSTM.csv") 

#Loading the Dataset
SYMBOL = "Volatility 75 Index"
TIMEFRAME = mt5.TIMEFRAME_M1
dataset_train  = lstm.DFdataset_1(SYMBOL,TIMEFRAME,2022,2,1,2022,2,9)
print(dataset_train)

training_set = dataset_train.iloc[:, 1:2].values

print(training_set)

#Feature Scaling
sc = MinMaxScaler(feature_range = (0, 1))
training_set_scaled = sc.fit_transform(training_set)


#print(training_set_scaled)

#Creating Data with Timesteps
XY = lstm.Get_xtrain_ytrain_norm(training_set_scaled)
X_train = np.array(XY[0])
#print(X_train)
y_train = np.array(XY[1])
#print(y_train)
#print("X_train")
#print(len(X_train))
#print(X_train)
#print("y_train")
#print(y_train)
#Building the LSTM
#lstm.fit_LSTM(X_train,y_train,50)
modelx = Model("LSTM40.model")

regressor = tf.keras.models.load_model("LSTM40.model")

#Predicting Future Stock using the Test Set
dataset_test = lstm.DFdataset_1(SYMBOL,TIMEFRAME,2022,2,9,2022,2,10)
print(dataset_test)
#real_stock_price = dataset_test.iloc[:28, 1:2].values
#real_stock_price = sc.fit_transform(real_stock_price)

#print(dataset_train)
test = dataset_train
dataset_total = test.append(dataset_test)
#print(dataset_total)

test  =dataset_total.iloc[len(dataset_total['open']) - len(dataset_test['open']):, 1:2].values
test = sc.fit_transform(test)
#print(len(test[:60]))
#print(test[:60])
x = []
y = []
x_test = []
for i in range(60, 60+100): #0---10
    # Creates the 60 timesteps of each value. E.g. row 1 = 0 -> 59, row 2 = 1 -> 60
    x_temp = []
    y_temp = []
    x_temp.append(test[i-60:i, 0])
    
    x_temp = np.array(x_temp)
    x_temp = np.reshape(x_temp, (x_temp.shape[0], x_temp.shape[1], 1))
    print(x_temp[0])
    predicted_stock_price = regressor.predict(x_temp)
    y.append(test[i,0])
    x.append(predicted_stock_price[0][0])
    print(predicted_stock_price[0][0])
    print(test[i,0])
def checkGain(real_stock_price,predicted_stock_price):
    gain = 0
    perte = 0
    for i in range(1, len(predicted_stock_price)):
        if(real_stock_price[i-1]<predicted_stock_price[i] and real_stock_price[i-1]<real_stock_price[i]): #buy
            gain = gain+1
        if(real_stock_price[i-1]>=predicted_stock_price[i] and real_stock_price[i-1]>=real_stock_price[i]): #buy
            gain = gain+1
        else:
            perte = perte+1
    print(gain)
    print(perte)
    print(gain-perte)
checkGain(y,x) 
#print(x_test)
#predicted_stock_price = regressor.predict(x_test)
#print(predicted_stock_price)
plt.plot(y,'-ok', color = 'black', label = 'TATA Stock Price')
plt.plot(x,'-ok', color = 'green', label = 'Predicted TATA Stock Price')
plt.title('TATA Stock Price Prediction')
plt.xlabel('Time')
plt.ylabel('TATA Stock Price')
plt.legend()
plt.show() 
    
#inputs = test[len(dataset_total['open']) - len(dataset_test['open']) - 59:]
#print(inputs)
#test = test.iloc[:100, 1:2].values
#inputs = sc.fit_transform(inputs)
#print(test)
#XY = lstm.Get_xtrain_ytrain_norm(test)
#Creating Data
#lstm.get_x(dc)

#print(training)
"""training_set=[]
print(training)
for i in range(0,len(training)):
    training_set.append(training[i])
#print(training_set)
training_set_scaled = sc.fit_transform(training_set[:]) #training_set data
#print(training_set_scaled)
#print(len(training_set_scaled))
X_test=[]
for i in range(60, 60+28):
    X_test.append(training_set_scaled[i-60:i, 0])
#X_test.append(training_set_scaled[60-60:60, 0])
print(X_test)
print("***************************************")
X_test= np.array(X_test)
X_test = np.reshape(X_test, (X_test.shape[0], X_test.shape[1], 1))  """ 
"""
dataset_total = pd.concat((dataset_train['open'], dataset_test['open']), axis = 0)
inputs = dataset_total[len(dataset_total) - len(dataset_test) - 59:].values
inputs = inputs.reshape(-1,1)
inputs = sc.transform(inputs)
X_test = []
for i in range(60, 60+28):
    X_test.append(inputs[i-60:i, 0])

print(X_test)
X_test = np.array(X_test)
X_test = np.reshape(X_test, (X_test.shape[0], X_test.shape[1], 1))
"""
"""
predicted_stock_price = regressor.predict(X_test)
#predicted_stock_price = sc.inverse_transform(predicted_stock_price)

print(predicted_stock_price)

lstm.plot_predict(real_stock_price,predicted_stock_price)
lstm.plot_predict2(real_stock_price,predicted_stock_price)

def checkGain(real_stock_price,predicted_stock_price):
    gain = 0
    perte = 0
    for i in range(1, len(predicted_stock_price)):
        if(predicted_stock_price[i-1]<predicted_stock_price[i] and real_stock_price[i-1]<real_stock_price[i]): #buy
            gain = gain+1
        if(predicted_stock_price[i-1]>=predicted_stock_price[i] and real_stock_price[i-1]>=real_stock_price[i]): #buy
            gain = gain+1
        else:
            perte = perte+1
    print(gain)
    print(perte)
    print(gain-perte)
checkGain(real_stock_price,predicted_stock_price)"""