function varargout = experiment_oscilloscope(action,varargin)

narginchk(1,3)

switch action
    
    case 'get experiment'
        varargout{1} = 'Oscilloscope';
    
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

% Oscilloscope Informations
header.AC = str2double(datasForKey('AC'));
header.DC = str2double(datasForKey('DC'));
header.PkPk = str2double(datasForKey('Pk-Pk'));
header.Signal_Unit = datasForKey('Signal Unit');

end

% data for longterm are already good
function [header,experiment] = processData(header,experiment)
    fprintf('nothing done at data \n');
end