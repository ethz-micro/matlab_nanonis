function colorMap = nanonisMap(nPti)
% return nPti number of color distributed over the rgm colormap 
% defined below 
%
% input: nPti = integer number of the number of colors
%
% outpu: colorMap = nPti x 3 rgb color matrix
%

narginchk(0,1)

if nargin == 0
    nPti = 64;
end

% RGB map of the nanonis colors
rgbPti = [...
      0,   8,   3,   4; ...
     17, 124,  48,  68; ...
     29, 194,  47,  47; ...
     39, 222, 126,  29; ...
     49, 227, 192,  27; ...
     58, 232, 232, 232; ...
     63, 255, 255, 255; ...
    ];

% get color distributed along x within the RGB map 
x = linspace(0,63,nPti);
r = colorfunction(rgbPti(:,1),rgbPti(:,2),x);
g = colorfunction(rgbPti(:,1),rgbPti(:,3),x);
b = colorfunction(rgbPti(:,1),rgbPti(:,4),x);

% normalize colors to 1
colorMap = [r',g',b']/255;

%% plot result
% figure
% box on
% hold on
% plot(cPti(:,1),cPti(:,2),'r');
% plot(x,r,'or');
% plot(cPti(:,1),cPti(:,3),'g');
% plot(x,g,'og');
% plot(cPti(:,1),cPti(:,4),'b');
% plot(x,b,'ob');


function myColor = colorfunction(xP,yP,x)

% create a cellarray of function within the given intervals xP,yP
f = cell(1,size(xP,1));
for i = 1:size(xP,1)-1
    a0 = diff(yP(i:i+1))/diff(xP(i:i+1));
    b0 = -xP(i)*a0+yP(i);
    % fprintf('x*%0.2f+%0.2f\n',x*a0+b0);
    f{i} = @(x) x*a0+b0;
end
% add  function to the last point of the interval
f{size(xP,1)} = f{size(xP,1)-1};

myColor = arrayfun(@(x_i) f{1,find(xP<=x_i,1,'last')}(x_i),x);