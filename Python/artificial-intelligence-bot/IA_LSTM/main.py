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
import pandas as pd

lstm = ModelLSTM("datasetLSTM.csv") 
login=20542428
password="@Aa!!12@"
Server="Deriv-Server"

log = lstm.MQL5Login(login,password,Server)
print(log)
SYMBOL = "Volatility 75 Index"
#SYMBOL = "Crash 500 Index"
TIMEFRAME = mt5.TIMEFRAME_M1

sy = 2022
sm = 1
sd = 1
ey = 2022
em = 1
ed = 7
lstm.ToCSV("Volatility",SYMBOL,TIMEFRAME,sy, sm, sd,ey, em, ed)