function [p,range] = plotSEM(data,header)
%Plot SEM data

%Range = 2*std of data
range = [-2 2]*nanstd(data(:));
p=plotSxm(data, header, range);
end