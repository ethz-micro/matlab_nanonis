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

function channel = loadChannel(fn,n,data_info)
    
    idx=floor(n/2+1);%The index of data info is half the channel index (both direction saved)
     
    %Copy info on channels (duplicate as Direction = both)
    channel = data_info(idx);
    
    %Is the direction backwards?
    dirBack= mod(n,2)==1;
    
    %Should we load the data?
    loadData = false;
    
    switch channel.Direction
        case 'both'
            %Save line direction
            if dirBack
                channel.Direction = 'backward';
            else
                channel.Direction = 'forward';
            end
            loadData = true;
        case 'forward'
            if ~dirBack
                loadData = true;
            end
            
        case 'backward'
            if dirBack
                loadData = true;
            end
            
            
    end
    
    if loadData
        
        %load data in channel
        [header, data]=load.loadsxm(fn,n);
        
        header.scan_type = scanType(data_info);
        
        %Save data
        channel.data=data;
        
        channel=load.processChannel(channel,header);
        
        
    else
        channel.data=0;
    end
    
end

function scan_type = scanType(data_info)
    
     %For STM scans, Z is the first data, for NFESEM, it is the current,
     %For SEM, Video
    switch data_info(1).Name
        case 'Z'
            scan_type='STM';
        case 'Current'
            scan_type='NFESEM';
        case 'Video'
            scan_type='SEMPA';
        otherwise
            scan_type='Unknown';
    end
end