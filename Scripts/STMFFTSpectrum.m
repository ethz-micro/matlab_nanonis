close all
clear all

%Get STM Data
fileSTM=loadSxM.loadProcessedSxM('Data/2013-12-04/image035.sxm');%35
SpP=fileSTM.header.scan_range(1)/fileSTM.header.scan_pixels(1);%distance [m] to pixels
[wavelength_STM,radial_average_STM] =op.getRadialFFT(fileSTM.channels(1).data,1e9/SpP);
noise_fit_STM = op.getRadialNoise(wavelength_STM,radial_average_STM);

%Get SEM Data
idx=36:48;
fn='Data/Aram/image';
Z=[25,20,18,15,12,11,10,9,8,7,6,5,4]-0.5;
idx=flip(idx);
Z=flip(Z);
ext='.sxm';
fns=arrayfun(@(x) sprintf('%s%03d%s',fn,x,ext),idx,'UniformOutput',false);
files=cellfun(@loadSxM.loadProcessedSxM,fns,'UniformOutput',false);


%% plot correlation for all i
figure
%for i=1:numel(files)
for i=[10,3];%13 3
    files{i}.channels(3).data=op.interpPeaks(files{i}.channels(3).data);
    [wavelength_SEM, radial_average_SEM] =op.getRadialFFT(files{i}.channels(3).data);
    noise_fit_SEM=op.getRadialNoise(wavelength_SEM, radial_average_SEM);
    loglog(radial_average_STM,radial_average_SEM,'x--','DisplayName',sprintf('Z= %.1fnm',Z(i)))
    hold all
end
legend(gca,'show')
%fileSEM=loadSxM.loadProcessedSxM('Data/Aram/image037.sxm');%36-48
xlabel('Amplitude STM [au]')
ylabel('Amplitude NFESEM [au]')
set(gca,'FontSize',20)



%% plot STM spectrum
figure
loglog(wavelength_STM,radial_average_STM,'x',wavelength_STM,noise_fit_STM)
xlabel('wavelength [nm]')
ylabel('amplitude')
set(gca,'FontSize',20)
legend('Radial Spectrum','Fitted Noise','FontSize',12,'Location','NorthEast')


%% plot SEM Spectum
figure
loglog(wavelength_SEM,radial_average_SEM,'x',wavelength_SEM,noise_fit_SEM)

%% plot Images
figure
plotSxM.plotFile(fileSTM,1)
figure
plotSxM.plotFile(files{i},3)


