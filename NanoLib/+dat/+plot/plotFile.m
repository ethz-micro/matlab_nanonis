function hObject = plotFile(file,chn_number,varargin)
%PLOTFILE - plots the channels of the file loaded with the function
%           dat.load.loadProcessedDat
%
% Syntax: 
%   hObject = PLOTFILE(file,chn_number)
%   hObject = PLOTFILE(file,chn_number,run_number)
%
% Inputs:
%    file - structure containing fields: header and channels as loaded by 
%           dat.load.loadProcessedDat
%    chn_number - channel number(s) to plot
%    varargin - are the same as for starndard matlab plot function
%               additional options are the same as dat.plot.plotData.m
%
% Outputs:
%    hObject - figure handle
%
% Example:
%   file = dat.load.loadProcessedDat(fn);
%   hObj = dat.plot.PLOTFILE(file,2);
%
% See also dat.plot.plotData.m

% September 2016

%------------- BEGIN CODE --------------

% check variables number
narginchk(2,inf)

% plot
hObject = [];

for i = 1:numel(chn_number)
    iCh = chn_number(i);
    hObj = dat.plot.plotChannel(file.channels(1),file.channels(iCh),...
        varargin{:});
    hObject = [hObject;hObj];
end

xlabel(sprintf('%s in %s',file.channels(1).Name,file.channels(1).Unit));
ylabel(sprintf('%s in %s',file.channels(chn_number(1)).Name,file.channels(chn_number(1)).Unit));

end
