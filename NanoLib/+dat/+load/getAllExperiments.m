function experimentList = getAllExperiments()
%GETALLEXPERIMENTS - seraches for the functions called experiments_type
% within the NanoLib libreary. Additionally this function looks for user
% defined package folder in the matlab_nanonis_experiments folder which
% may be created in the same folder where the project was cloned.
% 
% Syntax: 
%   experimentList = GETALLEXPERIMENTS()
%
% Inputs:
%   -
%
% Outputs:
%   experimentList - 2 x n list, where n is the number of the function 
%      experiment_type. In the first column is listed the unique name
%      of the experiment. In the second column is the correspondent function.
%
% Note: This function is used by the function loadProcessedDat when loading different
%   experiments.
%
% See also loadProcessedDat

% September 2016

%------------- BEGIN CODE --------------

% semicolon
sc = ':';
if ispc
    sc = ';';
end

% get path of the NanoLib directory
mp = strsplit(path,sc);

% get NanoLib Experiments
iN = strfind(mp,'NanoLib');
if cellfun('isempty', iN)
    nanoList={[]};
else
    baseNanoPath = mp{not(cellfun('isempty', iN))};
    nanoPath = strsplit(findLoad(baseNanoPath,''),';');
    for i = 1:numel(nanoPath)
        nanoList{i} = getList(baseNanoPath,nanoPath{i});
    end
end

% get user define experiments
iN = strfind(mp,'matlab_nanonis_experiments');
if cellfun('isempty', iN)
    userNanoList={[]};
else
    baseNanoUserPath = mp{not(cellfun('isempty', iN))};
    nanoUserPath = strsplit(findLoad(baseNanoUserPath,''),';');
    for i = 1:numel(nanoUserPath)
        userNanoList{i} = getList(baseNanoUserPath,nanoUserPath{i});
    end
end

% set all experiments together
experimentList = cat(1,nanoList{:},userNanoList{:});

end

function experiment_list = getList(basePath,path)

allExperiments = dir(sprintf('%s/%s/%s',basePath,path,'experiment_*.m'));

path(strfind(path,'+')) = [];
path(strfind(path,'/')) = '.';

experiment_list = cell(numel(allExperiments),2);
for i = 1:numel(allExperiments)
    fn = str2func(sprintf('%s.%s',path,allExperiments(i).name(1:end-2)));
    
    experiment_list{i,1} = fn('get experiment');
    experiment_list{i,2} = sprintf('%s.%s',path,allExperiments(i).name(1:end-2));
end

end

function loadPath = findLoad(path,loadPath,basePath)

narginchk(2,3)
if nargin == 2
    basePath = path;
    ip = 1;
else
    ip = length(basePath)+2;
end


dirList = dir(path);
for i = 1 : numel(dirList)
    
    if dirList(i).isdir && strcmp(dirList(i).name,'+load')
        % fprintf('%s/%s\n',path,dirList(i).name)
        loadPath = sprintf('%s;%s/%s',loadPath,path(ip:end),dirList(i).name);
        return
    elseif dirList(i).isdir && strcmp(dirList(i).name(1),'+')
        % fprintf('%s/%s\n',path,dirList(i).name)
        loadPath = findLoad(sprintf('%s/%s',path(ip:end),dirList(i).name),loadPath,basePath);
    end
end

if strcmp(loadPath(1),';') %|| strcmp(loadPath(1),':')
    loadPath(1) = [];
end

end