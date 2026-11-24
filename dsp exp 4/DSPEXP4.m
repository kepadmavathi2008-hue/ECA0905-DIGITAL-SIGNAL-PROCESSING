matlab
clc;
clear;
close all;

% 1. INPUT PARAMETERS
Fs = 1000;
Fp = 100;
Fst = 150;
Rp = 1;
Rs = 40;

Wp = Fp/(Fs/2);
Wst = Fst/(Fs/2);

% 2. CHEBYSHEV FORMULA
epsilon = sqrt(10^(Rp/10)-1);
N_formula = acosh(sqrt((10^(Rs/10)-1)/(10^(Rp/10)-1))) ...
    / acosh(Fst/Fp);
N_theory = ceil(N_formula);

% 3. BUTTERWORTH FILTER
[Nb,Wb] = buttord(Wp,Wst,Rp,Rs);
[bB,aB] = butter(Nb,Wb,'low');

% 4. CHEBYSHEV-I FILTER
[Nc,Wc] = cheb1ord(Wp,Wst,Rp,Rs);
[bC,aC] = cheby1(Nc,Rp,Wc,'low');

% 5. ELLIPTIC FILTER
[Ne,We] = ellipord(Wp,Wst,Rp,Rs);
[bE,aE] = ellip(Ne,Rp,Rs,We,'low');

% 6. DISPLAY PARAMETERS
fprintf('\nIIR FILTER COMPARATIVE ANALYSIS\n');
fprintf('Sampling Frequency = %.2f Hz\n',Fs);
fprintf('Passband Edge = %.2f Hz\n',Fp);
fprintf('Stopband Edge = %.2f Hz\n',Fst);
fprintf('Passband Ripple = %.2f dB\n',Rp);
fprintf('Stopband Attenuation = %.2f dB\n',Rs);

% 7. CHEBYSHEV FORMULA RESULTS
fprintf('\nCHEBYSHEV TYPE-I FORMULA\n');
fprintf('Epsilon = %.4f\n',epsilon);
fprintf('Calculated Order = %.4f\n',N_formula);
fprintf('Theoretical Order = %d\n',N_theory);

% 8. FILTER ORDER
fprintf('\nFILTER ORDER COMPARISON\n');
fprintf('Butterworth Order = %d\n',Nb);
fprintf('Chebyshev-I Order = %d\n',Nc);
fprintf('Elliptic Order = %d\n',Ne);

% 9. DISPLAY COEFFICIENTS
fprintf('\nBUTTERWORTH COEFFICIENTS\n');
disp('Numerator:'); disp(bB);
disp('Denominator:'); disp(aB);

fprintf('\nCHEBYSHEV-I COEFFICIENTS\n');
disp('Numerator:'); disp(bC);
disp('Denominator:'); disp(aC);

fprintf('\nELLIPTIC COEFFICIENTS\n');
disp('Numerator:'); disp(bE);
disp('Denominator:'); disp(aE);

% 10. FREQUENCY RESPONSES
N = 4096;
[HB,f] = freqz(bB,aB,N,Fs);
[HC,~] = freqz(bC,aC,N,Fs);
[HE,~] = freqz(bE,aE,N,Fs);

MB = 20*log10(abs(HB)+eps);
MC = 20*log10(abs(HC)+eps);
ME = 20*log10(abs(HE)+eps);

% 11. PASSBAND RIPPLE
P = f <= Fp;
Ripple_B = max(MB(P))-min(MB(P));
Ripple_C = max(MC(P))-min(MC(P));
Ripple_E = max(ME(P))-min(ME(P));

% 12. STOPBAND ATTENUATION
S = f >= Fst;
Stop_B = -max(MB(S));
Stop_C = -max(MC(S));
Stop_E = -max(ME(S));

% 13. DEVIATION
Dev_C_Ripple = abs(Ripple_C-Rp)/Rp*100;
Dev_B_Stop = abs(Stop_B-Rs)/Rs*100;
Dev_C_Stop = abs(Stop_C-Rs)/Rs*100;
Dev_E_Stop = abs(Stop_E-Rs)/Rs*100;

% 14. TRANSITION BANDWIDTH
TransitionBW = Fst-Fp;

% 15. PERFORMANCE RESULTS
fprintf('\nFILTER PERFORMANCE\n');
fprintf('\nPASSBAND RIPPLE\n');
fprintf('Butterworth = %.4f dB\n',Ripple_B);
fprintf('Chebyshev-I = %.4f dB\n',Ripple_C);
fprintf('Elliptic = %.4f dB\n',Ripple_E);

fprintf('\nSTOPBAND ATTENUATION\n');
fprintf('Butterworth = %.4f dB\n',Stop_B);
fprintf('Chebyshev-I = %.4f dB\n',Stop_C);
fprintf('Elliptic = %.4f dB\n',Stop_E);

fprintf('\nCHEBYSHEV RIPPLE DEVIATION = %.4f %%\n',Dev_C_Ripple);
fprintf('Butterworth Stopband Deviation = %.4f %%\n',Dev_B_Stop);
fprintf('Chebyshev Stopband Deviation = %.4f %%\n',Dev_C_Stop);
fprintf('Elliptic Stopband Deviation = %.4f %%\n',Dev_E_Stop);

fprintf('\nTRANSITION BANDWIDTH = %.2f Hz\n',TransitionBW);

% 16. MAGNITUDE RESPONSE
figure;
plot(f,MB,'LineWidth',1.5);
hold on;
plot(f,MC,'LineWidth',1.5);
plot(f,ME,'LineWidth',1.5);
grid on;
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title('Comparison of IIR Filter Magnitude Responses');
legend('Butterworth','Chebyshev-I','Elliptic');
xlim([0 250]);
ylim([-80 5]);
xline(Fp,'--','Fp = 100 Hz');
xline(Fst,'--','Fst = 150 Hz');
yline(-Rp,'--','Rp = -1 dB');
yline(-Rs,'--','Rs = -40 dB');
hold off;

% 17. PHASE RESPONSE
Phase_B = unwrap(angle(HB))*180/pi;
Phase_C = unwrap(angle(HC))*180/pi;
Phase_E = unwrap(angle(HE))*180/pi;

figure;
plot(f,Phase_B,'LineWidth',1.2);
hold on;
plot(f,Phase_C,'LineWidth',1.2);
plot(f,Phase_E,'LineWidth',1.2);
grid on;
xlabel('Frequency (Hz)');
ylabel('Phase (degrees)');
title('Comparison of IIR Filter Phase Responses');
legend('Butterworth','Chebyshev-I','Elliptic');
xlim([0 250]);
hold off;

% 18. FILTER ORDER GRAPH
figure;
bar([Nb Nc Ne]);
set(gca,'XTick',1:3);
set(gca,'XTickLabel',{'Butterworth','Chebyshev-I','Elliptic'});
ylabel('Filter Order');
xlabel('Filter Type');
title('Comparison of IIR Filter Orders');
grid on;
