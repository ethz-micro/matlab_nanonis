%--------------------------------------------------------------------------
%   This files shows the difference between the default load process, i.e.
%   'Mean', and the other optional process: 'Median' and
%   'PlaneLineCorrection'.
%
%
%--------------------------------------------------------------------------

%% add NanoLib
addpath('../../NanoLib/')

%% Load 
fileName='../Files/Si_7x7_012.sxm';

fileMean=sxm.load.loadProcessedSxM(fileName);
fileRaw=sxm.load.loadProcessedSxM(fileName,'Raw');
fileMedian=sxm.load.loadProcessedSxM(fileName,'Median');
fileUniform=sxm.load.loadProcessedSxM(fileName,'PlaneLineCorrection');

%% plot
figure('Name','Process: Mean');
sxm.plot.plotFile(fileMean,1,'Units','nm');

figure('Name','Process: Raw');
sxm.plot.plotFile(fileRaw,1,'Units','nm');

figure('Name','Process: Median');
sxm.plot.plotFile(fileMedian,1,'Units','nm');

figure('Name','Process: PlaneLineCorrection');
sxm.plot.plotFile(fileUniform,1,'Units','nm');
