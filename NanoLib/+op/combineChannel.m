function channel=combineChannel(file,name, chn,chw)
    %Get data
    data = cat(3,file.channels(chn).data);
    weights(1,1,:)=chw(:);
    data = data .* repmat(weights,size(data,1),size(data,2),1);
    channel.data = squeeze (sum(data,3));
    
    %Save name
    channel.Name=name;
    
    %Save direction
    %If every direction is the same, save direction, otherwhise both
    if all(strcmp({file.channels(chn).Direction},file.channels(chn(1)).Direction)) 
        channel.Direction=file.channels(chn(1)).Direction;
    else
        channel.Direction='both';
    end
    
    %Unit
    if all(strcmp({file.channels(chn).Unit},file.channels(chn(1)).Unit)) 
        channel.Unit=file.channels(chn(1)).Unit;
    else
        channel.Unit='?';%What does it mean to add something that has different units?
    end
    
    
    
end