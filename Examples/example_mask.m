%--------------------------------------------------------------------------
%   This files compute a mask from a STM image and apply it on the original
%   image
%
%
%
%--------------------------------------------------------------------------

%% add NanoLib
addpath('../NanoLib/')

%% load data
fileName='Files/Si_7x7_051.sxm';
sxm = loadSxM.loadProcessedSxM(fileName,'Z');

%% Get mask 

%Mask prct
prctUp = 90;
prctDown = 15;
smallestComStruct=20;

%Compute mask
[maskUpSTM, maskDownSTM] = mask.getMask(op.nanHighStd(sxm.channels.data),...
    smallestComStruct, prctUp, prctDown,'plotFFT');

%% Plot

% stm
figure; title('STM Data + Mask.');
plotSxM.plotFile(sxm,1);

% apply mask
[xrange,yrange] = op.getRange(sxm.header);
mask.applyMask(maskUpSTM,[1,0,0], .4,xrange*1e9,yrange*1e9)
mask.applyMask(maskDownSTM,[0,0,0], .4,xrange*1e9,yrange*1e9)



