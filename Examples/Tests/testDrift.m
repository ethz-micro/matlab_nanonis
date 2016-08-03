%---------------------------------------------
%   This files detects the drift
%
%
%
%
%---------------------------------------------

close all;
clear all;

%Load two images
file4=loadSxM.loadProcessedSxM('Data/March/2015-03-02/image004.sxm');
file9=loadSxM.loadProcessedSxM('Data/March/2015-03-02/image009.sxm');

%Remove peaks
file4.channels(1).data=op.interpPeaks(file4.channels(1).data);
file9.channels(1).data=op.interpPeaks(file9.channels(1).data);
%Get offset
[offset,XC]=op.getOffset(file4.channels(1).data,file4.header,file9.channels(1).data,file9.header);

%plot cross correlation
figure
imagesc(XC)
axis image

%%
%plot two images
figure
plotSxM.plotFile(file9,1);
hold on
plotSxM.plotFile(file4,1,-offset(1),-offset(2));

%%
figure
plotSxM.plotFile(file4,1);
figure
plotSxM.plotFile(file9,1);

