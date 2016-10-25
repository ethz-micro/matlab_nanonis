function [nanoLib,dataPath]=setSettings()

% get path
wdlg = warndlg({'set local path to NanoLib'});
waitfor(wdlg);
nanoLib = uigetdir(pwd,'Set NanoLib path');
if ~ischar(nanoLib)
    error('Chose a directory for NanoLib');
end

wdlg = warndlg({'set local path to Data'});
waitfor(wdlg);
dataPath = uigetdir(pwd,'Set NanoLib USER library path');
if ~ischar(dataPath)
    error('Chose a directory for Data');
end

% save
fn = sprintf('%s','localSettings.txt');
fileID = fopen(fn,'w');
fprintf(fileID,'%s\t%s\n','nanoLib',nanoLib);
fprintf(fileID,'%s\t%s\n','dataPath',dataPath);
fclose(fileID);