clear all;
close all;
idx=36:48;
fn='Data/Aram/image0';
ext='.sxm';
fns=arrayfun(@(x) [fn num2str(x) ext],idx,'UniformOutput',false);
files=cellfun(@load.loadProcessedSxM,fns);

Z=[25,20,18,15,12,11,10,9,8,7,6,5,4]-0.5;

noiseSTD=0.0005;

fig=figure;
hold all

for i=numel(files):-1:1
    
    %figure(fig)
    file = files(i);
    Ne=file.channels(3).median.*(file.header.scan_time(1)/file.header.scan_pixels(1));
    X=Ne.^-.5;
    Y=file.channels(3).std-noiseSTD*X;
    plot(X,Y,'x','DisplayName',sprintf('Z=%d',Z(i)));
    A(i)=min(Y);
    
    
end
%figure(fig)
xlabel('median^{-.5}')
ylabel('STD')
legend(gca,'show')

figure
plot(Z,A)


%%

k=3;
f=11;

Datas=arrayfun(@(x) sgolayfilt(x.channels(3).data,k,f,[],2),files,'UniformOutput',false);


STDevs=arrayfun(@(x) median(x.channels(3).std),files);
Means=arrayfun(@(x) median(x.channels(3).median),files);


%{
DIFF=cellfun(@(x) diff(x,1,2),Datas,'UniformOutput',false);
A=cellfun(@(x) std(x(:)),DIFF);
plot(Z,A)
title('Diff STD')
figure
STDD=cellfun(@(x) std(x(:)),Datas);
plot(Z,STDD)
title('Residual STD')

figure
plot(Z,A./STDD
%}
figure
plot(Z,STDevs)
title('Median STD')
figure
plot(Z,Means)
title('Median mean')
figure
plot(Z,STDevs./Means)
title('Coefficient of variation')
Y=STDevs./Means;

%{
for i=1:size(files,2)
    A=diff(Datas{i},1,2);
    figure
    histogram(A(:),100)
    title(sprintf('%d',Z(i)))
    
end

%}
%{

k=3;
f=11;
file=files(12);
nmPPix=file.header.scan_range(1)/file.header.scan_pixels(1);

xL=file.header.scan_range(1)-[28 10].*1e-9;
yL=[52 55].*1e-9;

iL=50;

Data=file.channels(3).data;
figure

figure
plot.plotFile(file,3)
hold all

plot(xL,yL,'g')
plot([0 256]*nmPPix,[50 50]*nmPPix,'g')
title('RAW')

figure
file2=file;
file2.channels(3).data=sgolayfilt(file.channels(3).data,k,f,[],2);
plot.plotFile(file2,3)

title('Filtered')

figure

hold all

D=file.channels(3).data(iL,:);
filt=sgolayfilt(D,k,f);
X=(1:numel(filt))*nmPPix*1e9;
plot(X,flip(D));
plot(X,flip(filt));




%%

xL = floor(xL./nmPPix);
yL = floor(yL./nmPPix);
figure
raw=file.channels(3).data(yL(1),min(xL):max(xL));
raw=flip(raw(:));
X=(1:size(raw))*nmPPix;
plot(X,raw,'x-');
xlabel('nm')
ylabel('V')


filt=sgolayfilt(raw,k,f);
hold all
plot(X,filt, '.--')

%}

