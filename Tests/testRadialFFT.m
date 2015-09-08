close all;
clear all;
%fn='Data/Aram/image035.sxm';%36:48
cn=1;%1 is current, 3 intensity
%cn=3;
%fn='Data/Aram/image046.sxm';%36:48
%fn='Data/2013-12-04/image061.sxm';
%fn='Data/2013-12-04/image054.sxm';
%fn='Data/2013-12-06/image006.sxm';
%fn='Data/Aram/image048.sxm';
%fn='Data/2013-12-06/image047.sxm';
%fn='Data/2013-12-05/image036.sxm';
%fn='Data/2013-12-05/image051.sxm';
%fn='Data/2013-12-05/image060.sxm';
fn='Data/2013-12-06/image028.sxm';
%fn='Data/2013-12-06/image029.sxm';%29-32
%fn='Data/2013-12-05/image040.sxm';

file=load.loadProcessedSxM(fn);%Z=3.5

%Get data
[radius, radial_average] =op.getRadialFFT(file.channels(cn).data,file.header.scan_pixels(1)/file.header.scan_range(1)/1e9);
[noise_fit] =op.getRadialNoise(radius, radial_average);

figure
loglog(1./radius,radial_average,'x-')
hold all
%loglog(radius(radius>limR),radial_amplitude(radius>limR),'x-')
loglog(1./radius,noise_fit)
%title('4.12.13 - image 46','FontSize',12)
xlabel('wavelength [nm]')
ylabel('Amplitude [unitless]')
set(gca,'FontSize',20)
legend('Radial Spectrum','Fitted Noise','2nd noise','FontSize',12,'Location','NorthEast')

%%
figure
plot.plotFile(file,cn,0,0,'NoTitle')
%%
figure
%loglog(radius,40*(radial_average-noise_fit)+1,'x-','DisplayName','40*(average-corr)+1')
%hold all
loglog(1./radius,radial_average./noise_fit,'x-','DisplayName','signal/noise')
%title('ratio vs substraction');
xlabel('wavelength [nm]')
ylabel('Amplitude [au]')
legend(gca,'show')

%%
figure
plot.plotFile(file,cn);

%%

figure
loglog(radius,radial_average,'x-')
hold all

data=op.interpHighStd(file.channels(cn).data);
%Get data
[radius, radial_average] =op.getRadialFFT(data,file.header.scan_pixels(1)/file.header.scan_range(1)/1e9);
loglog(radius,radial_average,'x-')

data=op.interpPeaks(file.channels(cn).data);

%Get data
[radius, radial_average] =op.getRadialFFT(data,file.header.scan_pixels(1)/file.header.scan_range(1)/1e9);
loglog(radius,radial_average,'x-')

data=op.interpPeaks(op.interpHighStd(file.channels(cn).data));

%Get data
[radius, radial_average] =op.getRadialFFT(data,file.header.scan_pixels(1)/file.header.scan_range(1)/1e9);
loglog(radius,radial_average,'x-')
loglog(radius,noise_fit,'-')

legend('Base','Interpolated lines', 'interpolated peaks')
xlabel('frequency [1/nm]')
ylabel('Amplitude [au]')
set(gca,'FontSize',20)


[noise_fit,signal_start,signal_error] =op.getRadialNoise(radius, radial_average);

figure
loglog(1./radius,radial_average,'x-')
hold all
loglog(1./radius,noise_fit,'-')

legend('Radial Spectrum', 'Fitted Noise','2','3')
xlabel('wavelength [nm]')
ylabel('Amplitude [dimentionless]')
set(gca,'FontSize',20)



file.channels(cn).data=data;

figure
plot.plotFile(file,cn);
%%
figure
loglog(1./radius,radial_average./noise_fit)

