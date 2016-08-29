function varargout = experiment_longTerm(action,varargin)

narginchk(1,3)

switch action
    
    case 'get experiment'
        varargout{1} = 'LongTerm Data';
    
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
        error('action should be: get header, process data')
        
end


end

function header = processHeader(header)

% grid information
header.grid_points = 1;

% parameters 
header.sweep_signal = 'Time';
timeStamp = strsplit(header.base_timestamp,' ');
header.base_timestamp_date=timeStamp{1};
header.base_timestamp_time=timeStamp{2};

% user defined informations
Date=strsplit(header.date,' ');
header.rec_date=Date{1};
header.rec_time=Date{2};

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