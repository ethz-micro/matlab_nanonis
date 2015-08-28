clear all;
close all;

chn=1;%1
cutPrct=1;%1.6;
%% FILES SERIES
%%{
idx=23:48;
fn='Data/2013-12-06/image';
Z=[25,20,17,15,12,10,9,8,6,3,1,0,-1,-3,-5,-6,-7,-8,-9,-10,-11,-12,-12,-14,-15,-15]+21;
%}

%{
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
idx=54:66;
fn='Data/2013-12-04/image';
Z=[20,18,15,12,10,9,8,7,6,5,4,3,2]+2;
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
    [radial_average(i,:), radius(i,:), noise_fit(i,:),NCoeff(i,:)] = ...
        op.getRadialFFT(file.channels(chn).data);
    radial_signal(i,:)=radial_average(i,:)./noise_fit(i,:);
    
    %distance [m] to pixels
    SpP=file.header.scan_range(1)/file.header.scan_pixels(1);
    radiusPx=radius(i,:);
    radius(i,:)=radius(i,:)./SpP./1e9;% 1/px to 1/nm
    
    %Find last point > cutPrct
    rIdx=find(radial_signal(i,:)>cutPrct,1,'last');
    %rIdx=find(radial_signal(i,:)<1.2,1,'first');
    if isempty(rIdx)
        signal_start(i)=nan;
        sigal_error(i)=nan;
    else
        signal_start(i)=1./radius(i,rIdx);
        sigal_error(i)=abs(1./radius(i,rIdx)-1./radius(i,rIdx+1));
    end
    
    %Extract number of electrons (~ don't know voltage meaning)
    Ne_line(i,:)=file.channels(chn).lineMean.*(file.header.scan_time(1)/file.header.scan_pixels(1));
    
    %Extract Variance of each line
    STD_line(i,:)=file.channels(chn).lineStd;
    
    %Total image std
    STDImg(i)=nanstd(file.channels(chn).data(:));
    
    data=file.channels(chn).data;
    data=op.filterData(data,1./radiusPx(rIdx));
    STDFiltered(i)=nanstd(data(:));
    
end

STDImg=STDImg';
STDFiltered=STDFiltered';

%Number of electrons per pixel for the image
Ne_Img=mean(Ne_line,2);

%minimum slope
MinSlopeLine=min(min((STD_line.^2).*Ne_line));

%Median value of variance
MedianVarImg=median(STD_line.^2,2);

%remove resolution with low signal to noise intensity
badRes=max(radial_signal,[],2)./cutPrct<2;% cut at least at half
signal_start(badRes)=nan;
sigal_error(badRes)=nan;

%% Radial Spectrum
figure('Name','Radial Spectrum');
loglog(radius',radial_average','x--')
xlabel('frequency [1/nm]')
ylabel('amplitude [au]')
set(gca,'FontSize',20)
title('Radial Spectrum');
legend(arrayfun(@(x) sprintf('Z=%.2f',x),Z,'UniformOutput',false)...
    ,'FontSize',12,'Location','NorthEast')

%% Signal To Noise
figure('Name','Signal to Noise Ratio');
loglog(1./radius',radial_signal','x--');
hold all
loglog(1./radius(1,:),0./radius(1,:)+cutPrct)
xlabel('Wavelength [nm]')
ylabel('Amplitude [au]')
set(gca,'FontSize',20)
title('Signal to Noise Ratio');
legend([arrayfun(@(x) sprintf('Z=%.2f',x),Z,'UniformOutput',false), 'Threshold'] ...
    ,'FontSize',12,'Location','NorthWest')

%% Plot Resolution

figure
errorbar(Z,signal_start,sigal_error,'x')
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
plot(1./Z,STDFiltered.*sqrt(2),'x--','DisplayName','filtered STD * sqrt(2)')
l=legend(gca,'show','Location','NorthWest');
set(l,'FontSize',12)
xlabel('1/Z [1/nm]')
ylabel('Amplitude [au]')
set(gca,'FontSize',20)


%% Coeff 1
figure
plot(Z,NCoeff(:,1),'x','DisplayName','C1');
mean(NCoeff(:,1))
title('coeff1 vs Z')
xlabel('Z')
ylabel('C1')
set(gca,'FontSize',20)
%% Noise Amplitude vs Ne
figure
plot(1./sqrt(Ne_Img),exp(NCoeff(:,2)),'x','DisplayName','C1');
title('Noise Amplitude vs Ne')
xlabel('1/sqrt(Ne)')
ylabel('Noise Amplitude')
set(gca,'FontSize',20)

%%
figure
plot.plotFile(files{8},chn)
%{
for i=numel(files):-1:1
   figure
   plot.plotFile(files{i},chn)
end
%}

