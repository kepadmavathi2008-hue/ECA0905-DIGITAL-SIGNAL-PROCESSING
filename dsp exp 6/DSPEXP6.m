matlab
clear; clc; close all;

Fs = 8000;
fc = 1500;
wc = fc/(Fs/2);
N = 50;

% Window Functions
w_rect = rectwin(N+1);
w_hamm = hamming(N+1);
w_hann = hann(N+1);
w_black = blackman(N+1);

% FIR Filter Design
b_rect = fir1(N,wc,w_rect);
b_hamm = fir1(N,wc,w_hamm);
b_hann = fir1(N,wc,w_hann);
b_black = fir1(N,wc,w_black);

% Frequency Response
[H_rect,f] = freqz(b_rect,1,1024,Fs);
H_hamm = freqz(b_hamm,1,1024,Fs);
H_hann = freqz(b_hann,1,1024,Fs);
H_black = freqz(b_black,1,1024,Fs);

% Display Output
fprintf('FIR WINDOWING TECHNIQUES\n');
fprintf('Filter Order: %d\n',N);
fprintf('Cutoff Frequency: %d Hz\n',fc);

disp('Rectangular Window Coefficients:');
disp(b_rect(1:5));

disp('Hamming Window Coefficients:');
disp(b_hamm(1:5));

disp('Hanning Window Coefficients:');
disp(b_hann(1:5));

disp('Blackman Window Coefficients:');
disp(b_black(1:5));

% Magnitude Response
figure;

subplot(2,1,1);
plot(f,20*log10(max(abs(H_rect),1e-5)),'k');
hold on;
plot(f,20*log10(max(abs(H_hamm),1e-5)),'b');
plot(f,20*log10(max(abs(H_hann),1e-5)),'g');
plot(f,20*log10(max(abs(H_black),1e-5)),'r');
grid on;
legend('Rectangular','Hamming','Hanning','Blackman');
title('FIR Windowing Comparison');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
ylim([-100 10]);

% Phase Response
subplot(2,1,2);
plot(f,unwrap(angle(H_hamm))*180/pi,'b');
grid on;
title('Phase Response - Hamming Window');
xlabel('Frequency (Hz)');
ylabel('Phase (Degrees)');
