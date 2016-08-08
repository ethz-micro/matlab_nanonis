%-------------------------------------------------------------------------
%   This files load a STM image and plot an SxM file
%
%
%
%
%-------------------------------------------------------------------------

%% add NanoLib
addpath('../NanoLib/')

%% image name
fileName = 'Files/Si_7x7_012.sxm';

%% load image with all channels
sxmFile = loadSxM.loadProcessedSxM(fileName);
% plot data
figure; plotSxM.plotFile(sxmFile,1);
%% load image with only first channel !! start from 0
sxmFile = loadSxM.loadProcessedSxM(fileName,0);
% plot data
figure; plotSxM.plotFile(sxmFile,1);

%% load image with only first and last channels !! start from 0
sxmFile = loadSxM.loadProcessedSxM(fileName,[0,3]);
% plot data
figure; plotSxM.plotFile(sxmFile,2);

%% load image channel 'Z' forward and backward
sxmFile = loadSxM.loadProcessedSxM(fileName,'Z');
% plot data
figure; plotSxM.plotFile(sxmFile,1);

%% load image channel 'Z' forward and backward with Processing MEDIAN
sxmFile = loadSxM.loadProcessedSxM(fileName,'Z','Median');
% plot data
figure; plotSxM.plotFile(sxmFile,1);

%% load image channel 'Z' forward
sxmFile = loadSxM.loadProcessedSxM(fileName,'Z','fwd');
% plot data
figure; plotSxM.plotFile(sxmFile,1);

%% load image with list of channels to load, fwd and bwd
sxmFile = loadSxM.loadProcessedSxM(fileName,'Z','Current');
% plot data
iCh = 2; % Chennel 2 is Z bwd
figure
[~, range] = plotSxM.plotFile(sxmFile,iCh);
%plot histogram
figure
plotSxM.plotHistogram(sxmFile.channels(iCh).data,range);
title('Z height')