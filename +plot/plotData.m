function [h, range] = plotData(data,name,unit,header,varargin)
    switch header.scan_type
        case 'STM'
            range = rangeSTM(data);
        case 'SEM'
            range = rangeSEM(data);
    end
    %Check if there is no variation
    delta=range(2)-range(1);
    if abs(delta)==0
        range=[-1,1];
    end
    h=plotSxm(data,header,range,varargin{:});
    s=[header.rec_date, ' - '];
    s=[s,getName(header),' - '];
    s=[s,'\Delta= ',num2str(delta,3),' ',unit,' - '];
    s=[s,name];
    title(s);
    xlabel('x [m]');
    ylabel('y [m]');
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

function range = rangeSEM(data)
    %Plot SEM data
    
    %Range = 2*std of data
    range = [-2 2]*nanstd(data(:));
end

function range = rangeSTM(data)
    %Plot STM Data. Will use STDev to determine the noisy parts
    
    %Keep lines with STD < 3* median to scale
    stdData= nanstd(data,0,2);
    stdCut=3*nanmedian(stdData);
    
    %Cut to keep "good lines"
    linesSTDev= stdData < stdCut;
    linesSTDev = logical(linesSTDev*ones([1 size(data,2)]));%matrix size
    signal=data(linesSTDev);
    
    %Use 2 std
    stdData=nanstd(signal(:));
    
    % if stdData is NaN, put arbitrary range
    if isnan(stdData)
        stdData=0;
    end
    
    %Range is 3 stdev
    range = [-1 1]*3*stdData;
end

function s=getName(header)
    %scan_file: 'E:\Nanonis\2015-02-27\image007.sxm'
    s=header.scan_file;
    list = strsplit(s,'\');
    s=list{end};
    list = strsplit(s,'.');
    s=list{1};
    
end