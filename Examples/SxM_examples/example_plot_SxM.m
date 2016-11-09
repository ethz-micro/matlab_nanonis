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
sxmFile = sxm.load.loadProcessedSxM(fileName,'Z','Mean');
%% plot data
figure; sxm.plot.plotFile(sxmFile,1);

figure; sxm.plot.plotFile(sxmFile,1,'NoTitle');

figure; sxm.plot.plotFile(sxmFile,1,100e-9,100e-9);

figure; sxm.plot.plotFile(sxmFile,1,'Units','nm',100,100);
%%
figure; 
subplot(2,1,1); sxm.plot.plotFile(sxmFile,1,'HoldPosition','NoTitle');
subplot(2,1,2); sxm.plot.plotFile(sxmFile,2,'HoldPosition','NoTitle');
