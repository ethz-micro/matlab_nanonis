function [data, lineMean , lineStd, slope] = processSEM(data)
%processSTM corrects for the mean ans std variation, and does plane
%correction

%The lines are gaussian. The mean and std depends on the distance
%tip-sample, that changes during the measurment because of the drift, and
%on other things.

%Some useful functions
    function data = normalizeLine(data)
        %Normalize the mean and STDev
        data=(data-nanmean(data,2)*ones([1 size(data,2)]))./(nanstd(data,0,2)*ones([1 size(data,2)]));
    end
    function [data,corr] = flatenMeanPlane(data)
        %Remove sample tilt
        crv = nanmean(data,1);
        x=1:size(crv,2);
        p = polyfit(x,crv,1);
        corr= p(1)*x+p(2);
        data = data - ones([size(data,1) 1])*corr;
    end

%Save mean and STDev
lineMean = nanmean(data,2);
lineStd = nanstd(data,0,2);

%Remove mean and STDev
data = normalizeLine(data);

%Remove slope
[data,slope] = flatenMeanPlane(data);
  
%Renormalize
mnData=nanmean(data(:));
stdData=nanstd(data(:));

%Data
data = data - mnData;
data = data/stdData;


%idem for the slope
slope = slope-mnData;
slope = slope/stdData;


end