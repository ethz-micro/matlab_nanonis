function [h, range] = plotChannel(file, n,varargin)
    name=[file.channels(n).Name,' - ',file.channels(n).Direction];
    [h, range] = plot.plotData(file.channels(n).data,name,file.header,varargin{:});
end



