import random
import itertools
import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'
from tensorflow import keras 
import tensorflow as tf
import numpy as np
import pandas as pd
import chardet

class Working:
    def __init__(mysillyobject, name): #other operations that are necessary to do when the object is being created
        mysillyobject.name = name
        
    def open_dataset(self,file):
        link = r"C:\Users\Onintsoa\AppData\Roaming\MetaQuotes\Terminal\F762D69EEEA9B4430D7F17C82167C844\MQL5\Files\Data"+"\\"+file
        try:
            f = open(link, 'rb')
            
            d= pd.read_csv(link,encoding='UTF-16') #ascii
                    # Close opend file
            f.close()
            #print("dataset file read")
            return d
        except OSError:
            print("Could not open/read file:", link)

            return []
            sys.exit()

    def Write_Predect(self,value,file):
        link = r"C:\Users\Onintsoa\AppData\Roaming\MetaQuotes\Terminal\F762D69EEEA9B4430D7F17C82167C844\MQL5\Files\Data"+"\\"+file
        if(value>=1):
            value = random.uniform(1,0.9)

        if(value<=0):
            value = random.uniform(0,0.1)
        try:
            f = open(link,'w')
            f.write(str(value))
            f.close()
            print("Predict file writen")
            return True
        except IOError as e:
            print(e.args)
            return False
            pass
            
   
    def GetEncod(self,file):
        with open(file, 'rb') as rawdata:
            result = chardet.detect(rawdata.read(100000))
            #print(result['encoding'])
            return result['encoding']
    def open_dataset_backtest(self,file):
        link = r"C:\Users\Onintsoa\AppData\Roaming\MetaQuotes\Terminal\Common\Files"+"\\"+file
        try:
            f = open(link, 'rb')
            
            d= pd.read_csv(link,encoding=self.GetEncod(link)) #ascii
                    # Close opend file
            f.close()
            #print("dataset file read")
            return d
        except OSError:
            print("Could not open/read file:", link)

            return []
            sys.exit()
    
    def Write_Predect_backtest(self,value,file):
        link = r"C:\Users\Onintsoa\AppData\Roaming\MetaQuotes\Terminal\Common\Files"+"\\"+file
        try:
            f = open(link,'w')
            f.write(str(value))
            f.close()
            print("Predict file writen")
            return True
        except IOError as e:
            print(e.args)
            return False
            pass
            
            
 
    def CSVGet_X(self,df):
      
        return X