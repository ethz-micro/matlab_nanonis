function channel = processChannel(channel,header,varargin)

    %Orientate the data
    channel.data = orientateData(channel.data,channel.Direction,header.scan_dir);
    
    %Specific process
    switch header.scan_type
        case {'NFESEM','SEMPA'}
            %The units become arbitrary
            channel.Unit='';
            
            %If current & min<0 , take min as offset
            if strcmp(channel.Name,'Current')
                minI=min(channel.data(:));
                if minI<0
                    %Correct the offset
                    channel.data=channel.data-minI;
                end
            end
            
        case 'SEMPA'
            %reset nans
            channel.data(abs(channel.data)>2^30)=nan;
    end

    %Get various possibilities for line correction
    channel.lineMedian=nanmedian(channel.data,2);
    channel.lineMean=nanmean(channel.data,2);
    channel.linePlane= getLineFit(channel.data,2);
    
    %Default choise is mean
    columnCorr=channel.lineMean;
    
    methodStr='Mean';
    %Check varargin for different value
    if nargin >2
        switch varargin{1}
            case 'Raw'
                methodStr='Raw';
            case 'PlaneLineCorrection'
                columnCorr=channel.linePlane;
            case 'Median'
                columnCorr=channel.lineMedian;
                methodStr='Median';
                channel.linePlane= getLineFit(channel.data,2,methodStr);
        end
    end
    
    %store raw data
    channel.rawData = channel.data;
    
    switch methodStr
        case 'Raw'
            % nothing to do
        otherwise
            
            %Correct data
            channel.data=correctData(channel.data,columnCorr,header.scan_type);
            
            %Get residual slope
            channel.lineResidualSlope= getLineFit(channel.data,1,methodStr);
            
            %Correct data
            channel.data=correctData(channel.data,channel.lineResidualSlope,header.scan_type);
            
            %Compute STD
            channel.lineStd = std(channel.data,0,2);
    end
    
    %turn the datas - done after the rest because scan was line by line
    channel.data = rotateData(channel.data,header.scan_angle);
end

function lineFit = getLineFit(data,dim,varargin)
    centerfun=@nanmean;
    if nargin>2
        if strcmp(varargin{1},'Median')
            centerfun=@nanmedian;
        end
    end
    %Get mean line curve
    if dim ==1
        crv = centerfun(data,1);
        x=(1:size(crv,2));
    elseif dim==2
        crv = centerfun(data,2);
        x=(1:size(crv,1))';
    end
    
    
    %Fit polynomial of degree 1
    p = polyfit(x,crv,1);
    lineFit= p(1)*x+p(2);
end

function data = correctData(data,corr,scanType)
    corrM=repmat(corr,size(data,1)/size(corr,1),size(data,2)/size(corr,2));
    switch scanType
        case {'NFESEM', 'SEMPA'}
            data=data./corrM;
        case 'STM'
            data=data - corrM;
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
