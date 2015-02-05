%% Three different approaches for array processing:
%   The first approach is matched filter
%   The second one is sampled matrix inversion (SMI) where the correlation
%   matrix is obtained through theoretical compuation. This method doesn't
%   include signal but only contains interference and noise. This is not
%   practical since signal may be presented during estimation. This is
%   where the third method trying to show that signal presence doesn't
%   affect SMI results.
%   The third method uses the sampled data for correlation matrix
%   computation.

%% settings
M = 20;         % number of antennas
phi_i = 30;     % interference steering angle
phi_s = 20;     % source steering angle
SNR_i = 40;     % interferece SNR
SNR_s = 20;     % source SNR
N = 200;        % number of samples
lambda = 1;     %% normalized lambda
d = 1/lambda;   % normalized antenna spacing
signal_index = 100;

% signal source (only exists at one time instant)
u_s = (d/lambda)*sin(phi_s*pi/180);
s = zeros(M,N);
s(:,signal_index) = (10^(SNR_s/20))*exp(-j*2*pi*u_s*[(0:M-1)]/M)/sqrt(M);

% noise 
w = (randn(M,N)+j*randn(M,N))/sqrt(2);

% interference
v_i = (10^(SNR_i/20)*exp(-j*pi*[0:M-1]'*sin(phi_i*pi/180)))/sqrt(M);

% Received signals: signal+interference+noise, interference+noise, and
% signal+noise
x_sipn = s + (10^(SNR_i/20))*v_i*(randn(1,N)+j*randn(1,N))/sqrt(2)+w;
x_ipn = (10^(SNR_i/20))*v_i*(randn(1,N)+j*randn(1,N))/sqrt(2)+w;
x_sw = s + w;

% spatial matched filter, assuming signal angle is known
c_mf = exp(-j*2*pi*u_s*[(0:M-1)]/M)/sqrt(M);

% Matched filter outputs
y_mf1 = c_mf * x_sw;
y_mf2 = c_mf * x_sipn;
y_mf3 = c_mf * x_ipn;

figure(1)

subplot(3,1,1)
plot(abs(y_mf1))
title('Matched Filter Output in Time Domain on signal+noise, signal appears at n=100')
grid
subplot(3,1,2)
plot(abs(y_mf2))
title('Matched Filter Output in Time Domain on signal+interference+noise')
grid
subplot(3,1,3)
plot(abs(y_mf3))
title('Matched Filter Output in Time Domain on inteference+noise')
grid
%plot(20*log10(abs(v_i)))

% SMI approach, ideal autocorrelation matrix
R_ipn = (10^(SNR_i/10))*v_i*v_i' + eye(M);
v_s = s(:,100);
c_smi = R_ipn^(-1) * v_s/(v_s'*R_ipn^(-1)*v_s);
y_smi1 = c_smi' * x_sw;
y_smi2 = c_smi' * x_sipn;
y_smi3 = c_smi' * x_ipn;

figure(2)
subplot(3,1,1)
plot(20*log10(abs(y_smi1)))
title('Matched Filter Output in Time Domain on signal+noise, signal appears at n=100')
grid
subplot(3,1,2)
plot(20*log10(abs(y_smi2)))
title('Matched Filter Output in Time Domain on signal+interference+noise')
grid 
subplot(3,1,3)
plot(20*log10(abs(y_smi3)))
title('Matched Filter Output in Time Domain on inteference+noise')
grid

% SMI approach, using estimated autocorrelation matrix, K = 1.5M, where K
% is the sample size that can vary. The larger K is, the better.
K = 1.5 * M;
R_ipn_est = zeros(M, M);
for i = 1 : K : N - K - 1
    R_ipn_est = R_ipn_est + x_sipn(:, i:i+K)*x_sipn(:,i:i+K)';
end
R_est = R_ipn_est / K;
c_est = R_est^(-1)*v_s/(v_s'*R_est^(-1)*v_s);

y_est1 = c_est' * x_sw;
y_est2 = c_est' * x_sipn;
y_est3 = c_est' * x_ipn;

figure(3)
title('SMI with K-sampled Correlation Matrix')
subplot(3,1,1)
plot(20*log10(abs(y_est1)))
title('Matched Filter Output in Time Domain on signal+noise, signal appears at n=100')
grid
subplot(3,1,2)
plot(20*log10(abs(y_est2)))
title('Matched Filter Output in Time Domain on signal+interference+noise')
grid
subplot(3,1,3)
plot(20*log10(abs(y_est3)))
title('Matched Filter Output in Time Domain on inteference+noise')
grid
