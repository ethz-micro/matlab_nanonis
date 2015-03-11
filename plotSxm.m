function p=plotSxm(data,header,range)
%Plot and reorientate the images

%Flip if up
if strcmp(header.scan_dir,'up')
    data = flip(data,1);
end

%Rotate
if header.scan_angle ~=0
    data = imrotate(data,-header.scan_angle);
end

%plot
p = imagesc([0 header.scan_range(1)],[0 header.scan_range(2)],data,range);
axis image;

end