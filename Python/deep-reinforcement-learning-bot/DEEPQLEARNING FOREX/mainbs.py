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
SYMBOL = "Volatility 75 Index"
SYMBOL = "Crash 500 Index"
TIMEFRAME = mt5.TIMEFRAME_M1
#df = data.DFdataset(SYMBOL,TIMEFRAME,2022,2,1,2022,3,1)
df1 = DFdataset_1(SYMBOL,TIMEFRAME,2022,4,1,2022,5,1)

df2 = DFdataset_1(SYMBOL,TIMEFRAME,2022,5,1,2022,5,3)


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
model.learn(total_timesteps=500000)
model.save('pp')
model = PPO2.load("pp")
#-6497.269171764005
#-28.450912496060482
#-23.133360367120986
"""
                     time       open       high        low      close
0     2022-04-30 21:00:00  932652.90  933273.69  932138.66  932138.66
1     2022-04-30 21:01:00  932000.45  932222.41  931409.05  931409.05
2     2022-04-30 21:02:00  931515.86  931535.97  929043.87  929699.71
3     2022-04-30 21:03:00  929449.00  929449.00  927552.86  928014.44
4     2022-04-30 21:04:00  928185.45  928360.41  926657.08  926974.13
...                   ...        ...        ...        ...        ...
12956 2022-05-09 20:56:00  899771.85  899771.85  899000.26  899486.85
12957 2022-05-09 20:57:00  899194.17  899806.85  898705.62  899025.91
12958 2022-05-09 20:58:00  899265.83  899265.83  898196.94  898196.94
12959 2022-05-09 20:59:00  898442.51  898750.63  897545.39  898705.01
12960 2022-05-09 21:00:00  899031.34  899031.34  898096.34  898610.18

[12961 rows x 5 columns]
                    time       open       high        low      close
0    2022-05-09 21:00:00  899031.34  899031.34  898096.34  898610.18
1    2022-05-09 21:01:00  898567.74  899280.57  897820.67  897926.54
2    2022-05-09 21:02:00  898017.97  898835.17  897426.77  898726.61
3    2022-05-09 21:03:00  898654.13  899045.31  897740.44  898236.16
4    2022-05-09 21:04:00  898490.64  899234.92  898236.23  898767.77
...                  ...        ...        ...        ...        ...
1436 2022-05-10 20:56:00  862066.15  863005.67  861805.04  862291.28
1437 2022-05-10 20:57:00  862583.69  863343.64  862390.70  863107.07
1438 2022-05-10 20:58:00  862931.76  863094.92  862191.48  862191.48
1439 2022-05-10 20:59:00  861983.85  862399.72  861027.31  861562.88
1440 2022-05-10 21:00:00  861219.40  862685.10  860749.28  862685.10
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


    