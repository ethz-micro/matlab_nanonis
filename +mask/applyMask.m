function applyMask(mask,varargin)
% This function apply the mask 'mask' to the current handle. 
%   X- and Yrange specify the position of the mask
%   color is a vector with RGB values : [R,G,B]
%   alpha is the transparancy of the mask

color=[0,0,0];
alpha=1;
xrange=get(gca,'XLim');
yrange=get(gca,'YLim');
%correct matlab extended margin (.2%)
xrange=xrange+.002*[1 -1]*diff(xrange);
yrange=yrange+.002*[1 -1]*diff(yrange);

if nargin>1
    color=varargin{1};
end
if nargin>2
    alpha=varargin{2};
end
if nargin>4
    xrange=varargin{3};
    yrange=varargin{4};
end

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
