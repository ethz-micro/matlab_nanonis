%---------------------------------------------
%   This files create an image for all the files in a folder in the given
%   folder
%
%   Calls loadFolder on all folders
%
%
%---------------------------------------------
close all;
clear all;
%call loadFolder in all folder inside superfolder
SuperFolder = 'Data/March';
files=dir(SuperFolder);


for i=1:numel(files)
    file = files(i);
    if file.isdir
        plot.folder2png([SuperFolder,'/', file.name]);
    end
end
