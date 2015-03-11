function [ data,header, lineMean , lineStd, slope] = loadSEM( fn,chn )
%load SEM data

%Load raw data
[header,data] = loadsxm(fn,chn);

%Flip if backwards
if mod(chn,2)==1
    data=flip(data,2);
end

%Process
[data, lineMean , lineStd, slope] = processSEM(data,header);

end

