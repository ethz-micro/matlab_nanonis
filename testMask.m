%Get a mask and test it


clear all;
close all;

%imag name
fn='Data/DataC2/2015-03-04/image006.sxm'; % 5-7

%Mask prct
prctUp = 80;
prctDown = 10;

file6=load.loadProcessedSxM(fn,[2:2:8]);
%Load 2,4,6,8 (forward channel 0 1 2 3)

%Add datas
data = 1/4*sum(cat(3,file6.channels.data),3);

%Compute mask
[maskUp, maskDown] = mask.getMask(data, 20, prctUp, prctDown,'plotFFT');

%Plot bare data 
figure
plot.plotSEM(data,file6.header);
title('Initial Data');

%Data + Mask
figure
plot.plotSEM(data,file6.header);
xrange=[0 file6.header.scan_range(1)];
yrange=[0 file6.header.scan_range(2)];
mask.applyMask(maskUp,xrange,yrange,[1,0,0], .2)
mask.applyMask(maskDown,xrange,yrange,[0,0,0], .2)
title('Initial Data + Mask');

%% LOAD STM
%try to match the mask and stm data
fn='Data/DataC2/2015-03-04/image004.sxm'; % 5-7

file4 = load.loadProcessedSxM(fn,0);

%Compute mask
[maskUpSTM, maskDownSTM] = mask.getMask(nanHighStd(file4.channels.data), 30, prctUp, prctDown,'plotFFT');

xoffset=(file4.header.scan_range(1)-xrange(2))*.5*1.1;
yoffset=(file4.header.scan_range(2)-yrange(2))*.5*.8;

figure
plot.plotChannel(file4,1);

figure
plot.plotChannel(file4,1);
mask.applyMask(maskUp,xrange+xoffset,yrange+yoffset,[1,0,0], .4)
mask.applyMask(maskDown,xrange+xoffset,yrange+yoffset,[0,0,0], .4)
title(['STM Data + Mask. Offset x:',num2str(xoffset*10^9),'nm, y:',num2str(yoffset*10^9),'nm'])


xrangeSTM=[0 file4.header.scan_range(1)];
yrangeSTM=[0 file4.header.scan_range(2)];

figure
image(xrangeSTM,yrangeSTM,cat(3,zeros(size(maskUpSTM)),zeros(size(maskUpSTM)),maskUpSTM));
%mask.applyMask(maskUpSTM,xrangeSTM,yrangeSTM,[0,0,1],1)
mask.applyMask(maskUp,xrange+xoffset,yrange+yoffset,[1,0,0], .4);
axis image

figure
image(xrangeSTM,yrangeSTM,cat(3,zeros(size(maskUpSTM)),zeros(size(maskUpSTM)),maskDownSTM));
%mask.applyMask(maskUpSTM,xrangeSTM,yrangeSTM,[0,0,1],1)
mask.applyMask(maskDown,xrange+xoffset,yrange+yoffset,[1,0,0], .4);
axis image

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


