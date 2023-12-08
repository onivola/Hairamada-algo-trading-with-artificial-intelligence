
import pandas as pd
import chardet
import itertools
class Dataset:
    def __init__(mysillyobject, name, age): #other operations that are necessary to do when the object is being created
        mysillyobject.name = name
        mysillyobject.age = age
    def GetEncod(self,file):
        with open(file, 'rb') as rawdata:
            result = chardet.detect(rawdata.read(100000))
            #print(result['encoding'])
            return result['encoding']
            
    def GetCSVData(self,file):
        df= pd.read_csv(file,encoding=self.GetEncod(file))
        #print(df)
        return df
        
    def diff_2ma(self,ma05,ma15,ma012,ma112):
        ma = []
        X = []
        Y = []
        
        ma.append(ma05)
        ma.append(ma012)
        ma = list(itertools.chain.from_iterable(ma))
        ma_max = max(ma)
        #print(ma)
        y_value = 1
        for j in range(1,len(ma15)): #check y
            if(ma15[j]<ma15[j-1]): #0
                y_value = 0
        Y.append(y_value)
        for i in range(0,len(ma)): #ma5 ma12
            X.append(abs(ma_max-ma[i]))
        #print(X)
        return [X,Y]
    def Get_Y(self,ma1):
        y_value = 1
        y = 0
        for j in range(1,len(ma1)): #check y
            if(ma1[j]<ma1[j-1]): #0
                y_value = y
                return 0
        #print(X)
        return 1
    def normalization(self,Prsi):
        old_min = min(Prsi)
        old_range = max(Prsi)
        new_min = 0
        new_range = 1
        xnorm = [float((n - old_min) / old_range * new_range + new_min) for n in Prsi]
        return xnorm
    def normalization_rsi_macd(self,Prsi,omin,omax):
        old_min = (omin)
        old_range = (omax)
        new_min = 0
        new_range = 1
        xnorm = [float((n - old_min) / old_range * new_range + new_min) for n in Prsi]
        return xnorm
    def Get_XY(self,df,nb0,nb1):
        XY = []
        x = []
        y = []
        for i in range(nb0,len(df)-nb1):
            
            if(df['MA5'][i]>df['MA12'][i] and df['MA5'][i-1]<df['MA12'][i-1]):
                Pma05 = []
                Pma15 = []
                Pma012 = []
                Pma112 = []
                Pma = []
                Pma01 = []
                Pma11 = []
                Pmacd = []
                Prsi =[]
                xt =[]
                for j in range(i-nb0,i): #15 avant croix
                    Pma05.append(df['MA5'][j])
                    Pma012.append(df['MA12'][j])
                    Pma01.append(df['MA1'][j])
                    Pmacd.append(df['MACD'][j])
                    Prsi.append(df['RSI'][j])
                for k in range(i,i+nb1): #15 apres croix
                    Pma11.append(df['MA1'][k])
                #print(len(Pma11))
                yt = self.Get_Y(Pma11)
                Pma01 = self.normalization(Pma01)
                Prsi = self.normalization_rsi_macd(Prsi,0,60)
                Pmacd = self.normalization_rsi_macd(Pmacd,-5,5)
                for l in range(0,len(Pma01)):
                    xt.append(Pma01[l])
                for m in range(0,len(Pma01)):
                    xt.append(Prsi[m])
                for n in range(0,len(Pma01)):
                    xt.append(Pmacd[n])
                    
                x.append(xt)
                y.append(yt)
                #if(i==10):
                    #break
                #print(Pma01)
                #print(Prsi)
                #print(Pmacd)
                #print(len(Pmacd))
                #print(y)
                
                
        XY.append(x)
        XY.append(y)
        return XY
        
    def diff_2ma_rsi(ma05,ma15,ma012,ma112,Prsi):
        ma = []
        X = []
        Y = []
        
        ma.append(ma05)
        ma.append(ma012)
        ma = list(itertools.chain.from_iterable(ma))
        ma_max = max(ma)
        #print(ma)
        y_value = 1
        for j in range(1,len(ma15)): #check y
            if(ma15[j]<ma15[j-1]): #0
                y_value = 0
        Y.append(y_value)
        for i in range(0,len(ma)): #ma5 ma12
            X.append(abs(ma_max-ma[i]))
        #print(X)
        Xnorm = normalization(X)
        #print(Xnorm)
        rsi = normalization(Prsi)
        #print(rsi)
        for i in range(0,len(rsi)): #ma5 ma12
            Xnorm.append(rsi[i])
        #print(Xnorm)
        return [Xnorm,Y]

    def Get_XY_rsi(df,nb0,nb1):
        XY = []
        x = []
        y = []
        for i in range(nb0,len(df)-nb1):
            
            if(df['MA5'][i]>df['MA12'][i] and df['MA5'][i-1]<df['MA12'][i-1]):
                Pma05 = []
                Pma15 = []
                Pma012 = []
                Pma112 = []
                Prsi = []
                Pma = []
                for j in range(i-nb0,i): #15 avant croix
                    Pma05.append(df['MA5'][j])
                    Pma012.append(df['MA12'][j])
                    Prsi.append(df['RSI'][j])
                for k in range(i,i+nb1): #15 apres croix
                    Pma15.append(df['MA5'][k])
                    Pma112.append(df['MA12'][k])

                xy = diff_2ma(Pma05,Pma15,Pma012,Pma112,Prsi)
                #print(xy)
                
                x.append(xy[0])
                y.append(xy[1])
               
                
        XY.append(x)
        XY.append(y)
        return XY