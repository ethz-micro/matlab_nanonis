function file=loadProcessedSxM(fn, varargin)

    %read header
    file.header = load.loadsxm(fn);
    
    %Save data infos in a nice format
    data_info = readDataInfos(file.header);
    
    %Save scan Type
    file.header.scan_type = scanType(data_info);
    
    %Channels numbers to save
    if nargin > 1
        nArray=varargin{1};
    else
        nArray=0:2*numel(data_info)-1;
    end
    
    %save channels
    for n=numel(nArray):-1:1;
        idx=nArray(n);
        file.channels(n)=loadChannel(fn,idx,data_info);
    end
    
    
end


function data_info = readDataInfos(header)
    %Read Data Infos
    infoStr = header.data_info;
    lines = strsplit(infoStr,'\n');
    
    %Read titles
    title = strsplit(lines{2},'\t');
    
    %Read each lines
    for n=3:numel(lines)%First is '', second is title
        %separate the \t
        infosChan = strsplit(lines{n},'\t');
        for i=numel(title):-1:1
            data_info(n-2).(title{i}) = infosChan{i};
        end
    end
    
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

function [data,corr] = flatenMeanPlane(data)
    %Remove sample tilt
    crv = nanmean(data,1);
    x=1:size(crv,2);
    p = polyfit(x,crv,1);
    corr= p(1)*x+p(2);
    data = data - ones([size(data,1) 1])*corr;
end

function [data, lineMedian] = processSTM(data)
    %processSTM correct for the drift by substracting the median of each lines.
    
    %Save mean and STDev
    lineMedian = nanmedian(data,2);
    
    %Remove median
    data=(data-nanmedian(data,2)*ones([1 size(data,2)]));
end

function [data, lineMean , lineStd] = processSEM(data)
    %processSTM corrects for the mean and std variation
    
    %The lines are gaussian. The mean and std depends on the distance
    %tip-sample, that changes during the measurment because of the drift, and
    %on other things.
    
    %Save mean and STDev
    lineMean = nanmean(data,2);
    lineStd = nanstd(data,0,2);
    
    %Remove mean and STDev
    data=(data-nanmean(data,2)*ones([1 size(data,2)]))./(nanstd(data,0,2)*ones([1 size(data,2)]));
    
end
function channel = loadChannel(fn,n,data_info)
    
    idx=floor(n/2+1);%The index of data info is half the channel index (both direction saved)
     
    %Copy info on channels (duplicate as Direction = both)
    channel = data_info(idx);
    
    %Save line direction
    if mod(n,2)==1
        channel.Direction = 'backward';
    else
        channel.Direction = 'forward';
    end
    
    %load data in channel
    [header, data]=load.loadsxm(fn,n);
    
    %Orientate the data
    data = orientateData(data,channel.Direction,header.scan_dir);
    
    %Process the data
    scan_type = scanType(data_info);
    switch scan_type
        case 'SEM'
            [data, channel.mean , channel.std] = processSEM(data);
        case 'STM'
            [data, channel.median] = processSTM(data);
        otherwise
            %Can't process data
    end
    %Flatten plane
    [data,channel.slope] = flatenMeanPlane(data);
    
    %turn the datas - done after the rest because scan was line by line
    data = rotateData(data,header.scan_angle);
    
    %Save data
    channel.data=data;
end

function scan_type = scanType(data_info)
    
     %For STM scans, Z is the first data, for SEM, it is the current
    switch data_info(1).Name
        case 'Z'
            scan_type='STM';
        case 'Current'
            scan_type='SEM';
        otherwise
            scan_type='Unknown';
    end
end