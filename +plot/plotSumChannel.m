function plotSumChannel(file,name, chn,chw)
    
    data = combineChannel(file, chn,chw);
    switch file.header.scan_type
        case 'STM'
            plot.plotSTM(data,file.header);
        case 'SEM'
            plot.plotSEM(data,file.header);
    end
    s=[file.header.rec_date, ' - '];
    s=[s,getName(file),' - '];
    s=[s,name];
    title(s);
    
end