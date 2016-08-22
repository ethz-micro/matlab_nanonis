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
file1=dat.load.loadDat('HistoryData.dat','../Files/');
iCh = utility.getChannel(file1.channels,'Current');
figure; dat.plot.plotFile(file1,iCh);

%% Load Spectrum
file2=dat.load.loadDat('../Files/Spectrum.dat');
iCh = utility.getChannel(file2.channels,'Current');
figure; dat.plot.plotFile(file2,iCh);

%% Load Spectrum
file3=dat.load.loadDat('../Files/Oscilloscope.dat');
iCh = utility.getChannel(file3.channels,'Current');
figure; dat.plot.plotFile(file3,iCh);

%% Load LongTerm
file4=dat.load.loadDat('../Files/LongTerm.dat');
iCh = utility.getChannel(file4.channels,'Z');
figure; dat.plot.plotFile(file4,iCh);


%% Load Bias-Spectroscopy
file5=dat.load.loadDat('../Files/Bias-Spectroscopy.dat');
iCh = utility.getChannel(file5.channels,'Current','forward');
figure; hold on; dat.plot.plotFile(file5,iCh);

%% combine channels
iCh = [2,3];
figure; hold on; dat.plot.plotFile(file5,iCh);
combined_channels = sxm.op.combineChannel(file5,'count fwd+bwd',[2,3],[1,1]);
dat.plot.plotChannel(combined_channels,file5.channels(1))

%% example of user defined experiments

%% Load LongTerm
file6=dat.load.loadDat('../Files/myLongTerm.dat');
iCh = utility.getChannel(file6.channels,'Z');
figure; dat.plot.plotFile(file6,iCh);

%% Load clamSpectra
file7=dat.load.loadDat('../Files/clamSpectra00003.dat');
iCh = utility.getChannel(file7.channels,'CLAM');%,'backward');
figure; hold on; dat.plot.plotFile(file7,iCh);

%% Load clamSpectra
file8=dat.load.loadDat('../Files/WinOS-EA-003.txt');

