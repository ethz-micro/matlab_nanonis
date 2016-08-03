function file = loadProcessedPar(fn,varargin)
    
    %Read header file
    [file.header, chInfos] = readPar(fn);
   
    %Get path to open corresponding data file
    path = getPath(fn);
    
    scanup=false;
    if strcmp(file.header.scan_dir,'up')
        scanup=true;
        file.header.scan_dir='down';%already switched
    end
    %There is 9 lines for each channel
    for i=numel(chInfos)/9:-1:1;
        [file.channels(i), file.header.scan_file]=loadProcessParChannel(chInfos,i,path,file.header,varargin{:});
    end
    
    if scanup
        file.header.scan_dir='up';
    end
    
end

function path = getPath(fn)
    %get data path
    i=strfind(fn,'/');
    if numel(i)>0
        path=fn(1:i(end));
    else
        path='';
    end
end

function data=loadParData(fn,scan_pixels)
    %Open .tfx file as int16 data
    fid = fopen(fn);
    data= fread(fid,scan_pixels,'int16','ieee-be')';
    fclose(fid);
end


function [header, chInfos] = readPar(fn)
    %read the content of the .par file
    
    %Read file
    fileContent=fileread(fn);
    
    %Split lines
    fileContent=strsplit(fileContent,'\n');
    
    %Define function to access index
    index = @(A,i) A{mod(i-1,numel(A))+1};%Mod to avoid overflow
    
    %Remove comments (starting with ;)
    fileContent=cellfun(@(x) strtrim(index(strsplit(x,';'),1)),fileContent,'UniformOutput',false);
    
    %Remove blank lines
    fileContent=fileContent(~strcmp('',fileContent));
    
    %Separate the field name from the infos (separated by : except for channel infos)
    function list=separate(str)
        
        k=strfind(str,':');
        if numel(k)>0
            list={str(1:k-1), str(k+1:end)};
        else
            list={str};
        end
    end
    
    %Separate name and values
    fileContent=cellfun(@(x) strtrim(separate(x)),fileContent,'UniformOutput',false);
    
    %Put filecontent in matrix for easy lookup
    FCMatrix=cell(size(fileContent,2),2);
    FCMatrix(:,1)=cellfun(@(x) index(x,1),fileContent,'UniformOutput',false);
    FCMatrix(:,2)=cellfun(@(x) index(x,2),fileContent,'UniformOutput',false);
    
    %all lines with 1 cell are channel infos
    chIdx=cellfun(@numel,fileContent)==1;
    chInfos=fileContent(chIdx);
    
    %Transform File Content matrix into header
    header = readHeader(FCMatrix);
    %Deduce Scan type from chInfos
    header.scan_type=scanType(chInfos);
    
end

function header = readHeader(FCMtx)
    
    %Create header
    datasForKey= @(x) FCMtx(strcmp(x,FCMtx(:,1)),2);
    
    %Date
    Date=datasForKey('Date');
    Date=strsplit(Date{1},' ');
    header.rec_date=Date{1};
    header.rec_time=Date{2};
    
    %Scan pixels
    pxX=str2double(datasForKey('Image Size in X'));
    pxY=str2double(datasForKey('Image Size in Y'));
    header.scan_pixels=[pxX;pxY];
    
    %Scan Range
    rX=str2double(datasForKey('Field X Size in nm'))*10^-9;
    rY=str2double(datasForKey('Field Y Size in nm'))*10^-9;
    header.scan_range=[rX;rY];
    
    %Scan Offset
    oX=str2double(datasForKey('X Offset'));
    oY=str2double(datasForKey('Y Offset'));
    header.scan_offset=[oX;oY];
    
    %Scan Angle
    header.scan_angle=str2double(datasForKey('Scan Angle'));
    
    %Scan Direction
    header.scan_dir=datasForKey('Scan Direction');
    header.scan_dir=lower(header.scan_dir{1});
    
    %Bias
    header.bias=str2double(datasForKey('Gap Voltage'));
    
end

function scan_type=scanType(chInfos)
    
    %For STM scans, Z is the first data, for NFESEM, it is the current
    switch chInfos{9}{1};
        case 'Z'
            scan_type='STM';
        case 'I'
            scan_type='NFESEM';
        otherwise
            scan_type='Unknown';
    end
    
end

function [channel, scan_file]=loadProcessParChannel(chInfos,i,path,header,varargin)
    %offset
    ofs=(i-1)*9;
    %Load infos
    channelTemp.Direction=lower(chInfos{ofs+1}{1});
    channelTemp.Unit=chInfos{ofs+7}{1};
    channelTemp.Name=chInfos{ofs+9}{1};
    fileName=chInfos{ofs+8};
    resolution=str2double(chInfos{ofs+6});
    %load data
    channelTemp.data=loadParData([path fileName{1}],header.scan_pixels')*resolution;
    %correct name current
    if strcmp(channelTemp.Name,'I')
        channelTemp.Name='Current';
    end
    %process data
    channel=loadSxM.processChannel(channelTemp,header,varargin{:});
    
    scan_file=fileName{1};
end