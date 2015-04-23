function [h, range] = plotFile(file, n,varargin)
    [h, range] = plot.plotChannel(file.channels(n),file.header,varargin{:});
end