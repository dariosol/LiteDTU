# coding: utf-8

# In[493]:


import os
os.chdir('./')

import matplotlib.lines as mlines
import matplotlib.pyplot as plt
import numpy as np
import sys
from matplotlib import cm
from ROOT import *#TCanvas, TFile, TProfile, TNtuple, TH1F, TH2F
#from ROOT import gROOT, gBenchmark, gRandom, gSystem, Double
from functions import parseSimulation, parseSimulationSerializers


fileIn = sys.argv[1]
fileOut = sys.argv[2]
Outputname = sys.argv[3]

# Lettura dei file acquisiti in DTU mode:
# 
# 4 colonne: dout_0 (samples in output dalla DTU)
# 
# mentre su dout_1, dout_2 e dout_3 ci sono soltanto parole da 32-bit di allineamento: 5A5A5A5A -> 01011010010110100101101001011010

filenameIn = fileIn
filenameOut = fileOut

timeIn=[]
dataIn=[]
timeIn,dataIn = parseSimulation(filenameIn,0)

timeOut=[]
dataOut=[]
gainOut=[]
timeOut,GainOut,dataOut = parseSimulationSerializers(filenameOut,0)


###Find Alignment in first 20 data###########
GoodOut=0
print ("Removing first zeroes")
for i in range(20):
    if(dataOut[i]!="000"):
        GoodOut=i
        break
print ("GoodOut ",GoodOut)
align=0
Offset =0
print ("Looking for alignment between samples in and samples out")
for al in range(100):
    for i in range(20): # scan first 20 samples to find input/output alignment
        if(dataOut[i+GoodOut]==dataIn[i+Offset]): align=align+1
        print("al ",al, " i ", i, " Offset ", Offset, " dataIn[i] ", dataIn[i+Offset], " dataOut[i] ",dataOut[i+GoodOut]," align ",align)
    if(align!=20): Offset=Offset+1
    else: break
    print ("align ",align)
    align=0
print ("Offset ",Offset)
latency=[]
time=[]
timeGain1=[]
Data=[]
if(align!=20):
    print ("alignment input-output not found")
    sys.exit()

print ((len(timeIn)-Offset))
print ("len timeout ",len(timeOut))
print ("len timein ",len(timeIn))
for itime in range(len(timeOut)-GoodOut-Offset):
    lat=float(timeOut[itime+GoodOut]) - float(timeIn[itime+Offset])
    if((timeOut[itime+GoodOut]/1000.>22600) and (timeOut[itime+GoodOut]/1000.) < 22900): print("timeOut[ns]: ",timeOut[itime+GoodOut]/1000.," timeIn [ns] ",timeIn[itime+Offset]/1000.," (DT) ",(timeOut[itime+GoodOut]-timeOut[itime+GoodOut-1])," data out ",dataOut[itime+GoodOut], " data in ",dataIn[itime+Offset]," latency [ns]", lat/1000.)
    latency.append(float(lat/1000.))
    time.append(float(timeOut[itime+GoodOut]/1000.))
    Data.append(int(dataOut[itime+GoodOut],16))
    if(GainOut[itime+GoodOut]=='1'):
        timeGain1.append(100)
    else:
        timeGain1.append(0)
plt.hist(latency,bins=24)  # density=False would make counts
plt.ylabel('Entries')
plt.xlabel('Latency (ns)');
#plt.show()


hlat    = TH1F( 'hlat', 'Latency', 100,0,625)
hlatVsTime    = TH1F( 'hlatVsTime', 'LatencyVsInput Time; [ns];Latency [sample]',len(latency),0,len(latency))
hTimeGain1    = TH1F( 'hTimeGain1', 'TimeGain1',len(latency),0,len(latency))
hData         = TH1F( 'Data', 'Data',len(latency),0,len(latency))
for itime in range(len(latency)):
    hlat.Fill(latency[itime])
    hlatVsTime.SetBinContent(itime,latency[itime])
    hTimeGain1.SetBinContent(itime,timeGain1[itime])
    hData.SetBinContent(itime,Data[itime])
filenameroot = filenameOut[10:36]
filenameroot = filenameroot + ".root"
print Outputname
hfile = gROOT.FindObject( filenameroot )
if hfile:
    hfile.Close()
hfile = TFile( Outputname, 'RECREATE' )

hlat.Write()
hlatVsTime.Write()

c1 = TCanvas("c1","transparent pad",200,10,700,500)
pad1 = TPad("pad1","",0,0,1,1)
pad2 = TPad("pad2","",0,0,1,1)
xmin = 3000
xmax = 5000
pad2.SetFillStyle(4000) #will be transparent
pad1.Draw()
pad1.cd()
gStyle.SetOptStat(0);
hTimeGain1.SetMarkerColor(2)
hlatVsTime.SetLineColor(2)
hData.SetMarkerColor(1)
hData.SetMarkerStyle(20)
hlatVsTime.GetXaxis().SetRangeUser(xmin,xmax)
hlatVsTime.GetYaxis().SetTitle("Latency")
hData.GetXaxis().SetRangeUser(xmin,xmax)
hData.GetYaxis().SetTitle("sample value")
hData.Draw("lp")
pad1.Update()

c1.cd();


#compute the pad range with suitable margins
ymin = 0
ymax = 625
dy = (ymax-ymin)/0.8 #10 per cent margins top and bottom
dx = (xmax-xmin)/0.8 #10 per cent margins left and right
pad2.Range(xmin-0.1*dx,ymin-0.1*dy,xmax+0.1*dx,ymax+0.1*dy)
pad2.Draw()
pad2.cd()
gStyle.SetOptStat(0)
hlatVsTime.GetXaxis().SetRangeUser(xmin,xmax)
hlatVsTime.Draw("][sames")
pad2.Update()
#draw axis on the right side of the pad
axis = TGaxis(xmax,ymin,xmax,ymax,ymin,ymax,50510,"+L")
axis.SetLabelColor(kRed)
axis.Draw()


#hlatVsTime.Draw("same")
#hTimeGain1.Draw("same")

