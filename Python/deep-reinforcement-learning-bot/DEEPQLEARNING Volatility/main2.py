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
from stable_baselines.common.policies import MlpLnLstmPolicy
from stable_baselines.common.vec_env import DummyVecEnv
from stable_baselines import PPO2
from stable_baselines import A2C
import MetaTrader5 as mt5
import MetaTrader5 as mt
from env.StockTradingEnvBuy import StockTradingEnvBuy
from env.StockTradingEnv3ch import StockTradingEnv3ch
from Dataset import Dataset
import pandas as pd
import matplotlib.pyplot as plt
from datetime import datetime
def DFdatasetCurrent(SYMBOL,TIMEFRAME,st,nb):
    rates = mt5.copy_rates_from_pos(SYMBOL, TIMEFRAME, st, nb)

    rates_frame = pd.DataFrame(rates)
    rates_frame['time']=pd.to_datetime(rates_frame['time'], unit='s')

    return rates_frame

    
    
    return df
def DFdataset_1(SYMBOL,TIMEFRAME,sy,sm,sd,ey,em,ed):
    start_dt = datetime(sy, sm, sd)
    end_dt =  datetime(ey, em, ed)
    print(end_dt)
    # request ohlc data a save them in a pandas DataFrame
    bars = mt5.copy_rates_range(SYMBOL, TIMEFRAME, start_dt, end_dt)
    df = pd.DataFrame(bars)[['time', 'open', 'high', 'low', 'close']]
    df['time'] = pd.to_datetime(df['time'], unit='s')
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
    login=3939327
    password="Alikagasy01"
    Server="Deriv-Demo"
    mt5.login(login,password,Server)
    print(mt5)
MT5_login()
SYMBOL = "Crash 500 Index"
TIMEFRAME = mt5.TIMEFRAME_M1
#df = data.DFdataset(SYMBOL,TIMEFRAME,2022,2,1,2022,3,1)
df1 = DFdataset_1(SYMBOL,TIMEFRAME,2022,5,13,2022,5,20)

df2 = DFdataset_1(SYMBOL,TIMEFRAME,2022,5,20,2022,5,21)


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
env1 = DummyVecEnv([lambda: StockTradingEnvBuy(df1)])
env2 = DummyVecEnv([lambda: StockTradingEnvBuy(df2)])
#env = DummyVecEnv([lambda: StockTradingEnv(df)])
env1.seed(0)
env2.seed(0)


model = PPO2(MlpPolicy, env1, verbose=1, seed=0, n_cpu_tf_sess=1)
model.learn(total_timesteps=200000)
model.save('buysell2')
model = PPO2.load("buysell2")
#-6497.269171764005
#-28.450912496060482
#-23.133360367120986 11 21
"""
                      time      open      high       low     close
0    2022-05-02 21:00:00  5978.178  5978.875  5978.178  5978.875
1    2022-05-02 21:01:00  5978.889  5979.627  5978.889  5979.627
2    2022-05-02 21:02:00  5979.631  5980.339  5979.631  5980.339
3    2022-05-02 21:03:00  5980.341  5981.005  5980.341  5981.005
4    2022-05-02 21:04:00  5981.022  5981.759  5981.022  5981.759
...                  ...       ...       ...       ...       ...
1436 2022-05-03 20:56:00  6156.314  6157.061  6156.314  6157.061
1437 2022-05-03 20:57:00  6157.065  6157.785  6157.065  6157.785
1438 2022-05-03 20:58:00  6157.791  6158.520  6157.791  6158.520
1439 2022-05-03 20:59:00  6158.526  6159.257  6158.526  6159.257
1440 2022-05-03 21:00:00  6159.272  6159.950  6159.272  6159.950
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
gain = 0
last_reward = 0
for i in range(1,(len(df1['open'])-212)):
    print(i)
    if(i==1):
        list_reward1 = []
    ac = []
    action, _states = model.predict(obs1)
    ac.append(action)
    print(action)
    #print(ac[0])
    #print(ac)
    obs1, rewards, done, info = env1.step(action)
    print("reward+++"+str(rewards[0]))
    print(info)
    if(int(info[0]['step'])==1):
        break
    if(rewards[0]>last_reward):
        gain = gain+0.82
        last_reward = rewards[0]
    if(rewards[0]<last_reward):
        gain = gain-1
        last_reward = rewards[0]
    list_reward1.append(rewards[0])
    list_done.append(float(info[0]['profit']))
    #print(list_reward1)
    print("done for="+str(done))
    
    
    env1.render()
plotxy(list_reward1)
plotxy(list_done)
list_done2 = []
nb_done = 0
gain = 0
last_reward = 0
for i in range(1,len(df2['open'])-212):
    print(i)
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
    print("reward+++"+str(rewards[0]))
    if(int(info[0]['step'])==1):
        break
    if(rewards[0]>last_reward):
        gain = gain+0.82
        last_reward = rewards[0]
        #list_done2.append(gain)
    if(rewards[0]<last_reward):
        gain = gain-1
        last_reward = rewards[0]
        #list_done2.append(gain)
    list_done2.append(float(info[0]['profit']))
    #print(info)
    
    env2.render()


plotxy(list_reward2)
plotxy(list_done2)


    