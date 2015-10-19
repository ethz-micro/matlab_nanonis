clear all;
close all;

chn=2;%0-1;2-3
I=12; % index at wich the amplitude is taken (6 => f=0.06 ; 12=> f=0.12 [1/nm])
%Data sets
%base='/Volumes/micro/STM_AFM/2013/';
base='Data/';

k=1;
%350
info{k}.name='350-4.12-1';
info{k}.idx=[36:43, 45:48];
info{k}.fn=[base,'2013-12-04/image'];
info{k}.Z=[25,20,18,15,12,11,10,9,7,6,5,4];%8
info{k}.drift=.5;


%200
k=k+1;
info{k}.name='200-4.12-2';
info{k}.idx=54:66;
info{k}.fn=[base,'2013-12-04/image'];
info{k}.Z=[20,18,15,12,10,9,8,7,6,5,4,3,2];
info{k}.drift=2;


%400
k=k+1;
info{k}.name='400-5.12-1';
info{k}.idx=[35:39,41:45];
info{k}.fn=[base,'2013-12-05/image'];
info{k}.Z=[14,10,8,6,4,0,-2,-4,-5,-6];
info{k}.drift=10;

%%{
%400
k=k+1;
info{k}.name='400-5.12-2';
info{k}.idx=47:64;
info{k}.fn=[base,'2013-12-05/image'];
info{k}.Z=[25,20,17,14,12,10,8,6,4,2,1,0,-1,-2,-3,-4,-5,-6];
info{k}.drift=10;
%}

%300
k=k+1;
info{k}.name='300-6.12-1';
info{k}.idx=6:16;
info{k}.fn=[base,'2013-12-06/image'];
info{k}.Z=[25,20,15,12,10,8,6,6,4,3,2];
info{k}.drift=2;

%%{
%300
k=k+1;
info{k}.name='300-6.12-2';
info{k}.idx=23:48;
info{k}.fn=[base,'2013-12-06/image'];
info{k}.Z=[25,20,17,15,12,10,9,8,6,3,1,0,-1,-3,-5,-6,-7,-8,-9,-10,-11,-12,-12,-14,-15,-15];
info{k}.drift=21;
%}

%300
k=k+1;
info{k}.name='300-6.12-3';
info{k}.idx=53:68;
info{k}.fn=[base,'2013-12-06/image'];
info{k}.Z=[25,20,17,14,11,8,5,2,0,1,-1,-2,-3,-4,-5,-6];
info{k}.drift=10.5;


%300
k=k+1;
info{k}.name='300-6.12-4';
info{k}.idx=71:77;
info{k}.fn=[base,'2013-12-06/image'];
info{k}.Z=[5,4,3,2,1,0,-1];
info{k}.drift=5;

%300
k=k+1;
info{k}.name='300-6.12-5';
info{k}.idx=80:86;
info{k}.fn=[base,'2013-12-06/image'];
info{k}.Z=[6,5,4,3,2,1,0];
info{k}.drift=3.5;

%% load data
if ~exist('loadedFiles','var')
    for k=numel(info):-1:1
        %correct drift
        info{k}.Z=info{k}.Z+info{k}.drift;%linspace(0,info{k}.drift,numel(info{k}.Z));
        %
        %Get files names
        ext='.sxm';
        fns=arrayfun(@(x) sprintf('%s%03d%s',info{k}.fn,x,ext),info{k}.idx,'UniformOutput',false);
        
        %Get data
        files =cellfun(@(x) load.loadProcessedSxM(x,chn),fns,'UniformOutput',false);
        
        % Remove noise
        for i=1:numel(files)
            if chn<2
                files{i}.channels.data=op.interpHighStd(files{i}.channels.data);
            end
            files{i}.channels.data=op.interpPeaks(files{i}.channels.data);
        end
        
        loadedFiles{k}=files;
    end
end


%% Make all plots

figR=figure;
hold all
figA=figure;
hold all
figC1=figure;
hold all
figC2=figure;
hold all
figC2Z=figure;
hold all
figSTD=figure;
hold all
figC2ZN=figure;
hold all
figNSTD=figure;
hold all


XY=0;
X2=0;

