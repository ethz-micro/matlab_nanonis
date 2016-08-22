function [filtered, removed] = filterData(data,pixSize,varargin)
    %This function keeps a circle in the fourrier plane corresponding to
    %pixSize
    %   Can add a 'plotFFT' to plot the fourrier transform & Zoom level 
    
    stdCut = 2;%Number of STDev kept on the data
    
    MEDIAN=nanmedian(data(:));
    data=data-MEDIAN;
    
    %Remove extreme values
    range = [-1 1]*stdCut*nanstd(data(:));
    low = data < range(1);
    data(low)=range(1);
    high = data > range(2);
    data(high) = range(2);
    
    %nan to 0 otherwise fft doesn't work
    data(isnan(data))=0;
    
    %Fourrier transform
    fTrans=fft2(data);
    
    %Create matrix for easy radius computation
    m = 1:size(fTrans,1);
    m=m.';
    n = 1:size(fTrans,2);
    
    %real part of c is first dim, imaginary is 2nd
    c=m*ones(size(n))+1i*(ones(size(m))*n);
    
    FFTRadius=size(data,1)/pixSize;
    %Calculate a circle around the corners
    indx = abs(c-c(1,1)) < FFTRadius;
    indx = indx | (abs(c-c(1,end)) < FFTRadius);
    indx = indx | (abs(c-c(end,1)) < FFTRadius);
    indx = indx | (abs(c-c(end,end)) < FFTRadius);
    
    
    %Extract interesting part
    redFTrans = complex(zeros(size(fTrans)));
    redFTrans(indx)=fTrans(indx);
    
    %Retrieve filtered data
    filtered=real(ifft2(redFTrans))+MEDIAN;
    
    %Compute removed part
    redFTrans = complex(zeros(size(fTrans)));
    redFTrans(~indx)=fTrans(~indx);
    removed=real(ifft2(redFTrans));
    
    
    
    function ret = swapSquares(data, sizeSq)
        ret=zeros(2*sizeSq);
        ret(1:sizeSq(1), 1: sizeSq(2))= data(end-sizeSq(1)+1:end,end-sizeSq(2)+1:end );
        ret(1:sizeSq(1), end-sizeSq(2)+1: end)=data(end-sizeSq(1)+1:end, 1: sizeSq(2));
        ret(end-sizeSq(1)+1:end, 1: sizeSq(2))=data(1:sizeSq(1), end-sizeSq(2)+1: end);
        ret(end-sizeSq(1)+1:end, end-sizeSq(2)+1: end)=data(1:sizeSq(1), 1: sizeSq(2));
    end
    
    
    % read the data if requested
    if nargin > 2
        cmd = varargin{1};
        if nargin >3
            zoom = varargin{2};
        else
            zoom=8;
        end
        if strcmp(cmd,'plotFFT')
            %Compute the quarter size
            sizeSq = floor(size(data)/zoom);
            %Reorder fourrier data
            dis = swapSquares(abs(fTrans),sizeSq);
            
            %Plot
            figure
            imagesc(dis);
            axis image
            title('Fourrier plane and selected area')
            %apply index mask
            sxm.mask.applyMask(swapSquares(indx,sizeSq),[1,0,0],.2,[0 size(dis,1)],[0 size(dis,2)])
        end
        
    end
    
end