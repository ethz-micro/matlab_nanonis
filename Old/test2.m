close all;
clear all;

fn='Data/March/2015-03-04/image005.sxm';
[header,data]=loadSxM.loadsxm(fn,0);

dStdRaw=std(data,0,2);

minI=min(data(:));
if minI<0
    %Correct the offset
    %data=data-minI;
end



dMean=mean(data,2);
dMMtx=repmat(dMean,1,size(data,2));
dStd=std(data./dMMtx,0,2);

X=dMean;

figure
Y=(dStdRaw).^2;

fit=polyfit(X,Y,2);
X1 = linspace(min(X),max(X));
Y1 = polyval(fit,X1);
%remove 10%
Y(Y>prctile(Y,95))=nan;
plot(X,Y,'x');
hold all
plot(X1,Y1)
title('raw')
xlabel('Ne')
ylabel('Var')


