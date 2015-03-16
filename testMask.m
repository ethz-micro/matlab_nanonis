%Get a mask and test it


clear all;
close all;

%imag name
fn='Data/DataC2/2015-03-04/image006.sxm'; % 5-7

%Mask prct
prctUp = 80;
prctDown = 10;

%Load 2,4,6,8 (forward channel 0 1 2 3)
file6=load.loadProcessedSxM(fn,2:2:8);

%file6.header

%Add datas
data = op.combineChannel(file6,1:4,1/4*[1,1,1,1]);

%Compute mask
[maskUp, maskDown] = mask.getMask(data, 20, prctUp, prctDown,'plotFFT');

%%
%Plot bare data 
figure
plot.plotData(data,'Initial Data',file6.header);

%Data + Mask
figure
plot.plotData(data,'Initial Data + Mask',file6.header);
[xrange,yrange] = op.getRange(file6.header);
mask.applyMask(maskUp,xrange,yrange,[1,0,0], .2)
mask.applyMask(maskDown,xrange,yrange,[0,0,0], .2)


%% LOAD STM
%try to match the mask and stm data
fn='Data/DataC2/2015-03-04/image004.sxm'; % 5-7

file4 = load.loadProcessedSxM(fn,0);

%Compute mask
[maskUpSTM, maskDownSTM] = mask.getMask(op.nanHighStd(file4.channels.data), 60, prctUp, prctDown,'plotFFT');

[xrangeSTM,yrangeSTM]=op.getRange(file4.header);

%%


[offset,XC,centerOffset]= op.getOffset(maskUpSTM,file4.header,maskUp,file6.header,'mask');
%%
xrange = xrange+offset(1);
yrange = yrange+offset(2);

figure
imagesc(XC)
title('cross correlation');

figure
plot.plotChannel(file4,1);

figure
plot.plotChannel(file4,1);
mask.applyMask(maskUp,xrange,yrange,[1,0,0], .4)
mask.applyMask(maskDown,xrange,yrange,[0,0,0], .4)
title(['STM Data + Mask. Offset x:',num2str(round(centerOffset(1)*10^9)),'nm, y:',num2str(round(centerOffset(2)*10^9)),'nm'])
%%

figure
plot.plotChannel(file4,1);
mask.applyMask(maskUpSTM,xrangeSTM,yrangeSTM,[1,0,0], .4);
mask.applyMask(maskDownSTM,xrangeSTM,yrangeSTM,[0,0,0], .4);

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


