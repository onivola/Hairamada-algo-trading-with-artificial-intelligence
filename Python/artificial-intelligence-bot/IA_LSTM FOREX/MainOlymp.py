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
#import pyautogui
lstm = ModelLSTM("datasetLSTM.csv") 
login=129927
password="@Aa!!12@"
Server="JustForex-Demo"
log = lstm.MQL5Login(login,password,Server)
print(log)
def Getmouseposition():
    while 1:
        mouse=pyautogui.position()
        print(mouse)
#Getmouseposition()
abisciseUp = 1272
ordonneUP = 515
abisciseDown = 1272
ordonneDown = 579

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
def Get_position(last_predict,predict):
    if(last_predict<predict):
        return 1
    else:
        return -1
def run_reel(name,file_data,file_predict):
    modelx = Model(name)
    work = Working(name)
    lstm = ModelLSTM(name) 
    #modelx.LoadModel(name)
    modelxx = tf.keras.models.load_model(name)
    last_nb = -1
    new_nb = 1
    last_predict = -1
    buy = 0
    sell =0
    while(1):
        dc = Get_x_test()
        #print(dc)
        time.sleep(1)
        if 'close' in dc:
            #print(dc)
            
            XTEST =  lstm.get_x(dc)
            new_nb = XTEST[0][0][len(XTEST[0][0])-1]
            if(new_nb!=last_nb):
                pos = 0
                
                #print(XTEST)
                res = modelxx.predict(XTEST) #predict
                restemp = res
                if(last_predict==-1):
                    last_predict =  XTEST[0][0][len(XTEST[0][0])-1]
                print(new_nb)
                print(res)
                res = Get_position(last_predict,res)
                if(res==1):
                    buy = buy+1
                    pos = buy
                    BUY()
                if(res==-1):
                    sell = sell-1
                    pos = sell
                    SELL()
                last_nb=new_nb
                last_predict = restemp

def Get_x_test():
   
    #SYMBOL = "Volatility 75 Index"
    SYMBOL = "EURUSD.m"
    TIMEFRAME = mt5.TIMEFRAME_M1
    d1 = 60
    df = lstm.DFdataset_current2(SYMBOL,TIMEFRAME,60)
    return df
    #print(df)
    #training_test = lstm.Iloc_df(df)
    #print(training_test)
""" 
dc = Get_x_test()
print(dc)
time.sleep(1)
if 'close' in dc:
    XTEST =  lstm.get_x(dc)
    print(XTEST)
"""
Chrash500_file_data = "datasettest1.csv"
Chrash500_file_predict = "predict1.csv"


Chrash1000_file_data = "datasettest2.csv"
Chrash1000_file_predict = "predict2.csv"

lstmvolatil_file_data = "datasetLSTM.csv"
lstmvolatil_file_predict = "predictLSTM.csv"



#run_reel_rsi("chrash500marsi.model",Chrash500_file_data,Chrash500_file_predict)
#run_demo("LSTM40.model",lstmvolatil_file_data,lstmvolatil_file_predict)
#run_reel("LSTM40.model",lstmvolatil_file_data,lstmvolatil_file_predict)
def Fit_model():
    lstm = ModelLSTM("datasetLSTM.csv") 

    #SYMBOL = "Volatility 75 Index"
    SYMBOL = "EURUSD.m"
    TIMEFRAME = mt5.TIMEFRAME_M1
    #d1 = 1441
    #df = lstm.DFdataset_current(SYMBOL,TIMEFRAME,d1*3)
    df = lstm.DFdataset(SYMBOL,TIMEFRAME,2022,1,2,2022,2,3)
    print(df)
    """training_test = lstm.Iloc_df(df)
    print(training_test)
    training_set_scaled = lstm.fitTransform(training_test)

    XY = lstm.Get_xtrain_ytrain(training_set_scaled)
    
    X_train = XY[0]
    print(X_train[0])
    
    dataset_test = lstm.DFdataset(SYMBOL,TIMEFRAME,2022,2,3,2022,2,4)
    
    xx =lstm.get_inputs2(df,dataset_test)
    
    
    modelxx = tf.keras.models.load_model("LSTM40.model")
    res = modelxx.predict([X_train[0]])
    print(res)
    y_train = XY[1"""

Fit_model()
    #lstm.fit_LSTM(X_train,y_train,50)
#while(1):
#	main()
	