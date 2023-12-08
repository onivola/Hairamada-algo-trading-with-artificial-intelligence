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
import datetime as dt
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
def DFdatasetCurrent(SYMBOL,TIMEFRAME,st,nb):
    rates = mt5.copy_rates_from_pos(SYMBOL, TIMEFRAME, st, nb)

    rates_frame = pd.DataFrame(rates)
    rates_frame['time']=pd.to_datetime(rates_frame['time'], unit='s')

    return rates_frame

    
    
    return df
def MT5_login():
    mt5.initialize()
    login=129927
    password="@Aa!!12@"
    Server="JustForex-Demo"
    mt5.login(login,password,Server)
    print(mt5)
MT5_login()
dataset = Dataset("drl")
SYMBOL = "EURUSD.m"
#SYMBOL = "Crash 500 Index"
TIMEFRAME = mt5.TIMEFRAME_M1
#df = data.DFdataset(SYMBOL,TIMEFRAME,2022,2,1,2022,3,1)
df1 = DFdatasetCurrent(SYMBOL,TIMEFRAME,0,1441*2)
whole_vol = dataset.get_whole_vol(df1)
whole = dataset.get_whole(df1)
#df1 = df.sort_values('time')

df2 = DFdatasetCurrent(SYMBOL,TIMEFRAME,1,7)
#df2 = df.sort_values('time')
    
#print(obs)
print(df2)
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


model = PPO2(MlpPolicy, env1, verbose=1)
model.learn(total_timesteps=500000)
model.save('ppo2')
model = PPO2.load("ppo2")
#-6497.269171764005
#-28.450912496060482
#-23.133360367120986
def CheckPriceChange(dfc,last):
    tm = str(dfc['time'][len(dfc)-1])
    if(tm!=last):
        return True;
    return False;
    

#print(obs)
last_time = "60"
last_time2 = "60" 
while(1):
    SYMBOL = "EURUSD.m"
    #SYMBOL = "Crash 500 Index"
    TIMEFRAME = mt5.TIMEFRAME_M1
    df2 = DFdatasetCurrent(SYMBOL,TIMEFRAME,1,61)
    df3 = DFdatasetCurrent(SYMBOL,mt5.TIMEFRAME_M4,1,3)
    if(CheckPriceChange(df3,last_time) and CheckPriceChange(df2,last_time2)):
        print("++++++predict+++++")
        last_time = str(df3['time'][len(df3)-1])
        last_time2 = str(df2['time'][len(df2)-1])
        print(whole)
        print(whole_vol)
        xy = dataset.get_obs_predict(df2,0,60,whole,whole_vol)
        obs = np.array(xy[0][0])
        action, _states = model.predict(obs)
        print(action)
        if(action==1):
            print("BUY")
            BUY()
        if(action==0):
            print("SELL")
            SELL()
