function channel=divideByChannel(file,name,chn_N,chn_D,chw)
    
    % direction
    if strcmp(file.channels(chn_N).Direction,file.channels(chn_D).Direction)
        channel.Direction=file.channels(chn_N).Direction;
    else
        error('you cannot divide process different directions. Check input channlels');
    end

    % division
    channel.data = chw * file.channels(chn_N).data./file.channels(chn_D).data;
    
    % name
    channel.Name=name;
    
    %Unit
    if strcmp(file.channels(chn_N).Unit,file.channels(chn_D).Unit)
        channel.Unit='a.u.';
    else
        channel.Unit=sprintf('%s / %s',file.channels(chn_N).Unit,file.channels(chn_D).Unit);
    end
    
end