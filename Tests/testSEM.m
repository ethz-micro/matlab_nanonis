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
fn='Data/March/2015-03-05/image004.sxm'; 
%Load 2,4,6,8 (current + forward channel 0 1 2 3)
file = load.loadProcessedSxM(fn,[0 2 4 6 8]);

%% Image without STD correction

%load
[header, data] = load.loadsxm(fn, 2);
%remove median
data=(data-median(data,2)*ones([1 size(data,2)]));
%plot
header.scan_type='SEM';
figure
plot.plotData(data,'non-stdev corrected channel 0','',header);

%% plot mean and std

%Correlation 
corrMnSTDev=corr(file.channels(2).mean,file.channels(2).std);

%print mean and stdev for data 0
figure        
plot(file.channels(2).mean)        
title(['mean channel 0, correlation with stdev: ',num2str(corrMnSTDev)]);        
figure        
plot(file.channels(2).std)        
title(['std channel 0, correlation with mean: ',num2str(corrMnSTDev)]);

%% plot images

%plot image
figure
[~, range] = plot.plotFile(file,2);

%plot histogram
figure
plot.plotHistogram(file.channels(2).data,range)
title('channel 0')

%Plot plane
figure
imagesc([0 file.header.scan_range(2)],[0 file.header.scan_range(2)],-ones([size(file.channels(2).data,1) 1])*file.channels(1).slope,range);
title('Corrected plane')
axis image

%% add 4 channels in one data

%Add datas
channel = op.combineChannel(file,'4 channels',2:5,1/4*[1,1,1,1]);

%plot image
figure
[~, range]=plot.plotChannel(channel,file.header);

%% Do the same for current

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

[signal,removed]=process.filterData(data,25);
figure
plot.plotData(signal,'Filtered - 25 px','',header);

figure
plot.plotData(removed,'Removed - 25 px','',header);














%% Old & discarded


%{
%% plot distributions
chanN=2;

[header, data] = loadsxm(fn, chanN);

%plot histogram
figure
histogram(data,50)

v=axis();

v(4)=v(4)/512;
figure
for i= 1:10:512
histogram(data(i,:),50)
axis(v);
pause(.1);
    
end
%}    




%{
%print mean and stdev for data 0
figure        
plot(mn0)        
legend('mean channel 0');        
figure        
plot(stdev0)        
legend('std channel 0');
figure        
plot(slope0)        
legend('slope channel 0');
%}



%{
%% Blur
kern = 1/4*[[1/4, 1/2,1/4];[1/2,1,1/2];[1/4,1/2,1/4]];
kern = 1/9*[[1, 1,1];[1,1,1];[1,1,1]];
B=conv2(dataFC,kern);

figure
imagesc([0 header.scan_range(1)],[0 header.scan_range(2)],B,range);

%cut 1.5
figure
big=B>1.5;
small = B <-1.5;
B(big)=0;
B(small)=0;
mesh(B)

%}




