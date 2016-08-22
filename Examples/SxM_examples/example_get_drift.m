%--------------------------------------------------------------------------
%   This files detects the drift
%
%
%
%
%--------------------------------------------------------------------------

%% add NanoLib
addpath('../../NanoLib/')

%% Load two images
file1=sxm.load.loadProcessedSxM('../Files/Si_7x7_028.sxm');
file2=sxm.load.loadProcessedSxM('../Files/Si_7x7_032.sxm');

iCh1 = utility.getChannel(file1.channels,'Z','forward');
iCh2 = utility.getChannel(file2.channels,'Z','forward');

% Remove peaks
file1.channels(iCh1).data=sxm.op.interpPeaks(file1.channels(iCh1).data);
file2.channels(iCh2).data=sxm.op.interpPeaks(file2.channels(iCh2).data);

%% Plot Figures
figure('Name','File 1');
sxm.plot.plotFile(file1,iCh1);
colormap(sxm.op.nanonisMap(128));
figure('Name','File 2');
sxm.plot.plotFile(file2,iCh2);
colormap(sxm.op.nanonisMap(128));
%% Get offset
[offset,XC]=sxm.op.getOffset(file1.channels(iCh1).data,file1.header,...
    file2.channels(iCh2).data,file2.header);

% plot cross correlation
figure('Name','Cross Correlation');
imagesc(XC)
axis image

% plot two images
figure('Name','Superposition');
sxm.plot.plotFile(file2,iCh2);
hold on
sxm.plot.plotFile(file1,iCh1,-offset(1),-offset(2));
colormap(sxm.op.nanonisMap(128));