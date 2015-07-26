close all
clear all
fn = 'Data/March/2015-03-12/image007.sxm';
fileMean=load.loadProcessedSxM(fn);
fileMedian=load.loadProcessedSxM(fn,'Median');
fileUniform=load.loadProcessedSxM(fn,'PlaneLineCorrection');

plot.plotFile(fileMean,1)
figure
plot.plotFile(fileMedian,1)
figure
plot.plotFile(fileUniform,1)
