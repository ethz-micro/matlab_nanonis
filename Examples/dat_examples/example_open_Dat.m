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
file1=dat.load.loadDat('../Files/HistoryData.dat');
iCh = utility.getChannel(file1.channels,'Current');
figure; dat.plot.plotChannel(file1,iCh);

%% Load Spectrum
file2=dat.load.loadDat('../Files/Spectrum.dat');
iCh = utility.getChannel(file2.channels,'Current');
figure; dat.plot.plotChannel(file2,iCh);

%% Load Spectrum
file3=dat.load.loadDat('../Files/Oscilloscope.dat');
iCh = utility.getChannel(file3.channels,'Current');
figure; dat.plot.plotChannel(file3,iCh);

%% Load LongTerm
file4=dat.load.loadDat('../Files/LongTerm.dat');
iCh = utility.getChannel(file4.channels,'Z');
figure; dat.plot.plotChannel(file4,iCh);

%% Load LongTerm
file5=dat.load.loadDat('../Files/myLongTerm.dat');
iCh = utility.getChannel(file5.channels,'Z');
figure; dat.plot.plotChannel(file5,iCh);

%% Load Bias-Spectroscopy
file6=dat.load.loadDat('../Files/Bias-Spectroscopy.dat');
iCh = utility.getChannel(file6.channels,'Current','forward');
figure; hold on; dat.plot.plotChannel(file6,iCh);

%% Load clamSpectra
file7=dat.load.loadDat('../Files/clamSpectra.dat');
iCh = utility.getChannel(file7.channels,'Counter');%,'backward');
figure; hold on; dat.plot.plotChannel(file7,iCh);

%% Load clamSpectra
file8=dat.load.loadDat('../Files/WinOS-EA-003.txt');
iCh = utility.getChannel(file8.channels,'Counts');%,'backward');
figure; hold on; dat.plot.plotChannel(file8,iCh);
