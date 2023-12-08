import random
import json
import gym
from gym import spaces
import pandas as pd
import numpy as np
from Dataset import Dataset
MAX_ACCOUNT_BALANCE = 2147483647
MAX_NUM_SHARES = 2147483647
MAX_SHARE_PRICE = 1
MAX_OPEN_POSITIONS = 5
MAX_STEPS = 20000

INITIAL_ACCOUNT_BALANCE = 10000


class StockTradingEnv1ch(gym.Env):
    """A stock trading environment for OpenAI gym"""
    metadata = {'render.modes': ['human']}

    def __init__(self, df):
        super(StockTradingEnv1ch, self).__init__()

        self.df = df
        self.end = 0
        #self.array_reward = [2,4,8,16,2*16,2*2*16,2*2*2*16,2*2*2*2*16]
        self.dataset = Dataset("drl")
        self.reward_range = (0, MAX_ACCOUNT_BALANCE)
        self.profit = 0
        self.endreward=0
        self.reward=0
        self.current_step = 0
        self.nb_pos = 0
        self.max_reward = 0
        self.min_reward = 0
        self.capital = 1000
        self.position = 1
        self.last_position = 1
        self.last_gain = 0
        self.whole = self.get_max_chandel(self.df)
        # Actions of the format Buy x%, Sell x%, Hold, etc.
        self.action_space = spaces.Discrete(3)
        # Prices contains the OHCL values for the last five prices
        self.observation_space = spaces.Box(
            low=0, high=1, shape=(100, 4), dtype=np.float16)

    def _next_observation(self):
        # Get the stock data points for the last 5 days and scale to between 0-1

        xy = self.dataset.get_obs(self.df,self.current_step,100,3,self.whole)
        obs2 = np.array(xy[0][0])
        #print("-------------------------------------------")
        #print(obs2)
        #print(self.whole)
        #print(np.shape(obs2))
        #print(obs2)

        return obs2
    def result_next_observation(self):
        # Get the stock data points for the last 5 days and scale to between 0-1

        xy = self.dataset.get_obs(self.df,self.current_step,100,3,self.whole)
        obs2 = np.array(xy[0][0])
        #print("-------------------------------------------")
        #print(np.shape(obs2))
        
        #print(xy[1])
        return xy[1]
    def get_max_chandel(self,df1):
        diff = []
        for i in range(0,len(df1['open'])):
            diff.append(abs (df1['open'][i] - df1['close'][i]))
        return max(diff)
    def get_reward(self,y,action_type):
        reward1 = 0
        ch1 = y[1][0][1]
        ch1_val = y[1][0][3]
        ch2 = y[1][1][1]
        ch2_val = y[1][1][3]
        ch3 =y[1][2][1]
        ch3_val = y[1][2][3]
        if(action_type ==0): #Sell
            if(ch1_val==0):
                reward1 = reward1+ch1
            if(ch1_val==1):
                reward1 = reward1-ch1
                #self.reward =self.endreward
                self.end = 0
                self.nb_pos = self.nb_pos+1
           
            #self.current_step += 1
        elif(action_type ==2): #Hold
            reward1 = 0
        elif(action_type==1): #Buy
            if(ch1_val==1):
                reward1 = reward1+ch1
            if(ch1_val==0):
                reward1 = reward1-ch1
                #self.reward =self.endreward
                self.end = 0
                self.nb_pos = self.nb_pos+1
        return reward1
    def Get_Position(self,last_pos,gain):
        return last_pos+gain
    def Get_Gain(self,ch):
        ref = (5978.572-5978.085)/self.whole# 0.1
        #print("gain ="+ str(abs(round((ch*0.1)/ref,2))))
        return abs(round((ch*0.1)/ref,2))
    def step(self, action):
        # Execute one time step within the environment
        
        obs = self._next_observation()
        y = self.result_next_observation()
        #print(obs)
        #print(y)
        #print(action)
        #print(y[len(y)-1])
        #print(y[0])
        self.current_step += 1
        #print("current_step"+str(self.current_step))
        action_type = action
        ch1 = y[1][0][1]
        ch1_val = y[1][0][3]
        ch2 = y[1][1][1]
        ch2_val = y[1][1][3]
        ch3 =y[1][2][1]
        ch3_val = y[1][2][3]
        if(action_type ==0): #Sell
            if(ch1_val==0):
                if(ch1>0):
                    self.reward = self.reward+self.Get_Gain(ch1)
                #if(ch1==0):#PERTE
                    #self.reward = self.reward-self.Get_Gain(ch1)
            if(ch1_val==1):#PERTE
                self.reward = self.reward-self.Get_Gain(ch1)
            self.nb_pos = self.nb_pos+1
            #self.current_step += 1
        elif(action_type ==2): #Hold
            self.reward = self.reward
        elif(action_type==1): #Buy
            if(ch1_val==1):
                if(ch1>0):
                    self.end = self.end+1
                    self.reward = self.reward+self.Get_Gain(ch1)
                #if(ch1==0): #PERTE
                    #self.reward = self.reward-self.Get_Gain(ch1)
            if(ch1_val==0):#PERTE
                self.reward = self.reward-self.Get_Gain(ch1)
            self.nb_pos = self.nb_pos+1
            #print(-222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222)
            #print(-11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111)
        
        #print("nb_pos="+str(self.nb_pos))
        #print("reward="+str(self.reward))
        done = False
        #print(len(self.df.loc[:, 'open'].values))
        if(self.current_step > (len(self.df.loc[:, 'open'].values) - 103)):
            self.current_step = 0
            self.reward =0
            self.nb_pos = 0
        return obs, self.reward, done, {}
    def step2(self, action):
        # Execute one time step within the environment
        
        obs = self._next_observation()
        y = self.result_next_observation()
        #print(y)
        #print(action)
        #print(y[len(y)-1])
        #print(y[0])
        self.current_step += 1
        #print("current_step = "+str(self.current_step))
        action_type = action
        if(action_type ==0 and y[0]>y[len(y)-1]):
            self.reward = self.reward+1
            self.end = self.end+1
            #self.current_step += 1
        elif(action_type ==2):
            self.reward = self.reward
        elif(action_type==1  and y[0]<y[len(y)-1]):
            self.reward = self.reward+1
            self.end = self.end+1
            #self.current_step += 1
            
            #print(-222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222)
        elif((action_type==1  and y[0]>y[len(y)-1]) or (action_type ==0 and y[0]<y[len(y)-1])):
            self.reward =self.reward -1
            self.end = 0
        elif(y[0]==y[len(y)-1]) or (y[0]==y[len(y)-1]):
            self.reward = self.reward+1
            
            #print(-11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111)
        self.profit = self.reward
        #print(self.profit)
        done = False
        #if(self.end>=14):
            #done = True
        #print("reward="+str(self.reward))
        #print("done = "+str(self.end))
        #print(len(self.df.loc[:, 'open'].values))
        if(self.current_step > (len(self.df.loc[:, 'open'].values) - 100)):
            self.current_step = 0
            self.reward =0
        return obs, self.reward, done, {}

    def reset(self):
        # Reset the state of the environment to an initial state
        self.balance = INITIAL_ACCOUNT_BALANCE
        self.net_worth = INITIAL_ACCOUNT_BALANCE
        self.max_net_worth = INITIAL_ACCOUNT_BALANCE
        self.shares_held = 0
        self.cost_basis = 0
        self.total_shares_sold = 0
        self.total_sales_value = 0
        #print("reset-------")
        # Set the current step to a random point within the data frame
        #self.current_step = 1
        return self._next_observation()

    def render(self, mode='human', close=False):
        # Render the environment to the screen
        

        print(f'Step: {self.current_step}')
        print(f'Balance: {self.balance}')
        print(
            f'Shares held: {self.shares_held} (Total sold: {self.total_shares_sold})')
        print(
            f'Avg cost for held shares: {self.cost_basis} (Total sales value: {self.total_sales_value})')
        print(
            f'Net worth: {self.net_worth} (Max net worth: {self.max_net_worth})')
        print(f'Profit: {self.profit}')