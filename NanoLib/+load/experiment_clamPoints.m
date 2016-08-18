function varargout = experiment_clamPoints(action,varargin)

narginchk(1,3)

switch action
    
    case 'get experiment'
        varargout{1} = 'CLAMPoints-dat';
    
    case 'get header'
        header = varargin{1};
        datasForKey = varargin{2};
        varargout{1} =  readHeader(header,datasForKey);
        
    case 'process data'
        header = varargin{1};
        experiment = varargin{2};
        [header,experiment] = processData(header,experiment);
        varargout{1} = header;
        varargout{2} = experiment;
        
    otherwise
        error('action should be: get header, process data')
        
end


end

function header = readHeader(header,datasForKey)

% grid information
header.grid_points = 1;
header.loops = 1; % 2016.04.03

% parameters
header.sweep_signal = 'Energy';

% user defined informations
Date=strsplit(datasForKey('Date'),' ');
header.rec_date=Date{1}; header.rec_time=Date{2};
header.user = datasForKey('User');

header.tip_information = strtok(datasForKey('Tip Information'),'""');
header.sample_material = strtok(datasForKey('Sample material'),'""');

% energy analysis informations
cmode = {'CAE';'CRR'};
header.clam_mode = cmode(str2double(datasForKey('CLAM Mode'))+1);
header.pass_energy = str2double(datasForKey('Pass Energy (eV)'));
header.retarding_ratio = str2double(datasForKey('Retarding Ratio'));
header.focus_mode = sprintf('1:%d',str2double(datasForKey('Focus Mode')));
header.focus_prcnt = str2double(datasForKey('Focus (%)'));
header.channeltron_front = str2double(datasForKey('Channeltron front (V)'));
header.channeltron_rear = str2double(datasForKey('Channeltron rear (V)'));
header.integration_time = str2double(datasForKey('Integration Time (ms)'));

end

function [header,experiment] = processData(header,experiment)
[header,experiment] = split_loops(header,experiment);
[header,experiment] = split_fwd_bwd(header,experiment);
end

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

