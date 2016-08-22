function hObject =  plotData(data,name,unit,sweep_chn,varargin)
% function hObject = plotChannel(myData,channel,varargin)
% varargin are the same as for normal matlab plot function

% plot
hObject = plot(sweep_chn.data,data,'DisplayName',name,varargin{:});

xlabel(sprintf('%s in %s',sweep_chn.Name,sweep_chn.Unit));
ylabel(sprintf('%s in %s',name,unit));
end
