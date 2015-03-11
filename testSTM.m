
clear all;
close all;

%image name
fn='Data/DataC2/2015-03-04/image008.sxm';%1-2;4;9

[data0,header, mn0,std0, slope0] = loadSTM(fn, 0);
%print header infos
header.data_info


%print mean and stdev for data 0

figure        
plot(mn0)   
title('median Z');

figure        
plot(std0) 
title('std Z');

figure
[~, range] = plotSTM(data0,header);
title('Z height')

%plot histogram
figure
plotHistogram(data0,range);
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