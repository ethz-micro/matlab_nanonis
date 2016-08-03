function data = interpPeaks(data)

%compare with 3* std
stdData= nanstd(data(:));
meanData=nanmean(data(:));
stdOld=5*stdData;

while stdOld/stdData>1.01% 1% diff
    stdOld=stdData;
    data(abs(data-meanData)>3*stdData)=nan;
    stdData= nanstd(data(:));
    meanData=nanmean(data(:));
end


%find good points
goodIdx=abs(data-meanData)<3*stdData;

%get lines and column vectors
line=1:size(data,1);
column=1:size(data,2);

%horizontal interpolation
interpolatedH= zeros(size(data))*nan;
for i=line(sum(~goodIdx,2)>0 & sum(goodIdx,2)>1)
    interpolatedH(i,~goodIdx(i,:)) = interp1(column(goodIdx(i,:)),data(i,goodIdx(i,:)),column(~goodIdx(i,:)));
end

%Vertical interpolation
interpolatedV= zeros(size(data))*nan;
for i=line(sum(~goodIdx,1)>0 & sum(goodIdx,1)>1)
    interpolatedV(~goodIdx(:,i),i) = interp1(line(goodIdx(:,i)),data(goodIdx(:,i),i),line(~goodIdx(:,i)));
end

%If one of the correction is nan, take value from the other
interpolatedH(isnan(interpolatedH))=interpolatedV(isnan(interpolatedH));
interpolatedV(isnan(interpolatedV))=interpolatedH(isnan(interpolatedV));

%mean between the two corrections
%interpolated=1/2*(interpolatedH+interpolatedV);

%replace data
data(~goodIdx)=interpolatedV(~goodIdx);
end