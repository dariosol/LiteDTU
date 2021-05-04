# coding: utf-8

import sys
import os
os.chdir('./')

import matplotlib.lines as mlines
import matplotlib.pyplot as plt
import numpy as np
import sys
import re
from matplotlib import cm


#Simulation files:
#first column: time in ps
#other columns: channel output
#parse simulation used for
#   presynth_DTU_GSM_00_ing01.dat -> input data
#   presynth_DTU_GSM_00_ing10.dat -> input data
#   presynth_DTUoutput_GSM00.dat -> output of DTU fifo

#IF they are hex, converted in binary files to maintain the Simona's code.

def parseTestMode(filename,maxlines):
    data_32bit = []
    countlines = 0
    if(maxlines==-1):
        countlines = len(open(filename).readlines(  ))
    else:
        countlines=maxlines
        
    print("number of lines in file: ",countlines)
    line = []
    mask = int("F000F",16)
    pattern0=int("30009",16)
    pattern1=int("6000c",16)
    pattern2=int("c0006",16)
    pattern3=int("90003",16)
    maskAdc = int("0FFF0",16)
    maskAdc1 = int("FFF",16)
    column2=0
    Dout0_0 = []
    Dout0_1 = []
    Dout1_0 = []
    Dout1_1 = []
    Dout2_0 = []
    Dout2_1 = []
    Dout3_0 = []
    Dout3_1 = []
    
    with open(filename) as fp:
        for i in range(0,countlines):
            line.append(fp.readline())
        fp.close()
            
        for pointer in line:
            column2 = int(pointer.split(' ')[1].strip(),16)
    	    column3 = int(pointer.split(' ')[2].strip(),16)
    	    column4 = int(pointer.split(' ')[3].strip(),16)
    	    column5 = int(pointer.split(' ')[4].strip(),16)
            #############################################################################
            if (   (  column2 & ( mask << (12) )  ) == pattern0 << (12)   ): 
                adc = (  column2 & ( maskAdc<<(12) )  )
                adc = adc >> (12)
                adc = adc >> 4
                adc1 = (column2 & maskAdc1)
                
                Dout0_0.append(adc1)
                Dout0_1.append(adc)
            else:
                print "error column 2"
                
            #############################################################################
            if (   (  column3 & ( mask << (12) )  ) == pattern1 << (12)   ): 
                adc = (  column3 & ( maskAdc<<(12) )  )
                adc = adc >> (12)
                adc = adc >> 4
                adc1 = (column3 & maskAdc1)
                
                Dout1_0.append(adc1)
                Dout1_1.append(adc)
            else:
                print "error column 3"
                
                #############################################################################
            if (   (  column4 & ( mask << (12) )  ) == pattern2 << (12)   ): 
                adc = (  column4 & ( maskAdc<<(12) )  )
                adc = adc >> (12)
                adc = adc >> 4
                adc1 = (column4 & maskAdc1)
                
                Dout2_0.append(adc1)
                Dout2_1.append(adc)
            else:
                print "error column 4"
                
                    
                #############################################################################
            if (   (  column5 & ( mask << (12) )  ) == pattern3 << (12)   ): 
                adc = (  column5 & ( maskAdc<<(12) )  )
                adc = adc >> (12)
                adc = adc >> 4
                adc1 = (column5 & maskAdc1)
                
                Dout3_0.append(adc1)
                Dout3_1.append(adc)
            else:
                print "error column 5"
                
                
                                            
        print ("len 0_0: ", len(Dout0_0) )
        print ("len 0_1: ", len(Dout0_1) )
        print ("len 1_0: ", len(Dout1_0) )
        print ("len 1_1: ", len(Dout1_1) )
        
        print "filling ADCH "
        ADCH = []
        for sample in range (len(Dout0_0)):
            ADCH.append(Dout1_0[sample])
            ADCH.append(Dout0_0[sample])
            ADCH.append(Dout1_1[sample])
            ADCH.append(Dout0_1[sample])
            
        print "filling ADCL "
        ADCL = []
        for sample in range (len(Dout2_0)):
            ADCL.append(Dout3_0[sample])
            ADCL.append(Dout2_0[sample])
            ADCL.append(Dout3_1[sample])
            ADCL.append(Dout2_1[sample])
            
    return ADCH, ADCL


