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
import pyautogui
import time

def Getmouseposition():
    while 1:
        mouse=pyautogui.position()
        print(mouse)
#Getmouseposition()
abisciseUp = 1509
ordonneUP = 590
abisciseDown = 1509
ordonneDown = 656
#Getmouseposition();
def clic_fonction(quantite,upX,upY,downX,downY):
	#print("anaty fonction click")
	#print(indicator_3_sma)
	if quantite == 2:
		#print("Click miakatra")
		pyautogui.click(upX ,upY)
	elif quantite == 1:
		#print("Click midina")
		pyautogui.click(downX,downY)
	else:
    	 return 0
def BUY():
    clic_fonction(2,abisciseUp,ordonneUP,abisciseDown,ordonneDown)
    return True
def SELL():
    clic_fonction(1,abisciseUp,ordonneUP,abisciseDown,ordonneDown)
    return True
def MT5_login():
    mt5.initialize()
    login=129927
    password="@Aa!!12@"
    Server="JustForex-Demo"
    mt5.login(login,password,Server)
    print(mt5)
    
    
MT5_login()


#print(res[0][0])
#print(dfc['time'][len(dfc)-1])
#print(float(dfc['time'][len(dfc)-1]))
def CheckPriceChange(dfc,last):
    if(float(dfc['time'][len(dfc)-1])!=last):
        return True;
    return False;
    
    
def run_olymp():
    last_time = 60
    while(1):
        data = Dataset("volatility 75")
        SYMBOL = "EURUSD.m"
        #SYMBOL = "Crash 500 Index"
        TIMEFRAME = mt5.TIMEFRAME_M5

        dfc = data.DFdatasetCurrent(SYMBOL,TIMEFRAME,60)
        #print(float(dfc['time'][len(dfc)-1]))
        if(CheckPriceChange(dfc,last_time)):
            print("++++++predict+++++")
            last_time = float(dfc['time'][len(dfc)-1])
            X = data.get_XYTEST(dfc,60,61)
            res = model_run.predict(X)
            res = res[0][0]
            print(res)
            if(res<0.5):
                SELL()
            if(res>0.5):
                BUY()

def run_olymp_time():
    last_time = 60
    model_olymp = Model("sdf")
    model_run1 = model_olymp.LoadModel("olympm1.model")
    model_run2 = model_olymp.LoadModel("olympm2.model")
    model_run3 = model_olymp.LoadModel("olympm3.model")
    model_run4 = model_olymp.LoadModel("olympm4.model")
    while(1):
        #sleep(1)
        data = Dataset("volatility 75")
        SYMBOL = "EURUSD.m"
        #SYMBOL = "Crash 500 Index"
        TIMEFRAME = mt5.TIMEFRAME_M1
        TIMEFRAME2 = mt5.TIMEFRAME_M2
        TIMEFRAME3 = mt5.TIMEFRAME_M3
        TIMEFRAME4 = mt5.TIMEFRAME_M4

        dfc1 = data.DFdatasetCurrent(SYMBOL,TIMEFRAME,60)
        dfc2 = data.DFdatasetCurrent(SYMBOL,TIMEFRAME2,60)
        dfc3 = data.DFdatasetCurrent(SYMBOL,TIMEFRAME3,60)
        dfc4 = data.DFdatasetCurrent(SYMBOL,TIMEFRAME4,60)
        #print(float(dfc['time'][len(dfc)-1]))
        
        if(CheckPriceChange(dfc4,last_time)):
            print("++++++predict+++++")
            last_time = float(dfc4['time'][len(dfc4)-1])
            X1 = data.get_XYTEST(dfc1,60,61)
            X2 = data.get_XYTEST(dfc2,60,61)
            X3 = data.get_XYTEST(dfc3,60,61)
            X4 = data.get_XYTEST(dfc4,60,61)
            res1 = model_run1.predict(X1)
            res1 = res1[0][0]
            print(res1)
            res2 = model_run2.predict(X2)
            res2 = res2[0][0]
            print(res2)
            res3 = model_run3.predict(X3)
            res3 = res3[0][0]
            print(res3)
            res4 = model_run4.predict(X4)
            res4 = res4[0][0]
            print(res3)
            if(res1<0.5 and res2<0.5 and res3<0.5 and res4<0.5):
                SELL()
            if(res1>0.5 and res2>0.5 and res3>0.5 and res4>0.5):
                BUY()



run_olymp_time()

