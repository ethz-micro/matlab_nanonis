function plotHistogram(data, range)
%Plots an instogram and corresponding range to visualize the cut posiiton
%cut 99.9% data
prct = prctile(data(:),99.9);
data(data>prct)=prct;

prct = prctile(data(:),0.1);
data(data<prct)=prct;

histogram(data,50)
hold all;
a = axis();
a(1:2)=[range(1),range(1)];
plot(a(1:2),a(3:4))
a(1:2)=[range(2),range(2)];
plot(a(1:2),a(3:4))

end