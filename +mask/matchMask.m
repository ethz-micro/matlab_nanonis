function [ret,xoffset,yoffset] = matchMask(mask1, header1,mask2,header2)
    %offset = [0, 0];
    
    %Compute pixels per m
    im1PixM=header1.scan_pixels(1)/header1.scan_range(1);
    im2PixM=header2.scan_pixels(1)/header2.scan_range(1);
    
    if im1PixM ~= im2PixM
        %Compute scale
        scale = im1PixM/im2PixM;
        
        %Rescale data
        mask2 = imresize(mask2,scale);
        mask2 = mask2>0.5;
    end
    
    %im1PixM is now the official size
    
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
    
   %Compute cross correlation
    XC=xcorr2(double(mask1),double(mask2));
    
    %Get cross correlation max
    [M1, I1]=max(XC);
    [~, Xoff]=max(M1);
    Yoff=I1(Xoff);
    
    %X is the second dimention!!!
    Xoff=Xoff-size(mask1,2);
    Yoff=Yoff-size(mask1,1);
    
    xoffset = Xoff/im1PixM;
    yoffset = Yoff/im1PixM;
    
    
    mask2=circshift(mask2,[Yoff, Xoff]);
    
    figure
    mask.applyMask(mask1,[0 1],[0 1], [1 0 0],.5);
    mask.applyMask(mask2,[0 1],[0 1], [0 0 1],.5);
    axis image;
    
    comb=mask1.*mask2;
    ret =sum(comb(:))/sum(mask1(:));
    
end