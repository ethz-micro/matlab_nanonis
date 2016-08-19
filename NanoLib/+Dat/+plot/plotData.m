function hObject = plotData(myData,data2plot,varargin)
% function hObject = plotChannel(myData,channel,varargin)
% varargin are the same as for normal matlab plot function

% get information form myData
experiment = myData.experiment;

% plot

hObject = plot(experiment.data(:,1,1),data2plot,varargin{:});


end
