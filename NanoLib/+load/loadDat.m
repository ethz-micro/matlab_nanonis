% read data file saved with nanonis
function myData=loadDat(varargin)
% varargin{1} = filename
% varargin{2} = pathname

% open document
if isempty(varargin)
    [fN,pN] = uigetfile('*.dat');
    if isequal(fN,0)
        disp('User selected Cancel')
        myData = nan;
        return
    end
elseif length(varargin) == 1
    if strcmp(getenv('OS'),'Windows_NT')
        pN = [pwd,'\']; %pwd: print working directory
    else
        pN = [pwd,'/']; %pwd: print working directory
    end
    fN = varargin{1};
else
    pN = varargin{2};
    fN = varargin{1};
end

display(['read file: ' fN]);

% get header
fileName = [pN,fN];
[header,iLine,experiment_fnc] = getHeader(fileName);

% get data
inputData = importdata(fileName,'\t',iLine);

header.channels = inputData.colheaders;
experiment.data = inputData.data;

% process data if needed
[header,experiment] = experiment_fnc('process data',header,experiment);

%add number of points to header
header.points = size(experiment.data,1);

% save file info to header
header.path = pN;
header.file = fN;

% save to output
myData = struct('header',header,'experiment',experiment);

end

% define function for experiment
function experiment_fnc = getExperiment(experiment)

% list of experiments
%{
    % version 0
    experiment_list = {
        'bias spectroscopy', 'load.experiment_biasSpectroscopy';
        'LongTerm Data',     'load.experiment_longTerm';
        'myLongTerm',        'load.experiment_myLongTerm';
        'LongTerm',          'readMyLongTermHeader'; % find such file!
        'History Data',      'load.experiment_history';
        'CLAMPoints-dat',    'load.experiment_clamPoints';
        'CLAM-python-txt',   'load.experiment_clamPoints_pyton';
        'Spectrum',          'load.experiment_spectrum';
        'Oscilloscope',      'load.experiment_oscilloscope';
    };
%}
experiment_list = load.getAllExperiments();

%Create header
experiment_name = @(x) experiment_list{strcmp(x,experiment_list(:,1)),2};

fprintf('Use function: %s\n',experiment_name(experiment));

experiment_fnc = str2func(experiment_name(experiment));

end

function [header,hLine,experiment_fnc] = getHeader(fileName)

% open file
fid = fopen(fileName);

% read file header
hLine = 0;
tLine = fgets(fid);
while ~strcmp(strtrim(tLine),'[DATA]')
    hLine = hLine+1;
    %header{hLine} = tLine;
    switch fileName(end-2:end)
        case 'dat'
            sLine = strsplit(tLine(1:end-3),'\t'); % last 4 characters are \t\n
        case 'txt'
            sLine = strsplit(tLine(1:end-2),'\t'); % last 2 characters are \t\n
        otherwise
            error('not allowd format');
    end
    %fprintf('%s \n',tLine);
    header.list(hLine,:) = {sLine{1},sLine{2:end}};
    tLine = fgets(fid);
end

hLine = hLine+2;

%close file
fclose(fid);

% Default parameters values in the header.
header.grid_points = 1; % dafault value
header.sweep_signal = 'define sweep signal'; % default value

% interprete header according to specific experiments
% function for extract datas from header at a given key
datasForKey= @(x) header.list{strcmp(x,header.list(:,1)),2};
% get experiment name
header.experiment = datasForKey('Experiment');
% get function for specific experiemt
experiment_fnc = getExperiment(header.experiment);
% read header
header = experiment_fnc('get header',header,datasForKey);

end


