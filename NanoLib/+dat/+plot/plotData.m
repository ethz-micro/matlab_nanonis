function hObject =  plotData(data,name,unit,x_channel,varargin)
%PLOTDATA - plots the data with name and unit according the the x_channel.
%   x_channel is a channel from a file loaded with
%   dat.load.loadProcessedDat.
%
% Syntax: 
%   hObject = PLOTDATA(data,name,unit,x_channel)
%   hObject = PLOTDATA(data,name,unit,x_channel,varargin)
%
% Inputs:
%    data - data in matrix/vector form to be plotted
%    name - string name of the data
%    unit - string unit of the data
%    x_channel - channel relative the x-axis
%    varargin - varargin are the same as for normal matlab plot function
%       additional options are:
%       varargin = {'loops',NUMBER}   : loops to display
%       varargin = {'xOffset',NUMBER} : shift of the x axis 
%       varargin = {'hideLabels'}     : leave labels out
%
% Outputs:
%    hObject - figure handle
%
% Example: 
%   file = dat.load.loadProcessedDat(fn);
%   data = norm(file.channels(2).data);
%   hObj = dat.plot.PLOTDATA(data,'normalized data','a.u.',file.channels(1));
%
% See also dat.load.loadProcessedDat

% September 2016

%------------- BEGIN CODE --------------

% search for options
xOffset = 0;
showLabels = true;
var2remove = nan(size(varargin,2),1);
loops = 1:size(data,2); % plot all loops as default
show_loops=length(loops);
for i = 1:size(varargin,2)
    if ischar(varargin{i})
        switch varargin{i}
            case 'loops'
                show_loops = varargin{i+1};
                var2remove(i) = i;
                var2remove(i+1) = i+1;
            case 'xOffset'
                xOffset = varargin{i+1};
                var2remove(i) = i;
                var2remove(i+1) = i+1;
            case 'hideLabels'
                showLabels = false;
                var2remove(i) = i;
        end
    end
end
% remove used varargin
varargin(var2remove(~isnan(var2remove))) = [];

% plot 
% if several loops: plot all+its mean,if one loop just plot
if length(loops)>1
    for i = 1:show_loops
        plot(x_channel.data(:,i)+xOffset,data(:,i),':',...
            'DisplayName',sprintf('%s %d',name,i),varargin{:});
        hold on
    end
    hObject = plot(x_channel.data(:,1)+xOffset,mean(data,2),...
        'DisplayName',sprintf('%s %d',name,i),varargin{:});
else
    hObject = plot(x_channel.data+xOffset,data,...
        'DisplayName',sprintf('%s %d',name,i),varargin{:});  
    hold on
end

if showLabels
    tt=title(name);
    set(tt,'Interpreter','Latex');
    if isempty(strtrim(x_channel.Unit))
        xlabel(sprintf('%s',x_channel.Name));
    else
        xx=xlabel(sprintf('%s in %s',x_channel.Name,x_channel.Unit));
        set(xx,'Interpreter','Latex'); 
    end
    if isempty(strtrim(unit))
        ylabel(sprintf('%s',name));
    else
        yy=ylabel(sprintf('%s in %s',name,unit));
        set(yy,'Interpreter','Latex'); 
    end
end

end
