function data = interpHighStd(data)

%Keep lines with STD < 2* median to scale
stdData= nanstd(data,0,2);
stdCut=2*nanmedian(stdData);

%Cut to keep "good lines"
linesSTDev= stdData > stdCut;

%Get index array
X=1:size(data,2);
Y=(1:size(data,1))';

%Get query
Xq=X;%want all X
Yq=Y(linesSTDev);%for bad lines

%Get good points
Xg=X;
Yg=Y(~linesSTDev);

%Interpolate query from good
data(Yq,Xq)=interp2(Xg,Yg,data(Yg,Xg),Xq,Yq);
end