def parseSimulation(filename,tobin=1):
    print ("filename: ",filename, " to bin ",tobin)
    countlines = 0
    countlines = len(open(filename).readlines(  ))
    print("number of lines in file: ",countlines)
    line = []
    with open(filename) as fp:
        for i in range(0,countlines):
            line.append(fp.readline())
            
        fp.close()
        
    data_32bit = []
    timeData = []


    scale = 16 ## equals to hexadecimal
    num_of_bits = 32
    for pointer in line:
        time=pointer.split(' ')[0]
        timeData.append(float(time))
        my_data = pointer.split(' ')[1]
        if(tobin==1):
            ff = bin(int(my_data, scale))[2:].zfill(num_of_bits) #from hex to bin
            data_32bit.append(ff[0:32])
        else:
            if my_data.endswith("\n"):  data_32bit.append(my_data[:-1])
            else: data_32bit.append(my_data)
            
        

    return timeData, data_32bit



def parseSimulationAllChannels(filename,tobin=1):
    print ("filename: ",filename, " to bin ",tobin)
    countlines = 0
    countlines = len(open(filename).readlines(  ))
    print("number of lines in file: ",countlines)
    line = []
    with open(filename) as fp:
        for i in range(0,countlines):
            line.append(fp.readline())
            
        fp.close()
        
    data_32bit0 = []
    data_32bit1 = []
    data_32bit2 = []
    data_32bit3 = []
    timeData = []


    scale = 16 ## equals to hexadecimal
    num_of_bits = 32
    for pointer in line:
        time=pointer.split(' ')[0]
        timeData.append(float(time))
        my_data0 = pointer.split(' ')[1]
        my_data1 = pointer.split(' ')[2]
        my_data2 = pointer.split(' ')[3]
        my_data3 = pointer.split(' ')[4]
        if(tobin==1):
            ff0 = bin(int(my_data0, scale))[2:].zfill(num_of_bits) #from hex to bin
            data_32bit0.append(ff0[0:32])
            ff1 = bin(int(my_data1, scale))[2:].zfill(num_of_bits) #from hex to bin
            data_32bit1.append(ff1[0:32])
            ff2 = bin(int(my_data2, scale))[2:].zfill(num_of_bits) #from hex to bin
            data_32bit2.append(ff2[0:32])
            ff3 = bin(int(my_data3, scale))[2:].zfill(num_of_bits) #from hex to bin
            data_32bit3.append(ff3[0:32])
        else:
            if my_data0.endswith("\n"):
                data_32bit0.append(my_data0[:-1])
            else:
                data_32bit0.append(my_data0)

            if my_data1.endswith("\n"):
                data_32bit1.append(my_data1[:-1])
            else:
                data_32bit1.append(my_data1)

            if my_data2.endswith("\n"):
                data_32bit2.append(my_data2[:-1])
            else:
                data_32bit2.append(my_data2)

            if my_data3.endswith("\n"):
                data_32bit3.append(my_data3[:-1])
            else:
                data_32bit3.append(my_data3)

                
        

    return timeData, data_32bit0, data_32bit1, data_32bit2, data_32bit3



#######AFTER DECODING
def parseSimulationSerializers(filename,tobin=1):
    print ("filename: ",filename, " to bin ",tobin)
    countlines = 0
    countlines = len(open(filename).readlines(  ))
    print("number of lines in file: ",countlines)
    line = []
    with open(filename) as fp:
        for i in range(0,countlines):
            line.append(fp.readline())
            
        fp.close()
        
    data_32bit = []
    timeData = []
    gainData = []

    scale = 16 ## equals to hexadecimal
    num_of_bits = 32
    for pointer in line:
        time=pointer.split(' ')[0]
        gain=pointer.split(' ')[1]
        my_data = pointer.split(' ')[2]
        if(tobin==1):
            ff = bin(int(my_data, scale))[2:].zfill(num_of_bits) #from hex to bin
            data_32bit.append(ff[0:32])
        else:
            if my_data.endswith("\n"):  data_32bit.append(my_data[:-1])
            else: data_32bit.append(my_data)
        gainData.append(gain)
        timeData.append(float(time))


    return timeData, gainData, data_32bit



