function experiment_list = getAllExperiments()

% get path of the NanoLib directory
mp = path;
iN = strfind(mp,'NanoLib');
nanoPath = strsplit(mp(1:iN+6),':');

allExperiments = dir(sprintf('%s/%s',nanoPath{end},'+dat/+load/experiment_*.m'));

experiment_list = cell(numel(allExperiments),2);
for i = 1:numel(allExperiments)
    fn = str2func(sprintf('dat.load.%s',allExperiments(i).name(1:end-2)));
    
    experiment_list{i,1} = fn('get experiment');
    experiment_list{i,2} = sprintf('dat.load.%s',allExperiments(i).name(1:end-2));
end
