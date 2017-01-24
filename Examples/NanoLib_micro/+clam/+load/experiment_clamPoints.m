function varargout = experiment_clamPoints(action,varargin)

narginchk(1,3)

switch action
    
    case 'get experiment'
        varargout{1} = 'CLAMPoints-dat';
    
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

% user defined informations
Date=strsplit(header.date,' ');
header.rec_date=Date{1};
header.rec_time=Date{2};

% energy informations
header.x__m_ = str2double(header.x__m_);
header.y__m_ = str2double(header.y__m_);
cmode = {'CAE';'CRR'};
header.clam_mode = cmode{str2double(header.clam_mode)+1};
header.pass_energy__ev_ = str2double(header.pass_energy__ev_);
header.retarding_ratio = str2double(header.retarding_ratio);
fmode = {'1:1';'1:3'};
header.focus_mode = fmode{1+str2double(header.focus_mode)};
try 
    header.focus__prcnt = str2double(header.focus____);
    header = rmfield(header,'focus____');
catch
    warning('new focuse mode');
end
header.channeltron_front__v_ = str2double(header.channeltron_front__v_);
header.channeltron_rear__v_ = str2double(header.channeltron_rear__v_);
header.integration_time__ms_ = str2double(header.integration_time__ms_);
try
    header.loops = str2double(header.loops);
catch
    header.loops = -1;
end
end

function [header,channels] = processData(header,data)

[header,channels] = split_loops(header,data);
[header,channels] = split_fwd_bwd(header,channels);

end

function [header,channels] = split_loops(header,data)
channels = struct;
if header.loops < 0
    %% try to get number of loops automatic
    x = data(:,1);
    nlps = 1;
    if rem(length(x),length(unique(x)))==0
        for lps = length(x)/length(unique(x)):-1:2
            if rem(length(x),lps)==0
                npti = length(x)/lps;
                dx = x(1:npti)-x(npti+1:2*npti);
                if dx==0
                    nlps = lps;
                    break
                end
            end
        end
    end
    header.loops = nlps;
end


if header.loops > 1
    pti = size(data,1)/header.loops;
    for i = 1:size(data,2)
        chnName = regexp(header.channels{i}, '(?<name>.*?)+\((?<unit>.*?)\)','names');
        channels(i).Name = strtrim(chnName.name);
        channels(i).Unit = chnName.unit;
        channels(i).Direction = 'forward';
        channels(i).data = reshape(data(:,i),pti,header.loops);
    end
else
    for i = 1:size(data,2)
        chnName = regexp(header.channels{i}, '(?<name>.*?)+\((?<unit>.*?)\)','names');
        channels(i).Name = strtrim(chnName.name);
        channels(i).Unit = chnName.unit;
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
        channels(k).data = nan(length(energies),header.loops);
        % backward
        channels(k+1).Name = raw_chn(i).Name;
        channels(k+1).Unit = raw_chn(i).Unit;
        channels(k+1).Direction = 'backward';
        channels(k+1).data = nan(length(energies),header.loops); 
        
        % save data
        for l = 1:header.loops
            
            % do mean
            yup = raw_chn(i).data(1:imax,l);
            for j = 1:length(energies)
                channels(k).data(j,l) = mean(yup(xup==energies(j)));
            end

            % do mean
            ydown = raw_chn(i).data(imax+1:end,l);
            for j = 1:length(energies)
                channels(k+1).data(j,l) = mean(ydown(xdown==energies(j)));
            end
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

