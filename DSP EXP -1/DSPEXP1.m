clear;
clc;
close all;

% Design Parameters
Fs = 8000;       % Sampling frequency in Hz
Ap = 1;          % Passband ripple in dB
As = 40;         % Stopband attenuation in dB

% 1. LOW-PASS FILTER DESIGN
fp_lp = 1000;    % Passband frequency
fs_lp = 1500;    % Stopband frequency

wp_lp = fp_lp/(Fs/2);
ws_lp = fs_lp/(Fs/2);

[N_lp, Wn_lp] = buttord(wp_lp, ws_lp, Ap, As);
[b_lp, a_lp] = butter(N_lp, Wn_lp, 'low');

% 2. HIGH-PASS FILTER DESIGN
fp_hp = 2500;    % Passband frequency
fs_hp = 1800;    % Stopband frequency

wp_hp = fp_hp/(Fs/2);
ws_hp = fs_hp/(Fs/2);

[N_hp, Wn_hp] = buttord(wp_hp, ws_hp, Ap, As);
[b_hp, a_hp] = butter(N_hp, Wn_hp, 'high');

% DISPLAY NUMERICAL OUTPUTS
fprintf('=== BUTTERWORTH IIR FILTERS ===\n\n');

fprintf('--- LOW-PASS FILTER ---\n');
fprintf('Filter Order: %d\n', N_lp);
fprintf('Cutoff Frequency: %.2f Hz\n', Wn_lp*(Fs/2));

fprintf('Numerator Coefficients:\n');
disp(b_lp);

fprintf('Denominator Coefficients:\n');
disp(a_lp);

fprintf('--- HIGH-PASS FILTER ---\n');
fprintf('Filter Order: %d\n', N_hp);
fprintf('Cutoff Frequency: %.2f Hz\n', Wn_hp*(Fs/2));

fprintf('Numerator Coefficients:\n');
disp(b_hp);

fprintf('Denominator Coefficients:\n');
disp(a_hp);

% FREQUENCY RESPONSE
[H_lp, f] = freqz(b_lp, a_lp, 1024, Fs);
[H_hp, ~] = freqz(b_hp, a_hp, 1024, Fs);

% PLOTTING
figure('Name', 'Butterworth IIR Filters');

% LPF Magnitude Response
subplot(2,2,1);
plot(f, 20*log10(max(abs(H_lp),1e-10)), 'b', 'LineWidth', 1.5);
grid on;
title(['LPF Magnitude Response (Order = ', num2str(N_lp), ')']);
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
ylim([-80 5]);

% LPF Phase Response
subplot(2,2,2);
plot(f, angle(H_lp)*180/pi, 'r', 'LineWidth', 1.5);
grid on;
title('LPF Phase Response');
xlabel('Frequency (Hz)');
ylabel('Phase (Degrees)');

% HPF Magnitude Response
subplot(2,2,3);
plot(f, 20*log10(max(abs(H_hp),1e-10)), 'b', 'LineWidth', 1.5);
grid on;
title(['HPF Magnitude Response (Order = ', num2str(N_hp), ')']);
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');

% HPF Phase Response
subplot(2,2,4);
plot(f, angle(H_hp)*180/pi, 'r', 'LineWidth', 1.5);
grid on;
title('HPF Phase Response');
xlabel('Frequency (Hz)');
ylabel('Phase (Degrees)');
