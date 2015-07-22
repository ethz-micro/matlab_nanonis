close all;
file = load.loadProcessedSxM('Data/2015_05_13/FE_Pol-N_T-50us_V-60V_001.sxm');

channel=op.combineChannel(file,'On Plane',[3 7],[1 -1]);

channel.data=blurData(channel.data,10);

%channel.data=channel.data-median(channel.data(:));
figure
plot.plotChannel(channel,file.header)
%{
data=channel.data;
figure
histogram(data,floor(prctile(data(:),1)):floor(prctile(data(:),99)))

data=file.channels(7).data;
figure
histogram(data,floor(prctile(data(:),1)):floor(prctile(data(:),99)))
figure
histogram(slidingmean,floor(prctile(slidingmean(:),1)):floor(prctile(slidingmean(:),99)))
%}