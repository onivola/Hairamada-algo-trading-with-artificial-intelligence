import pandas as pd
from scipy.stats import zscore
from sklearn.model_selection import train_test_split
import matplotlib.pyplot as plt
import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Activation
from tensorflow.keras.callbacks import EarlyStopping
import numpy as np
import MetaTrader5 as mt5
import MetaTrader5 as mt
from Dataset import Dataset
from sklearn import metrics
from tensorflow import keras
from Model import Model
def MT5_login():
    mt5.initialize()
    login=129927
    password="@Aa!!12@"
    Server="JustForex-Demo"
    mt5.login(login,password,Server)
    print(mt5)
    
    
MT5_login()


lst = [mt5.TIMEFRAME_M1,mt5.TIMEFRAME_M2,mt5.TIMEFRAME_M3,mt5.TIMEFRAME_M4]
for n in range(0,len(lst)):
    data = Dataset("volatility 75")
    SYMBOL = "EURUSD.m"
    #SYMBOL = "Crash 500 Index"

    TIMEFRAME = lst[n]
    #df = data.DFdataset(SYMBOL,TIMEFRAME,2022,2,1,2022,3,1)
    print(n)
    df = data.DFdatasetCurrent(SYMBOL,TIMEFRAME,28765*2)
    print(df)

    L=data.vectorisation(df['open'][1],df['high'][1],df['low'][1],df['close'][1],True)    
    print(L)

    XY=data.get_XY_simple(df,60,61)
    Xx = XY[0]
    Yy = XY[1]
    X=np.array(Xx)
    Y=np.array(Yy)
    print(XY[1])



    x_train,x_test,y_train,y_test = train_test_split(X,Y,test_size=0.01,random_state=10) #train and test data

    model_olymp = Model("olymp"+str(n+1)+".model")
    #model = model_olymp.fitModel("olymp.model",100,x_train,y_train,x_test,y_test,0.0001)
    model = model_olymp.fitModel("olympm"+str(n+1)+".model",400,x_train,y_train,x_test,y_test,0.0001)
    pred = model.predict(x_test)
    print(len(pred))
    print(len(y_test))
    # Measure MSE error.  
    score = metrics.mean_squared_error(pred,y_test)
    print("Final score (MSE): {}".format(score))



    # Measure RMSE error.  RMSE is common for regression.
    score = np.sqrt(metrics.mean_squared_error(pred,y_test))
    print("Final score (RMSE): {}".format(score))


    #Plot datapoints
    yi_list = list(range(0, len(y_test-1)))
    predi_list = list(range(0, len(pred-1)))

    print(len(yi_list))
    plt.scatter(y_test, yi_list)
    plt.scatter(pred, predi_list)
    plt.show()  


# Plot the chart
#chart_regression(pred.flatten(),y_test)