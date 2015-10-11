function [offset,XC,centerOffset] = getOffset(img1, header1,img2,header2,varargin)
    %compute the offset between the two images. 
    %add 'mask' if working with masks
    ismask=false;
    if nargin > 4
        cmd=varargin{1};
        if strcmp(cmd,'mask')
            ismask = true;
        end
        
    end
    
    %Compute pixels per meter
    im1PixM=header1.scan_pixels(1)/header1.scan_range(1);
    im2PixM=header2.scan_pixels(1)/header2.scan_range(1);
    
    %Rescale to get everithing at im1PixM pixel per meter
    if im1PixM ~= im2PixM
        %Compute scale
        scale = im1PixM/im2PixM;
        
        %Rescale data
        img2 = imresize(img2,scale);
        
        %Transform back to logical if mask
        if ismask
            img2 = img2>0.5;
        end
    end
    
    %Compute cross correlation
    XC=xcorr2(double(img1)-mean(mean(img1)),double(img2)-mean(mean(img2)));
    
    %Get cross correlation max
    [M1, I1]=max(abs(XC));
    [~, Xoff]=max(M1);  %X is the second dimention!!!
    Yoff=I1(Xoff);
    
    %Remove img2 size to get offset
    Xoff=Xoff-size(img2,2);
    Yoff=Yoff-size(img2,1);
    
    %Transform offset from pixel to meters
    offset(1)= Xoff/im1PixM;
    offset(2)= Yoff/im1PixM;
    
    %Compute the corresponding centered offset
    centerDiff=.5*(header1.scan_range-header2.scan_range);
    centerOffset=offset-centerDiff.';% remove center
    
end