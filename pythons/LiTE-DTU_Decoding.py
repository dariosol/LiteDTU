# coding: utf-8

# In[493]:


import os
os.chdir('./')

import matplotlib.lines as mlines
import matplotlib.pyplot as plt
import numpy as np
import sys
import argparse
from matplotlib import cm
from functions import *

parser=argparse.ArgumentParser(
    description='''Script to decode data from Lite DTU. ''',
    epilog="""All is well that ends well.""")
parser.add_argument('filename', type=str, default="", help=' data to be converted')
parser.add_argument('isdata', type=int, default=1, help=' data or simulation from verilog')
parser.add_argument('tobin', type=int, default=0, help='if data are in hex they must be converted in bin')
parser.add_argument('channel', type=int, default=0, help='channel to be converted')
parser.add_argument('fallback', type=int, default=0, help='running at 80MHz')

args=parser.parse_args()

plt.ion
    
file = args.filename
isdata = args.isdata
channel = args.channel
tobin = args.tobin
fallback=args.fallback
# Lettura dei file acquisiti in DTU mode:
# 
# 4 colonne: dout_0 (samples in output dalla DTU)
# 
# mentre su dout_1, dout_2 e dout_3 ci sono soltanto parole da 32-bit di allineamento: 5A5A5A5A -> 01011010010110100101101001011010


filename = file
print ("Starting conversion of file ", filename, ". Is it data? ", isdata, ". Must be converted in bin? ", tobin)
data_32bit = []
time = []
if(isdata==0):
    time,data_32bit = parseSimulation(filename,tobin)
else:
    data_32bit = parse(filename,tobin,channel)

# Bit per il riconoscimento delle differenti parole
idle_pattern    = "1110"
reset_pattern= "00110101010101010101010101010101"
idle_5A = "01011010010110100101101001011010"



Nsamples = []
Nsamples,samples,trailers,BC0,BC0time,errors,CRC12,parity = decodeDTU(time,data_32bit,0,-1,fallback)


# Plot della distribuzione del numero di samples contenuti in un frame (concluso da un trailer)

# In[500]:

if (fallback==0):
    binn = []
    for i in range(0,260):
        binn.append(i+0.5)

    fig=plt.figure(1,figsize=(12,8))

    axh = fig.add_subplot(111)
    axh = plt.hist(Nsamples,  bins=binn, facecolor='g', align = 'mid')
    print(len(Nsamples))


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
for i in range (0,len(samples)):
    time_stamp.append(i*6.25)
    time_stamp_FB.append(i*6.25*2)
    stamp.append(i)
    stamp_FB.append(i*2)
    if (len(samples[i])==6):
        int_samples.append(int(samples[i],2))
        int_samples_bas.append(int(samples[i],2))
        stamp_bas.append(i)
    else:
        if (samples[i][0]=='0'):
            count_gain10 += 1
            int_samples_sign_g10.append(int(samples[i][1:],2))
            stamp_g10.append(i)
            stamp_g10_FB.append(i*2)
            if (change==True):
                windowsize.append(count_gain1)
                count_gain1=0
                change=False
        else:
            count_gain1 += 1
            int_samples_sign_g1.append(int(samples[i][1:],2))
            stamp_g1.append(i)
            stamp_g1_FB.append(i*2)
            if (change==False):
                change=True
        int_samples.append(int(samples[i][1:],2))


# Plot dei samples in output suddivisi in samples di baseline, samples di segnale di guadagno 10 e samples di segnale di guadagno 1
print ("gain1 window size: ", windowsize)

fig=plt.figure(1,figsize=(16,10))

