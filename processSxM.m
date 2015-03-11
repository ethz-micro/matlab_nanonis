function [data, slope] = processSxM( data,header )
%Redress the datas and remove mean plane


    function [data,corr] = flatenMeanPlane(data)
        %Remove sample tilt
        crv = nanmean(data,1);
        x=1:size(crv,2);
        p = polyfit(x,crv,1);
        corr= p(1)*x+p(2);
        data = data - ones([size(data,1) 1])*corr;
    end

%Flatten data
[data,slope] = flatenMeanPlane(data);

%Orientation

%Flip if up
if strcmp(header.scan_dir,'up')
    data = flip(data,1);
end

%Rotate
if header.scan_angle ~=0
    data = imrotate(data,-header.scan_angle);
end

end

