function hObject = plotChannel(myData,channel,run_number)
% function hObject = plotChannel(myData,channel,run_number)

% check variables number
narginchk(2,3)

% get information form myData
experiment = myData.experiment;
header = myData.header;
fN = strsplit(header.file,'.');

% if not specific run_number plot all runs of experiment
if ~exist('run_number','var')
    run_number = 1:header.grid_points;
end

% plot
% hObject =  zeros(1,length(channel)*length(run_number));
ii = 1;
for iRun = run_number
    
    for iCh = channel
        jj = 1;
        if ~isempty(strfind(header.file,'.3ds'))
            jj = mod(iCh+1,2)+1;
        end
        curveName = sprintf('%s - %d %s',fN{1},iRun,header.channels{iCh});
        hObject(ii) = plot(experiment.data(:,jj,iRun),experiment.data(:,iCh,iRun),...
            'DisplayName',curveName);
        ii = ii + 1;
    end
    
end

end
