function plotChannel(file, n)
    switch file.header.scan_type
        case 'STM'
            plot.plotSTM(file.channels(n).data,file.header);
        case 'SEM'
            plot.plotSEM(file.channels(n).data,file.header);
    end
    s=[file.header.rec_date, ' - '];
    s=[s,getName(file),' - '];
    s=[s,file.channels(n).Name,' - ',file.channels(n).Direction];
    title(s);
    
end



