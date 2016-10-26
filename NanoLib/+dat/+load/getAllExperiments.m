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

% October 2016

%------------- BEGIN CODE --------------

fn = '+dat/+load/datSettings.txt';
if exist(fn,'file') == 2
    flist = importdata(fn,'\t');
    flist = cellfun(@(x) strsplit(x,'\t'),{flist{:}},'UniformOutput',false);
    allPath = cellfun(@(x) x{2},flist,'UniformOutput',false);
else
    [nanoLib,userNanoLib]=dat.load.setSettings();
    allPath = {nanoLib;userNanoLib};
end

if strcmp(allPath{2},'none')
    allPath = (allPath(1));
else
    addpath(allPath{2});
end

i = 1;
for j = 1:numel(allPath)
    baseNanoPath = allPath{j};
    nanoPath = strsplit(findLoad(baseNanoPath,''),';');
    for k = 1:numel(nanoPath)
        nanoList{i} = getList(baseNanoPath,nanoPath{k});
        i = i + 1;
    end
end

experimentList = cat(1,nanoList{:});
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