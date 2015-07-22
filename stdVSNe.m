
clear all;
close all;

%% load image

%image name
%fn='Data/March/2015-03-05/image004.sxm';
fn='Data/March/2015-03-04/image006.sxm';
%Load 2,4,6,8 (current + forward channel 0 1 2 3)
file = load.loadProcessedSxM(fn,[0 2 4 6 8]);


slope=1;%0.93;
Ne=file.channels(2).median.*(file.header.scan_time(1)/file.header.scan_pixels(1));
X=Ne.^-1;
Y=file.channels(2).std.^2;%-X*slope;
%myFit=fit(X,Y,'poly1');
figure        
%plot(X,Y,'x',X,myFit.p2+myFit.p1*X,'-')        
%, correlation with median: ',num2str(corrMnSTDev)]);
%legend('data',sprintf('%gx+%g',myFit.p1,myFit.p2))
plot(X,Y,'x',X,slope*X,'-')
xlabel('median^{-.5}')
ylabel('STD')
