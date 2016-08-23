function hObject =  plotData(data,name,unit,sweep_chn,varargin)
% hObject = plotData(data,name,unit,sweep_chn,varargin)
%
% varargin are the same as for normal matlab plot function
% additional options are:
%      varargin = {'xOffset',NUMBER} : shift of the x axis 
%      varargin = {'hideLabels'}     : leave labels out

% search for options
xOffset = 0;
showLabels = true;
var2remove = nan(size(varargin,2),1);
for i = 1:size(varargin,2)
    if ischar(varargin{i})
        switch varargin{i}
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
hObject = plot(sweep_chn.data+xOffset,data,varargin{:});
if showLabels
    title(name);
    xlabel(sprintf('%s in %s',sweep_chn.Name,sweep_chn.Unit));
    ylabel(sprintf('%s in %s',name,unit));
end
end
