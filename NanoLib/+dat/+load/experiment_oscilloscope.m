function varargout = experiment_oscilloscope(action,varargin)

narginchk(1,3)

switch action
    
    case 'get experiment'
        varargout{1} = 'Oscilloscope';
    
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

end

% process data
function [header,channels] = processData(header,data)
channels = struct;
for i = 1:size(data,2);
    chnName = regexp(header.channels{i}, '(?<name>.*?)+\((?<unit>.*?)\)','names');
    channels(i).Name = strtrim(chnName.name);
    channels(i).Unit = chnName.unit;
    channels(i).Direction = 'forward';
    channels(i).data = data(:,i);
end
end