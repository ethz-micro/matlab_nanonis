function hObject = plotChannel(y_channel,x_channel,varargin)
% hObject = plotChannel(channel,x_channel,varargin)
%
% varargin are the same as for normal matlab plot function
% additional options are:
%      varargin = {'xOffset',NUMBER} : shift of the x axis 
%      varargin = {'hideLabels'}     : leave labels out

if numel(y_channel) > 1
    error('plotchannel only plots 1 channel at the time. %d provided',numel(y_channel));
end

% one may provide the file insted of the x_channel
% in this case the first channel is the x_channel
if isfield(x_channel,'header')
    x_channel = x_channel.channels(1);
end

name = sprintf('%s - %s',y_channel.Name,y_channel.Direction);
hObject = dat.plot.plotData(y_channel.data,name,y_channel.Unit,x_channel,varargin{:});

end
    
