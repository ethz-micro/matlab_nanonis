fn='Data/FE-W(011)-001.hys';
fid = fopen(fn, 'r', 'ieee-be');    % open with big-endian

%Read Header until we have
% \1A\04 (hex) indicates beginning of binary data
headertxt='';
s1 = [0 0];
while s1~=[26 4]
              s2 = fread(fid, 1, 'char');
              headertxt=[headertxt s2];
              s1(1) = s1(2);
              s1(2) = s2;
end

%remove last thing
headertxt=headertxt(1:end-2);
headertxt=strsplit(headertxt,'\n');

for i=1:numel(headertxt)/2
    fieldName=strtrim(headertxt{2*i-1});
    fieldValue=strtrim(headertxt{2*i});
    header.(fieldName(2:end-1))=fieldValue;
    
end


header.MSR_SIZE=str2num(header.MSR_SIZE);

%Read Data
data =fread(fid, [header.MSR_SIZE 3], 'float');

fclose(fid);

Q=sum(data(:,2))/sum(data(:,3));

Contr=(Q*data(:,3)-data(:,2))./(Q*data(:,3)+data(:,2));

Time=data(:,1);

S=.1;

plot(Time,1/S*Contr);
hold all;
plot(-Time,-1/S*Contr);