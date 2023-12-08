import pandas as pd
import chardet
import MetaTrader5 as mt5
import MetaTrader5 as mt
from datetime import datetime
from datetime import datetime, timedelta
class Dataset:
    def __init__(mysillyobject, name): #other operations that are necessary to do when the object is being created
        mysillyobject.name = name
    def GetEncod(self,file):
        with open(file, 'rb') as rawdata:
            result = chardet.detect(rawdata.read(100000))
            #print(result['encoding'])
            return result['encoding']
            
    def GetCSVData(self,file):
        df= pd.read_csv(file,encoding=self.GetEncod(file))
        #print(df)
        return df
    def DFdatasetCurrent(self,SYMBOL,TIMEFRAME,nb):
        bars = mt5.copy_rates_from_pos(SYMBOL, TIMEFRAME, 1, nb)
        df = pd.DataFrame(bars)[['time', 'open', 'high', 'low', 'close']]
        #df['time'] = pd.to_datetime(df['time'], unit='s')
        return df
        
    def DFdataset(self,SYMBOL,TIMEFRAME,sy,sm,sd,ey,em,ed):
        start_dt = datetime(sy, sm, sd)
        end_dt =  datetime(ey, em, ed)
        # request ohlc data a save them in a pandas DataFrame
        bars = mt5.copy_rates_range(SYMBOL, TIMEFRAME, start_dt, end_dt)
        df = pd.DataFrame(bars)[['time', 'open', 'high', 'low', 'close']]
        df['time'] = pd.to_datetime(df['time'], unit='s')
        return df
        
    def reshape(self,P):
        Pn=[]
        for i in range(len(P)):
            for j in range(len(P[i])):
                Pn.append(P[i][j])
        return Pn
    def get_obs_predict(self,df2,i,b1):
        X=[]
        Y=[]
        Px=[]
        Py=[]
        reward = 0
        close1 = 0
        close = 0
        for x in range(i,i+b1):
            Px.append(self.vectorisation(df2['open'][x],df2['high'][x],df2['low'][x],df2['close'][x],False))
            close1 = df2['close'][x]


        X.append(Px)
        
        XY=[]
        #normalized_matrix = normalize_2d(X)
        XY.append(X)

        XY.append([0])
        return XY 
    def get_obs(self,df2,i,b1,b2,whole): #b1=5 b2 = 9
        X=[]
        Y=[]
        Px=[]
        Py=[]
        reward = 0
        close1 = 0
        close = 0
        for x in range(i,i+b1):
            Px.append(self.vectorisation(df2['open'][x],df2['high'][x],df2['low'][x],df2['close'][x],whole,False))
            close1 = df2['close'][x]
        
        for y in range(i+b1,i+b1+b2):
            Py.append(self.vectorisation(df2['open'][y],df2['high'][y],df2['low'][y],df2['close'][y],whole,False))
            close = df2['close'][y]
        Y.append(close1)
        Y.append(Py)
        Y.append(close)
        X.append(Px)
        
        #if(py[0]<py[1]):
            #P=self.reshape(Px)
            #X.append(P)
            #Y.append(0)
        XY=[]
        #normalized_matrix = normalize_2d(X)
        XY.append(X)

        XY.append(Y)
        return XY 

  
    def normalize_2d(self,matrix):
        norm = np.linalg.norm(matrix)
        matrix = matrix/norm  # normalized matrix
        return matrix
        #function vectorisation
    def vectorisationOHOL(self,Open,High,Low,Close):
        #whole=3500
        whole=30
        part=[0,0]
        part[0]= abs(Open-High)/whole
        part[1]= abs(Open-Low)/whole
        return part
    def vectorisation(self,Open,High,Low,Close,whole,troi):
        #whole=3500
        part=[0,0,0,0]
        if(troi):
            part=[0,0,0,0,0,0]
        if(Open > Close): # 0 midina
            part[0]=((High - Open) * 1 )/whole
            part[1]=((Open - Close)*1)/whole
            part[2]=((Close - Low))*1/whole
            part[3]=0
            if(troi==3):
                part[3]=Open
            if(troi==1):
                part[3]= (-((Open - Close)*1)/whole)
            if(troi==2):
                part[3]= Close
        if(Close >= Open): # 1 miakatra
            part[0]= ((High - Close) * 1 )/whole
            part[1]=((Close-Open)*1)/whole
            part[2]=((Open-Low)*1)/whole
            part[3]=1
            if(troi==3):
                part[3]=Open
            if(troi==1):
                part[3]=((Open - Close)*1)/whole
            if(troi==2):
                part[3]= Close
        return part

    def diffOpenClose(self,aB,bB,Open,Close):
        whole = abs(aB-bB) #50
        Next = (Open-Close)
        if(whole==0 or Next==0):
            return 0
        return (Next*0.5)/whole