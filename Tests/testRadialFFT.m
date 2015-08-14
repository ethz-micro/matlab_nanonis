%close all;
clear all;
fn='Data/Aram/image046.sxm';%36:48
%fn='Data/2013-12-04/image054.sxm';
%fn='Data/2013-12-04/image054.sxm';
%fn='Data/2013-12-06/image006.sxm';
%fn='Data/Aram/image046.sxm';
%fn='Data/2013-12-06/image031.sxm';
file=load.loadProcessedSxM(fn);%Z=3.5

%Get data
[~, radius, NoiseCoeff,radial_average] =op.getRadialFFT(file.channels(3).data);

%distance [m] to pixels
SpP=file.header.scan_range(1)/file.header.scan_pixels(1);

corr=radius.^NoiseCoeff(1).*exp(NoiseCoeff(2));

%%
limR=1/10;
figure
loglog(radius,radial_average,'x-')
hold all
%loglog(radius(radius>limR),radial_amplitude(radius>limR),'x-')
loglog(radius,corr)
title('loglog')

%%
figure
loglog(radius,40*(radial_average-corr)+1,'x-')
hold all
loglog(radius,radial_average./corr,'x-')
title('substracted corr') 
%%

figure
plot(1./radius,(radial_average-corr).*(2*pi*radius),'x-')
title('substracted corr, *r')



%%
%{
figure
plot(1./radius,(radial_amplitude-Noise).*(2*pi*radius),'x-');
%plot(radius,radial_amplitude./(2*pi*radius)+Noise);
xlabel('Wavelength')
ylabel('Amplitude')
title('old')
%}
%%

%%
figure
plot.plotFile(file,3);

