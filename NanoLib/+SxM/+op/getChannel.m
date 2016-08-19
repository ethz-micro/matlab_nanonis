function channelNumber = getChannel(channels,channelNames,direction)
%
% function channels = getChannel(channels,channelNames,direction)
%
% This function search in the channel variable for one or more channels 
% name. If no direction is chosen, all possible direction is chosen.
%
% input: channels = channel structure with field Name and Direction
%        channelname = cell array with the name (or part of name) to search
%        direction = string with direction (f and b also work)
%
% output: channelNumber = list of channel number

narginchk(2,3)

if ~iscellstr(channelNames)
    channelNames = {channelNames};
end

channelNumber = nan(1,numel(channels));
% find channel 2 plot
k = 1;
for j = 1:numel(channelNames)
    channelName = channelNames{j};
    for i = 1:numel(channels)
        if ~isempty(strfind(upper(channels(i).Name),upper(channelName)))
            channelNumber(k) = i;
            if exist('direction','var')
                if isempty(strfind(upper(channels(i).Direction),upper(direction)))
                    channelNumber(k) = nan;
                end
            end
            k = k+1;
        end
    end
end

channelNumber(isnan(channelNumber)) = [];

end

