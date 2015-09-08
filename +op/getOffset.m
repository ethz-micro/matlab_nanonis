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
    
    
    
    
    
    
    %{
    %Compute padding
    padXY=size(mask1)-size(mask2);
    half = round(.5*padXY);
    
    PadPre2=half;
    PadPost2=padXY-half;
    PadPre1=zeros(size(PadPre2));
    PadPost1=zeros(size(PadPre2));
    
    %The positive part of the padding is for mask2, the negative for mask 1
    idx1 = PadPre2<0;
    PadPre1(idx1)=-PadPre2(idx1);
    PadPre2(idx1)=0;
    
    idx1 = PadPost2<0;
    PadPost1(idx1)=-PadPost2(idx1);
    PadPost2(idx1)=0;
    
    %Apply padding
    mask2=padarray(mask2,PadPre2,0,'pre');
    mask2=padarray(mask2,PadPost2,0,'post');
    mask1=padarray(mask1,PadPre1,0,'pre');
    mask1=padarray(mask1,PadPost1,0,'post');
    
    %}
    
   
    
    %{
    mask2=circshift(mask2,[Yoff, Xoff]);
    comb=mask1.*mask2;
    ret =sum(comb(:))/sum(mask1(:));
    %}
    
end