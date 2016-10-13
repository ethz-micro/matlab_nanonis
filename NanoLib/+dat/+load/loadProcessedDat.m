function file=loadProcessedDat(varargin)
%LOADPROCESSEDDAT - loads a file.dat calling the function loaddat.m 
% provided by Nanonis. And process the header and the data according
% to the type of experiment by calling – automatically – 
% the corresponding experiment_#.
% 
% Syntax: 
%   file = LOADPROCESSEDDAT() ask for a fileName.dat and load it.
%   file = LOADPROCESSEDDAT(fileName) load the file named fileName.dat.
%   file = LOADPROCESSEDDAT(fileName,pathName) load the file named 
%          fileName.dat at a given pathName.
%
% Inputs:
%    fileName - name of file.
%    pathName - path of the file
%
% Outputs:
%    file - structure with fields: header and channels
%
% Example:
%   file = dat.load.loaddat(fn);
%
% See also dat.plot.plotData.m

% September 2016

%------------- BEGIN CODE --------------

% open document
if isempty(varargin)
    [fN,pN] = uigetfile('*.dat');
    if isequal(fN,0)
        disp('User selected Cancel')
        file = nan;
        return
    end
elseif length(varargin) == 1
    % check if path and file are provided together
    [pN,fN,ext] = fileparts(varargin{1});
    
    fN = sprintf('%s%s',fN,ext);
    
    if isempty(pN)
        pN = pwd;
    end
    
    if strcmp(getenv('OS'),'Windows_NT')
        pN = [pN,'\']; %pwd: print working directory
    else
        pN = [pN,'/']; %pwd: print working directory
    end
    
else
    pN = varargin{2};
    fN = varargin{1};
end

display(['read file: ' fN]);

% get header
fileName = [pN,fN];

[header,data,channelsList] = dat.load.loaddat(fileName);

% Default parameters values in the header.
header.grid_points = 1; % dafault value
header.channels = channelsList;

% get function for specific experiemt
experiment_fnc = getExperiment(header.experiment);
% read header
header = experiment_fnc('process header',header);

% process data if needed
[header,channels] = experiment_fnc('process data',header,data);

%add number of points to header
header.points = size(channels(1).data,1);

% save file info to header
header.path = pN;
header.file = fN;

% save to output
file = struct('header',header,'channels',channels);

end

% define function for experiment
function experiment_fnc = getExperiment(experiment)

% list of experiments
experiment_list = dat.load.getAllExperiments();

experiment_name = @(x) experiment_list{strcmp(x,experiment_list(:,1)),2};
fprintf('Use function: %s\n',experiment_name(experiment));

experiment_fnc = str2func(experiment_name(experiment));

end
