function [p,range] = plotSTM(data,header)

%Keep lines with STD < 3* median to scale
stdData= std(data,0,2);
stdCut=3*nanmedian(stdData);

%Cut to keep "good lines"
linesSTDev= stdData < stdCut;
linesSTDev = logical(linesSTDev*ones([1 size(data,2)]));%matrix size
signal=data(linesSTDev);

%Use 2 std
stdData=std(signal(:));
% if stdData is NaN, recompute on non-nan value
if isnan(stdData)
    good = ~isnan(signal);
    stdData=std(signal(:));
    %If still not good, there is no usable data
    if isnan(stdData)
        stdData=1;
    end
end

range = [-1 1]*3*stdData;

p = plotSxm(data, header, range);
end