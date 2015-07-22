function channel = processChannel(channel,header)
     %Orientate the data
    channel.data = orientateData(channel.data,channel.Direction,header.scan_dir);
    
    %Process the data
    switch header.scan_type
        case 'NFESEM'
            [channel.data, channel.median ,channel.slope] = processNFESEM(channel.data);
            %arbitrary units
            channel.Unit='';
        case 'STM'
            [channel.data, channel.median,channel.slope] = processSTM(channel.data);
        case 'SEMPA'
            %reset nans
            channel.data(abs(channel.data)>2^30)=nan;
            [channel.data, channel.median ,channel.slope] = processNFESEM(channel.data);
            channel.Unit='';
        otherwise
            %Can't process data
    end
    
    channel.std = std(channel.data,0,2);
    
   
    %turn the datas - done after the rest because scan was line by line
    channel.data = rotateData(channel.data,header.scan_angle);
end

function lineFit = getLineFit(data)
    %Get median line curve 
    crv = nanmedian(data,1);
    x=1:size(crv,2);
    %Fit polynomial of degree 1
    p = polyfit(x,crv,1);
    lineFit= p(1)*x+p(2);
end

function [data, lineMedian, slope] = processSTM(data)
    %processSTM correct for the drift by substracting the median of each lines.
    
    %Save mean and STDev
    lineMedian = nanmedian(data,2);
    
    %Remove median
    data=(data-nanmedian(data,2)*ones([1 size(data,2)]));
    
    %Flatten plane
    slope = getLineFit(data);
    data = data - ones([size(data,1) 1])*slope;
    
end

function [data, lineMedian , slope] = processNFESEM(data)
    %processSTM corrects for the mean and std variation
    
    %Save mean 
    lineMedian = nanmedian(data,2);
    
    %Remove mean by dividing (mathematical justification in thesis)
    data=data./(lineMedian*ones([1 size(data,2)]));
    
    %Flatten plane
    slope = getLineFit(data);
    data = data./(ones([size(data,1) 1])*slope);
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
