from stable_baselines import SAC
from stable_baselines import PPO2
from stable_baselines import A2C
from stable_baselines import DDPG
from stable_baselines import TD3
from stable_baselines.ddpg.policies import DDPGPolicy
from stable_baselines.common.policies import MlpPolicy
from stable_baselines.common.vec_env import DummyVecEnv
import pandas as pd
import MetaTrader5 as mt5
import MetaTrader5 as mt
from datetime import datetime
from env import env
def train_A2C(env_train, model_name, timesteps=10000):
    #A2C model
    #start = time.time()
    model = A2C('MlpPolicy', env_train, verbose=0)
    model.learn(total_timesteps=timesteps)
    #end = time.time()
    model.save(f"{config.TRAINED_MODEL_DIR}/{model_name}")
    print('Training time (A2C): ', (end-start)/60,' minutes')
    return modeldef 
    
    #train_DDPG(env_train, model_name, timesteps=10000):
def GetEncod(file):
    with open(file, 'rb') as rawdata:
        result = chardet.detect(rawdata.read(100000))
        #print(result['encoding'])
        return result['encoding']
def DFdataset(SYMBOL,TIMEFRAME,sy,sm,sd,ey,em,ed):
    start_dt = datetime(sy, sm, sd)
    end_dt =  datetime(ey, em, ed)
    # request ohlc data a save them in a pandas DataFrame
    bars = mt5.copy_rates_range(SYMBOL, TIMEFRAME, start_dt, end_dt)
    df = pd.DataFrame(bars)[['time', 'open', 'high', 'low', 'close']]
    df['time'] = pd.to_datetime(df['time'], unit='s')
    return df
    def MQL5Login(self,login,password,Server):
        mt5.initialize()
        return mt5.login(login,password,Server)
def Get_df(sy,sm,sd,ey,em,ed):
    login=3939327
    password="Alikagasy01"
    Server="Deriv-Demo"
    SYMBOL = "Volatility 75 Index"
    TIMEFRAME = mt5.TIMEFRAME_M1
    mt5.initialize()
    log =  mt5.login(login,password,Server)
    print(log)
    df = DFdataset(SYMBOL,TIMEFRAME,sy,sm,sd,ey,em,ed)
    return df

df =  Get_df(2022,1,1,2022,2,2)

print(df)
print(1584321)
env_train = env(df)
train_A2C(env_train, "drl", timesteps=10000)



model = PPO2(MlpPolicy, env, verbose=1)
model.learn(total_timesteps=20000)

obs = env.reset()
for i in range(2000):
    action, _states = model.predict(obs)
    obs, rewards, done, info = env.step(action)
    env.render()