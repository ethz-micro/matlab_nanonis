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
    %  decompose varargin information and remove whats already used
    j = nan(numel(varargin),1);
    mkttl=true;
    scale={'m',1};
    setOuterPostion = true;
    for i = 1:numel(varargin)
        switch varargin{i}
            case 'NoTitle'
                mkttl=false;
                j(i) = i;
            case {'Units','units'}
                scale_legend={'m',1;'mum',1e6;'nm',1e9};
                datasForKey= @(x) scale_legend(strcmp(x,scale_legend(:,1)),:);
                scale = datasForKey(varargin{i+1});
                j(i:i+1) = i:i+1;
            case {'HoldPosition','holdPosition'}
                setOuterPostion = false;
                j(i) = i;
        end
    end
    varargin(j(~isnan(j))) = [];
    % plot
    h=plotSxm(data,header,range,scale{2},varargin{:});
    l1=[header.rec_date, ' - '];
    l1=[l1,getName(header)];%' - '];
    %Remove _
    l1=regexprep(l1,'_','\\_');
    l2=regexprep(name,'_','\\_');
    l3=['Delta= ',num2str(delta,3),' ',unit];
    % set(gca,'FontSize',20);
    xlabel(sprintf('x [%s]',scale{1}));
    ylabel(sprintf('y [%s]',scale{1}));
    if mkttl    
        title({l1;l2;l3})%,'FontSize',12);
    end
    if setOuterPostion; set(gca,'OuterPosition',[0,0,1,1]); end
end

function p=plotSxm(data,header,range,scale,varargin)
    %Plot
    
    %Varargin gives x and y offset
    xoffset=0;
    yoffset=0;
    if nargin>5
        xoffset=varargin{1};
        yoffset=varargin{2};
    end
    XScale=[0 header.scan_range(1)]*scale+xoffset;
    YScale=[0 header.scan_range(2)]*scale+yoffset;
    p = imagesc(XScale,YScale,data,range);
    axis image;
    %To export image correctly
    % set(gcf,'Position',[100 100 512 512],'PaperUnits','Points','PaperSize',[512,512],'PaperPosition',[0,0,512,512]);
    
end

function range = rangeNFESEM(data)
    %Plot SEM data
    data=sxm.op.nanHighStd(data);
    %Range = 2*std of data
    range = [-2 2]*nanstd(data(:))+nanmean(data(:));
    %range=[.7 1.3];
end

function range = rangeSTM(data)
    %Plot STM Data. Will use STDev to determine the noisy parts
    signal=sxm.op.nanHighStd(data);
    %Use 2 std
    stdData=nanstd(signal(:));
    
    % if stdData is NaN, put arbitrary range
    if isnan(stdData)
        stdData=0;
    end
    
    %Range is 2 stdev
    range = [-1 1]*2*stdData+nanmean(data(:));
end

function s=getName(header)
    %scan_file: 'E:\Nanonis\2015-02-27\image007.sxm'
    s=header.scan_file;
    list = strsplit(s,'\');
    s=list{end};
    list = strsplit(s,'.');
    s=list{1};
    
end