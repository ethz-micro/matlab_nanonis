close all;
clear all;

%%

%{
%Load aram STM and FESTM
DTSTMfn='Data/Aram/image035.sxm';
FESTMfn='Data/Aram/image046.sxm';

DTSTM=load.loadProcessedSxM(DTSTMfn);
FESTM=load.loadProcessedSxM(FESTMfn);

DTcn=1;
FEcn=3;
%}

%%{
%Load STM and FESTM
DTSTMfn='Data/Urs/m2_ori.par';
FESTMfn='Data/Urs/m14_ori.par';

DTSTM=load.loadProcessedPar(DTSTMfn);
FESTM=load.loadProcessedPar(FESTMfn);

DTcn=1;
FEcn=2;
%}
%%
figure
plot.plotFile(DTSTM,DTcn);
figure
plot.plotFile(FESTM,FEcn);
%%

%Find FE Resolution
data=FESTM.channels(FEcn).data;
data=op.interpPeaks(data);
[radial_average, radius, noise_fit] =op.getRadialFFT(data);

cutPrct=1.3;

signalNorm=radial_average./noise_fit;
rIdx=find(signalNorm>cutPrct,1,'last');
wavelength=1./radius(rIdx);

%Compute 15% mask on DTSTM
data=DTSTM.channels(DTcn).data;
[maskUp, maskDown] = mask.getMask(data, wavelength, 15, 85);

%Plot DTSTM + masks
figure
plot.plotFile(DTSTM,DTcn);
mask.applyMask(edge(maskUp));
mask.applyMask(edge(maskDown),[1,0,0]);

%% Find Offset
%Find offset
[offset, XC]=op.getOffset(DTSTM.channels(DTcn).data, DTSTM.header,FESTM.channels(FEcn).data, FESTM.header);
[xrange,yrange] = op.getRange(DTSTM.header);
xrange = xrange-offset(1);
yrange = yrange-offset(2);

%% Plot FESTM + DTSTM masks
figure
plot.plotFile(FESTM,FEcn);
mask.applyMask(edge(maskUp),[0,0,0],1,xrange,yrange);
mask.applyMask(edge(maskDown),[1,0,0],1,xrange,yrange);

%% Idem in the other way

%Compute 15% mask on FESTM
data=FESTM.channels(FEcn).data;
[maskUp, maskDown] = mask.getMask(data, wavelength, 30, 80);

%Plot FESTM + masks
figure
plot.plotFile(FESTM,FEcn,0,0,'NoTitle');
mask.applyMask(edge(maskUp),[1,0,0]);
%mask.applyMask(edge(maskDown),[1,0,0]);

%print -dpdf -loose FESTM

%plot DTSTM + mask
[xrange,yrange] = op.getRange(FESTM.header);
xrange = xrange+offset(1);
yrange = yrange+offset(2);

%Plot DTSTM + FESTM masks
figure
plot.plotFile(DTSTM,DTcn,0,0,'NoTitle');
mask.applyMask(edge(maskUp),[1,0,0],1,xrange,yrange);
%mask.applyMask(edge(maskDown),[1,0,0],1,xrange,yrange);

xlim(xrange*1e9)
ylim(yrange*1e9)

%print -dpdf -loose DTSTM


%%
figure
plot.plotFile(FESTM,1,0,0,'NoTitle');





