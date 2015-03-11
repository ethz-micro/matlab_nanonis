function [data, lineMedian,lineSTDev, slope] = processSTM(data)
%processSTM correct for the drift by substracting the median of each lines.
%It also does plane correction

%Some useful functions
    function data = flatenLine(data)
        %Remove the median
        data=(data-nanmedian(data,2)*ones([1 size(data,2)]));
    end
    function [data,corr] = flatenMeanPlane(data)
        %Remove sample tilt
        crv = nanmedian(data,1);
        x=1:size(crv,2);
        p = polyfit(x,crv,1);
        corr= p(1)*x+p(2);
        data = data - ones([size(data,1) 1])*corr;
    end

%Save mean and STDev
lineMedian = nanmedian(data,2);
lineSTDev = nanstd(data,0,2);

%Remove mean
data = flatenLine(data);

%Remove slope
[data,slope] = flatenMeanPlane(data);

end