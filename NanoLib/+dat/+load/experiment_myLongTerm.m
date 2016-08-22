function varargout = experiment_myLongTerm(action,varargin)

narginchk(1,3)

switch action
    
    case 'get experiment'
        varargout{1} = 'myLongTerm';
    
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

% parameters 
header.sweep_signal = 'Time (s)';

% user defined informations
Date=strsplit(datasForKey('Date'),' ');
header.rec_date=Date{1}; header.rec_time=Date{2};
header.user = datasForKey('User');
header.tip_information = strtok(datasForKey('Tip Information'),'""');
header.sample_material = strtok(datasForKey('Sample material'),'""');

end

% process Data
function [header,channels] = processData(header,data)
channels = struct;
for i = 1:size(data,2);
    chnName = strsplit(header.channels{i}(1:end-1),'(');
    channels(i).Name = strtrim(chnName{1});
    channels(i).Unit = chnName{2};
    channels(i).Direction = 'forward';
    channels(i).data = data(:,i);
end
end