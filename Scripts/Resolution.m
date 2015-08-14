clear all;
close all;

%{

%Get file name from all files
idx=23:48;
fn='Data/2013-12-06/image';
ext='.sxm';
fns=arrayfun(@(x) sprintf('%s%03d%s',fn,x,ext),idx,'UniformOutput',false);
files=cellfun(@load.loadProcessedSxM,fns,'UniformOutput',false);

%Corresponding Z
Z=[25,20,17,15,12,10,9,8,6,3,1,0,-1,-3,-5,-6,-7,-8,-9,-10,-11,-12,-12,-14,-15,-15]+21;
%}



%{

%Get file name from all files
idx=36:48;
fn='Data/Aram/image0';
ext='.sxm';
fns=arrayfun(@(x) [fn num2str(x) ext],idx,'UniformOutput',false);
files=cellfun(@load.loadProcessedSxM,fns,'UniformOutput',false);

%Corresponding Z
Z=[25,20,18,15,12,11,10,9,8,7,6,5,4]-0.5;
%}

%% 2nd
%%{
%Get file name from all files
idx=6:16;
fn='Data/2013-12-06/image';
ext='.sxm';
fns=arrayfun(@(x) sprintf('%s%03d%s',fn,x,ext),idx,'UniformOutput',false);
files=cellfun(@load.loadProcessedSxM,fns,'UniformOutput',false);

%Corresponding Z
Z=[25,20,15,12,10,8,6,6,4,3,2]+2;
%}
%{
%%3rd


%Get file name from all files
idx=54:66;
fn='Data/2013-12-04/image';
ext='.sxm';
fns=arrayfun(@(x) sprintf('%s%03d%s',fn,x,ext),idx,'UniformOutput',false);
files=cellfun(@load.loadProcessedSxM,fns,'UniformOutput',false);

%Corresponding Z
Z=[20,18,15,12,10,9,8,7,6,5,4,3,2]+2;

%}

%% %Plot fourrier amplitude
figS=figure
title('Radial spectrum');
figR=figure
title('Radial spectrum');


for i=numel(files):-1:1
    
    %Get data
    [radial_signal(i,:), radius(i,:), NCoeff(i,:),radial_average(i,:),radial_std(i,:)] =op.getRadialFFT(files{i}.channels(3).data);
    
    figure(figR)
    %Plot
    loglog(radius(i,:),radial_average(i,:),'x--','DisplayName',sprintf('Z=%.2f',Z(i)));
    hold all
    
    figure(figS)
    %Plot
    loglog(1./radius(i,:),radial_signal(i,:),'x--','DisplayName',sprintf('Z=%.2f',Z(i)));
    hold all
    

end

figure(figS)
legend(gca,'show')
xlabel('wavelength [px]')
ylabel('amplitude [au]')
%set(gca,'YScale','log');
set(gca,'FontSize',20)

figure(figR)
legend(gca,'show')
xlabel('frequency [1/px]')
ylabel('amplitude [au]')
%set(gca,'YScale','log');
set(gca,'FontSize',20)



%%
[~,I]=max(radial_signal(11,:));
figure
plot(1./Z,radial_signal(:,I),'x');

%%
figure
plot(1./Z,radial_signal(:,1),'x');
%%
figure
plot(Z,radial_signal(:,1),'x');
%%
for i=numel(Z):-1:1;
    rIdx=find(radial_signal(i,:)>1.4,1,'last');
    if isempty(rIdx)
        D(i)=nan;
        error(i)=nan;
    else
        D(i)=1./radius(i,rIdx);
        error(i)=abs(1./radius(i,rIdx)-1./radius(i,rIdx+1));
    end
    
end

figure
errorbar(Z,D/2,error/2,'x')


%% %plot std of each line
figure;
hold all

%Keep minimum
MinSlopeLine=1000;

