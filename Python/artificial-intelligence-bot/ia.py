import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'
import MetaTrader5 as mt5
import MetaTrader5 as mt
import numpy as np
import plotly.graph_objects as go
from tensorflow.keras import optimizers
from tensorflow import keras 
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense
##Volatility 75 Index
import pandas as pd
import plotly.express as px 
from datetime import datetime
from datetime import datetime, timedelta
### Partie A - Les données
from tensorflow.keras.datasets import mnist
from tensorflow.keras.utils import to_categorical
from IPython.display import display
import itertools
import MetaTrader5 as mt5
import MetaTrader5 as mt
import pandas as pd
import chardet
import itertools
import tensorflow as tf
from tensorflow.keras import layers
from tensorflow.keras import activations
from tensorflow.keras.datasets import cifar10
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Dropout, Activation, Flatten
# more info on callbakcs: https://keras.io/callbacks/ model saver is cool too.
from tensorflow.keras.callbacks import TensorBoard
import pickle
import time
from matplotlib import pyplot as plt
from plot_keras_history import plot_history
import matplotlib
import matplotlib.pyplot as plt
from keras import callbacks
from sklearn.model_selection import train_test_split
import seaborn as sns
from sklearn.metrics import confusion_matrix
from numpy.random import seed
print(111)
print(tf.__version__)
df= pd.read_csv('chrashma.csv',encoding='UTF-16')
print(df)

import itertools

def diff_2ma(ma05,ma15,ma012,ma112):
    ma = []
    X = []
    Y = []
    
    ma.append(ma05)
    ma.append(ma012)
    ma = list(itertools.chain.from_iterable(ma))
    ma_max = max(ma)
    #print(ma)
    y_value = 1
    for j in range(1,len(ma15)): #check y
        if(ma15[j]<ma15[j-1]): #0
            y_value = 0
    Y.append(y_value)
    for i in range(0,len(ma)): #ma5 ma12
        X.append(abs(ma_max-ma[i]))
    #print(X)
    return [X,Y]

def Get_XY(df,nb0,nb1):
    XY = []
    x = []
    y = []
    for i in range(nb0,len(df)-nb1):
        
        if(df['MA5'][i]>df['MA12'][i] and df['MA5'][i-1]<df['MA12'][i-1]):
            Pma05 = []
            Pma15 = []
            Pma012 = []
            Pma112 = []
            Pma = []
            for j in range(i-nb0,i): #15 avant croix
                Pma05.append(df['MA5'][j])
                Pma012.append(df['MA12'][j])
            for k in range(i,i+nb1): #15 apres croix
                Pma15.append(df['MA5'][k])
                Pma112.append(df['MA12'][k])

            xy = diff_2ma(Pma05,Pma15,Pma012,Pma112)
            old_min = min(xy[0])
            old_range = max(xy[0])
            new_min = 0
            new_range = 1
            xnorm = [float((n - old_min) / old_range * new_range + new_min) for n in xy[0]]
            x.append(xnorm)
            y.append(xy[1])
            #break
            
    XY.append(x)
    XY.append(y)
    return XY

XY = Get_XY(df,15,5)
X = XY[0]
Y = XY[1]
print((X[0]))
print(Y)

