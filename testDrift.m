close all;
clear all;

file4=load.loadProcessedSxM('Data/March/2015-03-02/image004.sxm');
file9=load.loadProcessedSxM('Data/March/2015-03-02/image009.sxm');

[offset,XC]=op.getOffset(file4.channels(1).data,file4.header,file9.channels(1).data,file9.header);
figure
imagesc(XC)
%%
figure
plot.plotChannel(file4,1);
hold on
plot.plotChannel(file9,1,offset(1),offset(2));

