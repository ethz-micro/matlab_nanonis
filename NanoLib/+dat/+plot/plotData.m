function hObject =  plotData(data,name,unit,x_channel,varargin)
% hObject = plotData(data,name,unit,x_channel,varargin)
%
% varargin are the same as for normal matlab plot function
% additional options are:
%      varargin = {'loops',NUMBER}   : loops to display
%      varargin = {'xOffset',NUMBER} : shift of the x axis 
%      varargin = {'hideLabels'}     : leave labels out

% search for options
xOffset = 0;
showLabels = true;
var2remove = nan(size(varargin,2),1);
loops = 1:size(data,2); % plot all loops as default
for i = 1:size(varargin,2)
    if ischar(varargin{i})
        switch varargin{i}
            case 'loops'
                loops = varargin{i+1};
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
hObject = gobjects(length(loops));
ih = 1;
for i = loops
    hObject(ih) = plot(x_channel.data(:,i)+xOffset,data(:,i),...
        'DisplayName',sprintf('%s %d',name,i),varargin{:});
    
    if ih==1; hold on; end
    ih = ih+1;
end
%hold off;

if showLabels
    title(name);
    xlabel(sprintf('%s in %s',x_channel.Name,x_channel.Unit));
    ylabel(sprintf('%s in %s',name,unit));
end

end
