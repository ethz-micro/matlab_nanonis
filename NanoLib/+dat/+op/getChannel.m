function channels = getChannel(header,channelName,direction)
% function channels = getChannel(header,channelName,direction)

narginchk(2,3)

channels = nan(1,numel(header.channels));
% find channel 2 plot
for ii = 1:numel(header.channels)
    if ~isempty(strfind(upper(header.channels{ii}),upper(channelName)))
        channels(ii) = ii;
        if exist('direction','var')
            if isempty(strfind(header.channels{ii},direction))
                channels(ii) = nan;
            end
        end
    end   
end

channels = channels(~isnan(channels));

end

