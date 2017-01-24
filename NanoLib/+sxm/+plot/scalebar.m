function hObj = scalebar(xStart,yStart,blength,bunits,varargin)
%
% INPUT
%
% xStart = x position of the scale bar /eventually the scan_range
% yStart = y position of the scale bar /eventually the scan_range
% blength = length of the bar
% bunits = units of the bar
% varargin = 'Location', combine 'North','South','West','East'
%            'Color', rgb vector
%
% OUTPUT
% hObj = 2 element graphical object:
% > hObj(1) = scale bar
% > hObj(2) = bar unit
%
% Remark: xStart and yStart can be provided as ranges, 
%  e.g. xStart = [min(x),max(x)]. If this is the case the scale bar will be
%  automaticly placed within the 10% of the [min(x), min(y)] point.


narginchk(4,inf)
sbPos = [0,0]; % scale bar position if scan range provided
sbLoc = {'North';'South';'West';'East'};
sbCol = ones(1,3); % default white
for i = 1:2:numel(varargin)
    switch varargin{i}
        case 'Location'
            for j = 1:numel(sbLoc)
                loc = regexp(upper(varargin{i+1}),upper(sbLoc{j}),'match');
                if ~isempty(loc)
                    sbPos(floor(j/3)+1) = mod(j+1,2);
                end
            end
        case 'Color'
            sbCol = varargin{i+1};
         otherwise
             warning('not valid varargin.')
    end
end

dx = blength;

switch size(xStart,2)
    case 1
        x = xStart;
    case 2
        if sbPos(2)
            x = xStart(2) - diff(xStart)/10 - dx;
        else
            x = xStart(1) + diff(xStart)/10;
        end
end

switch size(xStart,2)
    case 1
        y = yStart;
    case 2
        if sbPos(1)
            y = yStart(2) - diff(yStart)/10;
        else
            y = yStart(1) + diff(yStart)/10;
        end
        
end



hObj(1) = line([x x+dx],y*ones(1,2),1*ones(1,2),'Color',sbCol,...
    'LineWidth',3);
hObj(2) = text(x+dx/2,y,1,sprintf('%.0f %s',blength,bunits),...
    'Color',sbCol,...
    'HorizontalAlignment','center',...
    'VerticalAlignment','bottom','FontSize',20);