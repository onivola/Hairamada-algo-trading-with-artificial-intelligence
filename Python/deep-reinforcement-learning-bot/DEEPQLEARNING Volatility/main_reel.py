print('Running in 1-thread CPU mode for fully reproducible results training a CNN and generating numpy randomness.  This mode may be slow...')
# Seed value
# Apparently you may use different seed values at each stage
seed_value= 1

# 1. Set `PYTHONHASHSEED` environment variable at a fixed value
import os
os.environ['PYTHONHASHSEED']=str(seed_value)
seed_value += 1

# 2. Set `python` built-in pseudo-random generator at a fixed value
import random
random.seed(seed_value)
seed_value += 1

# 3. Set `numpy` pseudo-random generator at a fixed value
import numpy as np
np.random.seed(seed_value)
seed_value += 1

# 4. Set `tensorflow` pseudo-random generator at a fixed value
import tensorflow as tf
tf.set_random_seed(seed_value)

# 5. Configure a new global `tensorflow` session
session_conf = tf.ConfigProto(intra_op_parallelism_threads=1, inter_op_parallelism_threads=1)
sess = tf.Session(graph=tf.get_default_graph(), config=session_conf)
#tf.keras.backend.set_session(sess)
tf.compat.v1.keras.backend.set_session(sess)
#df = pd.read_csv('./data/AAPL.csv')
#df = df.sort_values('Date')
import gym
import json
from stable_baselines.common.policies import MlpPolicy
from stable_baselines.common.vec_env import DummyVecEnv
from stable_baselines import PPO2
import MetaTrader5 as mt5
import MetaTrader5 as mt
from env.StockTradingEnv import StockTradingEnv
from Dataset import Dataset
import pandas as pd
import pyautogui
from env.StockTradingEnv3ch import StockTradingEnv3ch
from Working import Working
import time
from time import sleep
from datetime import datetime
def DFdatasetCurrent(SYMBOL,TIMEFRAME,st,nb):
    rates = mt5.copy_rates_from_pos(SYMBOL, TIMEFRAME, st, nb)

    rates_frame = pd.DataFrame(rates)
    rates_frame['time']=pd.to_datetime(rates_frame['time'], unit='s')

    return rates_frame

def DFdataset_1(SYMBOL,TIMEFRAME,sy,sm,sd,ey,em,ed):
    start_dt = datetime(sy, sm, sd)
    end_dt =  datetime(ey, em, ed)
    print(end_dt)
    # request ohlc data a save them in a pandas DataFrame
    bars = mt5.copy_rates_range(SYMBOL, TIMEFRAME, start_dt, end_dt)
    df = pd.DataFrame(bars)[['time', 'open', 'high', 'low', 'close']]
    df['time'] = pd.to_datetime(df['time'], unit='s')
    return df
def MT5_login():
    mt5.initialize()
    login=20542428
    password="@Aa!!12@"
    Server="Deriv-Server"
    mt5.login(login,password,Server)
    print(mt5)
MT5_login()
dataset = Dataset("drl")
SYMBOL = "Volatility 75 Index"
#SYMBOL = "Crash 500 Index"
TIMEFRAME = mt5.TIMEFRAME_M1
#df = data.DFdataset(SYMBOL,TIMEFRAME,2022,2,1,2022,3,1)
df1 = DFdatasetCurrent(SYMBOL,TIMEFRAME,0,1441*20)
whole = dataset.get_whole(df1)
#df1 = df.sort_values('time')

#tsara 100000

df2 = DFdatasetCurrent(SYMBOL,TIMEFRAME,1,7)
#df2 = df.sort_values('time')
    
#print(obs)
print(df1)
#df1, df2 = split_df(df)
#print(df)
tm = str(df2['time'][len(df2)-1])
print(tm)
#df1 = df.iloc[:4254,:]
#df2 = df.iloc[4254:,:]
print(df1)


# The algorithms require a vectorized environment to run
env1 = DummyVecEnv([lambda: StockTradingEnv3ch(df1)])
env2 = DummyVecEnv([lambda: StockTradingEnv3ch(df2)])
#env = DummyVecEnv([lambda: StockTradingEnv(df)])
env1.seed(0)
env2.seed(0)
#15:09

#model = PPO2(MlpPolicy, env1, verbose=1, seed=10, n_cpu_tf_sess=1)
#model.learn(total_timesteps=10000*20)
#model.save('vol')
model = PPO2.load("vol")
#-6497.269171764005
#-28.450912496060482
#-23.133360367120986
def CheckPriceChange(dfc,last):
    tm = str(dfc['time'][len(dfc)-1])
    if(tm!=last):
        return True;
    return False;
    
file_data = "datasetDRL.csv"
file_predict = "predictDRL.csv"
#print(obs)
last_time = "60"
last_time2 = "60" 
last_nb = -1

"""
work = Working("drl")
dc = work.open_dataset_backtest(file_data)
print(dc)
xy = dataset.get_obs_predict(dc,0,60,whole,whole_vol)
print(xy)
obs = np.array(xy[0][0])
action, _states = model.predict(obs)
print(action)
new_nb = float(dc['open'][60])
print(new_nb)
while(work.Write_Predect_backtest(action,file_predict)==False): #write predict value
    e = 1
#3188.14
"""
buy = 3
sell = -3
hold = 10000000
pos = 0
while(1):
    work = Working("drl")
    SYMBOL = "Volatility 75 Index"
    SYMBOL = "Crash 500 Index"
    dc = work.open_dataset(file_data)
    #print(dc)
    time.sleep(1)
    if 'open' in dc:
        new_nb = float(dc['open'][200])
        print(last_nb)
        if(new_nb!=last_nb):
            xy = dataset.get_obs_predict(dc,0,200,whole)
            obs = np.array(xy[0][0])
            action, _states = model.predict(obs)
            print("Action-------------")
            print(action)
            if(action==1):
                buy = buy+1
                pos = buy
            if(action==0):
                sell = sell-1
                pos = sell
            if(action ==2):
                hold = hold+1
                pos = hold;
            print(pos)
            while(work.Write_Predect(pos,file_predict)==False): #write predict value
                e = 1
            last_nb=new_nb
            
