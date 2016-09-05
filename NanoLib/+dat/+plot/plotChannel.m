function hObject = plotChannel(x_channel,y_channel,varargin)
%PLOTCHANNEL - plots ONE y_channel vs the x_channel, both are channels
%    of the file loaded with the function dat.load.loadProcessedDat
%
% Syntax: 
%   hObject = PLOTCHANNEL(x_channel)
%   hObject = PLOTCHANNEL(x_channel,y_channel)
%   hObject = PLOTCHANNEL(x_channel,y_channel,varargin)
%
% Inputs:
%    x_channel - channel relative to the x-axis. If only the x_channel is 
%                given, it is plotted vs the number of points.
%    y_channel - channel relative to the y-axis
%    varargin - are the same as for starndard matlab plot function
%       additional options are the same as dat.plot.plotData.m
%
% Outputs:
%    hObject - figure handle
%
% Example: 
%   file = dat.load.loadProcessedDat(fn);
%   hObj = dat.plot.PLOTCHANNEL(file.channels(1),file.channels(2));
%
% See also dat.plot.plotData.m

% September 2016

%------------- BEGIN CODE --------------

% check number of argument in
narginchk(1,inf);

% check if if x_channel is given as argument
xGiven = false;
if nargin == 1
    xGiven = true;
elseif ~isstruct(y_channel)
    xGiven = true;
    varargin = {y_channel,varargin{:}};
end
if xGiven
    y_channel = x_channel;
    x_channel.Name = 'pti';
    x_channel.Unit = ' ';
    x_channel.Direction = y_channel.Direction;
    x_channel.data = repmat(1:size(y_channel.data,1),size(y_channel.data,2),1)';
end

% check if more than 1 channel given
if numel(y_channel) > 1
    error('plotchannel only plots 1 channel at the time. %d provided',numel(y_channel));
end

name = sprintf('%s - %s',y_channel.Name,y_channel.Direction);
hObject = dat.plot.plotData(y_channel.data,name,y_channel.Unit,x_channel,varargin{:});

end
    
