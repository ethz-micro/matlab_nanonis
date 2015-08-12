close all;
clear all;

fn='Data/March/2015-03-04/image005.sxm';%DIST = 11
ttl='2015-03-04/image005.sxm';

file = load.loadProcessedSxM(fn,[0]);

figure
plot.plotFile(file,1);


%Get number of electrons
Ne=file.channels(1).lineMean;%.*(file.header.scan_time(1)/file.header.scan_pixels(1))/(1.6*10^(-19));

%Prepare for 1/N vs STD^2 plot
X=1./Ne;
Y=file.channels(1).lineStd.^2;
Y=(file.channels(1).lineRawStd.*X).^2;

%remove 10%
Y(Y>prctile(Y,90))=nan;

%Plot
figure     
plot(X,Y,'x')
xlabel('1/Ne')
ylabel('Variance')
set(gca,'FontSize',20)
title(ttl)
legend('Var[Line]','location','southeast')




