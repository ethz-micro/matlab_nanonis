
clear all;
close all;

%% load image

%image name

%%{
fn='Data/March/2015-03-05/image004.sxm';%DIST = 11
ttl='2015-03-05/image004.sxm';
%}
%%{
fn='Data/March/2015-03-04/image006.sxm';%DIST =0
ttl='2015-03-04/image006.sxm';
%}
%{
fn='Data/March/2015-03-04/image005.sxm';%DIST = 11
ttl='2015-03-04/image005.sxm';
%}


%Load 2,4,6,8 (current + forward channel 0 1 2 3)
file = load.loadProcessedSxM(fn,[0 2 4 6 8]);


%% plot CH 0

%Slope found in hysteresis measurements 
slope=1.03;

%Get number of electrons
Ne=file.channels(2).lineMean.*(file.header.scan_time(1)/file.header.scan_pixels(1));

%Prepare for 1/N vs STD^2 plot
X=Ne.^-1;
Y=file.channels(2).lineStd.^2;

%Remove extraordinary data
Y(Y>prctile(Y,90))=nan;

%Plot
figure        
plot(X,Y,'x',X,slope*X,'-')
xlabel('1/Ne')
ylabel('Variance')
set(gca,'FontSize',20)
title(ttl)
legend('Var[Line]','\sigma_n^2/N_e','location','southeast')

%%
figure 
%% Idem current 

%Get number of electrons
Ne=file.channels(1).lineMean.*(file.header.scan_time(1)/file.header.scan_pixels(1))/(1.6*10^(-19));

%Prepare for 1/N vs STD^2 plot
X=Ne.^-1;
Y=file.channels(1).lineStd.^2;

%Remove extraordinary data
Y(Y>prctile(Y,90))=nan;

%Plot
  
hold all
plot(X,Y,'x')
xlabel('1/Ne')
ylabel('Variance')
set(gca,'FontSize',20)
title(ttl,'FontSize',20)
%legend('Var[Line]','location','southeast')

%%
title('','FontSize',15)

legend('2015-03-05/image004.sxm - d = 11nm', '2015-03-04/image005.sxm - d = 11nm', '2015-03-04/image006.sxm - d = 0nm');



