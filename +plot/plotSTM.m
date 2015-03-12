function [p,range] = plotSTM(data,header)
%Plot STM Data. Will use STDev to determine the noisy parts

%Keep lines with STD < 3* median to scale
stdData= nanstd(data,0,2);
stdCut=3*nanmedian(stdData);

%Cut to keep "good lines"
linesSTDev= stdData < stdCut;
linesSTDev = logical(linesSTDev*ones([1 size(data,2)]));%matrix size
signal=data(linesSTDev);

%Use 2 std
stdData=nanstd(signal(:));

% if stdData is NaN, recompute on non-nan value
if isnan(stdData)
    good = ~isnan(signal);
    stdData=std(signal(good));
end

%Range is 3 stdev
range = [-1 1]*3*stdData;

p = plot.plotSxm(data, header, range);
end