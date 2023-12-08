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


class StockTradingEnv(gym.Env):
    """A stock trading environment for OpenAI gym"""
    metadata = {'render.modes': ['human']}

    def __init__(self, df):
        super(StockTradingEnv, self).__init__()

        self.df = df
        self.end = 0
        self.dataset = Dataset("drl")
        self.reward_range = (0, MAX_ACCOUNT_BALANCE)
        self.profit = 0
        self.endreward=0
        self.reward=0
        self.current_step = 0
        self.nb_pos = 0
        self.whole = self.get_whole()
        self.whole_vol = self.get_whole_vol()
        # Actions of the format Buy x%, Sell x%, Hold, etc.
        self.action_space = spaces.Discrete(3)
        # Prices contains the OHCL values for the last five prices
        self.observation_space = spaces.Box(
            low=0, high=1, shape=(60, 5), dtype=np.float16)
    def get_whole_vol(self):
        list_volume = []
        for i in range(0,len(self.df['open'])):
            list_volume.append(abs(self.df['tick_volume'][i]))
        print("max_vol = "+str(max(list_volume)))
        return max(list_volume)

    def get_whole(self):
        list_open = []
        for i in range(0,len(self.df['open'])):
            list_open.append(abs(self.df['open'][i]-self.df['close'][i]))
        print("max_open ="+str(max(list_open)))
        return max(list_open)
    def _next_observation(self):
        # Get the stock data points for the last 5 days and scale to between 0-1

        xy = self.dataset.get_obs(self.df,self.current_step,60,3,self.whole,self.whole_vol)
        obs2 = np.array(xy[0][0])
        #print(obs2)

        return obs2
    def result_next_observation(self):
        # Get the stock data points for the last 5 days and scale to between 0-1

        xy = self.dataset.get_obs(self.df,self.current_step,60,3,self.whole,self.whole_vol)
        obs2 = np.array(xy[0][0])

        
        #print(xy[1])
        return xy[1]
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
            if(ch2_val==0):
                reward1 = reward1+ch2
            if(ch2_val==1):
                reward1 = reward1-ch2
            if(ch3_val==0):
                reward1 = reward1+ch3
            if(ch3_val==1):
                reward1 = reward1-ch3
            #self.current_step += 1
        elif(action_type ==2): #Hold
            reward1 = 0
        elif(action_type==1): #Buy
            if(ch1_val==1):
                reward1 = reward1+ch1
            if(ch1_val==0):
                reward1 = reward1-ch1
            if(ch2_val==1):
                reward1 = reward1+ch2
            if(ch2_val==0):
                reward1 = reward1-ch2
            if(ch3_val==1):
                reward1 = reward1+ch3
            if(ch3_val==0):
                reward1 = reward1-ch3
        return reward1
    def step(self, action):
        # Execute one time step within the environment
        
        obs = self._next_observation()
        y = self.result_next_observation()
        #print(y)
        #print(action)
        #print(y[len(y)-1])
        #print(y[0])
        self.current_step += 4
        print("current_step = "+str(self.current_step))
        action_type = action
        if(action_type ==0 and y[0]>y[len(y)-1]): #Sell
            self.reward = self.reward+self.get_reward(y,action_type)
            self.end = self.end+1
            self.nb_pos = self.nb_pos+1
            #self.current_step += 1
        elif(action_type ==2): #Hold
            self.reward = self.reward
        elif(action_type==1  and y[0]<y[len(y)-1]): #Buy
            self.reward = self.reward+self.get_reward(y,action_type)
            self.end = self.end+1
            self.nb_pos = self.nb_pos+1
            #self.current_step += 1
            
            #print(-222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222)
        elif((action_type==1  and y[0]>y[len(y)-1]) or (action_type ==0 and y[0]<y[len(y)-1])): #perte
            self.reward =self.endreward
            self.end = 0
            self.nb_pos = self.nb_pos+1
        elif((y[0]==y[len(y)-1]) or (y[0]==y[len(y)-1])) and action_type!=2: #neutre
            self.nb_pos = self.nb_pos+1
            self.reward = self.endreward
            self.end = 0
            
            #print(-11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111)
        self.profit = self.reward
        #print(self.profit)
        done = False
        if(self.end>=14):
            self.reward = self.reward*2
            self.endreward =  self.reward
            done = True
        
        print("nb_pos="+str(self.nb_pos))
        print("reward="+str(self.reward))
        print("done = "+str(self.end))
        print(len(self.df.loc[:, 'open'].values))
        info = self.end
        if(self.current_step > (len(self.df.loc[:, 'open'].values) - 63)):
            self.current_step = 0
            self.reward =0
            self.nb_pos = 0
            self.endreward = 0
        return obs, self.reward, done, {}
    def step2(self, action):
        # Execute one time step within the environment
        
        obs = self._next_observation()
        y = self.result_next_observation()
        #print(y)
        #print(action)
        #print(y[len(y)-1])
        #print(y[0])
        self.current_step += 4
        print("current_step = "+str(self.current_step))
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
        if(self.end>=14):
            done = True
        print("reward="+str(self.reward))
        print("done = "+str(self.end))
        print(len(self.df.loc[:, 'open'].values))
        if(self.current_step > (len(self.df.loc[:, 'open'].values) - 17)):
            #self.current_step = 0
            test_list = [0,1,2,3]
  
            # printing original list 
            print("Original list is : " + str(test_list))
            # using random.randrange() to 
            # get a random number 
            rand_idx = random.randrange(len(test_list))
            random_num = test_list[rand_idx]
            
            self.current_step = random_num
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
        print("reset-------")
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