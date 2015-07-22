function data = nanHighStd(data)

%Keep lines with STD < 3* median to scale
stdData= nanstd(data,0,2);
stdCut=3*nanmedian(stdData);

%Cut to keep "good lines"
linesSTDev= stdData > stdCut;
linesSTDev = logical(linesSTDev*ones([1 size(data,2)]));%matrix size
data(linesSTDev)=nan;
end