%---------------------------------------------
%   This files load a STM image and plot the various data
%
%
%
%
%---------------------------------------------

clear all;
close all;

%% load image

%image name
fn='Data/DataC2/2015-03-04/image004.sxm';%1-2;4;9
file = load.loadProcessedSxM(fn,0);

%% plot data

%print mean and stdev for data 0
figure        
plot(file.channels(1).median)   
title('median Z');

figure        
plot(nanstd(file.channels(1).data,0,2)) 
title('std Z');

%plot image
figure
[~, range] = plot.plotFile(file,1);

%plot histogram
figure
plot.plotHistogram(file.channels(1).data,range);
title('Z height')




%{
%% plot distributions
chanN=0;

[header, data] = loadsxm(fn, chanN);

%plot histogram
figure
histogram(data,50)

v=axis();

v(4)=v(4)/512;
figure
for i= 1:10:150
histogram(data(i,:),50)
axis(v);
pause(.1);
    
end
%}