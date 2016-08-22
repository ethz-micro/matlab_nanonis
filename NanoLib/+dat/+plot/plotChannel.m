function hObject = plotChannel(channel,sweep_chn,varargin)

name = sprintf('%s - %s',channel.Name,channel.Direction);
hObject = dat.plot.plotData(channel.data,name,channel.Unit,sweep_chn,varargin{:});

end
    
