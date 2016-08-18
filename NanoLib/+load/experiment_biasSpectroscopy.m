function varargout = experiment_biasSpectroscopy(action,varargin)

narginchk(1,3)

switch action
    
    case 'get experiment'
        varargout{1} = 'bias spectroscopy';
    
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
header.sweep_signal = 'Bias (V)';

% user defined informations specific for experiment
Date=strsplit(datasForKey('Date'),' ');
header.rec_date=Date{1}; header.rec_time=Date{2};
header.user = datasForKey('User');

% ->> still to finish
% header.points = str2double(datasForKey('Points'));

end

% data for longterm are already good
function [header,experiment] = processData(header,experiment)
fprintf('%s\n','add information for sweep forward');
for i = 2:2:numel(header.channels);
    chn = header.channels{i};
    iBrkt = strfind(chn,'(');
    header.channels{i} = [chn(1:iBrkt-1),'[fwd]',chn(iBrkt-1:end)];
end
end