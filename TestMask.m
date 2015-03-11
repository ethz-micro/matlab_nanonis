%Get a mask and test it


clear all;
close all;

%imag name
fn='Data/DataC2/2015-03-04/image006.sxm'; % 5-7

%Mask prct
prctUp = 80;
prctDown = 10;

%Load 2,4,6,8 (forward channel 0 1 2 3)
[data0,header] = loadSEM(fn, 2);
data1 = loadSEM(fn, 4);
data2 = loadSEM(fn, 6);
data3 = loadSEM(fn, 8);

%Add datas
data = 1/4*(data0+data1+data2+data3);

%Compute mask
[maskUp, maskDown] = getMask(data, prctUp, prctDown,'plotFFT');

%Plot bare data 
figure
plotSEM(data,header);
title('Initial Data');

%Data + Mask
figure
plotSEM(data,header);
xrange=[0 header.scan_range(1)];
yrange=[0 header.scan_range(2)];
applyMask(maskUp,xrange,yrange,[1,0,0], .2)
applyMask(maskDown,xrange,yrange,[0,0,0], .2)
title('Initial Data + Mask');

%% LOAD STM
%try to match the mask and stm data
fn='Data/DataC2/2015-03-04/image004.sxm'; % 5-7

[data0,header] = loadSTM(fn, 0);

%Compute mask
[maskUpSTM, maskDownSTM] = getMask(data0, prctUp, prctDown,'plotFFT');

figure
plotSTM(data0,header)
title('STM Data')

figure
plotSTM(data0,header)
xoffset=(header.scan_range(1)-xrange(2))*.5*1.1;
yoffset=(header.scan_range(2)-yrange(2))*.5*.8;
applyMask(maskUp,xrange+xoffset,yrange+yoffset,[1,0,0], .4)
applyMask(maskDown,xrange+xoffset,yrange+yoffset,[0,0,0], .4)
title(['STM Data + Mask. Offset x:',num2str(xoffset*10^9),'nm, y:',num2str(yoffset*10^9),'nm'])


xrangeSTM=[0 header.scan_range(1)];
yrangeSTM=[0 header.scan_range(2)];

figure
image(xrangeSTM,yrangeSTM,cat(3,zeros(size(maskUpSTM)),zeros(size(maskUpSTM)),maskUpSTM));
applyMask(maskUp,xrange+xoffset,yrange+yoffset,[1,0,0], .4);

figure
plotSTM(data0,header)
applyMask(maskUpSTM,xrangeSTM,yrangeSTM,[1,0,0], .4);

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


