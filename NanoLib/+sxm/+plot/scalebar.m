function hObj = scalebar(xStart,yStart,blength,bunits)
%
% INPUT
%
% xStart = x position of the scale bar
% yStart = y position of the scale bar
% blength = length of the bar
% bunits = units of the bar
%
% OUTPUT
% hObj = 2 element graphical object:
% > hObj(1) = scale bar
% > hObj(2) = bar unit
%
% Remark: xStart and yStart can be provided as ranges, 
%  e.g. xStart = [min(x),max(x)]. If this is the case the scale bar will be
%  automaticly placed within the 10% of the [min(x), min(y)] point.


narginchk(4,4)

dx = blength;

switch size(xStart,2)
    case 1
        x = xStart;
    case 2
        x = xStart(1) + diff(xStart)/10;
end

switch size(xStart,2)
    case 1
        y = yStart;
    case 2
        y = yStart(1) + diff(yStart)/10;
end


hObj(1) = line([x x+dx],y*ones(1,2),1*ones(1,2),'Color',ones(1,3),...
    'LineWidth',3);
hObj(2) = text(x+dx/2,y,1,sprintf('%.0f %s',blength,bunits),...
    'Color',ones(1,3),...
    'HorizontalAlignment','center',...
    'VerticalAlignment','bottom','FontSize',20);