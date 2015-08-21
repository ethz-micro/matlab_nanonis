close all
clear all

%Get STM Data
fileSTM=load.loadProcessedSxM('Data/2013-12-04/image035.sxm');%35
[radial_average_STM, radius_STM, noise_fit_STM, noise_coeff_STM] =op.getRadialFFT(fileSTM.channels(1).data);
SpP=fileSTM.header.scan_range(1)/fileSTM.header.scan_pixels(1);%distance [m] to pixels
radius_STM=radius_STM./SpP./1e9;

%Get SEM Data
idx=36:48;
fn='Data/Aram/image';
Z=[25,20,18,15,12,11,10,9,8,7,6,5,4]-0.5;
idx=flip(idx);
Z=flip(Z);
ext='.sxm';
fns=arrayfun(@(x) sprintf('%s%03d%s',fn,x,ext),idx,'UniformOutput',false);
files=cellfun(@load.loadProcessedSxM,fns,'UniformOutput',false);


%% plot correlation for all i
figure
%for i=1:numel(files)
for i=[10,3];%13 3
    files{i}.channels(3).data=op.interpPeaks(files{i}.channels(3).data);
    [radial_average_SEM, radius_SEM, noise_fit_SEM, noise_coeff_SEM] =op.getRadialFFT(files{i}.channels(3).data);
    loglog(radial_average_STM,radial_average_SEM,'x--','DisplayName',sprintf('Z= %.1fnm',Z(i)))
    hold all
end
legend(gca,'show')
%fileSEM=load.loadProcessedSxM('Data/Aram/image037.sxm');%36-48
xlabel('Amplitude STM [au]')
ylabel('Amplitude NFESEM [au]')
set(gca,'FontSize',20)



%% plot STM spectrum
figure
loglog(radius_STM,radial_average_STM,'x',radius_STM,noise_fit_STM)
xlabel('frequency [1/nm]')
ylabel('Amplitude [au]')
set(gca,'FontSize',20)
legend('Radial Spectrum','Fitted Noise','FontSize',12,'Location','NorthEast')


%% plot SEM Spectum
figure
loglog(radius_SEM,radial_average_SEM,'x',radius_SEM,noise_fit_SEM)

%% plot Images
figure
plot.plotFile(fileSTM,1)
figure
plot.plotFile(files{i},3)
%% plot Filtered dat
[filtered, removed] = op.filterData(fileSTM.channels(1).data,4.5);

figure
imagesc(filtered)
axis image
figure
imagesc(removed)
axis image

