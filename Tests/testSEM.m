%---------------------------------------------
%   This files load a SEM image and plot the various data
%
%
%
%
%---------------------------------------------

clear all;
close all;

%% load image

%image name
%fn='Data/March/2015-03-05/image004.sxm';
fn='Data/March/2015-03-04/image006.sxm';
%Load 2,4,6,8 (current + forward channel 0 1 2 3)
file = load.loadProcessedSxM(fn,[0 2 4 6 8]);

%% Image without STD correction

%load
[header, data] = load.loadsxm(fn, 2);
%remove median
data=(data-mean(data,2)*ones([1 size(data,2)]));

%data=flip(data,2);
%data=flip(data,1);


%plot
header.scan_type='NFESEM';
figure
plot.plotData(data,'Raw channel 0','',header);

%% plot median and std

%print median and stdev for data 0
figure        
plot(file.channels(2).lineMedian)        
title(['median channel 0']);%, correlation with stdev: ',num2str(corrMnSTDev)]);
figure
plot(std(file.channels(2).data,0,2))
title(['std channel 0']);


%% plot images

%plot image
figure
[h, range] = plot.plotFile(file,2,0,0,'NoTitle');
set(gcf,'PaperPositionMode','auto')
print -depsc -loose BarPlot
%%

%plot histogram
figure
plot.plotHistogram(file.channels(2).data,range)
title('channel 0')

%Plot plane
figure
imagesc([0 file.header.scan_range(2)],[0 file.header.scan_range(2)],ones([size(file.channels(2).data,1) 1])*file.channels(1).lineResidualSlope,range);
title('Corrected plane')
axis image

%% add 4 channels in one data

%Add datas
channel = op.combineChannel(file,'4 channels',2:5,1/4*[1,1,1,1]);

%plot image
figure
[~, range]=plot.plotChannel(channel,file.header);

%% current

%plot image
figure
plot.plotFile(file,1);

%% 5 channels

%Add datas
data = 1/2*(channel.data+file.channels(1).data);

%plot image
figure
plot.plotData(data,'5 channels','',header);

%% Plot filtered data
[signal,removed]=op.filterData(data,25);
figure
plot.plotData(signal,'Filtered - 25 px','',header);

figure
plot.plotData(removed,'Removed - 25 px','',header);





