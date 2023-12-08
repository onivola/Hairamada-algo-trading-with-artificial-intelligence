import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'
import MetaTrader5 as mt5
import MetaTrader5 as mt
import numpy as np
import plotly.graph_objects as go
from tensorflow.keras import optimizers
from tensorflow import keras 
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense
##Volatility 75 Index
import pandas as pd
import plotly.express as px 
from datetime import datetime
from datetime import datetime, timedelta
### Partie A - Les données
from tensorflow.keras.datasets import mnist
from tensorflow.keras.utils import to_categorical
from IPython.display import display
import itertools
import MetaTrader5 as mt5
import MetaTrader5 as mt
import pandas as pd
import chardet
import itertools
import tensorflow as tf
from tensorflow.keras import layers
from tensorflow.keras import activations
from tensorflow.keras.datasets import cifar10
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Dropout, Activation, Flatten
# more info on callbakcs: https://keras.io/callbacks/ model saver is cool too.
from tensorflow.keras.callbacks import TensorBoard
import pickle
import time
from matplotlib import pyplot as plt
from plot_keras_history import plot_history
import matplotlib
import matplotlib.pyplot as plt
from keras import callbacks
from sklearn.model_selection import train_test_split
import seaborn as sns
from sklearn.metrics import confusion_matrix
from numpy.random import seed