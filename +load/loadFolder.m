function loadFolder(folderName)
    %load and save all files in folder
    
    %Save as a PNG in rootImgName
    function savePNG(name)
        imgName=[rootImgName, name,'.png'];
        saveas(gcf,imgName);
    end
    
    
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
                
                plot.plotChannel(file,1);
                savePNG('ZF');
                
                plot.plotChannel(file,2);
                savePNG('ZB');
                
            case 'SEM'
                
                %Save current Forward
                plot.plotChannel(file,1);
                savePNG('FCF');
                
                %Save current Backward
                plot.plotChannel(file,2);
                savePNG('FCB');
                
                %Add and plot 4 channels
                plot.plotSumChannel(file,'4 channels - forward', 3:2:9,1/4*[1 1 1 1]);
                savePNG('4CF');
                
                %Idem backwards
                plot.plotSumChannel(file,'4 channels - backward', 4:2:10,1/4*[1 1 1 1]);
                savePNG('4CB');
                
            otherwise
                msgbox('unknown scan type - not typical saved channels');
        end
        
        
        
    end
    
    
end