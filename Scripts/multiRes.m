clear all;
close all;

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
info{k}.idx=35:45;
info{k}.fn=[base,'2013-12-05/image'];
info{k}.Z=[14,10,8,6,4,2,0,-2,-4,-5,-6]+10;
info{k}.drift=10;


%400
k=k+1;
info{k}.name='400-5.12-2';
info{k}.idx=47:64;
info{k}.fn=[base,'2013-12-05/image'];
info{k}.Z=[25,20,17,14,12,10,8,6,4,2,1,0,-1,-2,-3,-4,-5,-6]+10;
info{k}.drift=10;

%300
k=k+1;
info{k}.name='300-6.12-1';
info{k}.idx=6:16;
info{k}.fn=[base,'2013-12-06/image'];
info{k}.Z=[25,20,15,12,10,8,6,6,4,3,2]+2;
info{k}.drift=2;


%300
k=k+1;
info{k}.name='300-6.12-2';
info{k}.idx=23:48;
info{k}.fn=[base,'2013-12-06/image'];
info{k}.Z=[25,20,17,15,12,10,9,8,6,3,1,0,-1,-3,-5,-6,-7,-8,-9,-10,-11,-12,-12,-14,-15,-15]+21;
info{k}.drift=21;


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



%%

figR=figure;
hold all
figA=figure;
hold all
figC1=figure;
hold all
figC2=figure;
hold all


cutPrct=1.3;

for k=1:numel(info)
    
    clear Nimg radial_average radius noise_fit NCoeff radial_signal signal_start sigal_error
    
    %Get files names
    ext='.sxm';
    fns=arrayfun(@(x) sprintf('%s%03d%s',info{k}.fn,x,ext),info{k}.idx,'UniformOutput',false);
    
    %Get data
    files =cellfun(@load.loadProcessedSxM,fns,'UniformOutput',false);
    
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
        Nimg(i)=mean(file.channels(3).lineMean);
        
    end
    
    %remove resolution with low signal to noise intensity
    badRes=max(radial_signal,[],2)./cutPrct<2;% cut at least at half
    signal_start(badRes)=nan;
    sigal_error(badRes)=nan;
    
    radial_corr=radial_average-noise_fit;
    [~,I]=max(max(radial_corr));

    
    name = sprintf('%s f=%02.2f [1/nm]',info{k}.name,radius(1,I));
    figure(figA)
    plot(1./info{k}.Z,radial_corr(:,I),'x--','DisplayName',name);
    
    name = sprintf('%s Drift:%02.1f',info{k}.name,info{k}.drift);
    figure(figR)
    errorbar(info{k}.Z,signal_start,sigal_error,'x','DisplayName',name)
    
    figure(figC1)
    plot(1./info{k}.Z,NCoeff(:,1),'x','DisplayName',name);
    
    figure(figC2)
    plot(1./sqrt(Nimg),exp(NCoeff(:,2)),'x--','DisplayName',name);
    
end
%%
figure(figA)
xlabel('1/Z [1/nm]')
ylabel('Amplitude [au]')
set(gca,'FontSize',20)
l=legend(gca,'show','Location','NorthWest');
set(l,'FontSize',12)
%%

figure(figR)

xlabel('Z [nm]')
ylabel('Wavelength [nm]')
set(gca,'FontSize',20)
l=legend(gca,'show','Location','NorthWest');
set(l,'FontSize',12)
title('Resolution')

%%
figure(figC1)
xlabel('1/Z [1/nm]')
ylabel('C1')
set(gca,'FontSize',20)
l=legend(gca,'show','Location','NorthWest');
set(l,'FontSize',12)
    
figure(figC2)
xlabel('1/sqrt(Ne)')
ylabel('Noise Amplitude')
set(gca,'FontSize',20)
l=legend(gca,'show','Location','NorthWest');
set(l,'FontSize',12)

