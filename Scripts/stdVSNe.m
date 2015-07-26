
clear all;
close all;

%% load image

%image name
fn='Data/March/2015-03-05/image004.sxm';%DIST = 11
%fn='Data/March/2015-03-04/image006.sxm';%DIST =0

%Load 2,4,6,8 (current + forward channel 0 1 2 3)
file = load.loadProcessedSxM(fn,[0 2 4 6 8]);

%Slope found in hysteresis measurements 
slope=1.03;

%Get number of electrons
Ne=file.channels(2).lineMean.*(file.header.scan_time(1)/file.header.scan_pixels(1));

%Prepare for 1/N vs STD^2 plot
X=Ne.^-1;
Y=file.channels(2).lineStd.^2;

%Remove extraordinary data
Y(Y>.2)=nan;

%Plot
figure        
plot(X,Y,'x',X,slope*X,'-')
xlabel('1/Ne')
ylabel('Variance')
set(gca,'FontSize',20)
title('2015-03-05/image004.sxm')
legend('Var[Line]','sigma_e^2/Ne','location','southeast')