ax = fig.add_subplot(111)
if(fallback==0):
    ax.plot(stamp,int_samples, color = 'grey', linestyle = ':')
    ax.plot(stamp_bas, int_samples_bas, 'o', color = 'deepskyblue',markersize=20,label='Baseline gain x10')
    ax.plot(stamp_g10, int_samples_sign_g10, 'o', color = 'blue',markersize=20,label='Signal gain x10')
    ax.plot(stamp_g1, int_samples_sign_g1, '*', color = 'coral',markersize=20,label='Signal gain x1')
    ymax = max(int_samples)
    print("sample length: ", len(int_samples))
    xpos = int_samples.index(ymax)
    xmax = stamp[xpos]
    print ("xmax absolute: ",xmax)
    print("ymax: ",ymax)
    #ax.axis([xmax-20,xmax+20, 0, ymax+ymax*0.15])
    ax.axis([0,len(int_samples), 0,  ymax+ymax*0.15])
    ax.axhline(y=63, xmin=0, xmax=10000, linewidth=1, color = 'firebrick')
    ax.axhline(y=4095, xmin=0, xmax=10000, linewidth=1, color = "red")
    ax.legend(loc=5,fontsize = 16)
    plt.xticks(fontsize = 16)
    plt.yticks(fontsize = 16)
    plt.ylabel("ADC counts",fontsize = 20)
    plt.xlabel("samples",fontsize = 20)
    if(len(BC0)!=0): ax.axvline(x=BC0[0],ymin=0, ymax=4000, linewidth=1, color = "green")
    plt.show()
else:
    ax.plot(stamp_FB,int_samples, color = 'grey', linestyle = ':')
    ax.plot(stamp_g10_FB, int_samples_sign_g10, 'o', color = 'blue',markersize=20,label='Signal gain x10')
    ax.plot(stamp_g1_FB, int_samples_sign_g1, '*', color = 'coral',markersize=20,label='Signal gain x1')
    ymax = max(int_samples)
    print("sample length: ", len(int_samples))
    xpos = int_samples.index(ymax)
    xmax = stamp[xpos]
    print ("xmax absolute: ",xmax)
    print("ymax: ",ymax)
    #ax.axis([xmax-20,xmax+20, 0, ymax+ymax*0.15])
    ax.axis([0,len(int_samples), 0,  ymax+ymax*0.15])
    ax.axhline(y=63, xmin=0, xmax=10000, linewidth=1, color = 'firebrick')
    ax.axhline(y=4095, xmin=0, xmax=10000, linewidth=1, color = "red")
    ax.legend(loc=5,fontsize = 16)
    plt.xticks(fontsize = 16)
    plt.yticks(fontsize = 16)
    plt.ylabel("ADC counts",fontsize = 20)
    plt.xlabel("samples",fontsize = 20)
    if(len(BC0)!=0): ax.axvline(x=BC0[0],ymin=0, ymax=4000, linewidth=1, color = "green")
    plt.show()

#fig.savefig(filename[:-4]+"_full.png")


# In[503]:


sub_base =  int_samples[xpos+10:xpos+30] 
base =sum(sub_base) / len(sub_base) 
print("average baseline: ", base)
print("First 400 samples: ", int_samples[0:400])

#
#timeIn01,dataIn01 = parseSimulation("/home/na62torino/temp/presynth_DTU_GSM_00_ing01.dat",0)
#timeIn10,dataIn10 = parseSimulation("/home/na62torino/temp/presynth_DTU_GSM_00_ing10.dat",0)
#dataIn01_less=dataIn01[30:500]
#dataIn10_less=dataIn10[30:500]
#diff=0
#sampleschecked=0
#for x in range (len(int_samples[10:400])):
#    sampleschecked=sampleschecked+1;
#    print ("data in ", int(dataIn10_less[x],16), "data out",int_samples[x+10])
#    print("10:    ",int_samples[x+10]-int(dataIn10_less[x],16))
#    print("1:    ",int_samples[x+10]-int(dataIn01_less[x],16))
#    if(int_samples[x]-int(dataIn10_less[x],16)!=0):     
#        if(int_samples[x+10]-int(dataIn01_less[x],16)!=0):
#            diff+=int_samples[x+10]-int(dataIn10_less[x],16)
#    
#
#print ("diff: ", diff, " over ",sampleschecked)


xpos=xmax;
r=int_samples[xpos-6:xpos+20]
print("Values around the maximum peak: ", r)
fake=int_samples_sign_g1[0:16]
newfake=[]
for x in fake:
    newfake+=[x+6]
print ("values at gain 1 (+ fake baseline of 6)",newfake)

   
numbers = int_samples
local_maxima=FindMaxima(numbers,base)
print ("position of maxima: ",local_maxima)


nmax=0;
for i in local_maxima:
    nmax=nmax+1;
    r=int_samples[i-6:i+9]
    # print(nmax,") Values around the local maximum peak: ",r)



print ("BC0s: ", BC0) 


