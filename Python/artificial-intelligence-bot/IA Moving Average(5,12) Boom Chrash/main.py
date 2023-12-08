from Dataset import Dataset
from Model import Model
from Working import Working
import time
from threading import Thread
from time import sleep
import matplotlib.pyplot as plt
import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'
from tensorflow import keras 
import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Dropout, Activation, Flatten
import numpy as np
from sklearn.model_selection import train_test_split
from tensorflow.keras.callbacks import EarlyStopping
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

dataset = Dataset("chrashma", 36)
work = Working("marsimacd")

"""df = work.open_dataset_backtest("datasettest.csv")
print(df)
print(df['MACD'])
x = work.CSVGet_X(df)
print(x)
print(len(x))
modeltest = tf.keras.models.load_model("MAMACDRSI.model")
print(modeltest.predict(x))"""


#print(X)
#print(Y)
"""res = modelChrash500.predict(XTEST) #predict
work.Write_Predect(res,file_predict)
print(res)"""


def run(name,file_data,file_predict):
    modelx = Model(name)
    work = Working(name)
    #modelx.LoadModel(name)
    modelxx = tf.keras.models.load_model(name)
    last_nb = -1
    last_predict = -10
    while(1):
        dc = work.open_dataset(file_data)
        time.sleep(1)
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
            print(new_nb)
            if(new_nb!=last_nb):
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
        time.sleep(1)
        if 'MA5' in dc:
            #print(dc)
            new_nb = float(dc['MA5'][60])
            print(last_nb)
            if(new_nb!=last_nb):
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
            new_nb = float(dc['MA5'][60])
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


Chrash500_file_data = "datasettest2.csv"
Chrash500_file_predict = "predict2.csv"


Chrash1000_file_data = "datasettest2.csv"
Chrash1000_file_predict = "predict2.csv"

run_demo_rsi("MAMACDRSI.model",Chrash500_file_data,Chrash500_file_predict)
file = "marsimacd4m.csv"
dcd = work.open_dataset(file)
print(dcd)
file = "ma1244.csv"
dc = work.open_dataset(file)
print(dc)
XTEST = dataset.Get_XY(dc,60,5)
X = XTEST[0]
Y = XTEST[1]
print(len(X))
#print(Y)
model = Model("marsimacd")


Xn=np.array(X)
Yn=np.array(Y)
print(X[1])
print(len(X[1]))


x_train,x_test,y_train,y_test = train_test_split(Xn,Yn,test_size=0.25,random_state=10) #train and test data

model_olymp = Model("MAMACDRSI.model")
#model = model_olymp.fitModel_regretion("MAMACDRSI.model",300,x_train,y_train,x_test,y_test,0.0001)
#model = model_olymp.fit_LSTM(x_train,y_train,1000) 

model_olymp.fitModel(4000,X,Y,len(X[0]),0.0001)
modeltest = tf.keras.models.load_model("MAMACDRSI.model")
model_olymp.test_validation(modeltest,X,Y,100)
pred = modeltest.predict(x_test)

model_olymp.test_validation(modeltest,X,Y,100)
yi_list = list(range(0, len(y_test-1)))
predi_list = list(range(0, len(pred-1)))

print(len(yi_list))
plt.scatter(y_test, yi_list)
plt.scatter(pred, predi_list)
plt.show()  
         
"""T=Thread(target=run,args=("Chrash500.model",Chrash500_file_data,Chrash500_file_predict))
T1=Thread(target=run,args=("Chrash1000.model",Chrash1000_file_data,Chrash1000_file_predict))

T.start()
T1.start()
T.join()
T1.join()"""