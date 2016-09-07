function varargout = experiment_clamPoints_pyton(action,varargin)

narginchk(1,3)

switch action
    
    case 'get experiment'
        varargout{1} = 'CLAM-python-txt';
    
    case 'process header'
        header = varargin{1};
        varargout{1} =  processHeader(header);
        
    case 'process data'
        header = varargin{1};
        experiment = varargin{2};
        [header,experiment] = processData(header,experiment);
        varargout{1} = header;
        varargout{2} = experiment;
        
    otherwise
        error('action should be: process header, process data')
        
end

end

% process header
function header = processHeader(header)

% parameters from header

% user defined informations
Date=strsplit(header.date,' ');
header.rec_date=Date{1};
header.rec_time=Date{2};

% energy information
header.focus_mode = sprintf('1:%s',header.focus_mode);
header.loops = str2double(header.loops);

end

function [header,channels] = processData(header,data)

[header,channels] = split_loops(header,data);
[header,channels] = split_fwd_bwd(header,channels);

end


function [header,channels] = split_loops(header,data)
channels = struct;
loops = header.loops/2;
if loops > 1
    pti = size(data,1)/loops;
    for i = 1:size(data,2);
        chnName = strsplit(header.channels{i},{'[',']'});
        if numel(chnName) == 3
            channels(i).Name = strcat(chnName{1},chnName{3});
            channels(i).Unit = chnName{2};
        else
            channels(i).Name = chnName{1};
            channels(i).Unit = '';
        end
        channels(i).Direction = 'forward';
        channels(i).data = reshape(data(:,i),pti,loops);
    end
else
    for i = 1:size(data,2);
        chnName = strsplit(header.channels{i},{'[',']'});
        if numel(chnName) == 3
            channels(i).Name = strcat(chnName{1},chnName{3});
            channels(i).Unit = chnName{2};
        else
            channels(i).Name = chnName{1};
            channels(i).Unit = '';
        end
        channels(i).Direction = 'forward';
        channels(i).data = data(:,i);
    end
end

end

function [header,channels] = split_fwd_bwd(header,raw_chn)


sweepMax = find(raw_chn(1).data(:,1)==max(raw_chn(1).data(:,1)),1,'last');
if sweepMax ~= length(raw_chn(1).data)
%if channels(1).data(1,1)==channels(1).data(end,1)
    % find maximal values
    % !!! one can have more points per energy !!!
    maxV = find(raw_chn(1).data(:,1)==max(raw_chn(1).data(:,1)));
    imax = maxV(floor(end/2));
    xup = raw_chn(1).data(1:imax,1);
    xdown = raw_chn(1).data(imax+1:end,1);
        
    energies = unique(raw_chn(1).data(:,1));

    channels = struct;
    for i = 1:numel(raw_chn)
        k = 2*(i-1)+1;
        % forward
        channels(k).Name = raw_chn(i).Name;
        channels(k).Unit = raw_chn(i).Unit;
        channels(k).Direction = 'forward';
        channels(k).data = nan(length(energies),1);
        % do mean        
        yup = raw_chn(i).data(1:imax);
        for j = 1:length(energies)
            channels(k).data(j) = mean(yup(xup==energies(j)));
        end
        % backward
        channels(k+1).Name = raw_chn(i).Name;
        channels(k+1).Unit = raw_chn(i).Unit;
        channels(k+1).Direction = 'backward';
        channels(k+1).data = nan(length(energies),1);
        % do mean
        ydown = raw_chn(i).data(imax+1:end);
        for j = 1:length(energies)
            channels(k+1).data(j) = mean(ydown(xdown==energies(j)));
        end
    end
    
else
    fprintf('only forward\n');
end

chnName = repmat(header.channels',1,2);
header.channels = reshape(chnName',2*numel(header.channels),1)';

%% remove energy backward
channels(2) = [];
header.channels(2) = [];

end


%{
function [header,experiment] = split_fwd_bwd(header,experiment)

if experiment.data(1,1)==experiment.data(end,1)
    channels = cell(1,2*numel(header.channels));
    
    maxV = find(experiment.data(:,1)==max(experiment.data(:,1)));
    imax = maxV(floor(end/2));
    energies = unique(experiment.data(:,1));
    data = nan(length(energies),2*numel(header.channels));
    for ii = 1:numel(header.channels)
        channels{(ii-1)*2+1} = sprintf('%s (fwd)', header.channels{ii});
        channels{ii*2} = sprintf('%s (bwd)', header.channels{ii});
        
        % do mean
        xup = experiment.data(1:imax,1);
        yup = experiment.data(1:imax,ii);
        for jj = 1:length(energies)
            data(jj,(ii-1)*2+1) = mean(yup(xup==energies(jj)));
        end
        xup = experiment.data(imax+1:end,1);
        yup = experiment.data(imax+1:end,ii);
        for jj = 1:length(energies)
            data(jj,ii*2) = mean(yup(xup==energies(jj)));
        end
    end
    
else
    channels = cell(1,numel(header.channels));
    for ii = 1:numel(header.channels)
        channels{ii} = sprintf('%s (fwd)', header.channels{ii});
    end
    energies = unique(experiment.data(:,1));
    data = nan(length(energies),numel(header.channels));
    xup = experiment.data(:,1);
    yup = experiment.data(:,ii);
    for jj = 1:length(energies)
        data(:,ii*2) = mean(yup(xup==energies(jj)));
    end
end

experiment.data = data;
header.channels = channels;

end

function [header,experiment] = split_loops(header,experiment)
loops = header.loops/2;
if loops > 1
    
    loopsName = arrayfun(@(x) sprintf('Counts %d',x),1:loops,'UniformOutput',false');
    channels = [header.channels(1),loopsName,header.channels(3:end)];
    
    pti = size(experiment.data,1)/loops;
    data = [experiment.data(1:pti,1),...
        reshape(experiment.data(:,2),pti,loops)...
        experiment.data(1:pti,3:end)];
    
    experiment.data = data;
    header.channels = channels;
    
end

end
%}
