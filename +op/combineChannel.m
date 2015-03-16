function data=combineChannel(file, chn,chw)
    data = cat(3,file.channels(chn).data);
    weights(1,1,:)=chw(:);
    data = data .* repmat(weights,size(data,1),size(data,2),1);
    data = squeeze (sum(data,3));
end