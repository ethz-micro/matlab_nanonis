function [ data,header,lineMedian,lineSTDev, slope] = loadSTM( fn,chn )
%load STM data

%Load raw data
[header,data] = loadsxm(fn,chn);

%Flip if backwards
if mod(chn,2)==1
    data=flip(data,2);
end

%Process
[data, lineMedian,lineSTDev, slope] = processSTM(data,header);

end

