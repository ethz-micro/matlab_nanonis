function plotSumChannel(file,name, chn,chw)
    
    data = cat(3,file.channels(chn).data);
    weights(1,1,:)=chw(:);
    data = data .* repmat(weights,size(data,1),size(data,2),1);
    data = squeeze (sum(data,3));
    
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