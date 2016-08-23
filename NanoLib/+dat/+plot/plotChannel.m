function hObject = plotChannel(channel,sweep_chn,varargin)
% hObject = plotChannel(channel,sweep_chn,varargin)
%
% varargin are the same as for normal matlab plot function
% additional options are:
%      varargin = {'xOffset',NUMBER} : shift of the x axis 
%      varargin = {'hideLabels'}     : leave labels out

if numel(channel) > 1
    error('plotchannel only plots 1 channel at the time. %d provided',numel(channel));
end

name = sprintf('%s - %s',channel.Name,channel.Direction);
hObject = dat.plot.plotData(channel.data,name,channel.Unit,sweep_chn,varargin{:});

end
    
