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
file1=load.loadDat('../Files/HistoryData.dat');
%
figure
% plot(file1.experiment.data(:,1),file1.experiment.data(:,2))
plotDat.plotChannel(file1,1);

%% Load Spectrum
file2=load.loadDat('../Files/Spectrum.dat');
%
figure
plot(file2.experiment.data(:,1),file2.experiment.data(:,2))

%% Load Spectrum
file3=load.loadDat('../Files/Oscilloscope.dat');
%
figure
plot(file3.experiment.data(:,1),file3.experiment.data(:,2))

%% Load LongTerm
file4=load.loadDat('../Files/LongTerm.dat');
%
figure
plot(file4.experiment.data(:,1),file4.experiment.data(:,2))

%% Load LongTerm
file5=load.loadDat('../Files/myLongTerm.dat');
%
figure
plot(file5.experiment.data(:,1),file5.experiment.data(:,2))

%% Load Bias-Spectroscopy
file6=load.loadDat('../Files/Bias-Spectroscopy.dat');
%
figure
plot(file6.experiment.data(:,1),file6.experiment.data(:,2))

%% Load clamSpectra
file7=load.loadDat('../Files/clamSpectra.dat');
%
figure
plot(file7.experiment.data(:,1),file7.experiment.data(:,6))
