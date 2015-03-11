
clear all;
close all;
%image name
fn='Data/DataC2/2015-02-27/image007.sxm'; % 5-7

%% Non STDev corrected data
[header, data] = loadsxm(fn, 2);
data=(data-median(data,2)*ones([1 size(data,2)]));
figure
plotSEM(data,header);
title('non-stdev corrected channel 0');

%% Load SED data

%Load 2,4,6,8 (forward channel 0 1 2 3)
[header, data0] = loadsxm(fn, 2);
[~, data1] = loadsxm(fn, 4);
[~, data2] = loadsxm(fn, 6);
[~, data3] = loadsxm(fn, 8);

%Process Datas
[data0, mn0, stdev0, slope0] = processSEM(data0);
data1=processSEM(data1);
data2=processSEM(data2);
data3=processSEM(data3);

%print header infos
header.data_info

%Correlation 
corrMnSTDev=corr(mn0,stdev0);

%% plot mean and std

%print mean and stdev for data 0
figure        
plot(mn0)        
title(['mean channel 0, correlation with stdev: ',num2str(corrMnSTDev)]);        
figure        
plot(stdev0)        
title(['std channel 0, correlation with mean: ',num2str(corrMnSTDev)]);

%% plot images

%plot image
figure
[~, range] = plotSEM(data0,header);
title('channel 0')

%plot histogram
figure
plotHistogram(data0,range)
title('channel 0')

%Plot plane
figure
imagesc([0 header.scan_range(1)],[0 header.scan_range(2)],-ones([size(data0,1) 1])*slope0,range);
title('Corrected plane')

%% add 4 channels in one data

%Add datas
data = 1/4*(data0+data1+data2+data3);

%plot image
figure
[~, range]=plotSEM(data,header);
title('4 channels')

%% Do the same for current

[header, dataFC] = loadsxm(fn, 0);
[dataFC, mn0, stdev0, slope0] = processSEM(dataFC);

%plot image
figure
plotSEM(dataFC,header);
title('Field current');

%% 5 channels
%Add datas
data = 1/2*(data+dataFC);

%plot image
figure
plotSEM(data,header);
title('5 channels')

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




