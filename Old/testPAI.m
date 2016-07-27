%close all
clear all
fn='Data/March/2015-03-04/image005.sxm';


%%
[header, CH0]=loadSxM.loadsxm(fn,2);
[~, CH2]=loadSxM.loadsxm(fn,6);
N0=mean(CH0,2).*(header.scan_time(1)/header.scan_pixels(1));
N2=mean(CH2,2).*(header.scan_time(1)/header.scan_pixels(1));


%%

Q=N0./N2;
MQ=repmat(Q,1,size(CH2,2));

S=0.1;
P=1/S*((MQ.*CH2-CH0)./(MQ.*CH2+CH0));
Q=mean(N0)/mean(N2);
Neq=4.*N0./(Q+1);

%%
%{
figure
imagesc(P)
axis image
%}
%%
slope=1.03;
Y=slope./Neq./S^2;

%figure
plot(1./Neq,std(P,0,2).^2,'x');
hold all
plot(1./Neq,Y)
xlabel('1/Neq')
ylabel('Var(C)')
set(gca,'FontSize',20)