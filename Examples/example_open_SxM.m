%-------------------------------------------------------------------------
%   This files load a STM image and plot an SxM file
%
%
%
%
%-------------------------------------------------------------------------

%% add NanoLib
addpath('../NanoLib/')

%% load image

fileName = 'Files/Si_7x7_200x200.sxm';% image name
sxmFile = loadSxM.loadProcessedSxM(fileName);

%% plot data

iCh = 1; % Channel number

%plot image
figure
[~, range] = plotSxM.plotFile(sxmFile,iCh);

%plot histogram
figure
plotSxM.plotHistogram(sxmFile.channels(iCh).data,range);
title('Z height')