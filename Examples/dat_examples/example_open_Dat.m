%--------------------------------------------------------------------------
%   This files opens all already supported dat experiments
%
%
%
%
%--------------------------------------------------------------------------

%% add NanoLib
addpath('../../NanoLib/')

%% Load HystoryData
file1=dat.load.loadProcessedDat('HistoryData.dat','../Files/');
iCh = utility.getChannel(file1.channels,'Current');
figure; dat.plot.plotFile(file1,iCh);

%return
%% Load Spectrum
file2=dat.load.loadProcessedDat('../Files/Spectrum.dat');
iCh = utility.getChannel(file2.channels,'Current');
figure; 
dat.plot.plotChannel(file2,file2.channels(iCh),'Color','r',...
    'hideLabels','DisplayName',file2.channels(iCh).Name);
xlabel(sprintf('%s in %s',file2.channels(1).Name,file2.channels(1).Unit));
ylabel(sprintf('%s in %s',file2.channels(iCh).Name,file2.channels(iCh).Unit));

%% Load Oscilloscope
file3=dat.load.loadProcessedDat('../Files/Oscilloscope.dat');
%
iCh = utility.getChannel(file3.channels,'Current');
figure;
dat.plot.plotData(file3.channels(iCh).data,file3.channels(iCh).Name,...
    file3.channels(iCh).Unit,file3.channels(1),'LineStyle','-','MarkerSize',6);

%% Load LongTerm
file4=dat.load.loadProcessedDat('../Files/LongTerm.dat');
iCh = utility.getChannel(file4.channels,'Z');
figure; dat.plot.plotFile(file4,iCh);


%% Load Bias-Spectroscopy
file5=dat.load.loadProcessedDat('../Files/Bias-Spectroscopy.dat');
iCh = utility.getChannel(file5.channels,'Current','forward');
figure; hold on; dat.plot.plotFile(file5,iCh);

%% combine channels
iCh = [2,3];
figure; hold on; dat.plot.plotFile(file5,iCh);
combined_channels = utility.combineChannel(file5,'count fwd+bwd',[2,3],[1,1]);
dat.plot.plotChannel(file5,combined_channels);

%% example of user defined experiments

%% Load LongTerm
file6=dat.load.loadProcessedDat('../Files/myLongTerm.dat');
iCh = utility.getChannel(file6.channels,'Z');
figure; dat.plot.plotFile(file6,iCh);

%% Load clamSpectra
file7=dat.load.loadProcessedDat('../Files/clamSpectra1.dat');
iCh = utility.getChannel(file7.channels,'CLAM');%,'backward');
figure; hold on; dat.plot.plotFile(file7,iCh);

%% Load clamSpectra
file8=dat.load.loadProcessedDat('../Files/WinOS-EA-003.txt');
iCh = utility.getChannel(file8.channels,'counts');%,'backward');
figure; hold on; dat.plot.plotFile(file8,iCh);
