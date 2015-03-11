function [data, lineMedian,lineSTDev, slope] = processSTM(data,header)
%processSTM correct for the drift by substracting the median of each lines.
%It also does plane correction

%Save mean and STDev
lineMedian = nanmedian(data,2);
lineSTDev = nanstd(data,0,2);

%Remove median
data=(data-nanmedian(data,2)*ones([1 size(data,2)]));

%Remove slope
[data,slope] = processSxM(data,header);

end