##########DATA ACQUIRED IN TEST BENCH
def parse(filename,tobin=1,channel=0):
    print ("filename: ",filename, " to bin ",tobin)
    countlines = 0
    countlines = len(open(filename).readlines(  ))
    print("number of lines in file: ",countlines)
    line = []
    with open(filename) as fp:
        for i in range(0,countlines):
            line.append(fp.readline())            
        fp.close()
            
    data_32bit = []
    timeData = []


    scale = 16 ## equals to hexadecimal
    num_of_bits = 32
    for pointer in line:
        my_data = re.split(' |,',pointer)[int(channel)]
        if(tobin==1):
            ff = bin(int(my_data, scale))[2:].zfill(num_of_bits) #from hex to bin
            data_32bit.append(ff[0:32])
        else:
            if my_data.endswith("\n"):  data_32bit.append(my_data[:-1])
            elif my_data.endswith("\r\n"):  data_32bit.append(my_data[:-2])
            else: data_32bit.append(my_data)
            
    return data_32bit




def decodeDTU(time,data_32bit,startentry,endentry,fallback):
    # Patterns for decoding
    sign_pattern_1  = "001010"
    sign_pattern_2  = "001011"
    bas_pattern_1   = "01"
    bas_pattern_2   = "10"
    idle_pattern    = "1110"
    trailer_pattern = "1101"
    flush_pattern   = "11111110111011011100000011011110" #"feedc0de"
    synch_pattern   = "11001010111111101100101011111110" #"cafecafe"
    idle_5A = "01011010010110100101101001011010"
    reset_pattern = "00110101010101010101010101010101"

    n_bas = 0
    n_baseline_1 = 0
    n_baseline_2 = 0
    n_sign = 0
    n_signal_1 = 0
    n_signal_2 = 0
    n_idle = 0
    n_trailers = 0
    n_synch=0
    n_flush=0


    samples = [] #lista dei samples
    trailers =[] #lista dei trailer
    word_error = []
    conta_samples_trailer = 0
    T_Nsamples = []
    T_CRC12 = []
    T_Ntrailer = []
    Nsamples = []
    BC0 = []
    BC0time = []
    Flushtime = []
    Reset = []
    overall_samples=2 # shift of 2 samples because of 1 clock anticipation in FB
    parity=[]
    end=-1
    crc = '000000000000'
    
    if(endentry ==-1):
        end =  len(data_32bit)
    else:
        end = endentry

    for j in range(startentry,end):
        ###########################################
        ###############FALLBACK####################
        if (fallback==1):
            if (data_32bit[j][0:4] == idle_pattern):
               n_idle += 1            
            else:
                if(data_32bit[j][2:4]=="00"):
                    BC0.append((overall_samples+1)*2)
                    BC0time.append(time[j])
                elif (data_32bit[j][2:4]=="01"):
                    BC0.append(overall_samples*2)
                    BC0time.append(time[j]+25000)#fallback is 25 ns before: add 25 ns
                overall_samples = overall_samples + 2
                parity.append(data_32bit[j][4:6])
                samples.append(data_32bit[j][19:])
                samples.append(data_32bit[j][6:19])

        ###########################################
        ###############STANDARD####################
        else:
            if (data_32bit[j][0:2] == bas_pattern_1):
                n_baseline_1 += 1
                n_bas += 5
                overall_samples +=5
                conta_samples_trailer += 5
                samples.append(data_32bit[j][26:])
                samples.append(data_32bit[j][20:26])
                samples.append(data_32bit[j][14:20])
                samples.append(data_32bit[j][8:14])
                samples.append(data_32bit[j][2:8])
                crc=CRC_function(data_32bit[j],crc)
                
            elif (data_32bit[j][0:2] == bas_pattern_2):
                crc=CRC_function(data_32bit[j],crc)
                val = int(data_32bit[j][2:8],2)
                n_baseline_2 += 1 
                overall_samples+=val
                n_bas += val
                conta_samples_trailer += val
                if (val == 1):
                    samples.append(data_32bit[j][26:])
                elif (val == 2):
                    samples.append(data_32bit[j][26:])
                    samples.append(data_32bit[j][20:26])
                elif (val == 3):
                    samples.append(data_32bit[j][26:])
                    samples.append(data_32bit[j][20:26])
                    samples.append(data_32bit[j][14:20])
                elif (val == 4):
                    samples.append(data_32bit[j][26:])
                    samples.append(data_32bit[j][20:26])
                    samples.append(data_32bit[j][14:20])
                    samples.append(data_32bit[j][8:14])
                else:
                    print("\terrore su Val!")
            elif (data_32bit[j][0:6] == sign_pattern_1):
                crc=CRC_function(data_32bit[j],crc)
                n_signal_1 += 1
                n_sign += 2 
                conta_samples_trailer += 2
                overall_samples+=2
                samples.append(data_32bit[j][19:])
                samples.append(data_32bit[j][6:19])

            elif (data_32bit[j] == flush_pattern):
                print ("flush!")
                n_flush +=1
                Flushtime.append(time[j])
            elif (data_32bit[j] == synch_pattern):
                n_synch +=1

            elif (data_32bit[j] == reset_pattern):
                print ("reset!")
                conta_samples_trailer=0
                Reset.append(overall_samples)

            elif (data_32bit[j][0:6] == sign_pattern_2):
                crc=CRC_function(data_32bit[j],crc)
                if(data_32bit[j][0:7]=="0010110"):
                    n_signal_2 += 1
                    n_sign += 1
                    conta_samples_trailer += 1
                    overall_samples+=1
                    samples.append(data_32bit[j][19:])
                elif (data_32bit[j][0:7] == "0010111"):
                    print("Header")
                    n_bas+=1  
                    BC0.append(overall_samples)                     
                    BC0time.append(time[j])
                    overall_samples+=1
                    conta_samples_trailer += 1  
                    samples.append(data_32bit[j][19:])
                else:
                    print("header/signal1 data format error!:" + (data_32bit[j]))
            elif (data_32bit[j][0:4] == trailer_pattern):
                n_trailers += 1
                trailers.append(data_32bit[j])
                Nsamples.append(conta_samples_trailer)
                T_CRC12.append(data_32bit[j][12:24])

                print ("CRC: ", data_32bit[j][12:24], " calculated: ",crc)
                crc = '000000000000'
                
                if(int(data_32bit[j][4:12],2)!=conta_samples_trailer):#[24:],2)!=conta_samples_trailer):
                    print("SAMPLING ERROR FOUND IN TRAILER:")
                    print("word: ",data_32bit[j])
                    print("Total number of trailers: ",n_trailers)
                    print("In the trailer number ", int(data_32bit[j][24:],2), " i found:" , data_32bit[j][4:12], int(data_32bit[j][4:12],2))
                    print("while the offline counting says: ",conta_samples_trailer)
                    print("loop index: ",j)
                    print("\nRicorda che se questo errore è correlato al primo trailer memorizzato nel file è ok, ovvero è molto probabile che il conteggio sia errato, in quanto l'inizio del salvataggio dei samples su file avviene in un  momento \"random\"")
                    conta_samples_trailer = 0
                else:
                    #print("Trailer ",data_32bit[j][0:4]," ",data_32bit[j][4:12]," ",data_32bit[j][12:20]," ",data_32bit[j][20:32)
                    conta_samples_trailer = 0
            elif (data_32bit[j][0:4] == idle_pattern):
                n_idle += 1
            else:
                print( "\tError!! ", data_32bit[j])
                word_error.append(data_32bit[j])




    print("Report:")
    print("Number of samples encoded in 6-bit: ", n_bas)
    print("Number of 32-bit words which contain 5x 6-bit samples (BASELINE word complete): ", n_baseline_1)
    print("Number of 32-bit words which contain between 4 and 1 6-bit samples (BASELINE word incomplete): ", n_baseline_2)
    print("Number of samples encoded in 13-bit: ", n_sign)
    print("Number of 32-bit words which contain 2x 13-bit samples (SIGNAL word complete): ", n_signal_1)
    print("Number of 32-bit words which contain one 13-bit sample (SIGNAL word incomplete): ", n_signal_2)
    print("Number of IDLE words: ", n_idle)
    print("Number of trailers: ", n_trailers)
    print("Number of headers: ", len(BC0))
    print("Number of Resets: ", len(Reset))
    print("Number of Synchs: ", n_synch)
    print("Number of Flushs: ", n_flush)
    print("Number of unknown/wrong words: ", len(word_error))
    print("Flushtime: ", Flushtime)
    print ("BC0s:", BC0)
    print ("BC0time:", BC0time)
    print("Resets: ",Reset)
    return Nsamples, samples,trailers,BC0,BC0time,word_error,T_CRC12,parity 




