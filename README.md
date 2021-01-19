# LiteDTU
LiteDTU starting from version 1.2

Presynthesis simulation with Questa sim.
- v1.2 submitted in may and tested by Simona is the starting point
- Simona was doing the sim with Cadence. All the presynth needed files are in folder FromSimona...
- New simulation for v2.0: 1) LiteDTUv2.0 contains files to be shared with Gianni 2) AuxiliaryForSimulation contains the serializer, 
the Test Bench and all the other stuff needed to simuate.

NOTE
AuxiliaryForSimulation/SyncUnit_v1bTMR.v is there but it's not used

NOTE FROM GIANNI Regarding files in the topFilesv1.2 folder
Ciao Dario,
ti allego i verilog del datapath della LiTE-DTU. Ecco qualche spiegazione :

1. il blocco LDTUv2_dp raccoglie tutta la logica che viaggia a 160 MHz, e
    che viene sintetizzata e P&R assieme. Non include l'I2C (che lavora a
    bassa frequenza) e il serializzatore (che lavora a 1.28 GHz).

2. il blocco LDTUv2_dp ha 3 parti principali :
     - SyncUnit : genera i fast command
     - TestUnit : gestisce l'ADC test mode
     - DTU : parte principale, gestisce tutto il resto.
    io mi sono occupato delle prime due parti e del blocco top, mentre 
Simona
    si era occupata della DTU (che quindi ora passerebbe a te)

3. il blocco DTU è un'istanza del modulo LiTE_DTU_160MHz_v1_2. Servirà 
quindi
    un modulo LiTE_DTU_160MHz_v2 (o come preferirai chiamarlo) che si 
interfaccia
    con il resto. Nei commenti del codice verilog ti ho messo i segnali 
che andranno
    aggiunti per implementare le nuove funzionalità

4. quando avrò il tuo codice verilog metterò tutto assieme e farò girare 
il tool
    di sintesi e poi quello di P&R. Ti manderò poi il risultato, in modo 
che tu lo
    possa simulare e verificare che tutto torni. Dato che con la sintesi 
il blocco
    diventa un qualcosa di unico, ti serviranno dei testbench che usano 
l'intero blocco
    LDTUv2_dp.
