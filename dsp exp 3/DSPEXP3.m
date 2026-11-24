matlab
clear;
clc;
close all;

Fs = 5000;
T = 1/Fs;
fc = 1000;
Omega_c = 2*pi*fc;

% Analog Filter
b_a = Omega_c;
a_a = [1 Omega_c];

% 1. Impulse Invariance
[b_imp, a_imp] = impinvar(b_a, a_a, Fs);

% 2. Bilinear Transformation with Prewarping
Omega_p = (2/T)*tan(Omega_c*T/2);
b_pre = Omega_p;
a_pre = [1 Omega_p];

[b_blt, a_blt] = bilinear(b_pre, a_pre, Fs);

% Display Results
fprintf('EXPERIMENT 3: FILTER COMPARISON\n\n');
fprintf('Analog Cutoff Frequency: %.2f rad/s\n', Omega_c);
fprintf('Prewarped Frequency: %.2f rad/s\n\n', Omega_p);

fprintf('IMPULSE INVARIANCE\n');
disp('Numerator:');
disp(b_imp);
disp('Denominator:');
disp(a_imp);

fprintf('BILINEAR TRANSFORMATION\n');
disp('Numerator:');
disp(b_blt);
disp('Denominator:');
disp(a_blt);

% Frequency Responses
[H_imp, f] = freqz(b_imp, a_imp, 1024, Fs);
[H_blt, ~] = freqz(b_blt, a_blt, 1024, Fs);

% Plotting
figure('Name','Filter Comparison');

subplot(2,1,1);
plot(f,abs(H_imp),'b','LineWidth',1.5);
hold on;
plot(f,abs(H_blt),'r--','LineWidth',1.5);
grid on;
legend('Impulse Invariance','Bilinear Transformation');
title('Magnitude Response Comparison');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

subplot(2,1,2);
plot(f,angle(H_imp)*180/pi,'b','LineWidth',1.5);
hold on;
plot(f,angle(H_blt)*180/pi,'r--','LineWidth',1.5);
grid on;
legend('Impulse Invariance','Bilinear Transformation');
title('Phase Response Comparison');
xlabel('Frequency (Hz)');
ylabel('Phase (degrees)');
