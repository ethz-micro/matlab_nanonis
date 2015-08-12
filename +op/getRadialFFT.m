function [radial_amplitude, pixFrequency_radius,noise_amplitude] =getRadialFFT(data)
    %Gives the radial amplitude for a given pixel frequency deducting the
    %noise
    %Adapted from http://www.mathworks.com/matlabcentral/newsreader/view_original/88838
    
    %Get fourrier transform
    img=abs(fft2(data-mean(data(:))));
    
    %Reorder fourrier data
    sizeSq = floor(size(img)/2);
    img = swapSquares(img,sizeSq);
   
    %compute center, +1 as matlab don't start from 0
    center = size(img)/2+1;
    
    %compute size (assumed square)
    img_size=size(img,1);
    
    % Create the meshgrid to be used in resampling
    [X,Y] = meshgrid(1:img_size,1:img_size);
    
    %Create the test radius
    radius = 1:.5:round(0.5*img_size);
    
    %loop radius
    for i=size(radius,2):-1:1
        r=radius(i);
        
        % To avoid redundancy, sample at roughly 1 px distances
        num_pxls = 2*pi*r;
        theta = 0:1/num_pxls:2*pi;
        
        x = center(1) + r*cos(theta);
        y = center(2) + r*sin(theta);
        
        sampled_radial_slice = interp2(X,Y,img,x,y);
        radial_average(i) = mean(sampled_radial_slice);
        
    end
    
    %Approximate noise to minimum of radial average
    noise_amplitude=min(radial_average);
    
    %Get radial amplitude (rescaled)
    radial_amplitude=(radial_average-noise_amplitude).*radius*2*pi./(img_size^2);%
    
    %Rescale radius and noise amplitude
    pixFrequency_radius=radius./img_size;
    noise_amplitude=noise_amplitude./img_size;
end