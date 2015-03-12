function plotHistogram(data, range)
%Plots an instogram and corresponding range to visualize the cut posiiton

histogram(data,50)
hold all;
a = axis();
a(1:2)=[range(1),range(1)];
plot(a(1:2),a(3:4))
a(1:2)=[range(2),range(2)];
plot(a(1:2),a(3:4))

end