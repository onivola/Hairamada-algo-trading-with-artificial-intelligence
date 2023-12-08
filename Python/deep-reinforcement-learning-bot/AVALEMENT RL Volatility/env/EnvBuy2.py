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


class EnvBuy2(gym.Env):
    """A stock trading environment for OpenAI gym"""
    metadata = {'render.modes': ['human']}

    def __init__(self, df):
        super(EnvBuy2).__init__()
        self.nb_obs = 0
        self.df = df
        self.end = 0
        self.chmin = self.get_min()
        self.dataset = Dataset("drl")
        self.reward_range = (0, MAX_ACCOUNT_BALANCE)
        self.profit = 0
        self.endreward=0
        self.reward=0
        self.current_step = 0
        self.nb_pos = 0
        self.whole = self.get_whole()
        self.nb_gain = 0
        self.nb_perte = 0
        # Actions of the format Buy x%, Sell x%, Hold, etc.
        self.action_space = spaces.Discrete(2)
        # Prices contains the OHCL values for the last five prices
        self.observation_space = spaces.Box(
            low=0, high=1, shape=(204, 2), dtype=np.float16)
    

    def get_whole(self):
        list_open = []
        for i in range(0,len(self.df['open'])):
            list_open.append(abs(self.df['open'][i]-self.df['close'][i]))
        #print("max_open ="+str(max(list_open)))
        return max(list_open)
    def get_min(self):
        list_open = []
        for i in range(0,len(self.df['open'])):
            list_open.append(abs(self.df['open'][i]-self.df['close'][i]))
        #print("max_open ="+str(max(list_open)))
        return min(list_open)
    def _next_observation(self):
        # Get the stock data points for the last 5 days and scale to between 0-1

        xy = self.dataset.get_obs01(self.df,self.current_step,204,6,self.whole)
        obs2 = np.array(xy[0][0])
        #print(obs2)

        return obs2
    def result_next_observation(self):
        # Get the stock data points for the last 5 days and scale to between 0-1

        xy = self.dataset.get_obs01(self.df,self.current_step,204,6,self.whole)
        obs2 = np.array(xy[0][0])

        
        #print(xy[1])
        return xy[1]
        
    def GetGain(self,ch):
        return round((ch*0.1)/self.chmin,2)
    def get_reward(self,y,action_type):
        reward1 = 0
        ch1 = y[1][0][0] #quantity
        ch1_val = y[1][0][1] #1 || 0
        ch2 = y[1][1][0]
        ch2_val = y[1][1][1]
        ch3 =y[1][2][0]
        ch3_val = y[1][2][1]
        ch4 =y[1][3][0]
        ch4_val = y[1][3][1]
        ch5 =y[1][4][0]
        ch5_val = y[1][4][1]
        ch6 =y[1][5][0]
        ch6_val = y[1][5][1]

        if(action_type ==0): #Hold
            reward1 = 0
        elif(action_type==1): #Buy
            if(ch1_val==1):
                reward1 = reward1+self.GetGain(ch1)
            if(ch1_val==0):
                reward1 = reward1-self.GetGain(ch1)
            if(ch2_val==1):
                reward1 = reward1+self.GetGain(ch2)
            if(ch2_val==0):
                reward1 = reward1-self.GetGain(ch2)
            if(ch3_val==1):
                reward1 = reward1+self.GetGain(ch3)
            if(ch3_val==0):
                reward1 = reward1-self.GetGain(ch3)
            if(ch4_val==1):
                reward1 = reward1+self.GetGain(ch4)
            if(ch4_val==0):
                reward1 = reward1-self.GetGain(ch4)
            if(ch5_val==1):
                reward1 = reward1+self.GetGain(ch5)
            if(ch5_val==0):
                reward1 = reward1-self.GetGain(ch5)
            if(ch6_val==1):
                reward1 = reward1+self.GetGain(ch6)
            if(ch6_val==0):
                reward1 = reward1-self.GetGain(ch6)
        return reward1
    def step(self, action):
        # Execute one time step within the environment
        #print(y)
        #print(action)
        #print(y[len(y)-1])
        #print(y[0])
        #obs = self._next_observation()
        #self.reward =0
        y = self.result_next_observation()
        #print("current_step = "+str(self.current_step))
        action_type = action
        #print(action_type)

        if(action_type ==0): #Hold
            self.reward = self.reward
        elif(action_type==1): #Buy
            if(self.get_reward(y,action_type)<=0):
                self.nb_perte = self.nb_perte+1
                #self.reward = self.reward-2
            if(self.get_reward(y,action_type)>0):
                self.nb_gain = self.nb_gain + 1
                #self.reward = self.reward+1
            self.reward = self.reward+self.get_reward(y,action_type)
            self.end = self.end+1
            self.nb_pos = self.nb_pos+1
        #self.current_step += 1
        #print(-11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111)
        self.profit = self.profit+self.reward
        #print(self.profit)
        done = False
        #self.nb_obs = self.nb_obs+1
        #print("action = "+str(action))
        #print(self.nb_obs)
        #print(self.current_step)
        #if(self.nb_obs ==1):
        #print(self.current_step)
        self.current_step += 6
        obs = self._next_observation()
        #self.nb_obs =0 
        #if(self.end>=14):
            #self.reward = self.reward*2
            #self.endreward =  self.reward
            #done = True
        
        #print("nb_pos="+str(self.nb_pos))
        #print("reward="+str(self.reward))
        #print("done = "+str(self.end))
        #print(len(self.df.loc[:, 'open'].values))
        info = self.end
        self.end = 0
        if(self.current_step > (len(self.df.loc[:, 'open'].values) - (204+12))):
            #done = True
            print("reward=")
            print(self.reward)
            print("gain=")
            print(self.nb_gain)
            print("perte=")
            print(self.nb_perte)
            print(self.current_step)
            self.nb_obs = 0
            self.profit =0
            self.current_step = 0
            self.reward =0
            #self.rewar = 0
            self.nb_pos = 0
            self.endreward = 0
            self.nb_gain = 0
            self.end = 1
            obs = self._next_observation()
            if(self.nb_perte==0):
                done = True
            self.nb_perte =0
        return obs, self.reward, done, {'step': self.end,'profit': self.profit}
    def clear(self):
        self.balance = INITIAL_ACCOUNT_BALANCE
        self.net_worth = INITIAL_ACCOUNT_BALANCE
        self.max_net_worth = INITIAL_ACCOUNT_BALANCE
        self.shares_held = 0
        self.cost_basis = 0
        self.total_shares_sold = 0
        self.total_sales_value = 0
        self.current_step = 0
        return self._next_observation()
    def reset(self):
        print("reset = "+str(self.current_step))
        # Reset the state of the environment to an initial state
        self.balance = INITIAL_ACCOUNT_BALANCE
        self.net_worth = INITIAL_ACCOUNT_BALANCE
        self.max_net_worth = INITIAL_ACCOUNT_BALANCE
        self.shares_held = 0
        self.cost_basis = 0
        self.total_shares_sold = 0
        self.total_sales_value = 0
        self.end = 0
        self.profit =0
        self.reward = 0
        #print("reset-------")
        # Set the current step to a random point within the data frame
        self.current_step = 0
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