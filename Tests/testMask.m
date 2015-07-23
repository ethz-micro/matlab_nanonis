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
prctDown = 20;

%Compute mask
[maskUp, maskDown] = mask.getMask(data, 10, prctUp, prctDown,'plotFFT');

%% Plot Data and mask

%Plot bare data 
figure
plot.plotChannel(channel,file6.header);

%Data + Mask
figure
plot.plotChannel(channel,file6.header);
[xrange,yrange] = op.getRange(file6.header);
mask.applyMask(maskUp,xrange,yrange,[1,0,0], .2)
mask.applyMask(maskDown,xrange,yrange,[0,0,0], .2)



%% Get mask STM For comparaison

%Compute mask
[maskUpSTM, maskDownSTM] = mask.getMask(op.nanHighStd(file4.channels.data), 10, prctUp, prctDown,'plotFFT');

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
mask.applyMask(maskUp,xrange,yrange,[1,0,0], .4)
mask.applyMask(maskDown,xrange,yrange,[0,0,0], .4)
title(['STM Data + Mask. Offset x:',num2str(round(centerOffset(1)*10^9)),'nm, y:',num2str(round(centerOffset(2)*10^9)),'nm'])
%{
[xrangeSTM,yrangeSTM]=op.getRange(file4.header);
figure
plot.plotChannel(file4,1);
mask.applyMask(maskUpSTM,xrangeSTM,yrangeSTM,[1,0,0], .4);
mask.applyMask(maskDownSTM,xrangeSTM,yrangeSTM,[0,0,0], .4);
%}
%{

%% Load other SEM
fn='Data/DataC2/2015-03-04/image005.sxm'; % 5-7
%try to match the mask and sem data
[data,header] = loadSEM(fn, 0);
data = processSEM(data);
xoffset=xrange(2)*.1*-.4;
yoffset=yrange(2)*.1*-.8;

figure
plotSEM(data,header)
applyMask(maskUp,xrange+xoffset,yrange+yoffset,[1,1,1], 0)
title('SEM Data')

figure
plotSEM(data,header)
applyMask(maskUp,xrange+xoffset,yrange+yoffset,[1,0,0], .4)
applyMask(maskDown,xrange+xoffset,yrange+yoffset,[0,0,0], .4)
title(['SEM Data + Mask. Offset x:',num2str(xoffset*10^9),'nm, y:',num2str(yoffset*10^9),'nm'])

%}


