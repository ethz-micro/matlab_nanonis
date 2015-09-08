clear all;
close all;

chn=1;%1
%Data sets
%base='/Volumes/micro/STM_AFM/2013/';
base='Data/';

k=1;
%350
info{k}.name='350-4.12-1';
info{k}.idx=[36:43, 45:48];
info{k}.fn=[base,'2013-12-04/image'];
info{k}.Z=[25,20,18,15,12,11,10,9,7,6,5,4]-0.5;%8
info{k}.drift=.5;


%200
k=k+1;
info{k}.name='200-4.12-2';
info{k}.idx=54:66;
info{k}.fn=[base,'2013-12-04/image'];
info{k}.Z=[20,18,15,12,10,9,8,7,6,5,4,3,2]+2;
info{k}.drift=2;


%400
k=k+1;
info{k}.name='400-5.12-1';
info{k}.idx=[35:39,41:45];
info{k}.fn=[base,'2013-12-05/image'];
info{k}.Z=[14,10,8,6,4,0,-2,-4,-5,-6]+10;
info{k}.drift=10;

%%{
%400
k=k+1;
info{k}.name='400-5.12-2';
info{k}.idx=47:64;
info{k}.fn=[base,'2013-12-05/image'];
info{k}.Z=[25,20,17,14,12,10,8,6,4,2,1,0,-1,-2,-3,-4,-5,-6]+10;
info{k}.drift=10;
%}

%300
k=k+1;
info{k}.name='300-6.12-1';
info{k}.idx=6:16;
info{k}.fn=[base,'2013-12-06/image'];
info{k}.Z=[25,20,15,12,10,8,6,6,4,3,2]+2;
info{k}.drift=2;

%%{
%300
k=k+1;
info{k}.name='300-6.12-2';
info{k}.idx=23:48;
info{k}.fn=[base,'2013-12-06/image'];
info{k}.Z=[25,20,17,15,12,10,9,8,6,3,1,0,-1,-3,-5,-6,-7,-8,-9,-10,-11,-12,-12,-14,-15,-15]+21;
info{k}.drift=21;
%}

%300
k=k+1;
info{k}.name='300-6.12-3';
info{k}.idx=53:68;
info{k}.fn=[base,'2013-12-06/image'];
info{k}.Z=[25,20,17,14,11,8,5,2,0,1,-1,-2,-3,-4,-5,-6]+10.5;
info{k}.drift=10.5;


%300
k=k+1;
info{k}.name='300-6.12-4';
info{k}.idx=71:77;
info{k}.fn=[base,'2013-12-06/image'];
info{k}.Z=[5,4,3,2,1,0,-1]+5;
info{k}.drift=5;

%300
k=k+1;
info{k}.name='300-6.12-5';
info{k}.idx=80:86;
info{k}.fn=[base,'2013-12-06/image'];
info{k}.Z=[6,5,4,3,2,1,0]+3.5;
info{k}.drift=3.5;



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




