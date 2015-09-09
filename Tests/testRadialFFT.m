close all;
clear all;

cn=3;%1 is current, 3 intensity
%%
%fn='Data/Aram/image045.sxm';
%fn='Data/2013-12-04/image054.sxm';
%fn='Data/2013-12-05/image043.sxm';
%fn='Data/2013-12-06/image007.sxm';

%file=load.loadProcessedSxM(fn);%Z=3.5

cn=2;
fn='Data/Urs/m14_ori.par';

file=load.loadProcessedPar(fn);

%Get data
[radius, radial_average] =op.getRadialFFT(file.channels(cn).data,file.header.scan_pixels(1)/file.header.scan_range(1)/1e9);
[noise_fit] =op.getRadialNoise(radius, radial_average);

figure
loglog(1./radius,radial_average,'x-')
hold all
%loglog(radius(radius>limR),radial_amplitude(radius>limR),'x-')
loglog(1./radius,noise_fit)
%title('4.12.13 - image 46','FontSize',12)
xlabel('\lambda [nm]')
ylabel('amplitude')
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
xlabel('\lambda [nm]')
ylabel('amplitude')
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

%%
%F1=figure(F1);
%plot(1./radius,radial_average-noise_fit,'x-')
%hold all;

