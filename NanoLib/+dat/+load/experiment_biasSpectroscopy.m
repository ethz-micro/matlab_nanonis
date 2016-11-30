function varargout = experiment_biasSpectroscopy(action,varargin)

narginchk(1,3)

switch action
    
    case 'get experiment'
        varargout{1} = 'bias spectroscopy';
    
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

function header = processHeader(header)

% grid information
header.grid_points = 1;

% parameters 
header.sweep_signal = 'Bias (V)';

% user defined informations specific for experiment

end

% process Data
function [header,channels] = processData(header,data)
channels = struct;
i = 1; % first is time
chnName = strsplit(header.channels{i},{'(',')'});
channels(i).Name = strtrim(chnName{1});
channels(i).Unit = chnName{2};
channels(i).Direction = 'both';
channels(i).data = data(:,i);

for i = 2:size(data,2);
    ib = strfind(header.channels{i},'[bwd]');
    if isempty(ib)
        chnName = strsplit(header.channels{i},{'(',')'});
        channels(i).Name = strcat(chnName{1},chnName{3});
        channels(i).Unit = chnName{2};
        channels(i).Direction = 'forward';
    else
        chnName = header.channels{i};
        chnName(ib:ib+5) = [];
        chnName = strsplit(chnName,{'(',')'});
        channels(i).Name = strcat(chnName{1},chnName{3});
        channels(i).Unit = chnName{2};
        channels(i).Direction = 'backward';
        channels(i).data = data(:,i);
    end
    channels(i).data = data(:,i); 
end
end