def FindMaxima(numbers,baseline):
    maxima = []
    length = len(numbers)
    if length >= 2:
        if numbers[0] > numbers[1]:
            if  numbers[0] > baseline * 5:
                maxima.append(0)
            
        if length > 3:
            for i in range(1, length-1):     
                if numbers[i] > numbers[i-1] and numbers[i] > numbers[i+1]:
                    if  numbers[i] > baseline * 5:
                        maxima.append(i)

        if numbers[length-1] > numbers[length-2]:    
            if  numbers[length-1] > baseline * 5:
                maxima.append(length-1)        

    return maxima



def SortSamples(samples):
    count_gain1=0
    count_gain10=0
    int_samples = []
    time_stamp = []
    time_stamp_FB = []

    stamp = []
    stamp_FB = []
    int_samples_idle =[]
    int_samples_bas = []
    int_samples_sign_g10=[]
    int_samples_sign_g1=[]
    stamp_bas = []
    stamp_g10 = []
    stamp_g1 = []
    stamp_g10_FB = []
    stamp_g1_FB = []
    change = False
    windowsize=[]
    print ("len samples: ",len(samples))
    for i in range (0,len(samples)):
        time_stamp.append(i*6.25)
        time_stamp_FB.append(i*6.25*2+6.25)
        stamp.append(i)
        stamp_FB.append(i*2+1)        
        if (len(samples[i])==6):
            int_samples.append(int(samples[i],2))
            int_samples_bas.append(int(samples[i],2))
            stamp_bas.append(i)
            if (change==True):
                windowsize.append(count_gain1)
                count_gain1=0
                change=False
        else:
            if (samples[i][0]=='0'):
                count_gain10 += 1
                int_samples_sign_g10.append(int(samples[i][1:],2))
                stamp_g10.append(i)
                stamp_g10_FB.append(i*2)
            else:
                count_gain1 += 1
                int_samples_sign_g1.append(int(samples[i][1:],2))
                stamp_g1.append(i)
                stamp_g1_FB.append(i*2)
                if (change==False):
                    change=True
            int_samples.append(int(samples[i][1:],2))
                    
    print ("gain1 signal1 numbers: ", windowsize)

    return stamp, stamp_FB, int_samples, stamp_bas, int_samples_bas,stamp_g10, int_samples_sign_g10,stamp_g1, int_samples_sign_g1





