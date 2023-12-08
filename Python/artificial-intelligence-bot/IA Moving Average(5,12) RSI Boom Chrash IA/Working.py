import random
import itertools
import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'
from tensorflow import keras 
import tensorflow as tf
import numpy as np
import pandas as pd


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
            
   

    def open_dataset_backtest(self,file):
        link = r"C:\Users\Onintsoa\AppData\Roaming\MetaQuotes\Terminal\Common\Files"+"\\"+file
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

    def Write_Predect_backtest(self,value,file):
        link = r"C:\Users\Onintsoa\AppData\Roaming\MetaQuotes\Terminal\Common\Files"+"\\"+file
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
            
            
    def CSVdiff_2ma(self,ma05,ma15,ma012,ma112):
        ma = []
        X = []
        Y = []
        ma.append(ma05)
        ma.append(ma012)
        ma = list(itertools.chain.from_iterable(ma))
        ma_max = max(ma)

        y_value = 1

        for i in range(0,len(ma)): #ma5 ma12
            X.append(abs(ma_max-ma[i]))
        #print(X)
        return [X,Y]
    def CSVGet_X(self,df):
        X = []
        Pma05 = []
        Pma012 = []
        Pma = []
        for j in range(14,-1,-1): #15 avant croix
            Pma05.append(float(df['MA5'][j]))
            Pma012.append(float(df['MA12'][j]))
        
        xy = self.CSVdiff_2ma(Pma05,Pma,Pma012,Pma)
        
        old_min = min(xy[0])
        old_range = max(xy[0])
        new_min = 0
        new_range = 1
        xnorm = [float((n - old_min) / old_range * new_range + new_min) for n in xy[0]]
        X.append(xnorm)
        return X
    def CSVdiff_2ma_rsi(self,ma05,ma15,ma012,ma112):
        ma = []
        X = []
        Y = []
        ma.append(ma05)
        ma.append(ma012)
        ma = list(itertools.chain.from_iterable(ma))
        ma_max = max(ma)
        y_value = 1

        for i in range(0,len(ma)): #ma5 ma12
            X.append(abs(ma_max-ma[i]))
        #print(X)
        return [X,Y]
    def normalization(self,Prsi):
        old_min = min(Prsi)
        old_range = max(Prsi)
        new_min = 0
        new_range = 1
        xnorm = [float((n - old_min) / old_range * new_range + new_min) for n in Prsi]
        return xnorm
    def CSVGet_X_rsi(self,df):
        X = []
        Pma05 = []
        Pma012 = []
        Pma = []
        Pmarsi = []
        xnorm =[]
        for j in range(14,-1,-1): #15 avant croix
            Pma05.append(float(df['MA5'][j]))
            Pma012.append(float(df['MA12'][j]))
            Pmarsi.append(float(df['RSI'][j]))
            
        xy = self.CSVdiff_2ma_rsi(Pma05,Pma,Pma012,Pma)
        x = xy[0]
        xnorm = self.normalization(x)
        xrsinorm = self.normalization(Pmarsi)
        #print(xrsinorm)
        for i in range(0,len(xrsinorm)): #ma5 ma12
            xnorm.append(xrsinorm[i])
        X.append(xnorm)
        #print(X)
        return X

    def Check_Filechange(self,last_nb,dc):
        if(last_nb<float(dc['MA5'][16])):
            return True
        return False


    def run(self):
        last_nb = -1
        last_predict = -10
        while(1):
            dc = self.open_dataset()
            time.sleep(1)
            if 'MA5' in dc:
                #print(dc)
                new_nb = float(dc['MA5'][15])
                #print(last_nb)
                if(new_nb>last_nb):
                    XTEST = self.CSVGet_X(dc)
                    print(XTEST)
                    res = model.predict(XTEST) #predict
                    print(res)
                    res = round(float(res[0]),4)
                    if(res==last_predict):
                        last_predict = res
                        res = res+0.001
                    if(res!=last_predict):
                        last_predict = res
                    
                        
                    while(self.Write_Predect(res)==False): #write predict value
                        e = 1
                    last_nb=new_nb