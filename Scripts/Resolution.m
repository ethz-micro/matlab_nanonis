clear all;
close all;

%% FILES SERIES
%{
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

%%{
idx=35:45;
fn='Data/2013-12-05/image';
Z=[14,10,8,6,4,2,0,-2,-4,-5,-6]+10;
%}





idx=flip(idx);
Z=flip(Z);
%% LOAD FILES
ext='.sxm';
fns=arrayfun(@(x) sprintf('%s%03d%s',fn,x,ext),idx,'UniformOutput',false);
files=cellfun(@load.loadProcessedSxM,fns,'UniformOutput',false);

%% Loop files and get data

cutPrct=1.3;

for i=numel(files):-1:1
    
    % other infos
    file = files{i};
    
    %Radial FFT
    
    %Get data
    [radial_average(i,:), radius(i,:), noise_fit(i,:),NCoeff(i,:)] =op.getRadialFFT(file.channels(3).data);
    
    radial_signal(i,:)=radial_average(i,:)./noise_fit(i,:);
    
    %distance [m] to pixels
    SpP=file.header.scan_range(1)/file.header.scan_pixels(1);
    radius(i,:)=radius(i,:)./SpP./1e9;% 1/px to 1/nm
    
    %cut for resolution
    rIdx=find(radial_signal(i,:)>cutPrct,1,'last');
    if isempty(rIdx)
        signal_start(i)=nan;
        sigal_error(i)=nan;
    else
        signal_start(i)=1./radius(i,rIdx);
        sigal_error(i)=abs(1./radius(i,rIdx)-1./radius(i,rIdx+1));
    end
    
    %Extract number of electrons (~ don't know voltage meaning)
    Ne_line(i,:)=file.channels(3).lineMean.*(file.header.scan_time(1)/file.header.scan_pixels(1));
    
    %Extract Variance of each line
    STD_line(i,:)=file.channels(3).lineStd;
    
    %Total image std
    STDImg(i)=std(file.channels(3).data(:));
    
end
STDImg=STDImg';
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
xlabel('Wavelength [nm]')
ylabel('Amplitude [au]')
set(gca,'FontSize',20)
title('Signal to Noise Ratio');
legend(arrayfun(@(x) sprintf('Z=%.2f',x),Z,'UniformOutput',false) ...
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
plot(Z,STDImg.*sqrt(2),'x--','DisplayName','Image STD * sqrt(2)')
hold all
name = sprintf('Amplitude @ f=%.3g [1/nm]',radius(1,I));
plot(Z,radial_corr(:,I),'x-','DisplayName',name);
l=legend(gca,'show','Location','NorthWest');
set(l,'FontSize',12)
xlabel('1/Z [1/nm]')
ylabel('Amplitude [au]')
set(gca,'FontSize',20)

%{
%Plot corrected STD as a function of Z
Y=STDImg.^2-MinSlopeLine./Ne_Img;
plot(1./Z,sqrt(Y),'x--','DisplayName','Corrected')
%Plot corrected median Var
Y=MedianVarImg-MinSlopeLine./Ne_Img;
plot(1./Z,sqrt(Y),'x--','DisplayName','Corrected median')
%}


%% hold all
figure
plot(1./Z,NCoeff(:,1),'x','DisplayName','C1');
mean(NCoeff(:,1))
title('coeff1 vs 1/Z')
xlabel('1/Z')
ylabel('C1')
set(gca,'FontSize',20)
%%
figure
plot(1./sqrt(Ne_Img),exp(NCoeff(:,2)),'x','DisplayName','C1');
title('Noise Amplitude vs Ne')
xlabel('1/sqrt(Ne)')
ylabel('Noise Amplitude')
set(gca,'FontSize',20)

%%
%{
close all

for i=1:numel(files)
    file=files{i};
    figure
    plot.plotFile(file,3);
end

%% %plot std of each line
figure
plot(1./Ne_line',STD_line.^2','x')
hold on
xlabel('1/Ne')
ylabel('Variance')
title('Variance of each line')

%Plot min line
plot(1./Ne_Img,MinSlopeLine./Ne_Img,'DisplayName','Minimum');
set(gca,'FontSize',20)
legend([arrayfun(@(x) sprintf('Z=%.2f',x),Z,'UniformOutput',false),'min'] ...
    ,'FontSize',12,'Location','NorthEast')


%}
