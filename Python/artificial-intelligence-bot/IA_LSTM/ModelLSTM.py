import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

from keras.models import Sequential
from keras.layers import Dense
from keras.layers import LSTM
from keras.layers import Dropout
from sklearn.preprocessing import MinMaxScaler
sc = MinMaxScaler(feature_range = (0, 1))
import MetaTrader5 as mt5
import MetaTrader5 as mt
from datetime import datetime
from tensorflow import keras 
import tensorflow as tf
class ModelLSTM:
    def __init__(mysillyobject, name): #other operations that are necessary to do when the object is being created
        mysillyobject.name = name
        
    def LoadModel(self,label):
        model = tf.keras.models.load_model(label)
        print(model)
        return model

    def fitModel(self,epoch,X,Y,input_dim,lr):
     
        modelMc.save('VOLATILITY16662.model')
        model = tf.keras.models.load_model("VOLATILITY16662.model")
        return model
    def ToCSV(self,file,SYMBOL,TIMEFRAME,sy, sm, sd,ey, em, ed):
        #end_day=7
        #start_dt = datetime(2022,4,start_day)
        #end_dt = datetime.now()
        start_dt = datetime(sy, sm, sd)
        end_dt =  datetime(ey, em, ed)
        #end_dt = end_dt.replace(minute=40, hour=00, second=00, year=ey, month=em, day=ed)
        # request ohlc data a save them in a pandas DataFrame
        bars = mt5.copy_rates_range(SYMBOL, TIMEFRAME, start_dt, end_dt)
        df = pd.DataFrame(bars)[['time', 'open', 'high', 'low', 'close']]
        #df['time'] = pd.to_datetime(df['time'], unit='s')

        #df['open'][0]
        #print("bars zero"+str(bars[0]))
        print(df)
        #file1 = open("dataset.txt", "w")
        df.to_csv(file + '.csv', index=False)
        print("successfull download " + str(name))
    def MQL5Login(self,login,password,Server):
      
        mt5.initialize()
        return mt5.login(login,password,Server)
    def DFdataset(self,SYMBOL,TIMEFRAME,sy,sm,sd,ey,em,ed):
        start_dt = datetime(sy, sm, sd)
        end_dt =  datetime(ey, em, ed)
        end_dt = end_dt.replace(minute=40, hour=00, second=00, year=ey, month=em, day=ed)
        print(end_dt)
        # request ohlc data a save them in a pandas DataFrame
        bars = mt5.copy_rates_range(SYMBOL, TIMEFRAME, start_dt, end_dt)
        df = pd.DataFrame(bars)[['time', 'open', 'high', 'low', 'close']]
        df['time'] = pd.to_datetime(df['time'], unit='s')
        return df
    def DFdataset_1(self,SYMBOL,TIMEFRAME,sy,sm,sd,ey,em,ed):
        start_dt = datetime(sy, sm, sd)
        end_dt =  datetime(ey, em, ed)
        print(end_dt)
        # request ohlc data a save them in a pandas DataFrame
        bars = mt5.copy_rates_range(SYMBOL, TIMEFRAME, start_dt, end_dt)
        df = pd.DataFrame(bars)[['time', 'open', 'high', 'low', 'close']]
        df['time'] = pd.to_datetime(df['time'], unit='s')
        return df
    def GetCSVData(self,file):
        df= pd.read_csv(file,encoding=self.GetEncod(file))
        #print(df)
        return df
  
  
    def GetEncod(self,file):
        with open(file, 'rb') as rawdata:
            result = chardet.detect(rawdata.read(100000))
            #print(result['encoding'])
            return result['encoding']

    def Iloc_df(self,dataset_train):
        training_set = dataset_train.iloc[:, 3:4].values #open values
        #dataset_train.head()
        return training_set
    def fitTransform(self,training_test):
        sc = MinMaxScaler(feature_range = (0, 1))
        training_set_scaled = sc.fit_transform(training_test) #training_set data
        return training_set_scaled
    def Get_xtrain_ytrain_norm(self,training_set_scaled):
        X_train = []
        y_train = []
        for i in range(60,len(training_set_scaled)): #0---10
            # Creates the 60 timesteps of each value. E.g. row 1 = 0 -> 59, row 2 = 1 -> 60
            x_temp = []
            y_temp = []
            x_temp.append(training_set_scaled[i-60:i, 0])
            y_temp.append(training_set_scaled[i,0])
            x_temp, y_temp = np.array(x_temp), np.array(y_temp)

            x_temp = np.reshape(x_temp, (x_temp.shape[0], x_temp.shape[1], 1))
            X_train.append(x_temp[0])
            y_train.append(y_temp[0])
        return [X_train,y_train]
 
    def Get_xtrain_ytrain(self,training_set_scaled): 
        X_train = []
        y_train = []
        for i in range(60, len(training_set_scaled)): #0---10
            # Creates the 60 timesteps of each value. E.g. row 1 = 0 -> 59, row 2 = 1 -> 60
            X_train.append(training_set_scaled[i-60:i, 0])
            #print("x")
            #print(X_train)
             # Contains the next value after the 60 timesteps. E.g. row 1 = last value of row 2, row 2 = last value of row 3
            y_train.append(training_set_scaled[i,0])
            #print("y")
            #print(y_train)
        # Convert to numpy array to be accepted in our RNN
        X_train, y_train = np.array(X_train), np.array(y_train)

        X_train = np.reshape(X_train, (X_train.shape[0], X_train.shape[1], 1))

        print(len(X_train))
        print(len(y_train))
        return [X_train,y_train]


    def fit_LSTM(self,X_train,y_train,epochs):
        regressor = Sequential()

        regressor.add(LSTM(units = 50, return_sequences = True, input_shape = (X_train.shape[1], 1)))
        regressor.add(Dropout(0.2))

        regressor.add(LSTM(units = 50, return_sequences = True))
        regressor.add(Dropout(0.2))

        regressor.add(LSTM(units = 50, return_sequences = True))
        regressor.add(Dropout(0.2))

        regressor.add(LSTM(units = 50))
        regressor.add(Dropout(0.2))

        regressor.add(Dense(units = 1))

        regressor.compile(optimizer = 'adam', loss = 'mean_squared_error')

        regressor.fit(X_train, y_train, epochs = epochs, batch_size = 32)
        regressor.save('LSTM40.model')
        regressor.save('LSTM40.h5')
    def inverstransform(self,training_test):
        sc = MinMaxScaler(feature_range = (0, 1))  
        X_scaled = sc.fit_transform(training_test)
        obj = sc.fit(training_test)
        X_hat = obj.inverse_transform(X_scaled)

        return X_hat
    def get_inputs(self,dataset_train,dataset_test,regressor):
        dataset_total = pd.concat((dataset_train['close'], dataset_test['close']), axis = 0)
        inputs = dataset_total[1551:].values
        inputs = inputs.reshape(-1,1)
        sc = MinMaxScaler(feature_range = (0, 1))
        inputs = self.fitTransform(inputs)
        X_test = []
        for i in range(60, 1000):
            X_test.append(inputs[i-60:i, 0])
            print(X_test)
        X_test = np.array(X_test)
        X_test = np.reshape(X_test, (X_test.shape[0], X_test.shape[1], 1))
        print(X_test[0])
        predicted_stock_price = regressor.predict(X_test)
        print(predicted_stock_price)
        predicted_stock_price = self.inverstransform(predicted_stock_price)
        return predicted_stock_price
    
    def plot_predict(self,real_stock_price,predicted_stock_price):
        plt.plot(real_stock_price,'-ok', color = 'black', label = 'TATA Stock Price')
        plt.plot(predicted_stock_price,'-ok', color = 'green', label = 'Predicted TATA Stock Price')
        plt.title('TATA Stock Price Prediction')
        plt.xlabel('Time')
        plt.ylabel('TATA Stock Price')
        plt.legend()
        plt.show() 
       
    def plot_predict2(self,real_stock_price,predicted_stock_price):
        plt.plot(predicted_stock_price, color = 'green', label = 'Predicted TATA Stock Price')
        plt.title('TATA Stock Price Prediction')
        plt.xlabel('Time')
        plt.ylabel('TATA Stock Price')
        plt.legend()
        plt.show()
    def get_x(self,df):
        #workk = Working("datasetLSTM.csv")
        #df = workk.open_dataset_backtest("datasetLSTM.csv")
        training = df[:60]
        training_set=[]
        for i in range(0,len(training)):
            training_set.append([training['VALUE'][i]])
        #print(training_set)
        training_set_scaled = sc.fit_transform(training_set[:]) #training_set data
        #print(training_set_scaled)
        #print(len(training_set_scaled))
        X_test=[]
        X_test.append(training_set_scaled[60-60:60, 0])
        X_test= np.array(X_test)
        X_test = np.reshape(X_test, (X_test.shape[0], X_test.shape[1], 1))   
        #print(X_test)  
        return X_test