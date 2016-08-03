close all;
clear all;

cn=3;%1 is current, 3 intensity
%%
fn='Data/Aram/image048.sxm';
%fn='Data/2013-12-04/image035.sxm';%46
%fn='Data/2013-12-05/image045.sxm';
%fn='Data/2013-12-06/image046.sxm';

file=loadSxM.loadProcessedSxM(fn);%Z=3.5

%%
data=op.interpPeaks(file.channels(cn).data);
%Get data
[wavelength, radial_average] =op.getRadialFFT(data,file.header.scan_pixels(1)/file.header.scan_range(1)/1e9);
[noise_fit] =op.getRadialNoise(wavelength, radial_average);

figure
plot(wavelength,(radial_average-noise_fit),'x');
hold all
plot(wavelength, 0.04*noise_fit)
plot(wavelength, -0.04*noise_fit)
set(gca,'XScale','log')

%%

%{
cn=2;
fn='Data/Urs/m14_ori.par';
file=loadSxM.loadProcessedPar(fn);
%}

%Get data
[wavelength, radial_average] =op.getRadialFFT(file.channels(cn).data,file.header.scan_pixels(1)/file.header.scan_range(1)/1e9);


figure
loglog(wavelength,radial_average,'x-')
hold all

%%
hold all
[noise_fit] =op.getRadialNoise(wavelength, radial_average,2);
loglog(wavelength,noise_fit)
%title('4.12.13 - image 46','FontSize',12)
xlabel('\lambda [nm]')
ylabel('amplitude')
set(gca,'FontSize',20)
legend('Radial Spectrum','Fitted Noise','2nd noise','FontSize',12,'Location','NorthEast')

%%
figure
plotSxM.plotFile(file,cn,0,0,'NoTitle')
%%
figure
loglog(wavelength,radial_average./noise_fit,'x-','DisplayName','signal/noise')
%title('ratio vs substraction');
xlabel('\lambda [nm]')
ylabel('amplitude')
legend(gca,'show')

%%
figure
plotSxM.plotFile(file,cn);

%%

figure
loglog(wavelength,radial_average,'x-')

hold all

data=op.interpHighStd(file.channels(cn).data); % interpolate lines
%Get data
[wavelength, radial_average] =op.getRadialFFT(data,file.header.scan_pixels(1)/file.header.scan_range(1)/1e9);
%loglog(wavelength,radial_average,'x-')


data=op.interpPeaks(file.channels(cn).data); %interpolate peaks

%Get data
[wavelength, radial_average] =op.getRadialFFT(data,file.header.scan_pixels(1)/file.header.scan_range(1)/1e9);
loglog(wavelength,radial_average,'x-')

data=op.interpPeaks(op.interpHighStd(file.channels(cn).data));


%Get data
[wavelength, radial_average] =op.getRadialFFT(data,file.header.scan_pixels(1)/file.header.scan_range(1)/1e9);
%loglog(wavelength,radial_average,'x-')

%loglog(wavelength,noise_fit,'-')


legend('Base', 'Interpolated')
%legend('Base','Interpolated lines', 'interpolated peaks')
xlabel('\lambda [nm]')
ylabel('amplitude')
set(gca,'FontSize',20)


[noise_fit,signal_start,signal_error] =op.getRadialNoise(wavelength, radial_average,1);

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
plotSxM.plotFile(file,cn);
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

