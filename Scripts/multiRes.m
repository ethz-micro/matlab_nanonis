clear all;
close all;

%Data sets
%base='/Volumes/micro/STM_AFM/2013/';
base='Data/';

i=1;
%350
info{i}.name='350-4.12-1';
info{i}.idx=[36:43, 45:48];
info{i}.fn=[base,'2013-12-04/image'];
info{i}.Z=[25,20,18,15,12,11,10,9,7,6,5,4]-0.5;%8
info{i}.drift=.5;


%200
i=i+1;
info{i}.name='200-4.12-2';
info{i}.idx=54:66;
info{i}.fn=[base,'2013-12-04/image'];
info{i}.Z=[20,18,15,12,10,9,8,7,6,5,4,3,2]+2;
info{i}.drift=2;


%400
i=i+1;
info{i}.name='400-5.12-1';
info{i}.idx=35:45;
info{i}.fn=[base,'2013-12-05/image'];
info{i}.Z=[14,10,8,6,4,2,0,-2,-4,-5,-6]+10;
info{i}.drift=10;


%400
i=i+1;
info{i}.name='400-5.12-2';
info{i}.idx=47:64;
info{i}.fn=[base,'2013-12-05/image'];
info{i}.Z=[25,20,17,14,12,10,8,6,4,2,1,0,-1,-2,-3,-4,-5,-6]+10;
info{i}.drift=10;

%300
i=i+1;
info{i}.name='300-6.12-1';
info{i}.idx=6:16;
info{i}.fn=[base,'2013-12-06/image'];
info{i}.Z=[25,20,15,12,10,8,6,6,4,3,2]+2;
info{i}.drift=2;


%300
i=i+1;
info{i}.name='300-6.12-2';
info{i}.idx=23:48;
info{i}.fn=[base,'2013-12-06/image'];
info{i}.Z=[25,20,17,15,12,10,9,8,6,3,1,0,-1,-3,-5,-6,-7,-8,-9,-10,-11,-12,-12,-14,-15,-15]+21;
info{i}.drift=21;


%300
i=i+1;
info{i}.name='300-6.12-3';
info{i}.idx=53:68;
info{i}.fn=[base,'2013-12-06/image'];
info{i}.Z=[25,20,17,14,11,8,5,2,0,1,-1,-2,-3,-4,-5,-6]+10.5;
info{i}.drift=10.5;


%300
i=i+1;
info{i}.name='300-6.12-4';
info{i}.idx=71:77;
info{i}.fn=[base,'2013-12-06/image'];
info{i}.Z=[5,4,3,2,1,0,-1]+5;
info{i}.drift=5;

%300
i=i+1;
info{i}.name='300-6.12-5';
info{i}.idx=80:86;
info{i}.fn=[base,'2013-12-06/image'];
info{i}.Z=[6,5,4,3,2,1,0]+3.5;
info{i}.drift=3.5;



%%

figR=figure;
hold all
figA=figure;
hold all
figC1=figure;
hold all
figC2=figure;
hold all
C1=[];
for i=1:numel(info)
    
    clear MX NC I
    
    %Get files names
    ext='.sxm';
    fns=arrayfun(@(x) sprintf('%s%03d%s',info{i}.fn,x,ext),info{i}.idx,'UniformOutput',false);
    
    %Get data
    files =cellfun(@(x) load.loadProcessedSxM(x),fns,'UniformOutput',false);
    
    for j=numel(files):-1:1
        
        %Get data
        [radial_signal, radius,NC(j,:)] =op.getRadialFFT(files{j}.channels(3).data);
        
        %distance [m] to pixels
        SpP=files{j}.header.scan_range(1)/files{j}.header.scan_pixels(1);
        
        %Correct radius units
        radius=radius./SpP./1e9;% 1/px to 1/nm
        
        rIdx=find(radial_signal>1.3,1,'last');
        if isempty(rIdx)
            %Get max infos
            MX(j)=nan;
            I(j)=nan;
        else
            %Get max infos
            MX(j)=radial_signal(rIdx);
            I(j)=radius(rIdx);
        end
        
        
    end
    
    figure(figA)
    plot(1./info{i}.Z,MX,'x--','DisplayName',sprintf('%s Drift:%02.1f',info{i}.name,info{i}.drift));
    
    figure(figR)
    img_size=size(files{1}.channels(3).data,1);
    %error=(1/2)./(I.^2)*1/img_size/SpP/1e9;
    %errorbar(info{i}.Z,(1/2)./I,error,'x','DisplayName',sprintf('%s Drift:%02.1f',info{i}.name,info{i}.drift)) 
    plot(info{i}.Z,(1/2)./I,'x','DisplayName',sprintf('%s Drift:%02.1f',info{i}.name,info{i}.drift)) 
    figure(figC1)
    plot(1./info{i}.Z,NC(:,1),'x--');
    C1=[C1; NC(:,1)];
    figure(figC2)
    plot(1./info{i}.Z,NC(:,2),'x--');
end
figure(figA)
legend(gca,'show','Location','NorthWest')
xlabel('1/Z [1/nm]')
ylabel('amplitude [au]')
set(gca,'FontSize',20)

figure(figR)

xlabel('Z [nm]')
ylabel('half wavelength [nm]')
legend(gca,'show','Location','NorthWest')
title('Resolution')
set(gca,'FontSize',20)
