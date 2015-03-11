function p=plotSxm(data,header,range)
%Plot

p = imagesc([0 header.scan_range(1)],[0 header.scan_range(2)],data,range);
axis image;

end