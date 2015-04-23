function loadFolder(folderName)
    %load and save all files in folder
    
  
    
    
    %Create an images folder
    imgFolder = [folderName, '/images/'];
    mkdir(imgFolder);
    
    %Search all sxm files
    files = dir([folderName, '/*.sxm']);
    
    %Loop threw all sxm files
    for i=1:numel(files)
        
        %Load file
        fileInfo=files(i);
        fn = [folderName,'/',fileInfo.name];
        
        %prepare image name
        A = strsplit(fileInfo.name,'.');
        imgNbr = A{1};
        rootImgName=[imgFolder, imgNbr ,'-'];
        
        file=load.loadProcessedSxM(fn);
        
        switch file.header.scan_type
            
            case 'STM'
                
                %Plot
                
                plot.plotFile(file,1);
                savePNG(rootImgName,'ZF');
                
                plot.plotFile(file,2);
                savePNG(rootImgName,'ZB');
                
            case 'SEM'
                
                %Save current Forward
                plot.plotFile(file,1);
                savePNG(rootImgName,'FCF');
                
                %Save current Backward
                plot.plotFile(file,2);
                savePNG(rootImgName,'FCB');
                
                %Add and plot 4 channels
                channel= op.combineChannel(file,'4 channels',3:2:9,1/4*[1 1 1 1]);
                plot.plotChannel(channel,file.header);
                savePNG(rootImgName,'4CF');
                
                %Idem backwards
                channel= op.combineChannel(file,'4 channels',4:2:10,1/4*[1 1 1 1]);
                plot.plotChannel(channel,file.header);
                savePNG(rootImgName,'4CB');
                
            otherwise
                msgbox('unknown scan type - not typical saved channels');
        end
        
        
        
    end
    
    %Search all par files
    files = dir([folderName, '/*.par']);
    
    %Loop threw all par files
    for i=1:numel(files)
        
        %Load file
        fileInfo=files(i);
        fn = [folderName,'/',fileInfo.name];
        
        %prepare image name
        A = strsplit(fileInfo.name,'.');
        imgNbr = A{1};
        rootImgName=[imgFolder, imgNbr ,'-'];
        
        file=load.loadProcessedPar(fn);
        
        for j=1:numel(file.channels)
            plot.plotFile(file,j);
            savePNG(rootImgName,file.channels(j).Name);
        end
        
    end
    
    
    
end

%Save as a PNG in rootImgName
function savePNG(rootImgName,name)
    imgName=[rootImgName, name,'.png'];
    saveas(gcf,imgName);
end