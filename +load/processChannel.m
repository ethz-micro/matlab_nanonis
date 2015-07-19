function channel = processChannel(channel,header)
    %Orientate the data
    channel.data = orientateData(channel.data,channel.Direction,header.scan_dir);
    
    %Process the data
    switch header.scan_type
        case 'NFESEM'
            [channel.data, channel.mean , channel.std,channel.slope] = processNFESEM(channel.data);
        case 'STM'
            [channel.data, channel.median,channel.slope] = processSTM(channel.data);
        case 'SEMPA'
            [channel.data, channel.mean] = processSEMPA(channel.data);
        otherwise
            %Can't process data
    end
    
    %turn the datas - done after the rest because scan was line by line
    channel.data = rotateData(channel.data,header.scan_angle);
end

function [data, lineMean] = processSEMPA(data)
    %Reset nan
    
    data(abs(data)>2^30)=nan;
    
    
    %Save mean and STDev
    lineMean = nanmean(data,2);
    %lineStd = nanstd(data,0,2);
    
    %Remove mean and STDev
    data=(data-lineMean*ones([1 size(data,2)]))./(nanstd(data,0,2)*ones([1 size(data,2)]));
end

function [data,corr] = flatenMeanPlane(data)
    %Remove sample tilt
    crv = nanmedian(data,1);
    x=1:size(crv,2);
    p = polyfit(x,crv,1);
    corr= p(1)*x+p(2);
    data = data - ones([size(data,1) 1])*corr;
end

function [data, lineMedian, slope] = processSTM(data)
    %processSTM correct for the drift by substracting the median of each lines.
    
    %Save mean and STDev
    lineMedian = nanmedian(data,2);
    
    %Remove median
    data=(data-nanmedian(data,2)*ones([1 size(data,2)]));
    
    %Flatten plane
    [data,slope] = flatenMeanPlane(data);
end

function [data, lineMean , lineStd, slope] = processNFESEM(data)
    %processSTM corrects for the mean and std variation
    
    %The lines are gaussian. The mean and std depends on the distance
    %tip-sample, that changes during the measurment because of the drift, and
    %on other things.
    
    %Save mean and STDev
    lineMean = nanmean(data,2);
    lineStd = nanstd(data,0,2);
    
    %Remove mean and STDev
    data=(data-nanmean(data,2)*ones([1 size(data,2)]));%./(nanstd(data,0,2)*ones([1 size(data,2)]));
    
    %Flatten plane
    [data,slope] = flatenMeanPlane(data);
end

function data = orientateData(data,line_dir,scan_dir)
    %Flip if backwards
    if strcmp(line_dir, 'backward')
        data=flip(data,2);
    end
    
    %Flip if up
    if strcmp(scan_dir,'up')
        data = flip(data,1);
    end
end

function data = rotateData(data,angle)
    %Rotate
    if angle ~=0
        data = imrotate(data,-angle);
    end
end
