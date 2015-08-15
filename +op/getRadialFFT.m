function [radial_average, radius, noise_fit, noise_coeff] =getRadialFFT(data)
    %Gives the radial amplitude for a given pixel frequency deducting the
    %noise
   
    
    %Get fourrier transform
    img=abs(fft2(data-mean(data(:))));
    
    %Reorder fourrier data
    sizeSq = floor(size(img)/2);
    img = swapSquares(img,sizeSq);
    
    %compute center, +1 as matlab don't start from 0
    center = size(img)/2+1;
    
    %compute size (assumed square)
    img_size=size(img,1);
    
    %Create the test radius
    radius_step=1;
    radius = 1:radius_step:(round(0.5*img_size)-1);
    
     % Create the meshgrid to be used in resampling
    [X,Y] = meshgrid(1:img_size,1:img_size);
    
    DSquare=(X-center(2)).^2+(Y-center(1)).^2;
    
    for i=size(radius,2):-1:1
        r=radius(i);
        slice=((r-radius_step/2).^2 <= DSquare) & ((r+radius_step/2).^2 > DSquare);
        radial_average(i)=mean(img(slice));
        %radial_std(i)=std(img(slice));
    end
    
    %{
    %loop radius
    for i=size(radius,2):-1:1
        r=radius(i);
        %Adapted from http://www.mathworks.com/matlabcentral/newsreader/view_original/88838
        
        % To avoid redundancy, sample at roughly 1 px distances
        num_pxls = 2*pi*r;
        theta = 0:1/num_pxls:2*pi;
        
        x = center(1) + r*cos(theta);
        y = center(2) + r*sin(theta);
        
        sampled_radial_slice = interp2(X,Y,img,x,y);
        
        radial_average(i) = mean(sampled_radial_slice);
        %radial_std(i)=std(sampled_radial_slice);
        
    end
    %}
    
    
    %rescale radius and radial_average
    %radial_std=radial_std./img_size;
    radius=radius./img_size;
    radial_average=(radial_average./img_size).*(2*pi*radius);
    
    %radial_average is composed of the noise (x^a*b) and the signal (S/2*pi*r)
    %We arbitrarely set 5px as the limit where S=0
    % test 5 px
    limR=1/5;
    X=log(radius(radius>limR));
    Y=log(radial_average(radius>limR));
    noise_coeff=polyfit(X,Y,1);
    
    %test 10 px
    limR=1/10;
    X=log(radius(radius>limR));
    Y=log(radial_average(radius>limR));
    noise_coeff2=polyfit(X,Y,1);
    
     %Choose smallest slope
    if (abs(noise_coeff2(1))>abs(noise_coeff(1)))
        noise_coeff=noise_coeff2;
    end
    
     %test 7.5 px
    limR=1/10;
    X=log(radius(radius>limR));
    Y=log(radial_average(radius>limR));
    noise_coeff2=polyfit(X,Y,1);

     %Choose smallest slope
    if (abs(noise_coeff2(1))>abs(noise_coeff(1)))
        noise_coeff=noise_coeff2;
    end
    
    noise_fit=radius.^(noise_coeff(1)).*exp(noise_coeff(2));
   
end

function ret = swapSquares(data, sizeSq)
    ret=zeros(2*sizeSq);
    ret(1:sizeSq(1), 1: sizeSq(2))= data(end-sizeSq(1)+1:end,end-sizeSq(2)+1:end );
    ret(1:sizeSq(1), end-sizeSq(2)+1: end)=data(end-sizeSq(1)+1:end, 1: sizeSq(2));
    ret(end-sizeSq(1)+1:end, 1: sizeSq(2))=data(1:sizeSq(1), end-sizeSq(2)+1: end);
    ret(end-sizeSq(1)+1:end, end-sizeSq(2)+1: end)=data(1:sizeSq(1), 1: sizeSq(2));
end