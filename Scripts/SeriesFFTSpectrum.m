clear all;
close all;

chn=3;%1
%% FILES SERIES
%{
idx=23:48;
fn='Data/2013-12-06/image';
Z=[25,20,17,15,12,10,9,8,6,3,1,0,-1,-3,-5,-6,-7,-8,-9,-10,-11,-12,-12,-14,-15,-15]+21;
%}

%{
idx=71:77;
fn='Data/2013-12-06/image';
Z=[5,4,3,2,1,0,-1]+5;
%}

%%{
idx=36:48;
fn='Data/Aram/image';
Z=[25,20,18,15,12,11,10,9,8,7,6,5,4]-0.5;
%}

%{
idx=6:16;
fn='Data/2013-12-06/image';
Z=[25,20,15,12,10,8,6,6,4,3,2]+2;
%}


%{
idx=23:48;
fn='Data/2013-12-06/image';
Z=[25,20,17,15,12,10,9,8,6,3,1,0,-1,-3,-5,-6,-7,-8,-9,-10,-11,-12,-12,-14,-15,-15]+21;
%}

%{
idx=54:66;
fn='Data/2013-12-04/image';
Z=[20,18,15,12,10,9,8,7,6,5,4,3,2]+2;
%}

%{
idx=[36:43, 45:48];
fn='Data/2013-12-04/image';
Z=[25,20,18,15,12,11,10,9,7,6,5,4]-0.5;
%}

%{
idx=47:64;
fn='Data/2013-12-05/image';
Z=[25,20,17,14,12,10,8,6,4,2,1,0,-1,-2,-3,-4,-5,-6]+10;
%}


%Filp for plot purposes
idx=flip(idx);
Z=flip(Z);

%% LOAD FILES
ext='.sxm';
fns=arrayfun(@(x) sprintf('%s%03d%s',fn,x,ext),idx,'UniformOutput',false);
files=cellfun(@load.loadProcessedSxM,fns,'UniformOutput',false);

%% Remove noise
for i=1:numel(files)
    if chn<3
        files{i}.channels(chn).data=op.interpHighStd(files{i}.channels(chn).data);
    end
    files{i}.channels(chn).data=op.interpPeaks(files{i}.channels(chn).data);
end

%% Loop files and get data

%Choose the cut amplitude

%Z=Z(1:8);
for i=numel(files):-1:1
    file = files{i};
    %Get data
    [radius(i,:),radial_average(i,:)] = ...
        op.getRadialFFT(file.channels(chn).data,...
        file.header.scan_pixels(1)./file.header.scan_range(1)./1e9);
    
    %Get noise
    [noise_fit(i,:),signal_start(i),signal_error(i,:), noise_coeff(i,:)] =op.getRadialNoise(radius(i,:), radial_average(i,:));
    
    %Extract number of electrons (~ don't know voltage meaning)
    Ne_line(i,:)=file.channels(chn).lineMean.*(file.header.scan_time(1)/file.header.scan_pixels(1));
    
    %Extract Variance of each line
    STD_line(i,:)=file.channels(chn).lineStd;
    
    %Total image std
    STDImg(i)=nanstd(file.channels(chn).data(:));
    
end

STDImg=STDImg';

%Number of electrons per pixel for the image
Ne_Img=mean(Ne_line,2);

%minimum slope
MinSlopeLine=min(min((STD_line.^2).*Ne_line));

%Median value of variance
MedianVarImg=median(STD_line.^2,2);

radial_signal=radial_average./noise_fit;
%remove resolution with low signal to noise intensity
badRes=max(radial_signal,[],2)<2;% cut at least at half
signal_start(badRes)=nan;
signal_error(badRes,:)=nan;

%% Radial Spectrum
figure('Name','Radial Spectrum');
loglog(1./radius',radial_average','x--')
xlabel('\lambda [nm]')
ylabel('amplitude')
set(gca,'FontSize',20)
title('Radial Spectrum');
legend(arrayfun(@(x) sprintf('d=%.2f',x),Z,'UniformOutput',false)...
    ,'FontSize',12,'Location','NorthEast')

%% Signal To Noise
figure('Name','Signal to Noise Ratio');
loglog(1./radius',radial_signal','x--');
hold all
loglog(1./radius(1,:),0./radius(1,:)+1)
xlabel('\lambda [nm]')
ylabel('amplitude')
set(gca,'FontSize',20)
title('Signal to Noise Ratio');
legend([arrayfun(@(x) sprintf('d=%.2f',x),Z,'UniformOutput',false), 'amp=1'] ...
    ,'FontSize',12,'Location','NorthWest')

%% Plot Resolution

figure
errorbar(Z,signal_start,signal_error(:,1),signal_error(:,2),'x')
hold all
%errorbar(Z,signal_start_2,signal_error_2,'x')
%errorbar(Z,signal_start_3,signal_error_3,'x')
xlabel('Z [nm]')
ylabel('Wavelength [nm]')
title('Resolution')
set(gca,'FontSize',20)

%% plot max amplitude position

radial_corr=radial_average-noise_fit;
[~,I]=max(max(radial_corr));

%% %Plot std as a function of Z
figure
plot(1./Z,STDImg.*sqrt(2),'x--','DisplayName','Image STD * sqrt(2)')
hold all
name = sprintf('Amplitude @ f=%.3g [1/nm]',radius(1,I));
plot(1./Z,radial_corr(:,I),'x-','DisplayName',name);
%plot(1./Z,STDFiltered.*sqrt(2),'x--','DisplayName','filtered STD * sqrt(2)')
l=legend(gca,'show','Location','NorthWest');
set(l,'FontSize',12)
xlabel('1/Z [1/nm]')
ylabel('Amplitude [au]')
set(gca,'FontSize',20)


%% Coeff 1
figure
plot(Z,noise_coeff(:,1),'x','DisplayName','C1');
title('coeff1 vs Z')
xlabel('Z')
ylabel('C1')
set(gca,'FontSize',20)
%% Noise Amplitude vs Ne
figure
plot(1./sqrt(Ne_Img),exp(noise_coeff(:,2)),'x','DisplayName','C1');
title('Noise Amplitude vs Ne')
xlabel('1/sqrt(Ne)')
ylabel('Noise Amplitude')
set(gca,'FontSize',20)

%%
figure
plot.plotFile(files{13},chn);
%{
for i=numel(files):-1:1
   figure
   plot.plotFile(files{i},chn)
end
%}

