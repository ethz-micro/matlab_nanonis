function loadFolder(folderName)
%load and save all files in folder

    %Load & Process SEM Data
    function data = getSEMData(fn,n)
        [~, data] = loadsxm(fn, n);
        data = processSEM(data);
    end

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
        
        [~, ZForward] = loadsxm(fn, 0);
        [~, ZBackward] = loadsxm(fn, 1);
        
        ZForward = processSTM(ZForward);
        ZBackward = processSTM(ZBackward);
        ZBackward = flip(ZBackward,2);
        
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
        currF = getSEMData(fn, 0);
        currB = getSEMData(fn, 1);
        C0F = getSEMData(fn, 2);
        C0B = getSEMData(fn, 3);
        C1F = getSEMData(fn, 4);
        C1B = getSEMData(fn, 5);
        C2F = getSEMData(fn, 6);
        C2B = getSEMData(fn, 7);
        C3F = getSEMData(fn, 8);
        C3B = getSEMData(fn, 9);
        
        %Flip backwards
        currB=flip(currB,2);
        C0B = flip(C0B,2);
        C1B = flip(C1B,2);
        C2B = flip(C2B,2);
        C3B = flip(C3B,2);
        
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