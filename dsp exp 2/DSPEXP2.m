matlab
clear;
clc;
close all;

% Design Parameters
Fs = 10000;
Ap = 0.5;
As = 30;

% 1. Low-Pass Filter
fp_lp = 1500;
fs_lp = 2000;

wp_lp = fp_lp/(Fs/2);
ws_lp = fs_lp/(Fs/2);

[N_lp, Wn_lp] = cheb1ord(wp_lp, ws_lp, Ap, As);
[b_lp, a_lp] = cheby1(N_lp, Ap, Wn_lp, 'low');

% 2. High-Pass Filter
fp_hp = 2500;
fs_hp = 1800;

wp_hp = fp_hp/(Fs/2);
ws_hp = fs_hp/(Fs/2);

[N_hp, Wn_hp] = cheb1ord(wp_hp, ws_hp, Ap, As);
[b_hp, a_hp] = cheby1(N_hp, Ap, Wn_hp, 'high');

% Display Results
fprintf('CHEBYSHEV TYPE-I IIR FILTERS\n\n');

fprintf('LOW-PASS FILTER\n');
fprintf('Order = %d\n', N_lp);
fprintf('Cutoff Frequency = %.2f Hz\n', Wn_lp*(Fs/2));
disp('Numerator Coefficients:');
disp(b_lp);
disp('Denominator Coefficients:');
disp(a_lp);

fprintf('HIGH-PASS FILTER\n');
fprintf('Order = %d\n', N_hp);
fprintf('Cutoff Frequency = %.2f Hz\n', Wn_hp*(Fs/2));
disp('Numerator Coefficients:');
disp(b_hp);
disp('Denominator Coefficients:');
disp(a_hp);

% Frequency Response
[H_lp, f] = freqz(b_lp, a_lp, 1024, Fs);
[H_hp, ~] = freqz(b_hp, a_hp, 1024, Fs);

% Plot Results
figure('Name','Chebyshev Type-I Filters');

subplot(2,2,1);
plot(f,20*log10(abs(H_lp)+eps),'b','LineWidth',1.5);
grid on;
title('LPF Magnitude Response');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
ylim([-60 5]);

subplot(2,2,2);
plot(f,angle(H_lp)*180/pi,'r','LineWidth',1.5);
grid on;
title('LPF Phase Response');
xlabel('Frequency (Hz)');
ylabel('Phase (degrees)');

subplot(2,2,3);
plot(f,20*log10(abs(H_hp)+eps),'b','LineWidth',1.5);
grid on;
title('HPF Magnitude Response');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
ylim([-60 5]);

subplot(2,2,4);
plot(f,angle(H_hp)*180/pi,'r','LineWidth',1.5);
grid on;
title('HPF Phase Response');
xlabel('Frequency (Hz)');
ylabel('Phase (degrees)');