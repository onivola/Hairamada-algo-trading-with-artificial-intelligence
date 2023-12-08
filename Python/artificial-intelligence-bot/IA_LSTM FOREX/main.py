from Dataset import Dataset
from Model import Model
from Working import Working
import time
from threading import Thread
from time import sleep
import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'
from tensorflow import keras 
import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Dropout, Activation, Flatten

def run2(name,age):
    while(1):
        print("helo "+name+" "+str(age))
        sleep(1)
"""
T=Thread(target=run2,args=("Ayla",1))
T1=Thread(target=run2,args=("hi",22))

T.start()
T1.start()
T.join()
T1.join()
print("Bye")"""
"""p1 = Dataset("chrashma", 36)
df = p1.GetCSVData("chrashma.csv")
XY = p1.Get_XY(df,15,5)
X = XY[0]
Y = XY[1]
"""


"""
dc = work.open_dataset(file)
print(dc)
XTEST = work.CSVGet_X(dc)
print(XTEST)
res = modelChrash500.predict(XTEST) #predict
work.Write_Predect(res,file_predict)
print(res)
"""

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
        

def run_demo(name,file_data,file_predict):
    modelx = Model(name)
    work = Working(name)
    #modelx.LoadModel(name)
    modelxx = tf.keras.models.load_model(name)
    last_nb = -1
    last_predict = -10
    while(1):
        dc = work.open_dataset_backtest(file_data)
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
                
                    
                while(work.Write_Predect_backtest(res,file_predict)==False): #write predict value
                    e = 1
                last_nb=new_nb


def run_demo_rsi(name,file_data,file_predict):
    modelx = Model(name)
    work = Working(name)
    #modelx.LoadModel(name)
    modelxx = tf.keras.models.load_model(name)
    last_nb = -1
    last_predict = -10
    while(1):
        dc = work.open_dataset_backtest(file_data)
        time.sleep(5)
        if 'MA5' in dc:
            #print(dc)
            new_nb = float(dc['MA5'][15])
            #print(last_nb)
            if(new_nb>last_nb):
                XTEST = work.CSVGet_X_rsi(dc)
                print(XTEST)
                res = modelxx.predict(XTEST) #predict
                print(res)
                res = round(float(res[0]),4)
                if(res==last_predict):
                    last_predict = res
                    res = res+0.001
                if(res!=last_predict):
                    last_predict = res
                
                    
                while(work.Write_Predect_backtest(res,file_predict)==False): #write predict value
                    e = 1
                last_nb=new_nb
#model = Model("model")
#work = Working("model")



def run_reel_rsi(name,file_data,file_predict):
    modelx = Model(name)
    work = Working(name)
    #modelx.LoadModel(name)
    modelxx = tf.keras.models.load_model(name)
    last_nb = -1
    last_predict = -10
    while(1):
        dc = work.open_dataset(file_data)
        time.sleep(2)
        if 'MA5' in dc:
            #print(dc)
            new_nb = float(dc['MA5'][15])
            #print(last_nb)
            if(new_nb>last_nb):
                XTEST = work.CSVGet_X_rsi(dc)
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



Chrash500_file_data = "datasettest1.csv"
Chrash500_file_predict = "predict1.csv"


Chrash1000_file_data = "datasettest2.csv"
Chrash1000_file_predict = "predict2.csv"

#run_reel_rsi("chrash500marsi.model",Chrash500_file_data,Chrash500_file_predict)


workk = Working("datasetLSTM.csv")
df = workk.open_dataset_backtest("datasetLSTM.csv")
training = df[:60]
training_set=[]
for i in range(0,len(training)):
    training_set.append([training['VALUE'][i]])
print(training_set)

from sklearn.preprocessing import MinMaxScaler
sc = MinMaxScaler(feature_range = (0, 1))

training_set_scaled = sc.fit_transform(training_set[:]) #training_set data
print(training_set_scaled)
print(len(training_set_scaled))
import numpy as np
X_test=[]
X_test.append(training_set_scaled[60-60:60, 0])


X_test= np.array(X_test)

X_test = np.reshape(X_test, (X_test.shape[0], X_test.shape[1], 1))   

print(X_test)            
"""T=Thread(target=run,args=("Chrash500.model",Chrash500_file_data,Chrash500_file_predict))
T1=Thread(target=run,args=("Chrash1000.model",Chrash1000_file_data,Chrash1000_file_predict))

T.start()
T1.start()
T.join()
T1.join()"""