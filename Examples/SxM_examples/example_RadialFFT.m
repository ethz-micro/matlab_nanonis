close all;
clear all;
%% add NanoLib
addpath('../../NanoLib/')

cn=1;
%%
fn='../Files/Si_7x7_051.sxm';
file=sxm.load.loadProcessedSxM(fn);%Z=3.5

%%
data=sxm.op.interpPeaks(file.channels(cn).data);
%Get data
[wavelength, radial_average] =sxm.op.getRadialFFT(data,file.header.scan_pixels(1)/file.header.scan_range(1)/1e9);
[noise_fit] =sxm.op.getRadialNoise(wavelength, radial_average);

figure
plot(wavelength,(radial_average-noise_fit),'x');
hold all
plot(wavelength, 0.04*noise_fit)
plot(wavelength, -0.04*noise_fit)
set(gca,'XScale','log')

%%

%Get data
[wavelength, radial_average] =sxm.op.getRadialFFT(file.channels(cn).data,file.header.scan_pixels(1)/file.header.scan_range(1)/1e9);


figure
loglog(wavelength,radial_average,'x-')
hold all

%%
hold all
[noise_fit] = sxm.op.getRadialNoise(wavelength, radial_average,2);
loglog(wavelength,noise_fit)
%title('4.12.13 - image 46','FontSize',12)
xlabel('\lambda [nm]')
ylabel('amplitude')
set(gca,'FontSize',20)
legend('Radial Spectrum','Fitted Noise','2nd noise','FontSize',12,'Location','NorthEast')

%%
figure
sxm.plot.plotFile(file,cn,0,0,'NoTitle')
%%
figure
loglog(wavelength,radial_average./noise_fit,'x-','DisplayName','signal/noise')
%title('ratio vs substraction');
xlabel('\lambda [nm]')
ylabel('amplitude')
legend(gca,'show')

%%
figure
sxm.plot.plotFile(file,cn);

%%

figure
loglog(wavelength,radial_average,'x-')

hold all

data=sxm.op.interpHighStd(file.channels(cn).data); % interpolate lines
%Get data
[wavelength, radial_average] =sxm.op.getRadialFFT(data,file.header.scan_pixels(1)/file.header.scan_range(1)/1e9);
%loglog(wavelength,radial_average,'x-')


data=sxm.op.interpPeaks(file.channels(cn).data); %interpolate peaks

%Get data
[wavelength, radial_average] =sxm.op.getRadialFFT(data,file.header.scan_pixels(1)/file.header.scan_range(1)/1e9);
loglog(wavelength,radial_average,'x-')

data=sxm.op.interpPeaks(sxm.op.interpHighStd(file.channels(cn).data));


%Get data
[wavelength, radial_average] =sxm.op.getRadialFFT(data,file.header.scan_pixels(1)/file.header.scan_range(1)/1e9);
%loglog(wavelength,radial_average,'x-')

%loglog(wavelength,noise_fit,'-')


legend('Base', 'Interpolated')
%legend('Base','Interpolated lines', 'interpolated peaks')
xlabel('\lambda [nm]')
ylabel('amplitude')
set(gca,'FontSize',20)


[noise_fit,signal_start,signal_error] =sxm.op.getRadialNoise(wavelength, radial_average,1);

figure
loglog(wavelength,radial_average,'x-')
hold all
loglog(wavelength,noise_fit,'-')

legend('Radial Spectrum', 'Fitted Noise','2','3')
xlabel('wavelength [nm]')
ylabel('Amplitude [dimentionless]')
set(gca,'FontSize',20)



file.channels(cn).data=data;

figure
sxm.plot.plotFile(file,cn);
%%
figure
loglog(wavelength,radial_average./noise_fit,'x--')
hold on
loglog(wavelength,1+0./wavelength)
xlabel('\lambda [nm]')
ylabel('amplitude / noise')
set(gca,'FontSize',20)


%%
%F1=figure(F1);
%plot(wavelength,radial_average-noise_fit,'x-')
%hold all;

