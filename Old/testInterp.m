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

[wavelength,radial_average] =op.getRadialFFT(data,file.header.scan_pixels(1)/file.header.scan_range(1)/1e9);

figure
loglog(wavelength,radial_average,'x--')
hold all

data=op.interpPeaks(data);
[wavelength, radial_average] =op.getRadialFFT(data,file.header.scan_pixels(1)/file.header.scan_range(1)/1e9);
loglog(wavelength,radial_average,'x--')

legend('Base', 'Interpolated', 'other')
xlabel('\lambda [nm]')
ylabel('Amplitude [au]')
set(gca,'FontSize',20)

figure
histogram(data(:));

file.channels(chn).data=data;
figure
plot.plotFile(file,chn);

%%
[noise_fit,start]=op.getRadialNoise(wavelength, radial_average);
signalNorm=radial_average./noise_fit;



[filtered, removed]=op.filterData(data,start.*file.header.scan_pixels(1)/file.header.scan_range(1)/1e9);

file.channels(chn).data=filtered;
figure
plot.plotFile(file,chn);

file.channels(chn).data=removed;
figure
plot.plotFile(file,chn);

file.channels(chn).data=filtered+removed;
figure
plot.plotFile(file,chn);





