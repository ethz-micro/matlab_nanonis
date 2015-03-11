function [maskUp, maskDown] = getMask(data, prctUp, prctDown)%fn, varargin
%getMask creates a mask for the detection of pattern
%   Detailed explanation goes here

%% Settings

radius = 20;
scanFrac = 4;
stdCut = 2;
zoomFT=8;


%%

%Remove extreme values
range = [-1 1]*stdCut*std(data(:));
low = data < range(1);
data(low)=range(1);
high = data > range(2);
data(high) = range(2);

%Fourrier transform
fTrans=fft2(data);

%Create matrix for easy radius computation
m = 1:size(fTrans,1);
m=m.';
n = 1:size(fTrans,2);

%real part of c is first dim, imaginary is 2nd
c=m*ones(size(n))+1i*(ones(size(m))*n);

%Calculate a circle around the corners
indx = abs(c-c(1,1)) < radius;
indx = indx | (abs(c-c(1,end)) < radius);
indx = indx | (abs(c-c(end,1)) < radius);
indx = indx | (abs(c-c(end,end)) < radius);


%Extract interesting part
redFTrans = complex(zeros(size(fTrans)));
redFTrans(indx)=fTrans(indx);

%Retrieve filtered data
filtered=real(ifft2(redFTrans));

%calculate sliding mean
sldArea=size(data)/scanFrac;
normalMtx=flip(sldArea)*sldArea.'/size(sldArea,2);
slidingmean=convolve2(filtered,ones(sldArea)/normalMtx,'symmetric');

%Get flattened data
flatData= filtered-double(slidingmean);

%Compute high mask
threshold = prctile(flatData(:),prctUp);
keep = flatData > threshold;
maskUp = zeros(size(flatData));
maskUp(keep)=1;

%Compute low mask
threshold = prctile(flatData(:),prctDown);
keep = flatData < threshold;
maskDown = zeros(size(flatData));
maskDown(keep)=1;




%{
redFTrans = complex(zeros(size(fTrans)));

redFTrans(~indx)=fTrans(~indx);

noise=real(ifft2(redFTrans));

figure
imagesc(noise,range);
axis image
%}
sizeSq = size(data)/zoomFT;

    function ret = swapSquares(data, sizeSq)
        ret=zeros(2*sizeSq);
        ret(1:sizeSq(1), 1: sizeSq(2))= data(end-sizeSq(1)+1:end,end-sizeSq(2)+1:end );
        ret(1:sizeSq(1), end-sizeSq(2)+1: end)=data(end-sizeSq(1)+1:end, 1: sizeSq(2));
        ret(end-sizeSq(1)+1:end, 1: sizeSq(2))=data(1:sizeSq(1), end-sizeSq(2)+1: end);
        ret(end-sizeSq(1)+1:end, end-sizeSq(2)+1: end)=data(1:sizeSq(1), 1: sizeSq(2));
    end

dis = swapSquares(abs(fTrans),sizeSq);


figure
imagesc(dis);
axis image
applyMask(swapSquares(indx,sizeSq),[0 size(dis,1)],[0 size(dis,2)],[1,0,0],.2)



%{
figure
imagesc(filtered);
axis image

figure
imagesc(double(slidingmean))
axis image

figure
imagesc(flatData);
axis image
%}

end
