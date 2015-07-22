function [h, range] = plotData(data,name,unit,header,varargin)
    switch header.scan_type
        case 'STM'
            range = rangeSTM(data);
        case {'NFESEM','SEMPA'}
            range = rangeNFESEM(data);
        otherwise
            range=[-1 1]*(prctile(data(:),75)-prctile(data(:),25))+nanmean(data(:));
            
    end
    %Check if there is no variation
    delta=range(2)-range(1);
    if abs(delta)==0
        range=[-1,1];
    end
    h=plotSxm(data,header,range,varargin{:});
    l1=[header.rec_date, ' - '];
    l1=[l1,getName(header)];%' - '];
    %Remove _
    l2=regexprep(name,'_','\\_');
    l3=['Delta= ',num2str(delta,3),' ',unit];
    xlabel('x [m]');
    ylabel('y [m]');
    set(gca,'FontSize',20);
    title({l1;l2;l3},'FontSize',12);
end

function p=plotSxm(data,header,range,varargin)
    %Plot
    
    %Varargin gives x and y offset
    xoffset=0;
    yoffset=0;
    if nargin>4
        xoffset=varargin{1};
        yoffset=varargin{2};
    end
    
    p = imagesc([0 header.scan_range(1)]+xoffset,[0 header.scan_range(2)]+yoffset,data,range);
    axis image;
    
end

function range = rangeNFESEM(data)
    %Plot SEM data
    
    %Range = 2*std of data
    range = [-2 2]*nanstd(data(:))+nanmean(data(:));
    %range=[.7 1.3];
end

function range = rangeSTM(data)
    %Plot STM Data. Will use STDev to determine the noisy parts
    signal=op.nanHighStd(data);
    %Use 2 std
    stdData=nanstd(signal(:));
    
    % if stdData is NaN, put arbitrary range
    if isnan(stdData)
        stdData=0;
    end
    
    %Range is 3 stdev
    range = [-1 1]*3*stdData+nanmean(data(:));
end

function s=getName(header)
    %scan_file: 'E:\Nanonis\2015-02-27\image007.sxm'
    s=header.scan_file;
    list = strsplit(s,'\');
    s=list{end};
    list = strsplit(s,'.');
    s=list{1};
    
end