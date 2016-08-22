function [h, range] = plotFile(file, n,varargin)
    [h, range] = sxm.plot.plotChannel(file.channels(n),file.header,varargin{:});
end