function [h, range] = plotData(data,name,header)
    switch header.scan_type
        case 'STM'
            range = rangeSTM(data);
        case 'SEM'
            range = rangeSEM(data);
    end
    h=plotSxm(data,header,range);
    s=[header.rec_date, ' - '];
    s=[s,getName(header),' - '];
    s=[s,name];
    title(s);
end

function p=plotSxm(data,header,range)
    %Plot
    
    p = imagesc([0 header.scan_range(1)],[0 header.scan_range(2)],data,range);
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
    
    % if stdData is NaN, recompute on non-nan value
    if isnan(stdData)
        good = ~isnan(signal);
        stdData=std(signal(good));
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