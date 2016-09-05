function hObject = plotFile(file,chn_number,run_number)
%PLOTFILE - plots the channels and optionally the running number of a file
%
% Syntax: 
%   hObject = PLOTFILE(file,chn_number)
%   hObject = PLOTFILE(file,chn_number,run_number)
%
% Inputs:
%    file - structure containing fields: header and channels as loaded by 
%           dat.load.loadProcessedDat
%    chn_number - channel number(s) to plot
%    run_number - repetition number(s) to plot
%
% Outputs:
%    hObject - figure handle
%
% Example: 
%
% Other m-files required: dat.plot.plotData.m
%
% See also DAT.LOAD.loadProcessedDat, dat.plot.plotData.m

% September 2016

%------------- BEGIN CODE --------------

% check variables number
narginchk(2,3)

% get information form file
header = file.header;
fileStr = strsplit(header.file,'/');
fN = strsplit(fileStr{end},'.');

% if not specific run_number plot all runs of experiment
if ~exist('run_number','var')
    run_number = 1:header.grid_points;
end

% plot
hObject = gobjects(length(chn_number)*length(run_number));
i = 1;
for iRun = run_number
    for iCh = chn_number
        
        curveName = sprintf('%s - %d %s - %s',fN{1},iRun,file.channels(iCh).Name,file.channels(iCh).Direction);
        hObject(i) = dat.plot.plotData(file.channels(iCh).data(:,iRun),' ',...
            file.channels(iCh).Unit,file.channels(1),'hideLabels',...
            'DisplayName',curveName);
        i = i + 1;
    end
    
end

xlabel(sprintf('%s in %s',file.channels(1).Name,file.channels(1).Unit));
ylabel(sprintf('%s in %s',file.channels(chn_number(1)).Name,file.channels(chn_number(1)).Unit));

end
