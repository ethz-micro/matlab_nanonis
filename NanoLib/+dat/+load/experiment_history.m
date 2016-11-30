function varargout = experiment_history(action,varargin)

narginchk(1,3)

switch action
    
    case 'get experiment'
        varargout{1} = 'History Data';
    
    case 'process header'
        header = varargin{1};     
        varargout{1} =  processHeader(header);
        
    case 'process data'
        header = varargin{1};
        data = varargin{2}; 
        [header,channels] = processData(header,data);
        varargout{1} = header;
        varargout{2} = channels;
        
    otherwise
        error('action should be: process header, process data')
        
end

end

% process header
function header = processHeader(header)

% parameters from header
header.sampling_time = str2double(header.sample_period__ms_);

% user defined informations

end

% process data
function [header,channels] = processData(header,data)

channels = struct;
% add sweep signal to channels
channels(1).Name = 'Time';
channels(1).Unit = 's'; % !!! units changed to s !!!
channels(1).Direction = 'forward';
channels(1).data = (0:size(data,1)-1)'*header.sampling_time/1000;

% add data to channels
for i = 1:size(data,2);
    chnName = regexp(header.channels{i}, '(?<name>.*?)+\((?<unit>.*?)\)','names');
    channels(1+i).Name = strtrim(chnName.name);
    channels(1+i).Unit = chnName.unit;
    channels(1+i).Direction = 'forward';
    channels(1+i).data = data(:,i);
end

% update header.channels
header.channels = [...
    sprintf('s (%s)',channels(1).Name,channels(1).Unit),...
    header.channels];
end