for k=1:numel(info)
    
    %clear data from previus loop
    clear STDImg Nimg radial_average radius noise_fit noise_coeff radial_signal signal_start signal_error
    
    %Get files names
    ext='.sxm';
    fns=arrayfun(@(x) sprintf('%s%03d%s',info{k}.fn,x,ext),info{k}.idx,'UniformOutput',false);
    
    %Get data
    files =cellfun(@load.loadProcessedSxM,fns,'UniformOutput',false);
    
    %% Remove noise
    for i=1:numel(files)
        if chn<3
            files{i}.channels(chn).data=op.interpHighStd(files{i}.channels(chn).data);
        end
        files{i}.channels(chn).data=op.interpPeaks(files{i}.channels(chn).data);
    end
    
    for i=numel(files):-1:1
        
        file = files{i};
        
        %Get data
        [radius(i,:),radial_average(i,:)] = ...
            op.getRadialFFT(file.channels(chn).data,...
            file.header.scan_pixels(1)./file.header.scan_range(1)./1e9);
        
        %Get noise
        [noise_fit(i,:),signal_start(i),signal_error(i), noise_coeff(i,:)] =op.getRadialNoise(radius(i,:), radial_average(i,:));
        
        %get mean value of intensity
        Nimg(i)=mean(file.channels(chn).lineMean);
        
        %Total image std
        STDImg(i)=nanstd(file.channels(chn).data(:));
        
    end
    %{
    %remove resolution with low signal to noise intensity
    radial_signal=radial_average./noise_fit;
    badRes=max(radial_signal,[],2)<2;% cut at least at half
    signal_start(badRes)=nan;
    signal_error(badRes)=nan;
    %}
    
    %Find highest peak
    radial_corr=radial_average-noise_fit;
    [~,I]=max(max(radial_corr));
    I=6;
    
    %plot signal intensity
    name = sprintf('%s f=%02.2f [1/nm]',info{k}.name,radius(1,I));
    figure(figA)
    plot(1./info{k}.Z,radial_corr(:,I),'x--','DisplayName',name);
    
    %plot resolution
    name = sprintf('%s Drift:%02.1f',info{k}.name,info{k}.drift);
    figure(figR)
    errorbar(info{k}.Z,signal_start,signal_error,'x','DisplayName',name)
    
    
    %plot noise slope
    figure(figC1)
    plot(1./info{k}.Z,noise_coeff(:,1),'x','DisplayName',name);
    
    %plot noise intensity
    figure(figC2)
    plot(1./sqrt(Nimg),exp(noise_coeff(:,2)),'x--','DisplayName',name);
    
    figure(figC2Z)
    plot(1./info{k}.Z,noise_coeff(:,2),'x--','DisplayName',name);
    
    figure(figC2ZN)
    plot(1./info{k}.Z,log(exp(noise_coeff(:,2)).*sqrt(Nimg)'),'x--','DisplayName',name);
    
    %plot STD
    figure(figSTD)
    plot(1./info{k}.Z,STDImg,'x--','DisplayName',name);
    
end
% plot signal intensity
figure(figA)
xlabel('1/d [1/nm]')
ylabel('amplitude')
set(gca,'FontSize',20)
l=legend(gca,'show','Location','NorthWest');
set(l,'FontSize',12)
%%
%plot resolution
figure(figR)
xlabel('d [nm]')
ylabel('\Delta [nm]')
set(gca,'FontSize',20)
l=legend(gca,'show','Location','NorthWest');
set(l,'FontSize',12)
%title('Resolution')
%%
%plot noise slope
figure(figC1)
xlabel('1/d [1/nm]')
ylabel('C1')
set(gca,'FontSize',20)
l=legend(gca,'show','Location','NorthWest');
set(l,'FontSize',12)
%%
%plot noise intensity
figure(figC2)
xlabel('1/sqrt(Ne)')
ylabel('Noise Amplitude')
set(gca,'FontSize',20)
l=legend(gca,'show','Location','NorthWest');
set(l,'FontSize',12)

figure(figC2Z)
%xlabel('1/sqrt(Ne)')
%ylabel('Noise Amplitude')
xlabel('1/Z [1/nm]')
ylabel('log(Noise Amplitude)')
set(gca,'FontSize',20)
l=legend(gca,'show','Location','NorthWest');
set(l,'FontSize',12)

%%
figure(figC2ZN)
%xlabel('1/sqrt(Ne)')
%ylabel('Noise Amplitude')
xlabel('1/Z [1/nm]')
ylabel('log(Normalized Noise Amplitude)')
set(gca,'FontSize',20)
l=legend(gca,'show','Location','NorthWest');
set(l,'FontSize',12)

% plot signal intensity
figure(figSTD)
xlabel('1/Z [1/nm]')
ylabel('STD [au]')
set(gca,'FontSize',20)
l=legend(gca,'show','Location','NorthWest');
set(l,'FontSize',12)

