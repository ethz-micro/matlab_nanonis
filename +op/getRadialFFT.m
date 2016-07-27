function [wavelength, radial_spectrum] =getRadialFFT(data,varargin)
    %Gives the radial amplitude for a given pixel wavelength
    
    %Removes mean for FFT
    data=data-nanmean(data(:));
    %Removes nan data
    data(isnan(data))=0;
    %Get fourrier transform
    img=abs(fft2(data));

    %Reorder fourrier data
    sizeSq = floor(size(img)/2);
    img = swapSquares(img,sizeSq);
    
    %compute center, +1 as matlab don't start from 0
    center = size(img)/2+1;
    
    %compute size (assumed square)
    img_size=min(size(img));
    
    %Create the radius vector
    radius_step=1;
    
    radius = 1:radius_step:(round(0.5*img_size)-1);
    
    % Create the meshgrid to be used in resampling
    [X,Y] = meshgrid(1:size(img,2),1:size(img,1));
    
    %Assign a distance to the center to each position
    DSquare=(X-center(2)).^2+(Y-center(1)).^2;
    
    %For each radius
    for i=size(radius,2):-1:1
        r=radius(i);
        %Deduce which pixels are in the slice
        %slice=((r-radius_step/2).^2 <= DSquare) & ((r+radius_step/2).^2 > DSquare);
        slice=((r.^2+(r-radius_step).^2)./2 <= DSquare) & ((r.^2+(r+radius_step).^2)./2 > DSquare);
        %save the mean value
        radial_spectrum(i)=mean(img(slice));
    end
    
    %Multiply by 2 pi r
    radial_spectrum=radial_spectrum.*(2*pi*radius);
    
    %rescale radius and radial_average
    radius=radius./img_size;
    radial_spectrum=radial_spectrum./(size(img,1).*size(img,2));
    
    %Change radius unit
    if nargin >1
       pixPerUnit=varargin{1};
       radius=radius.*pixPerUnit;
    end
    
    %Compute wavelength
    wavelength=1./radius;
end

function ret = swapSquares(data, sizeSq)
    %swap every squares
    ret=zeros(2*sizeSq);
    ret(1:sizeSq(1), 1: sizeSq(2))= data(end-sizeSq(1)+1:end,end-sizeSq(2)+1:end );
    ret(1:sizeSq(1), end-sizeSq(2)+1: end)=data(end-sizeSq(1)+1:end, 1: sizeSq(2));
    ret(end-sizeSq(1)+1:end, 1: sizeSq(2))=data(1:sizeSq(1), end-sizeSq(2)+1: end);
    ret(end-sizeSq(1)+1:end, end-sizeSq(2)+1: end)=data(1:sizeSq(1), 1: sizeSq(2));
end