close all;
clear all;

file= load.loadProcessedSxM('FeW016.sxm');


%Trans = fft(file.channels(1).data(:));

%plot(abs(Trans))


scanT=file.header.scan_time(1);
scanT=1;
Fs = file.header.scan_pixels(1)/scanT;                      % Sampling frequency
T = 1/Fs;                                                   % Sample time
L = file.header.scan_pixels(1)*file.header.scan_pixels(2);  % Length of signal
t = (0:L-1)*T;                % Time vector
% Data 


y = file.channels(1).data;%(:)  % Data from channel 1
%y=ones(size(y));
%y(1:2:end,:)=0;
y=y.';
y=y(:);

figure
plot(1000*t,y)
title('Signal Corrupted with Zero-Mean Random Noise')
xlabel('time (milliseconds)')
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(y,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);
figure
% Plot single-sided amplitude spectrum.
plot(f,2*abs(Y(1:NFFT/2+1)))
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')


figure

A= zeros(size(file.channels(1).data));
A(:)=Y*L;
imagesc(abs(A))




figure

imagesc(abs(fft2(file.channels(1).data)))

figure
B=fft2(file.channels(1).data);
plot(f,abs(B(1:NFFT/2+1)))

figure
plot(abs(B(:)))

%{
A=real(Trans);
imagesc(real(Trans));

central = Trans(:,1);
side = Trans(:,100);
figure
plot(real(central))
hold all;
plot(real(side))
ax = axis();
figure
for i=1:size(Trans,2)
    plot(real(Trans(:,i)))
    axis(ax);
    pause(.1)
    
end
%}