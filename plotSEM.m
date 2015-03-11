function [p,range] = plotSEM(data,header)
%SEM
range = [-2 2]*nanstd(data(:));%Range = 2*std of data

p=plotSxm(data, header, range);

end