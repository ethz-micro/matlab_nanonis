function [h, range] = plotFile(file, n,varargin)
    [h, range] = plotSxM.plotChannel(file.channels(n),file.header,varargin{:});
end