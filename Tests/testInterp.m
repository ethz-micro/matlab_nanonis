close all;
clear all;
%fn='Data/2013-12-06/image046.sxm';
fn='Data/2013-12-04/image046.sxm';
chn=3;
cutPrct=1.3;

[header, data]= load.loadsxm(fn,chn);

figure
histogram(data(:));

file=load.loadProcessedSxM(fn);
data=file.channels(chn).data;

figure
histogram(data(:));

figure
plot.plotFile(file,chn);

[radial_average, radius] =op.getRadialFFT(data,file.header.scan_pixels(1)/file.header.scan_range(1)/1e9);

figure
loglog(radius,radial_average,'x--')
hold all

data=op.interpPeaks(data);
[radial_average, radius, noise_fit] =op.getRadialFFT(data,file.header.scan_pixels(1)/file.header.scan_range(1)/1e9);
loglog(radius,radial_average,'x--')

legend('Base', 'Interpolated', 'other')
xlabel('Frequency [1/nm]')
ylabel('Amplitude [au]')
set(gca,'FontSize',20)

figure
histogram(data(:));

file.channels(chn).data=data;
figure
plot.plotFile(file,chn);

%%

signalNorm=radial_average./noise_fit;

rIdx=find(signalNorm>cutPrct,1,'last');
wavelength=1./radius(rIdx)

[filtered, removed]=op.filterData(data,wavelength.*file.header.scan_pixels(1)/file.header.scan_range(1)/1e9);

file.channels(chn).data=filtered;
figure
plot.plotFile(file,chn);

file.channels(chn).data=removed;
figure
plot.plotFile(file,chn);

file.channels(chn).data=filtered+removed;
figure
plot.plotFile(file,chn);





