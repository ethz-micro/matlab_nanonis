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



for i=1:numel(info)
    
    %Files names
    
    ext='.sxm';
    fns=arrayfun(@(x) sprintf('%s%03d%s',info{i}.fn,x,ext),info{i}.idx,'UniformOutput',false);
    
    %Corresponding Height
    
    %Get data
    [~ , data{i}] =arrayfun(@(x) load.loadsxm(x{1}, 0),fns,'UniformOutput',false);
    %{
    k=3;
    f=11;
    data{i}=cellfun(@(x) sgolayfilt(x,k,f,[],2),data{i},'UniformOutput',false);
    %}
    ddata{i}=cellfun(@(x) diff(x,1,2),data{i},'UniformOutput',false);

    
end

%%



figTxT='STD/Mean^{3/2}';
figFor=@(x,y) x./(y.^(3/2));
figTxT='STD/Mean';
figFor=@(x,y) x./y;




close all
figure(1)
hold all
title(figTxT)
figure(2)
hold all
title('STD diff')

figure(3)
hold all
title('Mean')


ZBIG=0;
DBIG=0;

for i=1:numel(data)
    
    
    STDFL=cellfun(@(x) median(std(x,0,2)),data{i});
    STDFLD=cellfun(@(x) median(std(x,0,2)),ddata{i});
    MFL=cellfun(@(x) median(mean(x,2)),data{i});
    
    Y=figFor(STDFL,MFL);
    figure(1)
    plot(info{i}.Z,Y,'x-','DisplayName',sprintf('%s Drift:%02.1f',info{i}.name,info{i}.drift))
    figure(2)
    plot(info{i}.Z,STDFLD./STDFL,'x-','DisplayName',sprintf('%s Drift:%02.1f',info{i}.name,info{i}.drift))
    figure(3)
    plot(info{i}.Z,MFL,'x-','DisplayName',sprintf('%s Drift:%02.1f',info{i}.name,info{i}.drift))

    
    ZBIG=[ZBIG,info{i}.Z];
    DBIG=[DBIG,Y];
end
ZBIG=ZBIG(2:end);
DBIG=DBIG(2:end);
[myFit,gof]=fit(log(ZBIG'),log(DBIG'),'poly1')
figure(1)
%plot(3:50,0.5963./(3:50),'r','DisplayName','Fit 0.5963/d')
set(gca,'XScale','log');
set(gca,'YScale','log');

X=3:50;
plot(X,exp(myFit.p2).*X.^myFit.p1,'r','DisplayName','Fit')
legend(gca,'show')
xlabel('Distance [nm]')
ylabel(figTxT)
figure(2)
legend(gca,'show')
xlabel('Distance [nm]')
ylabel('STD(Diff)/STD')
figure(3)
legend(gca,'show')
xlabel('Distance [nm]')
ylabel('Mean')


%%

idx=info{1}.idx;
fn=info{1}.fn;
Z=info{1}.Z;

%Files names

ext='.sxm';
fns=arrayfun(@(x) sprintf('%s%03d%s',fn,x,ext),idx,'UniformOutput',false);

%Corresponding Height



%Get data
[~ , Fdata] =arrayfun(@(x) load.loadsxm(x{1}, 0),fns,'UniformOutput',false);
[~ , Bdata] =arrayfun(@(x) load.loadsxm(x{1}, 1),fns,'UniformOutput',false);

%Fdata=cellfun(@(x) diff(x,1,2),Fdata,'UniformOutput',false);

STDFA=cellfun(@(x) std(x(:)),Fdata);
MFA=cellfun(@(x) mean(x(:)),Fdata);

STDBA=cellfun(@(x) std(x(:)),Bdata);
MBA=cellfun(@(x) mean(x(:)),Bdata);


STDFL=cellfun(@(x) median(std(x,0,2)),Fdata);
MFL=cellfun(@(x) median(mean(x,2)),Fdata);

STDBL=cellfun(@(x) median(std(x,0,2)),Bdata);
MBL=cellfun(@(x) median(mean(x,2)),Bdata);

figure
hold all;
title('Standard deviation');
plot(Z,STDFA,'x--','DisplayName','Forward, All')
plot(Z,STDBA,'x--','DisplayName','Backward, All')
plot(Z,STDFL,'x-','DisplayName','Forward, Median over lines')
plot(Z,STDBL,'x-','DisplayName','Backward, Median over lines')
legend(gca,'show')

figure
hold all;
title('Mean values')
plot(Z,MFA,'x--','DisplayName','Forward, All')
plot(Z,MBA,'x--','DisplayName','Backward, All')
plot(Z,MFL,'x-','DisplayName','Forward, Median over lines')
plot(Z,MBL,'x-','DisplayName','Backward, Median over lines')
legend(gca,'show')
figure
hold all;
title('Coefficient of variation')
plot(Z,STDFL./MFL,'x-','DisplayName','Forward')
plot(Z,STDBL./MBL,'x-','DisplayName','Backward')
legend(gca,'show')

