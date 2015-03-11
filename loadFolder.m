function loadFolder(folderName)
%load and save all files in folder

    %Save as a PNG in rootImgName
    function savePNG(name)
        imgName=[rootImgName, name,'.png'];
        saveas(gcf,imgName);
    end

    %Set the title with name and header
    function titleSxm(name, header)
        title([header.rec_date,' - ', imgNbr ,' - ',name]);
    end

%Create an images folder
imgFolder = [folderName, '/images/'];
mkdir(imgFolder);

%Search all sxm files
files = dir([folderName, '/*.sxm']);

%Loop threw all sxm files
for i=1:numel(files)
    
    %Load file
    file=files(i);
    fn = [folderName,'/',file.name];
    header = loadsxm(fn);
    
    %prepare image name
    A = strsplit(file.name,'.');
    imgNbr = A{1};
    rootImgName=[imgFolder, imgNbr ,'-'];
    
    %Determine if STM or SEM
    info = header.data_info;
    A = strsplit(info,'\n');
    count = numel(A);%4 for stm, 7 for sem
    
    if count == 4
        %STM, load Z
        
        ZForward = loadSTM(fn, 0);
        ZBackward =loadSTM(fn, 1);
        
        %Plot
        
        plotSTM(ZForward,header);
        titleSxm('Z Forward',header);
        savePNG('ZF');
   
        plotSTM(ZBackward,header);
        titleSxm('Z Backward',header);
        savePNG('ZB');
        
    elseif count == 7
        %SEM, load channels 0-3 and current
        
        %Current
        currF = loadSEM(fn, 0);
        currB = loadSEM(fn, 1);
        C0F = loadSEM(fn, 2);
        C0B = loadSEM(fn, 3);
        C1F = loadSEM(fn, 4);
        C1B = loadSEM(fn, 5);
        C2F = loadSEM(fn, 6);
        C2B = loadSEM(fn, 7);
        C3F = loadSEM(fn, 8);
        C3B = loadSEM(fn, 9);
        
        %Save current Forward
        plotSEM(currF,header);
        titleSxm('Field current Forward',header);
        savePNG('FCF');
        
        %Save current Backward
        plotSEM(currB,header);
        titleSxm('Field current Backward',header);
        savePNG('FCB');
        
        %Add and plot 4 channels
        dataF = 1/4*(C0F + C1F + C2F + C3F);
        plotSEM(dataF,header);
        titleSxm('4 channels Forward',header);
        savePNG('4CF');
        
        %Idem backwards
        dataB = 1/4*(C0B + C1B + C2B + C3B);
        plotSEM(dataB,header);
        titleSxm('4 channels Backwards',header);
        savePNG('4CB');
        
    else
      msgbox('unknown scan type - not typical saved channels'); 
    end
    
    
    
end


end