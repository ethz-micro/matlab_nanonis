
%clear all;
close all;
[header,data]=load.loadsxm('data/2015_05_05/bulk_fe_002.sxm',3);

%% Prepare data
data=flip(data,2);
cut=1000000;
data = data';
data=data(:);
bigI=find(data>cut);
smallI=find(data<-cut);
bigV=data(data>cut);
smallV=data(data<-cut);

%% Double double point

slopeB=bigV./bigI;
doubleB=find(slopeB>1.5*median(slopeB));
if numel(doubleB>0)
    doubleB
    for I=doubleB
        bigV=[bigV(1:I);bigV(I:end)];
        bigI=[bigI(1:I);bigI(I:end)];
    end
end

slopeS=-smallV./smallI;
doubleS=find(slopeS>1.5*median(slopeS));
if numel(doubleS>0)
    doubleS
    for I=doubleS
        smallV=[smallV(1:I);smallV(I:end)];
        smallI=[smallI(1:I);smallI(I:end)];
    end
end

%% Plot position of peaks

X=1:numel(bigI);
X=X';
fitobjD=fit(X,bigI,'poly1');


figure
plot(bigI,'g.-');
hold all;
plot(smallI,'b.-')
%{
medianSlope=median([bigI./(1:length(bigI))';smallI./(1:length(smallI))']);
plot([0 length(bigI)],[0 medianSlope*length(bigI)],'r-');
%}
plot(fitobjD)

legend('Big','Small',sprintf('%.2d pix/peak, slope next: %.2d',fitobjD.p1,cut/fitobjD.p2));
xlabel('peak #');
ylabel('Index');
title('Location of peaks')
set(gca,'FontSize',20)





%% Plot value of peaks
figure
hold all;
plot(bigI,bigV,'g.')
plot(smallI,-smallV,'b.')
title('Value of peaks');
xlabel('Index')
ylabel('Value')

Slopes=[bigV./bigI; -smallV./smallI];
Slopes=Slopes([bigI;smallI]>1e6);
medianSlope=median(Slopes);


plotLine=@(x) plot([0 bigI(end)],[0 x*bigI(end)]);

plotLine(medianSlope);
plotLine(prctile(Slopes,1));
plotLine(prctile(Slopes,99));




legend(sprintf('big corr:%f',corr(bigI,bigV)), sprintf('-small corr:%f',corr(smallI,smallV)),sprintf('Median >1e6:%.3f',medianSlope),sprintf('1st prct>1e6:%.3f',prctile(Slopes,1)),sprintf('99 prct>1e6:%.3f',prctile(Slopes,99)));
set(gca,'FontSize',20)


%% Fit value of big peaks
%{
fitobj=fit(bigI,bigV,'poly1');
figure
plot(fitobj,bigI,bigV)
title(sprintf('%f *x + %f',fitobjD.p1,fitobjD.p2));
set(gca,'FontSize',20)
%}

%% Separate lines
%{
nbin=100;
roi=2/3;

%tan(theta)=V/I

theta=atan(bigV./bigI)*180/pi();

%At the end the peaks are separated
ROI=theta(roi*end:end);




figure
h=histogram(ROI,nbin);
Val=h.Values;

idx=((Val==0)&([0, Val(1:end-1)]~=0));
idx(1)=true;
idx(end)=true;
idx=find(idx);
clear result;
for i=numel(idx):-1:2
    result(i-1)=sum(Val(idx(i-1):idx(i)));
end

%bounds=h.BinEdges(idx);
%clear result;
%for i=numel(bounds):-1:2
%    result(i-1)=sum((theta<bounds(i)).*(theta>bounds(i-1)));
%end

legend(num2str(result))
title(sprintf('Angle of lines with ROI = %f of data',roi))
%}
%% plot diff between peaks
Diff=bigI-smallI;

%{
A=bigI(Diff<0);
B=smallI(Diff<0);
figure
plot(data(B+1:A-1));
negDiff=Diff(Diff<0);
if numel(negDiff)>1
title(sprintf('Data between negative difference: %d',negDiff(1)))
end
figure
hold all
plot(data(B-10:B-1),'.-');
plot(data(B+1:B+10),'.-');
plot(data(A-10:A-1),'.-');
plot(data(A+1:A+10),'.-');
legend('Left-','Left+','Right-','Right+')
%}


figure
histogram(Diff)
title('Distance between small & big indices')

%%
DiffV=smallV+bigV;

hist98=@(x) histogram(x,prctile(x,1):prctile(x,99));

figure
hist98(data)
title('data between 0 and 150')
legend(sprintf('median: %d',median(data)));

figure
DiffV1=DiffV(Diff==1);
hist98(DiffV1)
title('Difference between negative & positive peaks separated by 1')
legend(sprintf('median: %d',median(DiffV1)));

figure
DiffVB=DiffV(Diff>1);
hist98(DiffVB)
title('Difference between negative & positive peaks separated by > 1')
legend(sprintf('median: %d',median(DiffVB)));


DiffVS=DiffV(Diff<1);
if numel(DiffVS>0)
figure
hist98(DiffVS)
title('Difference between negative & positive peaks separated by <0')
legend(sprintf('mean: %d',mean(DiffVS)));
end

