%test get mask
%% remove
clear all;
close all;
%image name
fn='DataC2/2015-03-04/image006.sxm'; % 5-7

%Load 2,4,6,8 (forward channel 0 1 2 3)
[header, data0] = loadsxm(fn, 2);
[~, data1] = loadsxm(fn, 4);
[~, data2] = loadsxm(fn, 6);
[~, data3] = loadsxm(fn, 8);

%Process Datas
data0=processSEM(data0);
data1=processSEM(data1);
data2=processSEM(data2);
data3=processSEM(data3);


%Add datas
data = 1/4*(data0+data1+data2+data3);

prctUp = 80;
prctDown = 10;

[maskUp, maskDown] = getMask(data, prctUp, prctDown);

figure
plotSEM(data,header);

figure
plotSEM(data,header);
xrange=[0 header.scan_range(1)];
yrange=[0 header.scan_range(2)];
applyMask(maskUp,xrange,yrange,[1,0,0], .2)
applyMask(maskDown,xrange,yrange,[0,0,0], .2)

%% LOAD STM

fn='DataC2/2015-03-04/image004.sxm'; % 5-7

[header, data0] = loadsxm(fn, 0);
data0 = processSTM(data0);

figure
plotSTM(data0,header)

figure
plotSTM(data0,header)
xoffset=(header.scan_range(1)-xrange(2))*.5*1.1
yoffset=(header.scan_range(2)-yrange(2))*.5*.8
applyMask(maskUp,xrange+xoffset,yrange+yoffset,[1,0,0], .4)
applyMask(maskDown,xrange+xoffset,yrange+yoffset,[0,0,0], .4)

%% Load other SEM
fn='DataC2/2015-03-04/image005.sxm'; % 5-7

[header, data] = loadsxm(fn, 0);
data = processSEM(data);
xoffset=xrange(2)*.1*-.4
yoffset=yrange(2)*.1*-.8

figure
plotSEM(data,header)
applyMask(maskUp,xrange+xoffset,yrange+yoffset,[1,1,1], 0)

figure
plotSEM(data,header)
applyMask(maskUp,xrange+xoffset,yrange+yoffset,[1,0,0], .4)
applyMask(maskDown,xrange+xoffset,yrange+yoffset,[0,0,0], .4)


