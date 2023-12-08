import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'
from tensorflow import keras 
import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Activation
from tensorflow.keras.callbacks import EarlyStopping
from keras.layers import Dropout
from keras.layers import LSTM
import numpy as np
from sklearn.model_selection import train_test_split
from matplotlib import pyplot as plt
class Model:
    def __init__(mysillyobject, name): #other operations that are necessary to do when the object is being created
        mysillyobject.name = name
        
    def LoadModel(self,label):
        model = tf.keras.models.load_model(label)
        print(model)
        return model

    def fitModel(self,name,epoch,x_train,y_train,x_test,y_test,lr):

        # Build the neural network
        model = Sequential()
        model.add(Dense(25, input_dim=x_train.shape[1], activation='relu')) # Hidden 1
        model.add(Dense(10, activation='relu')) # Hidden 2
        model.add(Dense(1, activation='sigmoid')) # Output
        opt = keras.optimizers.Adam(learning_rate=lr)
        model.compile(loss='mean_squared_error', optimizer=opt)
        monitor = EarlyStopping(monitor='val_loss', min_delta=1e-3, 
                        patience=5, verbose=1, mode='auto', 
                        restore_best_weights=True)
        model.fit(x_train,y_train,validation_data=(x_test,y_test),verbose=2,epochs=epoch)
          
          
        model.save(name)
        model = tf.keras.models.load_model(name)
        return model
    def fit_LSTM(self,X_train,y_train,epochs):
        regressor = Sequential()

        regressor.add(LSTM(units = 50, return_sequences = True, input_shape = (X_train.shape[1], 1)))
        regressor.add(Dropout(0.2))

        regressor.add(LSTM(units = 50, return_sequences = True))
        regressor.add(Dropout(0.2))

        regressor.add(LSTM(units = 50, return_sequences = True))
        regressor.add(Dropout(0.2))

        regressor.add(LSTM(units = 50))
        regressor.add(Dropout(0.2))

        regressor.add(Dense(units = 1))

        regressor.compile(optimizer = 'adam', loss = 'mean_squared_error')

        regressor.fit(X_train, y_train, epochs = epochs, batch_size = 32)
        regressor.save('LSTM40.model')
        regressor.save('LSTM40.h5')
        return regressor
        
    # Regression chart.
    def chart_regression(self,pred, y, sort=True):
        t = pd.DataFrame({'pred': pred, 'y': y.flatten()})
        if sort:
            t.sort_values(by=['y'], inplace=True)
        plt.plot(t['y'].tolist(), label='expected')
        plt.plot(t['pred'].tolist(), label='prediction')
        plt.ylabel('output')
        plt.legend()
        plt.show()

    def test_validation(self,model,X,Y,nb_x):
        gainb = 0
        perteb = 0
        gains = 0
        pertes = 0
        Xt = X
        Yt = Y
        for i in range(0,nb_x):
            xp = []
            xp.append(Xt[i])
            res = model.predict(xp)
            res = round(float(res[0]),4)
            print(res)
            print(Yt[i][0])
            yt = float(Yt[i][0])
            if(yt==1 and res>0.5):
                gainb = gainb+1
            elif(yt==0 and res<0.5):
                gains = gains+1
            elif(yt==0 and res>0.5):
                perteb = perteb+1
            elif(yt==1 and res<0.5):
                pertes = pertes+1
                
            #print(res)
        print("PERTE BUY="+str(perteb))
        print("GAIN BUY="+str(gainb))
        print("PERTE SELL="+str(pertes))
        print("GAIN SELL="+str(gains))
        print("PROFIT="+str((gains+gainb)-(perteb+pertes)))