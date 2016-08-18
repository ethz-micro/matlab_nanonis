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
header.sweep_signal = 'Time (ms)';
header.sampling_time = str2double(datasForKey('Sample Period (ms)'));
header.sampling_time_unit = '(ms)';


% user defined informations
Date=strsplit(datasForKey('Date'),' ');
header.rec_date=Date{1}; header.rec_time=Date{2};
header.user = datasForKey('User');

end

% data for longterm are already good
function [header,experiment] = processData(header,experiment)

% add sweep signal
signalName = header.sweep_signal;
signalValues = (0:length(experiment.data(:,1))-1)'*header.sampling_time/1000;
[header,experiment] = addSignal(header,experiment,signalName,signalValues);

end

% add first row: signal name
function [header,experiment] = addSignal(header,experiment,signalName,signalValues)

header.channels = [signalName header.channels];
newData = [signalValues,experiment.data];

experiment.data = newData;

end