
# 1. Set `PYTHONHASHSEED` environment variable at a fixed value
import os


# 2. Set `python` built-in pseudo-random generator at a fixed value
import random


# 3. Set `numpy` pseudo-random generator at a fixed value
import numpy as np

# 4. Set `tensorflow` pseudo-random generator at a fixed value
import tensorflow as tf

import gym
import json
import datetime as dt
from stable_baselines.common.policies import MlpPolicy
from stable_baselines.common.vec_env import DummyVecEnv
from stable_baselines import PPO2
import MetaTrader5 as mt5
import MetaTrader5 as mt
from env.StockTradingEnv import StockTradingEnv
from env.StockTradingEnv3ch import StockTradingEnv3ch
from Dataset import Dataset
import pandas as pd
import matplotlib.pyplot as plt


print(1)