for k=1:numel(info)
    %clear data from previus loop
    clear noiseSTD STDImg Nimg radial_average wavelength noise_fit noise_coeff radial_signal signal_start signal_error
    
 
    
    for i=numel(loadedFiles{k}):-1:1
        
        file = loadedFiles{k}{i};
        
        %Get data
        [wavelength(i,:),radial_average(i,:)] = ...
            op.getRadialFFT(file.channels.data,...
            file.header.scan_pixels(1)./file.header.scan_range(1)./1e9);
        
        %Get noise
        [noise_fit(i,:),signal_start(i),signal_error(i,:), noise_coeff(i,:)] =op.getRadialNoise(wavelength(i,:), radial_average(i,:));
        
        if ~isnan(signal_start(i))
            XY=XY+signal_start(i)*info{k}.Z(i);
            X2=X2+info{k}.Z(i).^2;
        end
        %get mean value of intensity
        Nimg(i)=mean(file.channels.lineMean);
        
        %Total image std
        STDImg(i)=nanstd(file.channels.data(:));
        
        noiseSTD(i)=nanstd(radial_average(i,wavelength(i,:)<signal_start(i))./noise_fit(i,wavelength(i,:)<signal_start(i)));
        
    end
    %{
    %remove resolution with low signal to noise intensity
    radial_signal=radial_average./noise_fit;
    badRes=max(radial_signal,[],2)<2;% cut at least at half
    signal_start(badRes)=nan;
    signal_error(badRes)=nan;
    %}
    
    %Find highest peak
    radial_corr=sqrt(radial_average.^2-noise_fit.^2);
    %radial_corr=radial_average;
    
    %{
    start_array=signal_start;
    start_array(isnan(signal_start))=1;
    [~,maxI]=arrayfun(@(x) max(radial_average(x,wavelength(x,:)>start_array(x))),1:numel(signal_start));
    amplitude=radial_corr(sub2ind(size(radial_corr),1:numel(signal_start),maxI));
    amplitude(isnan(signal_start))=nan;
    %}
    
    
    amplitude=radial_corr(:,I);
    
    
    
    %plot signal intensity
    name = sprintf('%s \\lambda=%02.2f [nm]',info{k}.name,wavelength(1,I));
    %name = sprintf('%s',info{k}.name);
    figure(figA)
    plot(info{k}.Z,amplitude,'x-','DisplayName',name);
    
    %plot resolution
    name = sprintf('%s Drift:%02.1f',info{k}.name,info{k}.drift);
    figure(figR)
    errorbar(info{k}.Z,signal_start,signal_error(:,1),signal_error(:,2),'x','DisplayName',name)
    
    %plot noise slope
    figure(figC1)
    plot(info{k}.Z,noise_coeff(:,1),'x','DisplayName',name);
    
    %plot noise intensity
    figure(figC2)
    plot(1./sqrt(Nimg),exp(noise_coeff(:,2)),'x--','DisplayName',name);
    
    figure(figC2Z)
    plot(info{k}.Z,exp(noise_coeff(:,2)),'x--','DisplayName',name);
    
    figure(figC2ZN)
    plot(info{k}.Z,exp(noise_coeff(:,2)).*sqrt(Nimg)','x--','DisplayName',name);
    
    %plot STD
    figure(figSTD)
    X=sqrt(exp(noise_coeff(:,2)).^2+radial_corr(:,I).^2);
    plot(X,STDImg,'x--','DisplayName',name);
    %plot(info{k}.Z,STDImg,'x--','DisplayName',name);
    
    figure(figNSTD)
    plot(info{k}.Z,noiseSTD,'x','DisplayName',name);
    
end
%%
% plot signal intensity
figure(figA)
xlabel('d [nm]')
ylabel('amplitude')
set(gca,'FontSize',20)
l=legend(gca,'show','Location','NorthWest');
set(l,'FontSize',12)

set(gca,'YScale','log')

%%
%plot noise slope
figure(figC1)
xlabel('d [nm]')
ylabel('\alpha')
set(gca,'FontSize',20)
l=legend(gca,'show','Location','NorthWest');
set(l,'FontSize',12)

set(gca,'YScale','linear')

%%
%plot noise intensity
figure(figC2)
xlabel('1/\surd(Ne)')
ylabel('A_{N0}')
set(gca,'FontSize',20)
l=legend(gca,'show','Location','NorthWest');
set(l,'FontSize',12)
%%

figure(figC2Z)
%xlabel('1/sqrt(Ne)')
%ylabel('Noise Amplitude')
xlabel('d [nm]')
ylabel('A_{N0}')
set(gca,'FontSize',20)
l=legend(gca,'show','Location','NorthWest');

set(gca,'YScale','log')

%%
figure(figC2ZN)
%xlabel('1/sqrt(Ne)')
%ylabel('Noise Amplitude')
xlabel('d [nm]')
ylabel('A_{N0} \cdot \surd(N_e)')
set(gca,'FontSize',20)
l=legend(gca,'show','Location','NorthWest');
set(l,'FontSize',12)

set(gca,'YScale','log')

%% plot signal intensity
figure(figSTD)
xlabel('amplitude')
ylabel('STD')
set(gca,'FontSize',20)
l=legend(gca,'show','Location','NorthWest');
set(l,'FontSize',12)
set(gca,'XScale','log')
set(gca,'YScale','log')


%%
% plot signal intensity
figure(figNSTD)
xlabel('d [nm]')
ylabel('STD of spectrum noise')
set(gca,'FontSize',20)
l=legend(gca,'show','Location','NorthWest');
set(l,'FontSize',12)
%%
%plot resolution
figure(figR)
X=[min(cellfun(@(x) min(x.Z),info)),max(cellfun(@(x) max(x.Z),info))];
xlabel('d [nm]')
ylabel('\Delta [nm]')
set(gca,'FontSize',20)
l=legend(gca,'show','Location','NorthWest');
set(l,'FontSize',12)
%title('Resolution')

figure(figA)



