function [h, range] = plotChannel(channel,header,varargin)
    name=[channel.Name,' - ',channel.Direction];
    [h, range] = plot.plotData(channel.data,name,channel.Unit,header,varargin{:});
end