%Loop on files
for i=numel(files):-1:1
    file = files{i};
    
    %Extract number of electrons (~ don't know voltage meaning)
    Ne=file.channels(3).lineMean.*(file.header.scan_time(1)/file.header.scan_pixels(1));
    X=1./Ne;
    
    %Extract Variance of each line
    Y=file.channels(3).lineStd.^2;
    
    %Variance plot
    plot(X,Y,'x','DisplayName',sprintf('Z=%02.1f',Z(i)));
    
    %Extract other informations
    
    %minimum slope
    m=min(Y./X);
    if m<MinSlopeLine
        MinSlopeLine=m;
    end
    
    %Number of electrons for the image
    NImg(i)=mean(Ne);
    
    %Total image std
    STDImg(i)=std(file.channels(3).data(:));
    
    %Median value of variance
    MedianVarImg(i)=median(Y);
    
    
    
end

xlabel('1/Ne')
ylabel('Variance')
title('Variance of each line')

%Plot min line
plot(1./NImg,MinSlopeLine./NImg,'DisplayName','Minimum');
set(gca,'FontSize',20)
legend(gca,'show')

%% %Plot std as a function of Z
figure(101)
plot(1./Z,STDImg,'x--','DisplayName','Uncorrected')
hold all
%Plot corrected STD as a function of Z
Y=STDImg.^2-MinSlopeLine./NImg;
plot(1./Z,sqrt(Y),'x--','DisplayName','Corrected')
%Plot corrected median Var
Y=MedianVarImg-MinSlopeLine./NImg;
plot(1./Z,sqrt(Y),'x--','DisplayName','Corrected median')
%legend(gca,'show')
xlabel('1/Z [1/nm]')
ylabel('STD [au]')
set(gca,'FontSize',20)



%% %Plot fourrier amplitude
figure
hold all
title('Radial spectrum');

for i=numel(files):-1:1
    
    %Get data
    [radial_amplitude, radius, NCoeff(i,:)] =op.getRadialFFT(files{i}.channels(3).data);
    
    %distance [m] to pixels
    SpP=files{i}.header.scan_range(1)/files{i}.header.scan_pixels(1);
    
    %Correct radius units
    radius=radius./SpP./1e9;% 1/px to 1/nm
    
    %Plot
    plot(1./radius,radial_amplitude,'x--','DisplayName',sprintf('Z=%.2f',Z(i)));
    
    %Get max infos
    [MX(i),idx]=max(radial_amplitude);
    I(i)=radius(idx);
end
legend(gca,'show')
xlabel('wavelength [nm]')
ylabel('amplitude [au]')
%set(gca,'YScale','log');
set(gca,'FontSize',20)

%% Plot amplitude and noise for each Z

figure
plot(1./Z,MX,'x','DisplayName','Amplitude')
legend(gca,'show','Location','NorthWest')
xlabel('1/Z [1/nm]')
ylabel('amplitude [au]')
set(gca,'FontSize',20)

%% hold all
figure
plot(NImg,NCoeff(:,1),'x','DisplayName','C1');
mean(NCoeff(:,1))
title('coeff1 vs N')
xlabel('N')
ylabel('C1')
%% hold all
figure
plot(Z,NCoeff(:,1),'x','DisplayName','C1');
mean(NCoeff(:,1))
title('coeff1 vs Z')
xlabel('Z')
ylabel('C1')
%%
figure
plot(1./Z,NCoeff(:,2),'x','DisplayName','C1');
title('coeff2 vs 1/Z')
xlabel('1/Z')
ylabel('C2')

%%
figure
plot(1./NImg,exp(NCoeff(:,2)),'x','DisplayName','C1');
title('coeff2 vs 1/Nimg')
xlabel('1/Nimg')
ylabel('C2')

%% Plot Noise with MinSlope & straight line
%%{
figure
plot(1./NImg,exp(NCoeff(:,2).*2)/2,'x','DisplayName','Noise data');
hold all
plot(1./NImg,MinSlopeLine./NImg,'DisplayName',sprintf('Minimum Var ( %.3g )',MinSlopeLine));
%Take last data as point
plot(1./NImg,((exp(NCoeff(end,2).*2)/2)*NImg(end))./NImg,'DisplayName',sprintf('fit ( %.3g )',(NCoeff(end).^2*NImg(end))));

legend(gca,'show','Location','NorthWest')
xlabel('1/Ne')
ylabel('Variance')
set(gca,'FontSize',20)
%}

%% Plot resolution
img_size=size(files{1}.channels(1).data,1);
figure
%/2 as we want the half wavelength
%+- 1 px
errorbar(Z,(1/2)./I,(1/2)./(I.^2)*1/img_size/SpP/1e9,'x')
xlabel('Z [nm]')
ylabel('half wavelength [nm]')
title('Resolution')
set(gca,'FontSize',20)

%%
figure(101)
plot(1./Z,MX./sqrt(2),'x--','DisplayName','FFT Max')

legend(gca,'show','Location','NorthWest')
set(gca,'FontSize',20)

%%
%{
close all

for i=1:numel(files)
    file=files{i};
    figure
    plot.plotFile(file,3);
end
%}
