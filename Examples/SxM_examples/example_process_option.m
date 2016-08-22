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
fileMedian=sxm.load.loadProcessedSxM(fileName,'Median');
fileUniform=sxm.load.loadProcessedSxM(fileName,'PlaneLineCorrection');

%% plot
figure('Name','Process: Mean');
sxm.plot.plotFile(fileMean,1);

figure('Name','Process: Median');
sxm.plot.plotFile(fileMedian,1);

figure('Name','Process: PlaneLineCorrection');
sxm.plot.plotFile(fileUniform,1);
