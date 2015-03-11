close all;
clear all;

SuperFolder = '2015';
files=dir(SuperFolder);


for i=1:numel(files)
    file = files(i);
    if file.isdir
        loadFolder([SuperFolder,'/', file.name]);
    end
end
