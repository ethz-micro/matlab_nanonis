function varargout = experiment_history(action,varargin)

narginchk(1,3)

switch action
    
    case 'get experiment'
        varargout{1} = 'History Data';
    
    case 'get header'
        header = varargin{1};
        datasForKey = varargin{2};        
        varargout{1} =  readHeader(header,datasForKey);
        
    case 'process data'
        header = varargin{1};
        data = varargin{2}; 
        [header,channels] = processData(header,data);
        varargout{1} = header;
        varargout{2} = channels;
        
    otherwise
        error('action should be: get header, process data')
        
end


end

function header = readHeader(header,datasForKey)

% grid information
header.grid_points = 1;

% parameters 
header.sweep_signal = 'Time (ms)';
header.sampling_time = str2double(datasForKey('Sample Period (ms)'));
header.sampling_time_unit = '(ms)';


% user defined informations
Date=strsplit(datasForKey('Date'),' ');
header.rec_date=Date{1}; header.rec_time=Date{2};
header.user = datasForKey('User');

end

% data for longterm are already good
function [header,channels] = processData(header,data)

% add sweep signal
signalName = header.sweep_signal;
header.channels = [signalName header.channels];


channels = struct;
% add sweep signal to channels
chnName = strsplit(signalName(1:end-1),'(');
channels(1).Name = strtrim(chnName{1});
channels(1).Unit = chnName{2};
channels(1).Direction = 'forward';
channels(1).data = (0:size(data,1)-1)'*header.sampling_time/1000;
% !!! units changed to s !!!
channels(1).Unit = 's';

for i = 1:size(data,2);
    chnName = strsplit(header.channels{i}(1:end-1),'(');
    channels(1+i).Name = strtrim(chnName{1});
    channels(1+i).Unit = chnName{2};
    channels(1+i).Direction = 'forward';
    channels(1+i).data = data(:,i);
end
end