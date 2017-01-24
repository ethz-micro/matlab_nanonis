function [color,colorScale] = getColor(x,xRange,mapping)
% this function get a point and a range as an input
% compare it with the visible spectrum and return of light and return the
% corresponding color
%
% mandatory:
% x = value inside the xRange
% xRange = [xMin,xMax]
% opional:
% mappig = colormap function. It may be one of the default colormap 
%          values of matlab (e.g. jet,hsv,...). Jet is the default mapping
%
% example:
% [color,colorScale] = getColor(10,[0,100],@jet)
% 

narginchk(2,3); % check number of variable in

if max(size(xRange))~=2
    error('wrong range. xRange = [xMin,xMax]');
end

colorRange = [400,800];
colorStep = 0.1;
colorTicks = colorRange(1):colorStep:colorRange(2);

if exist('mapping','var')
    colorScale = mapping(length(colorTicks));
else
    colorScale = jet(length(colorTicks));
end

%{
% version 1

if ~exist('mapping','var');
    mapping = 'jet';
end

switch mapping
    case 'jet'
        colorScale = jet(length(colorTicks));
    case 'hsv'
        colorScale = hsv(length(colorTicks));
    case 'parula'
        colorScale = parula(length(colorTicks));
    case 'custom'
        colorScale = jet(length(colorTicks));
    otherwise
        error('wrong mapping')
end
%}

colorValue = colorRange(1)+(x-xRange(1))/diff(xRange)*diff(colorRange);

[~,iColor] = min(abs(colorTicks-colorValue));
color = colorScale(iColor,:);
