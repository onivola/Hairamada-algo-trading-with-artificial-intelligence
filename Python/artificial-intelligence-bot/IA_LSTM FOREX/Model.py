import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'
from tensorflow import keras 
import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Dropout, Activation, Flatten
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
    def PlotFitModel(self,history):
        #seed(12) #to get the same result
        training_loss = history.history['loss']
        test_loss = history.history['val_loss']

        # Create count of the number of epochs
        epoch_count = range(1, len(training_loss) + 1)

        # Visualize loss history
        plt.plot(epoch_count, training_loss, 'y--')
        plt.plot(epoch_count, test_loss, 'r-')
        plt.legend(['Training Loss', 'Validation Loss'])
        plt.xlabel('Epoch')
        plt.ylabel('Loss')
        plt.show();
        plt.savefig('books_read.png')
        training_loss2 = history.history['accuracy']
        test_loss2 = history.history['val_accuracy']

        # Create count of the number of epochs
        epoch_count2 = range(1, len(training_loss2) + 1)

        # Visualize loss history
        plt.plot(epoch_count2, training_loss2, 'y--')
        plt.plot(epoch_count2, test_loss2, 'r-')
        plt.legend(['Training Acc', 'Validation Acc'])
        plt.xlabel('Epoch')
        plt.ylabel('Acc')
        plt.show();
    def fitModel(self,epoch,X,Y,input_dim,lr):
        tf.random.set_seed(12) #to get the same result
        modelMc = Sequential()
        #modelMc.add(Dense(units=30*4,input_dim=input_dim,activation="relu")) #relu is the best activation function
        #modelMc.add(Dropout(0.1))
        #modelMc.add(Dense(units=30*12,input_dim=input_dim,activation="relu"))
        #modelMc.add(Dense(units=30,input_dim=input_dim,activation="relu"))
        kernel_regularizer=keras.regularizers.l2(0.1)
        modelMc.add(Dense(units=160,input_dim=input_dim,activation="relu"))
        modelMc.add(Dense(units=320,activation="relu"))
        modelMc.add(Dense(units=2,activation="relu"))
        modelMc.add(Dense(1))
        modelMc.add(Activation('sigmoid'))
        #kernel_regularizer=keras.regularizers.l2(0.1)
        #opt = keras.optimizers.Adam(learning_rate=0.0001)
        opt = keras.optimizers.Adam(learning_rate=lr)
        modelMc.compile(loss="mean_squared_error",optimizer=opt,metrics=["accuracy"]) #adam is the best
        
        X=np.array(X)
        Y=np.array(Y)
        #compilation - algorithme d'apprentissage
        #earlystopping = callbacks.EarlyStopping(monitor ="val_loss",mode ="min", patience = 5,restore_best_weights = True)
        #apprentissage
        x_train,x_test,y_train,y_test = train_test_split(X,Y,test_size=0.25,random_state=10) #train and test data
        #compilation - algorithme d'apprentissage
        #earlystopping = callbacks.EarlyStopping(monitor ="val_loss",mode ="min", patience = 5,restore_best_weights = True)
        #apprentissage
        history = modelMc.fit(x_train,y_train,verbose=1,epochs=epoch,batch_size=64,validation_data=(x_test,y_test))
        self.PlotFitModel(history)
        acc = modelMc.evaluate(x_test,y_test)
        print(acc)
        
        #y_pred = modelMc.predict(x_test)
        #y_pred = (y_pred>0.5)
        #cm = confusion_matrix(y_test,y_pred)
        #sns.heatmap(cm,annot=True)
        
        #cm = confusion_matrix(y_test,)
        #history = modelMc.fit(X,Y,epochs=epoch,batch_size=10,callbacks=[tensorboard])
        #PlotFitModel(history)mean_squared_error
        #poids synaptiques
        #print(modelMc.get_weights())
        modelMc.save('VOLATILITY16662.model')
        model = tf.keras.models.load_model("VOLATILITY16662.model")
        return model
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