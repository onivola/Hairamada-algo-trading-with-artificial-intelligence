
import pandas as pd
import chardet
import itertools

from sklearn.preprocessing import MinMaxScaler
sc = MinMaxScaler(feature_range = (0, 1))
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
                for j in range(i-nb0,i): #15 avant croix
                    Pma05.append(df['MA5'][j])
                    Pma012.append(df['MA12'][j])
                for k in range(i,i+nb1): #15 apres croix
                    Pma15.append(df['MA5'][k])
                    Pma112.append(df['MA12'][k])

                xy = self.diff_2ma(Pma05,Pma15,Pma012,Pma112)
                old_min = min(xy[0])
                old_range = max(xy[0])
                new_min = 0
                new_range = 1
                xnorm = [float((n - old_min) / old_range * new_range + new_min) for n in xy[0]]
                x.append(xnorm)
                y.append(xy[1])
                #break
                
        XY.append(x)
        XY.append(y)
        return XY
        
        
    def diff_2ma_rsi(self,ma05,ma15,ma012,ma112):
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
    def normalization(self,Prsi):
        old_min = min(Prsi)
        old_range = max(Prsi)
        new_min = 0
        new_range = 1
        xnorm = [float((n - old_min) / old_range * new_range + new_min) for n in Prsi]
        return xnorm
    def fitTransform(self,dataset_train):
        sc = MinMaxScaler(feature_range = (0, 1))
        training_set_scaled = sc.fit_transform(dataset_train) #training_set data
        return training_set_scaled

    def Get_XY_rsi_macd(self,MA1,MA5,MA12,RSI,MACD,nb0,nb1):
        XY = []
        X = []
        Y = []
        for i in range(nb0,len(MA1)-nb1):
            #print(i)
            #print(MA5[0])
            if(MA5[i][0]>=MA12[i][0] and MA5[i-1][0]<=MA12[i-1][0]):
                Pma05 = []
                Pma15 = []
                Pma012 = []
                Pma112 = []
                Pma = []
                Pma01 = []
                Pma11 = []
                Pmarsi = []
                Pmamacd = []
                x =  []
                y = []
                for j in range(i-nb0,i): #15 avant croix
                    x.append(MA5[j][0])
                for j in range(i-nb0,i): #15 avant croix
                    x.append(MA12[j][0])
                for j in range(i-nb0,i): #15 avant croix
                    x.append(MA1[j][0])
                for j in range(i-nb0,i): #15 avant croix
                    x.append((RSI[j][0]))
                for j in range(i-nb0,i): #15 avant croix
                    x.append((MACD[j][0]))
                y.append(MA1[i+nb1][0]) #y
                X.append(x)
                Y.append(y)
                
                

        return [X,Y]
    def Get_XY_rsi(self,df,nb0,nb1):
        XY = []
        x = []
        y = []
        for i in range(nb0,len(df)-nb1):
            
            if(df['MA5'][i]>=df['MA12'][i] and df['MA5'][i-1]<=df['MA12'][i-1]):
                Pma05 = []
                Pma15 = []
                Pma012 = []
                Pma112 = []
                Pma = []
                Pmarsi = []
                for j in range(i-nb0,i): #15 avant croix
                    Pma05.append(df['MA5'][j])
                    Pma012.append(df['MA12'][j])
                    Pmarsi.append((df['RSI'][j]))
                for k in range(i,i+nb1): #15 apres croix
                    Pma15.append(df['MA5'][k])
                    Pma112.append(df['MA12'][k])

                xy = self.diff_2ma_rsi(Pma05,Pma15,Pma012,Pma112)
                xnorm = self.normalization( xy[0])
                rsi = self.normalization(Pmarsi)
                for l in range(0,len(rsi)):
                    xnorm.append(rsi[l])
                x.append(xnorm)
                y.append(xy[1])
                #break
                
        XY.append(x)
        XY.append(y)
        return XY