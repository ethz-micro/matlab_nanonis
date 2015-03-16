function applyMask(mask,xrange,yrange,color,alpha)
% This function apply the mask 'mask' to the current handle. 
%   X- and Yrange specify the position of the mask
%   color is a vector with RGB values : [R,G,B]
%   alpha is the transparancy of the mask

%Create uniform image
colorImage(1,1,:)=color(:);
colorImage = repmat(colorImage,size(mask));

%Draw uniform image
hold on 
set(gca,'YDir','reverse');%because could cause a problem otherwhise
h = image(xrange,yrange,colorImage); 
hold off

%Apply alpha
alpha = mask*alpha;
set(h, 'AlphaData', alpha);

end
