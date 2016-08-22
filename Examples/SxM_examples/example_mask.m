%--------------------------------------------------------------------------
%   This files compute a mask from a STM image and apply it on the original
%   image
%
%
%
%--------------------------------------------------------------------------

%% add NanoLib
addpath('../../NanoLib/')

%% load data
fileName='../Files/Si_7x7_051.sxm';
sxmFile = sxm.load.loadProcessedSxM(fileName,'Z','forward');

%% Get mask 

%Mask prct
prctUp = 90;
prctDown = 15;
smallestComStruct=20;

%Compute mask
[maskUpSTM, maskDownSTM] = sxm.mask.getMask(sxm.op.nanHighStd(sxmFile.channels.data),...
    smallestComStruct, prctUp, prctDown,'plotFFT');

%% Plot

% stm
figure; title('STM Data + Mask.');
sxm.plot.plotFile(sxmFile,1);

% apply mask
[xrange,yrange] = sxm.op.getRange(sxmFile.header);
sxm.mask.applyMask(maskUpSTM,[1,0,0], .4,xrange*1e9,yrange*1e9)
sxm.mask.applyMask(maskDownSTM,[0,0,0], .4,xrange*1e9,yrange*1e9)



