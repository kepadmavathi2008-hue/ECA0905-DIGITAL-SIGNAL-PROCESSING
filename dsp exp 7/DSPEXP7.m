matlab
clear; clc; close all;

Fs = 10000;
fp = 1500;
fs = 2000;
N = 40;

% Normalized Frequencies
f_bands = [0 fp fs Fs/2]/(Fs/2);
a_bands = [1 1 0 0];

% Parks-McClellan Method
b_pm = firpm(N,f_bands,a_bands);

% Frequency-Sampling Method
b_fs = fir2(N,f_bands,a_bands);

% Display Coefficients
fprintf('EXPERIMENT 5: FIR FILTER DESIGN\n');
fprintf('Filter Order: %d\n',N);
fprintf('Passband Edge: %d Hz\n',fp);
fprintf('Stopband Edge: %d Hz\n',fs);

disp('Parks-McClellan Coefficients:');
disp(b_pm(1:10));

disp('Frequency-Sampling Coefficients:');
disp(b_fs(1:10));

% Frequency Response
[H_pm,f] = freqz(b_pm,1,1024,Fs);
H_fs = freqz(b_fs,1,1024,Fs);

% Magnitude Response
figure;

subplot(2,1,1);
plot(f,20*log10(max(abs(H_pm),1e-5)),'b','LineWidth',1.5);
hold on;
plot(f,20*log10(max(abs(H_fs),1e-5)),'r--','LineWidth',1.5);
grid on;
legend('Parks-McClellan','Frequency-Sampling');
title('Magnitude Response Comparison');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
ylim([-80 10]);

% Phase Response
subplot(2,1,2);
plot(f,unwrap(angle(H_pm))*180/pi,'b');
hold on;
plot(f,unwrap(angle(H_fs))*180/pi,'r--');
grid on;
legend('Parks-McClellan','Frequency-Sampling');
title('Phase Response Comparison');
xlabel('Frequency (Hz)');
ylabel('Phase (Degrees)');
