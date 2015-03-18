close all;
clear all;
%call loadFolder in all folder inside superfolder
SuperFolder = 'Data/March';
files=dir(SuperFolder);


for i=1:numel(files)
    file = files(i);
    if file.isdir
        load.loadFolder([SuperFolder,'/', file.name]);
    end
end
