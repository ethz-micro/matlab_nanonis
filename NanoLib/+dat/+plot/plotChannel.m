function hObject = plotChannel(file,chn_number,run_number)
% function hObject = plotChannel(file,chn_number,run_number)

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
        j = 1;
        if ~isempty(strfind(header.file,'.3ds'))
            j = mod(iCh+1,2)+1;
        end
        curveName = sprintf('%s - %d %s - %s',fN{1},iRun,file.channels(iCh).Name,file.channels(iCh).Direction);
        hObject(i) = plot(file.channels(j).data(:,iRun),file.channels(iCh).data(:,iRun),...
            'DisplayName',curveName);
        i = i + 1;
    end
    
end

xlabel(sprintf('%s in %s',file.channels(1).Name,file.channels(1).Unit));
ylabel(sprintf('%s in %s',file.channels(chn_number(1)).Name,file.channels(chn_number(1)).Unit));

end
