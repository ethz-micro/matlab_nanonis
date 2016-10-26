function [nRow,nCol,figPos] = fitFig2Screen(nFig,screenSize)
% screenSize = get(0,'screensize');
% nFig = 10; % figure number

nCol = 1;  % column number
done = false;
while ~done
    dx = screenSize(4)/nCol;
    nRow = floor(screenSize(3)/dx);
    if nRow*nCol < nFig
        nCol = nCol+1;
    else
        done = true;
    end
end
%%
%close all
[xM,yM] = meshgrid(0:nRow-1,1:nCol);
x = reshape(xM',1,nRow*nCol);
y = reshape(yM',1,nRow*nCol);
%
figPos = zeros(nFig,4);
%figure('Position',screenSize);
for i = 1:nFig % to plot consider to go from 
%for i = nFig:-1:1
    figPos(i,:) = [screenSize(1)+x(i)*dx,screenSize(4) - y(i)*dx,dx,dx];

   %figure('Position',figPos(i,:));
   %subplot(nCol,nRow,i);
end


%{
close all
figPos1 = zeros(nFig,4);
for i = 1:nFig
    figPos1(i,:) = figposition([...
        x(i)/nRow,y(i)/nCol,...
        1/nRow,1/nCol]*100);
    figPos1(i,:) = [figPos1(i,1:3),figPos1(i,3)];
    figure('Position',figPos1(i,:));
end
%}