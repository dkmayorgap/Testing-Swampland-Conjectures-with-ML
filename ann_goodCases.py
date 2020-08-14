#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Sep 13 11:52:15 2019
In this function a neural network is created to determine if the masses of
gives usefull values of the minimums to find.
@author: ug
"""
import tensorflow as tf
import numpy as np
import pandas as pd

data_input_T = np.load('dataPython.npy')
data_input_T = data_input_T[:,[2,1,3,0,6,5,7,4,9,12]]
np.savetxt('data_T.txt',data_input_T)
data_input = np.load('train_input_rand.npy')
np.savetxt('./train_input_rand.txt',data_input)
data_output = np.load('train_output_rand.npy').reshape(22000,1)
np.savetxt('./train_output_rand.txt',data_output)
def normalize(data):
    min_d = np.min(data,axis = 0)
    max_d = np.max(data,axis = 0)
    data_N = (data - min_d)/(max_d - min_d+0.01)
    return data_N    
    
    
data_input_n = normalize(data_input)

model = tf.keras.models.Sequential([tf.keras.layers.Dense(10, input_dim=10, activation='relu'),
                                    tf.keras.layers.Dense(10,activation=tf.nn.relu),
                                    tf.keras.layers.Dense(1,activation='sigmoid')])
model.compile(optimizer='adam',
              loss='binary_crossentropy',
              metrics = ['accuracy'])
model.fit(data_input_n,data_output,epochs = 10)

random_data = normalize(np.load('input_train.npy'))
prediction = model.predict(random_data)

result = np.load('train_output.npy')
