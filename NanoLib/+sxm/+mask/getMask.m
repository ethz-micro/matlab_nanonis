function [maskUp, maskDown, flatData] = getMask(data,pixSize, prctUp, prctDown,varargin)%fn, varargin
    %getMask creates a mask for the detection of pattern. It will filter the
    %datas using FFT, flatten the datas with a sliding mean and take a
    %threshold to cut the datas
    %   prctUp and -Down specify the fraction of pixel that should be kept in
    %   the mask
    %   Can add a 'plotFFT' to plot the fourrier transform
    
    %% Settings
    scanFrac = 4;%Fraction of the image on which the sliding averaging is done
    
    %Filter the data
    filtered = sxm.op.filterData(data,pixSize,varargin);
    
    %Flatten the datas
    flatData = flattenData(filtered,scanFrac);
   
    
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
    
    %%
    %{
    figure
    imagesc(flatData);
    axis image
    
    
%Plot removed part
figure
imagesc(noise,range);
axis image

figure
imagesc(filtered);
axis image

figure
imagesc(double(slidingmean))
axis image


    %}
    
end

function data=flattenData(data,scanFrac)
     %calculate sliding mean
    sldArea=floor(size(data)/scanFrac);
    normalMtx=flip(sldArea)*sldArea.'/size(sldArea,2);%X*Y
    slidingmean=sxm.convolve2.convolve2(data,ones(sldArea)/normalMtx,'symmetric');
    
    %Get flattened data
    data= data-double(slidingmean);
end