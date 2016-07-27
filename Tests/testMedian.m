close all
clear all
fn = 'Data/March/2015-03-12/image007.sxm';
fileMean=loadSxM.loadProcessedSxM(fn);
fileMedian=loadSxM.loadProcessedSxM(fn,'Median');
fileUniform=loadSxM.loadProcessedSxM(fn,'PlaneLineCorrection');

plotSxM.plotFile(fileMean,1)
figure
plotSxM.plotFile(fileMedian,1)
figure
plotSxM.plotFile(fileUniform,1)