def CRC_function(i, crc):
    newcrc = ""
    c_0 = i[1] + i[2] + i[5] + i[6] + i[7] + i[8] + i[9] + i[14] + i[15] + i[16] + i[17] + i[18] + i[19] + i[20] + i[23] + i[24] + i[25] + i[26] + i[27] + i[28] + i[29] + i[30] + i[31] + crc[9] + crc[8] + crc[7] + crc[6] + crc[5] + crc[2] + crc[1];
    step_0 = c_0.count("1")
    c_1 = i[0] + i[2] + i[4] + i[9] + i[13] + i[20] + i[22] + i[31] + crc[9] + crc[4] + crc[2] + crc[0];
    step_1 = c_1.count("1")
    c_2 = i[2] + i[3] + i[5] + i[6] + i[7] + i[9] + i[12] + i[14] + i[15] + i[16] + i[17] + i[18] + i[20] + i[21] + i[23] + i[24] + i[25] + i[26] + i[27] + i[28] + i[29] + i[31] + crc[9] + crc[7] + crc[6] + crc[5] + crc[3] + crc[2];
    step_2 = c_2.count("1")
    c_3 = i[4] + i[7] + i[9] + i[11] + i[13] + i[18] + i[22] + i[29] + i[31] + crc[11] + crc[9] + crc[7] + crc[4];
    step_3 = c_3.count("1")
    c_4 = i[3] + i[6] + i[8] + i[10] + i[12] + i[17] + i[21] + i[28] + i[30] + crc[10] + crc[8] + crc[6] + crc[3];
    step_4 = c_4.count("1")
    c_5 = i[2] + i[5] + i[7] + i[9] + i[11] + i[16] + i[20] + i[27] + i[29] + crc[11] + crc[9] + crc[7] + crc[5] + crc[2];
    step_5 = c_5.count("1")
    c_6 = i[1] + i[4] + i[6] + i[8] + i[10] + i[15] + i[19] + i[26] + i[28] + crc[10] + crc[8] + crc[6] + crc[4] + crc[1];
    step_6 = c_6.count("1")
    c_7 = i[0] + i[3] + i[5] + i[7] + i[9] + i[14] + i[18] + i[25] + i[27] + crc[9] + crc[7] + crc[5] + crc[3] + crc[0];
    step_7 = c_7.count("1")
    c_8 = i[2] + i[4] + i[6] + i[8] + i[13] + i[17] + i[24] + i[26] + crc[8] + crc[6] + crc[4] + crc[2];
    step_8 = c_8.count("1")
    c_9 = i[1] + i[3] + i[5] + i[7] + i[12] + i[16] + i[23] + i[25] + crc[7] + crc[5] + crc[3] + crc[1];
    step_9 = c_9.count("1")
    c_10 = i[0] + i[2] + i[4] + i[6] + i[11] + i[15] + i[22] + i[24] + crc[11] + crc[6] + crc[4] + crc[2] + crc[0];
    step_10 = c_10.count("1")
    c_11 = i[2] + i[3] + i[6] + i[7] + i[8] + i[9] + i[10] + i[15] + i[16] + i[17] + i[18] + i[19] + i[20] + i[21] + i[24] + i[25] + i[26] + i[27] + i[28] + i[29] + i[30] + i[31] + crc[10] + crc[9] + crc[8] + crc[7] + crc[6] + crc[3] + crc[2];
    step_11 = c_11.count("1")
    if (step_0 %2 == 0):
        newcrc = "0"
    else:
        newcrc = "1"
    if (step_1 %2 == 0):
        newcrc = "0" + newcrc
    else:
        newcrc = "1" + newcrc
    if (step_2 % 2 == 0):
        newcrc = "0" + newcrc
    else:
        newcrc = "1" + newcrc
    
    if (step_3 % 2 == 0):
        newcrc = "0" + newcrc
    else:
        newcrc = "1" + newcrc
    if (step_4 % 2 == 0):
        newcrc = "0" + newcrc
    else:
        newcrc = "1" + newcrc
    if (step_5 % 2 == 0):
        newcrc = "0" + newcrc
    else:
        newcrc = "1" + newcrc
    
    if (step_6 % 2 == 0):
        newcrc = "0" + newcrc
    else:
        newcrc = "1" + newcrc
    if (step_7 % 2 == 0):
        newcrc = "0" + newcrc
    else:
        newcrc = "1" + newcrc
    if (step_8 % 2 == 0):
        newcrc = "0" + newcrc
    else:
        newcrc = "1" + newcrc
    
    if (step_9 % 2 == 0):
        newcrc = "0" + newcrc
    else:
        newcrc = "1" + newcrc
    if (step_10 % 2 == 0):
        newcrc = "0" + newcrc
    else:
        newcrc = "1" + newcrc
    if (step_11 % 2 == 0):
        newcrc = "0" + newcrc
    else:
        newcrc = "1" + newcrc
    
        #print" --- %s" %newcrc
    return newcrc
                                    
