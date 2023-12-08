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
from env.StockTradingEnv1ch import StockTradingEnv1ch
from Dataset import Dataset
import pandas as pd
import matplotlib.pyplot as plt
def DFdatasetCurrent(SYMBOL,TIMEFRAME,st,nb):
    rates = mt5.copy_rates_from_pos(SYMBOL, TIMEFRAME, st, nb)

    rates_frame = pd.DataFrame(rates)
    rates_frame['time']=pd.to_datetime(rates_frame['time'], unit='s')

    return rates_frame

    
    
    return df
def plotxy(list_reward):
    y = list(range(0, len(list_reward)))
    print(y)
    plt.plot(y, list_reward)
     
    # naming the x axis
    plt.xlabel('x - axis')
    # naming the y axis
    plt.ylabel('y - axis')
     
    # giving a title to my graph
    plt.title('My first graph!')
     
    # function to show the plot
    plt.show()
def MT5_login():
    mt5.initialize()
    login=129927
    password="@Aa!!12@"
    Server="JustForex-Demo"
    mt5.login(login,password,Server)
    print(mt5)
MT5_login()
SYMBOL = "EURUSD.m"
#SYMBOL = "Crash 500 Index"
TIMEFRAME = mt5.TIMEFRAME_M1
#df = data.DFdataset(SYMBOL,TIMEFRAME,2022,2,1,2022,3,1)
df = DFdatasetCurrent(SYMBOL,TIMEFRAME,1000,1441*7)

df1 = df.sort_values('time')

df = DFdatasetCurrent(SYMBOL,TIMEFRAME,1,1000)

df2 = df.sort_values('time')

#df1, df2 = split_df(df)
#print(df)

#df1 = df.iloc[:4254,:]
#df2 = df.iloc[4254:,:]
print(df1)
print(df2)
dataset = Dataset("drl")
#xy = dataset.get_obs(df2,0,14,3)
#print(xy[0])
#print(xy[1])
# The algorithms require a vectorized environment to run
env1 = DummyVecEnv([lambda: StockTradingEnv(df1)])
env2 = DummyVecEnv([lambda: StockTradingEnv(df2)])
#env = DummyVecEnv([lambda: StockTradingEnv(df)])
env1.seed(0)
env2.seed(0)


model = PPO2(MlpPolicy, env1, verbose=1)
model.learn(total_timesteps=50000)
model.save('ppo2')
model = PPO2.load("ppo2")
#-6497.269171764005
#-28.450912496060482
#-23.133360367120986
"""
Profit: 14.82808691234095
Profit: 4.847021390000009
Profit: 1.5961219107703073
Profit: 27.392325404274743
Profit: 20.940430143442427
Profit: 0.25733199603018875
Profit: 20.791897249162503
Profit: 46.6085005992918
Profit: 28.097519245791773
"""
obs1 = env1.reset()
obs2 = env2.reset()
list_reward1 = []
list_reward2 = []
list_done = []
nb_done = 0
for i in range(1,(1441*7)-63):
    if(i==1):
        list_reward1 = []
    ac = []
    action, _states = model.predict(obs1)
    ac.append(action)
    print(action)
    #print(ac[0])
    #print(ac)
    obs1, rewards, done, info = env1.step(action)
    if(rewards[0]>0):
        nb_done = nb_done+1
    if((rewards[0]==0 and nb_done>0)):
        list_done.append(nb_done)
        nb_done=0
    list_reward1.append(rewards[0])
    #print(list_reward1)
    print("done for="+str(done))
    if(done):
        break
    
    
    env1.render()
plotxy(list_reward1)
plotxy(list_done)
list_done2 = []
nb_done = 0
for i in range(1,1000-63):
    if(i==1):
        list_reward2 = []
    ac = []
    action, _states = model.predict(obs2)
    ac.append(action)
    print(action)
    #print(ac[0])
    #print(ac)
    obs2, rewards, done, info = env2.step(action)
    print(rewards)
    list_reward2.append(rewards[0])
    #print(list_reward2)
    print("done for="+str(done))
    if(rewards[0]>0):
        nb_done = nb_done+1
    if((rewards[0]==0 and nb_done>0)):
        list_done2.append(nb_done)
        nb_done=0
    if(done):
        break
    #print(info)
    
    env2.render()


plotxy(list_reward2)
plotxy(list_done2)


    