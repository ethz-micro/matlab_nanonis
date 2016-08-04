%--------------------------------------------------------------------------
%   This files shows the difference between the default load process, i.e.
%   'Mean', and the other optional process: 'Median' and
%   'PlaneLineCorrection'.
%
%
%--------------------------------------------------------------------------

%% add NanoLib
addpath('../NanoLib/')

%% Load 
fileName='Files/Si_7x7_012.sxm';

fileMean=loadSxM.loadProcessedSxM(fileName);
fileMedian=loadSxM.loadProcessedSxM(fileName,'Median');
fileUniform=loadSxM.loadProcessedSxM(fileName,'PlaneLineCorrection');

%% plot
figure('Name','Process: Mean');
plotSxM.plotFile(fileMean,1);

figure('Name','Process: Median');
plotSxM.plotFile(fileMedian,1);

figure('Name','Process: PlaneLineCorrection');
plotSxM.plotFile(fileUniform,1);
