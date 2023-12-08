import pandas as pd
import chardet
import itertools
import MetaTrader5 as mt5
import MetaTrader5 as mt
from datetime import datetime
from datetime import datetime, timedelta
import statistics
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
    def get_XY(self,df2,b1,b2): #b1=5 b2 = 9
        X=[]
        Y=[]
        whole=3500*(b2-b1)
        for i in range(len(df2)-b2):
            Px=[]
            Py=[]
            nb0 = 0
            nb1 = 0
            for x in range(i,i+b1):
                px=self.vectorisation(df2['open'][x],df2['high'][x],df2['low'][x],df2['close'][x],False)
                Px.append(px)
            
            
            for y in range(i+b1,i+b2):
                py=self.vectorisation(df2['open'][y],df2['high'][y],df2['low'][y],df2['close'][y],False)
                if(py[3]==0):
                    nb0 = nb0+1
                if(py[3]==1):
                    nb1 = nb1+1
            y = 0
            #print(nb0)
            if(nb0>=b2-b1):
                y = -1
            if(nb1>=b2-b1):
                y = 1
            #print(y) 
            Y.append(y)
            P=self.reshape(Px)
            X.append(P)
            
            #if(py[0]<py[1]):
                #P=self.reshape(Px)
                #X.append(P)
                #Y.append(0)
        XY=[]
        #normalized_matrix = normalize_2d(X)
        XY.append(X)

        XY.append(Y)
        return XY 

    def get_XY_simple(self,df2,b1,b2): #b1=5 b2 = 9
        X=[]
        Y=[]
        whole=3500*(b2-b1)
        for i in range(len(df2)-b2):
            Px=[]
            Py=[]
            nb0 = 0
            nb1 = 0
            for x in range(i,i+b1):
                px=self.vectorisation(df2['open'][x],df2['high'][x],df2['low'][x],df2['close'][x],False)
                Px.append(px)
            
            y = i+b1
            py=self.vectorisation(df2['open'][y],df2['high'][y],df2['low'][y],df2['close'][y],False)
            Y.append(py[3])
            P=self.reshape(Px)
            X.append(P)
            
            #if(py[0]<py[1]):
                #P=self.reshape(Px)
                #X.append(P)
                #Y.append(0)
        XY=[]
        #normalized_matrix = normalize_2d(X)
        XY.append(X)

        XY.append(Y)
        return XY         
    def get_XYTEST(self,df2,b1,b2): #b1=5 b2 = 9
        X=[]
        whole=3500*(b2-b1)
        i = 0
        Px=[]
        for x in range(i,i+b1):
            px=self.vectorisation(df2['open'][x],df2['high'][x],df2['low'][x],df2['close'][x],False)
            Px.append(px)
        P=self.reshape(Px)
        X.append(P)


        return X
    def normalize_2d(self,matrix):
        norm = np.linalg.norm(matrix)
        matrix = matrix/norm  # normalized matrix
        return matrix
        #function vectorisation
    def vectorisationOHOL(self,Open,High,Low,Close):
        #whole=3500
        whole=0.0003
        part=[0,0]
        part[0]= abs(Open-High)/whole
        part[1]= abs(Open-Low)/whole
        return part
    def vectorisation(self,Open,High,Low,Close,troi):
        #whole=3500
        whole=0.0003
        part=[0,0,0,0]
        if(troi):
            part=[0,0,0,0]
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