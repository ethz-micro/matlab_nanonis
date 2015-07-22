function folder2png(folderName)
    %load all files in folder named 'foldername'
    %and saves them as png pictures in an 'images' folder
    
    %Create an images folder
    imgFolder = [folderName, '/images/'];
    mkdir(imgFolder);
    
    %Search all sxm files
    files = dir([folderName, '/*.sxm']);
    
    %Loop through all sxm files
    for i=1:numel(files)
        
        %Load file
        fileInfo=files(i);
        fn = [folderName,'/',fileInfo.name];
        
        %prepare image name
        A = strsplit(fileInfo.name,'.');
        imgNbr = A{1};
        rootImgName=[imgFolder, imgNbr ,'-'];
        
        %sxm to png
        sxm2png(fn,rootImgName);
        
        
    end
    
    %Search all .par files
    files = dir([folderName, '/*.par']);
    
    %Loop through all .par files
    for i=1:numel(files)
        
        %Load file
        fileInfo=files(i);
        fn = [folderName,'/',fileInfo.name];
        
        %prepare image name
        A = strsplit(fileInfo.name,'.');
        imgNbr = A{1};
        rootImgName=[imgFolder, imgNbr ,'-'];
        
        %Save file to PNG
        par2png(parFN,pngRootFN);        
    end
end

%Saves .par as PNG
function par2png(parFN,pngRootFN)
    file=load.loadProcessedPar(parFN);
    
    for j=1:numel(file.channels)
        plot.plotFile(file,j);
        savePNG(pngRootFN,file.channels(j).Name);
    end
end

%Saves SMX as a PNG
function sxm2png(sxmFN,pngRootFN)
    
    file=load.loadProcessedSxM(sxmFN);
    if isfield(file.header,'scan_type')
        switch file.header.scan_type
            
            case 'STM'
                
                %Plot
                
                plot.plotFile(file,1);
                savePNG(pngRootFN,'ZF');
                
                plot.plotFile(file,2);
                savePNG(pngRootFN,'ZB');
                
            case 'NFESEM'
                
                %Save current Forward
                plot.plotFile(file,1);
                savePNG(pngRootFN,'FCF');
                
                %Save current Backward
                plot.plotFile(file,2);
                savePNG(pngRootFN,'FCB');
                
                %Add and plot 4 channels
                channel= op.combineChannel(file,'4 channels',3:2:9,1/4*[1 1 1 1]);
                plot.plotChannel(channel,file.header);
                savePNG(pngRootFN,'4CF');
                
                %Idem backwards
                channel= op.combineChannel(file,'4 channels',4:2:10,1/4*[1 1 1 1]);
                plot.plotChannel(channel,file.header);
                savePNG(pngRootFN,'4CB');
                
            otherwise
                msgbox('unknown scan type - not typical saved channels');
        end
        
    end
end

%Save as a PNG in rootImgName
function savePNG(rootImgName,name)
    imgName=[rootImgName, name,'.png'];
    saveas(gcf,imgName);
end