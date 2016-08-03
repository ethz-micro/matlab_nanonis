close all
clear all

fn='Data/2013-03-01/m2_ori.par';
file=loadSxM.loadProcessedPar(fn,'PlaneLineCorrection');

plotSxM.plotFile(file,1);

figure
file=loadSxM.loadProcessedPar(fn);

plotSxM.plotFile(file,1);
%%
figure
plot(file.channels(1).lineMedian)
hold all
plot(file.channels(1).lineMean)
