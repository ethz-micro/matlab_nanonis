function [h, range] = plotChannel(file, n)
    name=[file.channels(n).Name,' - ',file.channels(n).Direction];
    [h, range] = plot.plotData(file.channels(n).data,name,file.header);
end



