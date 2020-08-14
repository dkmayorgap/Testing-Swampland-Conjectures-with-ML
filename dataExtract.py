#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Sep 10 16:13:26 2019
In this file the information of the string theory is obtained from the file 
that wights 230MB
@author: ug
"""

import numpy as np
import scipy.io as io

def deleteChar(data,character=False):
    data = data.replace('f0 -> ','')
    data = data.replace('f1 -> ','')
    data = data.replace('F0 -> ','')
    data = data.replace('F1 -> ','')
    data = data.replace('h0 -> ','')
    data = data.replace('h1 -> ','')
    data = data.replace('H0 -> ','')
    data = data.replace('H1 -> ','')
    data = data.replace('b0 -> ','')
    data = data.replace('b1 -> ','')
    data = data.replace('b3 -> ','')
    data = data.replace('B0 -> ','')
    data = data.replace('B1 -> ','')
    data = data.replace('B3 -> ','')
    data = data.replace('{','')
    data = data.replace('}','')
    data = data.replace("\\",'')
    data = data.replace("twoclas = ",'')
    data = data.replace('solf = ','')
    data = data.replace('trainingoutupdata = ','')
    data = data.replace('traininginputdata =','')
    data = data.replace('inputlambdaIms =','')
    data = data.replace('ouputlambdaIms =','')
    data = data.replace('faux =','')
    data = data.replace('testsol = ','')
    data = data.replace('lista = ','')
    data = data.replace('taur ->','')
    data = data.replace('taui ->','')
    data = data.replace('Ur ->','')
    data = data.replace('Ui ->','')
    data = data.replace('Si ->','')
    data = data.replace('Sr ->','')
    data = data.replace('`10.','')
    data = data.replace('*^','e')
    data = data.replace('\n', '')
    data = data.replace('`50.','')
#    data = data.replace(' ','')
    data = data.replace('vevNR=','')
    data = data.replace('/','./')
    data = data.replace('inter =','')
    if character != False:
        data = data.replace(character,'')
    return data

def convert_array(data,division):
    """
    Taking a string from mathematica, after deletChar modification and convert
    it to array.
    
    Args:
        data(str): string separated by comas
        division, number of cols of the output array
        
    Return:
        data(attay)
    """
    data = np.fromstring(data,dtype = np.float64,sep = ',')
    data = data.reshape((int(len(data)/division),division))
    return data

def convert(data,character,division,name_save_file,name_var):
    data = deleteChar(data,character)
    data = convert_array(data,division)   
    io.savemat(name_save_file,mdict = {name_var:data}) 
    return data


#muok_i = open('../trainingin-t').read()
#muok_i = deleteChar(muok_i,'ent = ')
#muok_i = convert_array(muok_i,10)   
#io.savemat('./Data/muok_i.mat',mdict = {'muok_i':muok_i})  

jerarquiamumsok1 = open('../jerarquiaMUMSOK1.txt').read()
#order Given :b0-0, b1-1, b3-2, B1-3, B3-4, h0-5, H0-6, B0-7, h1-8, H1-9, f0-10, F0-11, f1-12, F1-13
#order Net   :F0-11, f1-12, F1-13, f0-10, H0-6, h1-8, H1-9, h0-5, b1-1, B1-3
order = [11,12,13,10,6,8,9,5,1,3]
data = convert(jerarquiamumsok1,'sal = ',14,'./Data/jerarquiaMUMSOK1.mat','jerarquiaMUMSOK1')
data = data[:,order]
io.savemat('./Data/jerarquiaMUMSOK1.mat',mdict = {'jerarquiaMUMSOK1':data})
#sort_d = [2,1,3,0,6,5,7,4,9,12] 
#flujos_random = open('../NP_flujos_random').read()
#flujos_random = deleteChar(flujos_random)
#flujos_random = convert_array(flujos_random,14)
#flujos_random = flujos_random[:,sort_d]
#
#lista_random = open('../NP_lista_random.txt').read()
#lista_random = deleteChar(lista_random)
#lista_random = np.fromstring(lista_random,dtype = int,sep = ',')
#
#for i in range(1,19):
#    data = open('../trainingoutupdata-random-'+str(i)).read()
#    data = deleteChar(data)
#    data = convert_array(data,10)
#    if i == 1:
#        flujos_good = data
#    else:
#        flujos_good = np.concatenate((flujos_good,data))
#        
#
#position = np.zeros((len(flujos_good),)).astype(int)
#for num2,i in enumerate(flujos_good):
#    print(num2)
#    for num,j in enumerate(flujos_random):
#        if np.all(i ==j):
#            position[num2] = num        
#        
#position = position.astype(int)
#train_input_rand = flujos_random[:38000,:]
#train_output_rand = np.zeros((38000,))
#train_output_rand[position,] = 1
#np.save('train_input_rand_2.npy',train_input_rand)
#np.save('train_output_rand_2.npy',train_output_rand)
#
#np.savetxt('./train_input_rand_2.txt',train_input_rand)
#np.savetxt('./train_output_rand_2.txt',train_output_rand)
##data1 = open("Fluxes1.txt").read()
##data1 = deleteChar(data1)
##
##data = np.fromstring(data1,dtype = int,sep = ',')
##data = data.reshape((1830742,14))
##sort_d = [2,1,3,0,6,5,7,4,9,12]
##data_G = data[:,sort_d]
##np.save('dataPython',data)
##
##
##inputData = open('trainingoutupdata-jer4-1').read()
##inputData = deleteChar(inputData) 
##inputData = np.fromstring(inputData,dtype=int,sep=',')
##inputData = inputData.reshape((int(len(inputData)/10),10))
##np.save('inputData',inputData)
##
##position = np.zeros((91,))
##for num2,i in enumerate(inputData):
##    print(num2)
##    for num,j in enumerate(data_G):
##        if np.all(i ==j):
##            position[num2] = num
##            
##
##position_N = position[position>0]
##position_N = position_N.astype(int)
##train_output = np.zeros((10000,))
##train_output[position_N,] = 1
##train_input = data_G[:10000,:]
##
##np.save('input_train.npy',train_input)
##np.save('train_output.npy',train_output)
#
#data_input_T = open('../NP_flujos_buenos-todos').read()
#data_input_T = deleteChar(data_input_T)
#data_input_T = convert_array(data_input_T,14)
#data_input_T = data_input_T[:,sort_d]
#
#
#data_input_G = open('../trainingoutupdata-buenos').read()
#data_input_G = deleteChar(data_input_G)
#data_input_G = convert_array(data_input_G,10)
#
#
#position = np.zeros((len(data_input_G),)).astype(int)
#for num2,i in enumerate(data_input_G):
#    print(num2)
#    for num,j in enumerate(data_input_T):
#        if np.all(i ==j):
#            position[num2] = num
#            
#            
#data_output_T = np.zeros((len(data_input_T),1))
#data_output_T[position,] = 1
#
#np.savetxt('./Data/Data_Good_in_T.txt',data_input_T)
#np.savetxt('./Data/Data_Good_out_T.txt',data_output_T)
#np.savetxt('./Data/good_cases_T.txt',data_input_G)
#
#
#mumsok = open('../jerarquiaMUMSOK1.txt').read()
#mumsok = deleteChar(mumsok)
#mumsok = convert_array(mumsok,14)
#mumsok = mumsok[:,sort_d]
#np.savetxt('mumsok_cases.txt',mumsok)
#
#mumsok = open('../jerarquiaMUMSOK1.txt').read()
