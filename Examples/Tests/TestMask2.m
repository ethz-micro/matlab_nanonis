close all;
clear all;

%%

%{
%Load aram STM and FESTM
DTSTMfn='Data/Aram/image035.sxm';
FESTMfn='Data/Aram/image046.sxm';

DTSTM=loadSxM.loadProcessedSxM(DTSTMfn);
FESTM=loadSxM.loadProcessedSxM(FESTMfn);

DTcn=1;
FEcn=3;
%}

%%{
%Load STM and FESTM
DTSTMfn='Data/Urs/m2_ori.par';
FESTMfn='Data/Urs/m14_ori.par';

DTSTM=loadSxM.loadProcessedPar(DTSTMfn);
FESTM=loadSxM.loadProcessedPar(FESTMfn);

DTcn=1;
FEcn=2;
%}
%%
figure
plotSxM.plotFile(DTSTM,DTcn);
figure
plotSxM.plotFile(FESTM,FEcn);
%%

%Find FE Resolution
data=FESTM.channels(FEcn).data;
data=op.interpPeaks(data);
[radius, radial_average]=op.getRadialFFT(data);
[noise_fit, wavelength] = op.getRadialNoise(radius, radial_average);

%Compute 15% mask on DTSTM
data=DTSTM.channels(DTcn).data;
[maskUp, maskDown] = mask.getMask(data, wavelength, 15, 85);

%Plot DTSTM + masks
figure
plotSxM.plotFile(DTSTM,DTcn);
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
plotSxM.plotFile(FESTM,FEcn);
mask.applyMask(edge(maskUp),[0,0,0],1,xrange*1e9,yrange*1e9);
mask.applyMask(edge(maskDown),[1,0,0],1,xrange*1e9,yrange*1e9);

%% Idem in the other way

%Compute 15% mask on FESTM
data=FESTM.channels(FEcn).data;
[maskUp, maskDown] = mask.getMask(data, wavelength, 30, 80);

%Plot FESTM + masks
figure
plotSxM.plotFile(FESTM,FEcn,0,0);
mask.applyMask(edge(maskUp),[1,0,0]);
%mask.applyMask(edge(maskDown),[1,0,0]);

%print -dpdf -loose FESTM

%plot DTSTM + mask
[xrange,yrange] = op.getRange(FESTM.header);
xrange = xrange+offset(1);
yrange = yrange+offset(2);

%Plot DTSTM + FESTM masks
figure
plotSxM.plotFile(DTSTM,DTcn,0,0);
mask.applyMask(edge(maskUp),[1,0,0],1,xrange*1e9,yrange*1e9);
%mask.applyMask(edge(maskDown),[1,0,0],1,xrange,yrange);

xlim(xrange*1e9)
ylim(yrange*1e9)

%print -dpdf -loose DTSTM

figure
plotSxM.plotFile(DTSTM,DTcn,0,0);
mask.applyMask(edge(maskUp),[1,0,0],1,xrange*1e9,yrange*1e9);


%%
figure
plotSxM.plotFile(FESTM,1,0,0);





