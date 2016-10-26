%-------------------------------------------------------------------------
%   This files load a STM image and plot an SxM file
%
%
%
%
%-------------------------------------------------------------------------

%% add NanoLib
addpath('../../NanoLib/')

%% image name
fileName = '../Files/Si_7x7_012.sxm';

%% load image with all channels
sxmFile = sxm.load.loadProcessedSxM(fileName);
% plot data
figure; sxm.plot.plotFile(sxmFile,1);
%% load image with only first channel !! start from 0
sxmFile = sxm.load.loadProcessedSxM(fileName,0);
% plot data
figure; sxm.plot.plotFile(sxmFile,1);

%% load image with only first and last channels !! start from 0
sxmFile = sxm.load.loadProcessedSxM(fileName,[0,3]);
% plot data
figure; sxm.plot.plotFile(sxmFile,2);
% plot specific channel
iCh = utility.getChannel(sxmFile.channels,'Current','backward');
figure; sxm.plot.plotFile(sxmFile,iCh);

%% load image channel 'Z' forward and backward
sxmFile = sxm.load.loadProcessedSxM(fileName,'Z');
% plot data
figure; sxm.plot.plotFile(sxmFile,1);

%% load image channel 'Z' forward and backward with Processing Raw
sxmFile = sxm.load.loadProcessedSxM(fileName,'Z','Raw');
% plot data
figure; sxm.plot.plotFile(sxmFile,1);

%% load image channel 'Z' forward and backward with Processing MEDIAN
sxmFile = sxm.load.loadProcessedSxM(fileName,'Z','Median');
% plot data
figure; sxm.plot.plotFile(sxmFile,1);

%% load image channel 'Z' forward
sxmFile = sxm.load.loadProcessedSxM(fileName,'Z','fwd');
% plot data
figure; sxm.plot.plotFile(sxmFile,1);

%% load image with list of channels to load, fwd and bwd
sxmFile = sxm.load.loadProcessedSxM(fileName,'Z','Current');
% plot data
iCh = 2; % Chennel 2 is Z bwd
figure
[~, range] = sxm.plot.plotFile(sxmFile,iCh);
%plot histogram
figure
sxm.plot.plotHistogram(sxmFile.channels(iCh).data,range);
title('Z height')