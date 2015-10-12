%---------------------------------------------
%   This files compute a mask from a SEM image and apply it on a STM image
%
%
%
%
%---------------------------------------------
clear all;
close all;


%% load SEM data
%imag name
fn='Data/DataC2/2015-03-04/image006.sxm'; % 5-7
%Load 2,4,6,8 (forward channel 0 1 2 3)
file6=load.loadProcessedSxM(fn,2:2:8);
%Add datas
channel = op.combineChannel(file6,'4 channels',1:4,1/4*[1,1,1,1]);
data=channel.data;

%% LOAD STM Data

%try to match the mask and stm data
fn='Data/DataC2/2015-03-04/image004.sxm'; % 5-7
file4 = load.loadProcessedSxM(fn,0);

%{
fn='Data/2013-03-01/m2_ori.par';
file4=load.loadProcessedPar(fn);

fn='Data/2013-03-01/m19_ori.par';
file6=load.loadProcessedPar(fn);

channel=file6.channels(2);
data=channel.data;
%}
%% get mask

%Mask prct
prctUp = 80;
prctDown = 10;
smallestComStruct=20;
%Compute mask
[maskUp, maskDown] = mask.getMask(data, smallestComStruct, prctUp, prctDown,'plotFFT');

%% Plot Data and mask

%Plot bare data 
figure
plot.plotChannel(channel,file6.header);

%Data + Mask
figure
plot.plotChannel(channel,file6.header);
[xrange,yrange] = op.getRange(file6.header);

mask.applyMask(edge(maskUp),[0,0,0],1,xrange*1e9,yrange*1e9)
mask.applyMask(edge(maskDown),[1,0,0],1,xrange*1e9,yrange*1e9)



%% Get mask STM For comparaison

%Compute mask
[maskUpSTM, maskDownSTM] = mask.getMask(op.nanHighStd(file4.channels.data), smallestComStruct, prctUp, prctDown,'plotFFT');

%Get offset
[offset,XC,centerOffset]= op.getOffset(maskUpSTM,file4.header,maskUp,file6.header,'mask');

%% Plot STM And STM+Mask
xrange = xrange+offset(1);
yrange = yrange+offset(2);

%Plot cross correlation
figure
imagesc(XC)
title('cross correlation');

%Plot initial data
figure
plot.plotFile(file4,1);

%plot data + mask
figure
plot.plotFile(file4,1);
mask.applyMask(maskUp,[1,0,0], .4,xrange*1e9,yrange*1e9)
mask.applyMask(maskDown,[0,0,0], .4,xrange*1e9,yrange*1e9)
title(['STM Data + Mask. Offset x:',num2str(round(centerOffset(1)*10^9)),'nm, y:',num2str(round(centerOffset(2)*10^9)),'nm'])


