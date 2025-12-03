%clear all;

tic
rng(1);

% Parameters - experiment
monte = 10;    % No. of experiments
N = 50000;      % Number of samples
L = 8;         % Filter order
nv = 0.01;     % Noise variance

% Fixed point
fraclen = 12;
wrdlen = 16;

% Delaed update
del = 10;

% Parameters - LMS
mu_LMS = 1/32;       % Step size (1/64)

% TFLAF parameters
TFLAF_par.mu = 1/128;     % Step size = 1/128
P_t = 3;
TFLAF_par.Q_t = 2*P_t+1;
TFLAF_par.expL = L*TFLAF_par.Q_t;

% HBOTFLAF parameters
HBOTFLAF_par.mu_w = 1/64;     % Step size = 1/128
HBOTFLAF_par.mu_a = 1/64;       % Step size = 1/64
P_t = 3;
HBOTFLAF_par.Q = 2*P_t+1;

% Number of samples used to estimate steady-state MSE
mse_num_samples = 1000;

% Error variables
error_mc_LMS = zeros(1,N);
error_mc_TFLAF = zeros(1,N);
error_mc_HBOTFLAF = zeros(1,N);

error_mc_FxdLMS = zeros(1,N);

error_mc_FxdTFLAF = zeros(1,N);
error_mc_FxdLogTFLAF = zeros(1,N);

error_mc_FxdHBOTFLAF = zeros(1,N);
error_mc_FxdLogHBOTFLAF = zeros(1,N);

addpath("data/LUT/");
log_lut12 = load('data/LUT/log_mitchell_lut_Q4_12_no_rnd.mat');
log_lut12 = [0, log_lut12.log_mitchell_lut];

antilog_lut12 = load("data/LUT/antilog_mitchell_lut_Q6_12.mat");
antilog_lut12 = antilog_lut12.antilog_lut12;

% LUT logsin and logcos fxd
lut_fraclen = 7;
sin_fpath = sprintf('data/LUT/log2_sin_lut_%dquant_Q4_12.mat', lut_fraclen);
cos_fpath = sprintf('data/LUT/log2_cos_lut_%dquant_Q4_12.mat', lut_fraclen);
logsin16 = load(sin_fpath);
logcos16 = load(cos_fpath);
logsin16 = logsin16.log2sin_lut7_12;
logsin16(1) = 0;
logcos16 = logcos16.log2cos_lut7_12;
logcos16(end) = 0;

log_fraclen = 12;
log_acc_lut12 = log_lut12;

% LUT Phi Fixed 
lut_fraclen = 7;
sin_fpath = sprintf('data/LUT/sin_lut_%dquant_Q4_12.mat', lut_fraclen);
cos_fpath = sprintf('data/LUT/cos_lut_%dquant_Q4_12.mat', lut_fraclen);
sin16 = load(sin_fpath);
sin16 = sin16.sin_lut7_12;
cos16 = load(cos_fpath);
cos16 = cos16.cos_lut7_12;


for trial=1:monte

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Signal generation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%     Generate binary data

    x_white = 0.25*randn(1,N);  % Nonl filter input
%     x_white = 2*rand(1,N)-1;  % Nonl filter input
%     x_white = 1*randn(1,N);      % Lin only filter input
    
    % Thresholding to limit sample range
    th = 1.3;
    for i=1:N
        if( abs(x_white(i)) > th )
%             x_white(i) = sign(x_white(i))*th;
            x_white(i) = 0.25*x_white(i);
        end
    end
    x = x_white;
    ns = nv*randn(1,N);

%     % Coloured signal generation
%     x = zeros(1,N);
%     x(1) = x_white(1);
%     theta = 0.8;
% 
%     for i=2:N
%         x(i) = sqrt(1-theta^2)*x_white(i) + theta*x(i-1);
%     end

%     d(1) = x(1) + nv*randn(1,1);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Channel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Nonlinearity for NAEC 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Asymmetrical loudspeaker nonlinearity
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    gain = 4;
%     d_nl = zeros(1,N);

% %       Static nonlinearity
    z_l = 1.5*(x) - 0.3*(x).^2;

% %       Dynamic nonlinearity
%     z_l = 3/2*x - 3/10*x.^2 + 9/5*x.*[0,x(1:end-1)] + 1/2*x.*[0,0,x(1:end-2)] - ... 
%         2/5*x.*[0,0,0,x(1:end-3)] - 3/2*[0,x(1:end-1)].*[0,0,x(1:end-2)] + ...
%         9/10*x.*[0,x(1:end-1)].*[0,0,0,x(1:end-3)] + 1/2*[0,x(1:end-1)].*[0,0,x(1:end-2)].*[0,0,0,x(1:end-3)] - ... 
%         1/10*[0,x(1:end-1).^2] +1/5*[0,0,x(1:end-2).^2] - 1/10.*[0,0,0,x(1:end-3).^2] + ...
%         3/10*[0,0,0,x(1:end-3)].*[0,0,0,0,x(1:end-4)] - 6/5*[0,0,0,0,x(1:end-4).^2] + ...
%         1/5*[0,x(1:end-1)].*[0,0,0,0,0,x(1:end-5)] + 3/10*[0,0,0,x(1:end-3)].*[0,0,0,0,0,x(1:end-5)] + ... 
%         6/5*[0,0,0,0,0,x(1:end-5).^2];
    
%     z_l = 1.5*(x+0.5) - 0.3*(x+0.5).^2;   % Shifted Q point
    rho = 0.5*(z_l<=0) + 4*(z_l>0);
    d_nl = gain*(1./(1+exp(-rho.*z_l))-0.5);
%     d_nl = (d_nl-1);  % Shifting back to AC level

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Symmetrical soft clipping
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%     zeta = 0.25;
%     d_nl = zeros(1,N);
% 
%     for ind_nl = 1:length(x)
%         if ( abs(x(ind_nl)) <= zeta )
%             d_nl(ind_nl) = 2/(3*zeta) * x(ind_nl);
%         elseif ( abs(x(ind_nl)) > zeta && abs(x(ind_nl)) <= 2*zeta )
%             d_nl(ind_nl) = sign(x(ind_nl)) * (3-(2-abs(x(ind_nl))/zeta)^2)/3;
%         else
%             d_nl(ind_nl) = sign(x(ind_nl));
%         end
%     end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Room impulse response using RIR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     rir = fast_ISM_RoomResp(8000,[0.75 0.5 0.6 0.7 0.65 0.6],'t60', 0.06, [1 1 1.5], [2 2 1.5], [4 4 3]);
% %     rir(abs(rir) < 0.07*0.05599) = 0;
% %     d = conv(d_nl,rir(1:512)./0.05599);         % 512 tap system
%     d = conv(d_nl,rir(31:31+100)./0.05599);         % 128 tap system
% 
% %     d = conv(d_nl,[zeros(1,5),1,zeros(1,15),0.5,zeros(1,10),0.2,zeros(1,20),0.07]);
 
%    d = conv(d_nl,[-0.1,0.9,0.1,-0.3,0.4,-0.1,0.1,-0.05]);
    d = conv(d_nl,[1,0.5,0.2]);
%     d = conv(d_nl,[-0.1,0.9,0.1,-0.05]);

    d = d(1:length(d_nl)) + ns;
%     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    d_fi = d .* 2^(fraclen);
    d_fi = round(d_fi);
    if(overflow_det(d,fraclen,wrdlen))
        d
    end

    x_fi = x .* 2^(fraclen);
    x_fi = round(x_fi);
    if(overflow_det(x,fraclen,wrdlen))
        x
    end

    % Error variables
    e_LMS = zeros(1,N);
    e_TFLAF = zeros(1,N);
    e_HBOTFLAF = zeros(1,N);

    e_FxdLMS = zeros(1,N);
    e_FxdTFLAF = zeros(1,N);
    e_FxdLogTFLAF = zeros(1,N);
    e_FxdHBOTFLAF = zeros(1,N);
    e_FxdLogHBOTFLAF = zeros(1,N);

    e_LMS(1) = d(1);
    e_TFLAF(1) = d(1);
    e_HBOTFLAF(1) = d(1);

    e_FxdTFLAF(1) = nearest(d(1)*(2^(fraclen))).*(2^(-fraclen));
    e_FxdLogTFLAF(1) = nearest(d(1)*(2^(fraclen))).*(2^(-fraclen));
    e_FxdHBOTFLAF(1) = nearest(d(1)*(2^(fraclen))).*(2^(-fraclen));
    e_FxdLogHBOTFLAF(1) = nearest(d(1)*(2^(fraclen))).*(2^(-fraclen));


    % Weight initialize
    w_LMS = zeros(1,L+1);    

    w_TFLAF = zeros(1,TFLAF_par.expL+1);
    w_FxdTFLAF = zeros(1,TFLAF_par.expL+1);
    w_FxdLogTFLAF = zeros(1,TFLAF_par.expL+1);
    w_TFLAF_orig = zeros(1,TFLAF_par.expL+1);
    g_vec = zeros(1,TFLAF_par.expL+del*TFLAF_par.Q_t);
    g_vec_fxd = zeros(1,TFLAF_par.expL+del*TFLAF_par.Q_t);
    g_vec_orig = zeros(1,TFLAF_par.expL+del*TFLAF_par.Q_t);
    log_g_vec = zeros(1,TFLAF_par.expL+del*TFLAF_par.Q_t);
    log_g_vec_sign = zeros(1,TFLAF_par.expL+del*TFLAF_par.Q_t);
    log_g_vec_zero = ones(1,TFLAF_par.expL+del*TFLAF_par.Q_t);
    
    w_HBOTFLAF = zeros(1,L+1);
    a_HBOTFLAF = zeros(1,HBOTFLAF_par.Q);
    a_HBOTFLAF(1) = 1;
    s_vec_HBOTFLAF = zeros(1,L+del);
    g_vec_HBOTFLAF = zeros(L+del,HBOTFLAF_par.Q);

    w_FxdHBOTFLAF = zeros(1,L+1);
    a_FxdHBOTFLAF = zeros(1,HBOTFLAF_par.Q);
    a_FxdHBOTFLAF(1) = 1;

    w_FxdLogHBOTFLAF = zeros(1,L+1);
    a_FxdLogHBOTFLAF = zeros(1,HBOTFLAF_par.Q);
    a_FxdLogHBOTFLAF(1) = 1;

    s_vec_fxd_HBOTFLAF = zeros(1,L+del);
    g_vec_fxd_HBOTFLAF = zeros(L+del,HBOTFLAF_par.Q);
   
    log_s_vec_fxd_HBOTFLAF = zeros(1,L+del);
    log_g_vec_fxd_HBOTFLAF = zeros(L+del,HBOTFLAF_par.Q);
    log_s_vec_sign_fxd = zeros(1,L+del);
    log_s_vec_zero_fxd = ones(1,L+del);
    log_g_vec_sign_fxd = zeros(L+del,HBOTFLAF_par.Q);
    log_g_vec_zero_fxd = ones(L+del,HBOTFLAF_par.Q);

    % Channel related
    %x_vec = zeros(1,L);
    x_vec = zeros(1,L+del);     % Delayed version

    % Start MC experiment
    for i=1:N

        % Input tap
        x_vec = [x(i), x_vec(1:end-1)];

        % Apply to filters
% 
        [e_LMS(i)] = LMS_filter(x_vec(1:L), d(i), w_LMS);
        [e_TFLAF(i), g_vec] = TFLAF_filter(x(i), d(i), w_TFLAF, g_vec, TFLAF_par);
        [e_FxdLogTFLAF(i), log_g_vec, log_g_vec_sign, log_g_vec_zero] = LogTFLAF_filter_fxd(x(i), d(i), w_FxdLogTFLAF, log_g_vec, log_g_vec_zero, log_g_vec_sign, TFLAF_par, fraclen, lut_fraclen, wrdlen, logsin16, logcos16, log_acc_lut12, antilog_lut12, log_lut12);
%         [e_FxdLogTFLAF(i), log_g_vec, log_g_vec_sign, log_g_vec_zero] = LogTFLAF_filter_fxd(x(i), d(i), w_FxdLogTFLAF, log_g_vec, log_g_vec_zero, log_g_vec_sign, TFLAF_par, fraclen, lut_fraclen, wrdlen, sin16, cos16, log_lut12, antilog_lut12, log_acc_lut12);
          [e_FxdTFLAF(i), g_vec_fxd] = TFLAF_filter_fxd(x(i), d(i), w_FxdTFLAF, g_vec_fxd, TFLAF_par, fraclen, lut_fraclen, wrdlen, sin16, cos16);
        [e_HBOTFLAF(i), s_vec_HBOTFLAF, g_vec_HBOTFLAF] = HBOTFLAF_filter(x(i), d(i), w_HBOTFLAF, a_HBOTFLAF, s_vec_HBOTFLAF, g_vec_HBOTFLAF, HBOTFLAF_par);   
        [e_FxdHBOTFLAF(i), s_vec_fxd_HBOTFLAF, g_vec_fxd_HBOTFLAF] = HBOTFLAF_filter_fxd(x(i), d(i), w_FxdHBOTFLAF, a_FxdHBOTFLAF, s_vec_fxd_HBOTFLAF, g_vec_fxd_HBOTFLAF, HBOTFLAF_par, fraclen, wrdlen, sin16, cos16, lut_fraclen);
        [e_FxdLogHBOTFLAF(i), log_s_vec_fxd_HBOTFLAF, log_s_vec_sign_fxd, log_s_vec_zero_fxd, log_g_vec_fxd_HBOTFLAF, log_g_vec_sign_fxd, log_g_vec_zero_fxd] = LogHBOTFLAF_filter_fxd(x(i), d(i), w_FxdLogHBOTFLAF, a_FxdLogHBOTFLAF, log_s_vec_fxd_HBOTFLAF, log_s_vec_sign_fxd, log_s_vec_zero_fxd, log_g_vec_fxd_HBOTFLAF, log_g_vec_sign_fxd, log_g_vec_zero_fxd, HBOTFLAF_par, fraclen, wrdlen, logsin16, logcos16, antilog_lut12, log_lut12, lut_fraclen, log_acc_lut12, log_fraclen);
%         [e_FxdLogHBOTFLAF(i), log_s_vec_fxd_HBOTFLAF, log_s_vec_sign_fxd, log_s_vec_zero_fxd, log_g_vec_fxd_HBOTFLAF, log_g_vec_sign_fxd, log_g_vec_zero_fxd] = LogHBOTFLAF_filter_fxd(x(i), d(i), w_FxdLogHBOTFLAF, a_FxdLogHBOTFLAF, log_s_vec_fxd_HBOTFLAF, log_s_vec_sign_fxd, log_s_vec_zero_fxd, log_g_vec_fxd_HBOTFLAF, log_g_vec_sign_fxd, log_g_vec_zero_fxd, HBOTFLAF_par, fraclen, wrdlen, sin16, cos16, antilog_lut12, log_lut12, lut_fraclen, log_acc_lut12, log_fraclen);

        % Apply weight update

        if (i > del)
            [w_LMS] = LMS_update(x_vec(del+1:end), w_LMS, mu_LMS, e_LMS(i-del));
            [w_TFLAF] = TFLAF_update(w_TFLAF, e_TFLAF(i-del), g_vec(del*TFLAF_par.Q_t+1:end), TFLAF_par);
            [w_FxdLogTFLAF] = LogTFLAF_update_fxd(w_FxdLogTFLAF, e_FxdLogTFLAF(i-del), log_g_vec(del*TFLAF_par.Q_t+1:end), log_g_vec_zero(del*TFLAF_par.Q_t+1:end), log_g_vec_sign(del*TFLAF_par.Q_t+1:end), TFLAF_par, fraclen, wrdlen, log_lut12, antilog_lut12);

            [w_FxdTFLAF] = TFLAF_update_fxd(w_FxdTFLAF,e_FxdTFLAF(i-del),g_vec_fxd(del*TFLAF_par.Q_t+1:end), TFLAF_par, fraclen, wrdlen);
            [w_HBOTFLAF, a_HBOTFLAF] = HBOTFLAF_update(w_HBOTFLAF, a_HBOTFLAF, s_vec_HBOTFLAF(del+1:end), g_vec_HBOTFLAF(del+1:end,:), e_HBOTFLAF(i-del), HBOTFLAF_par);                           
            [w_FxdLogHBOTFLAF, a_FxdLogHBOTFLAF] = LogHBOTFLAF_update_fxd(w_FxdLogHBOTFLAF, a_FxdLogHBOTFLAF, log_s_vec_fxd_HBOTFLAF(del+1:end), log_s_vec_sign_fxd(del+1:end), log_s_vec_zero_fxd(del+1:end), log_g_vec_fxd_HBOTFLAF(del+1:end,:), log_g_vec_sign_fxd(del+1:end,:), log_g_vec_zero_fxd(del+1:end,:), e_FxdLogHBOTFLAF(i-del), HBOTFLAF_par, fraclen, wrdlen, log_lut12, antilog_lut12, log_acc_lut12, log_fraclen);
            [w_FxdHBOTFLAF, a_FxdHBOTFLAF] = HBOTFLAF_update_fxd(w_FxdHBOTFLAF, a_FxdHBOTFLAF, s_vec_fxd_HBOTFLAF(del+1:end), g_vec_fxd_HBOTFLAF(del+1:end,:), e_FxdHBOTFLAF(i-del), HBOTFLAF_par, fraclen, wrdlen);
        end

    end
        
    % MC error accumulation
    error_mc_LMS = error_mc_LMS + (e_LMS.^2);
    error_mc_TFLAF = error_mc_TFLAF + (e_TFLAF.^2);
    error_mc_HBOTFLAF = error_mc_HBOTFLAF + (e_HBOTFLAF.^2);

    error_mc_FxdTFLAF = error_mc_FxdTFLAF + (e_FxdTFLAF.^2);
    error_mc_FxdLogTFLAF = error_mc_FxdLogTFLAF + (e_FxdLogTFLAF.^2);
    error_mc_FxdHBOTFLAF = error_mc_FxdHBOTFLAF + (e_FxdHBOTFLAF.^2);
    error_mc_FxdLogHBOTFLAF = error_mc_FxdLogHBOTFLAF + (e_FxdLogHBOTFLAF.^2);

end

% Compute error over all MC experiments + 20 order averaging
error_mc_LMS = movmean(error_mc_LMS / monte,500);
error_mc_TFLAF = movmean(error_mc_TFLAF / monte,500);
error_mc_HBOTFLAF = movmean(error_mc_HBOTFLAF / monte,500);

error_mc_FxdTFLAF = movmean(error_mc_FxdTFLAF / monte,500);
error_mc_FxdLogTFLAF = movmean(error_mc_FxdLogTFLAF / monte,500);
error_mc_FxdHBOTFLAF = movmean(error_mc_FxdHBOTFLAF / monte,500);
error_mc_FxdLogHBOTFLAF = movmean(error_mc_FxdLogHBOTFLAF / monte,500);

toc

% Plot figures
figure;
plot(10*log10(error_mc_LMS));
hold on;
plot(10*log10(error_mc_TFLAF));
plot(10*log10(error_mc_FxdTFLAF));
plot(10*log10(error_mc_FxdLogTFLAF));
plot(10*log10(error_mc_HBOTFLAF));
plot(10*log10(error_mc_FxdHBOTFLAF));
plot(10*log10(error_mc_FxdLogHBOTFLAF));

grid on
xlabel('Iteration');
ylabel('MSE (dB)');
title('MSE learning curves');
legend("LMS", "TFLAF", "TFLAF-Fixed", "LogTFLAF", "HBO-TFLAF", "HBO-TFLAF-Fixed", "LogHBO-TFLAF");

disp("Steady state MSE ")

steadystateMSE_LMS = mean(10*log10(error_mc_LMS(end-mse_num_samples:end)))

steadystateMSE_HBOTFLAF = mean(10*log10(error_mc_HBOTFLAF(end-mse_num_samples:end)))
steadystateMSE_FxdHBOTFLAF = mean(10*log10(error_mc_FxdHBOTFLAF(end-mse_num_samples:end)))
steadystateMSE_FxdLogHBOTFLAF = mean(10*log10(error_mc_FxdLogHBOTFLAF(end-mse_num_samples:end)))

steadystateMSE_TFLAF = mean(10*log10(error_mc_TFLAF(end-mse_num_samples:end)))
steadystateMSE_FxdTFLAF = mean(10*log10(error_mc_FxdTFLAF(end-mse_num_samples:end)))
steadystateMSE_FxdLogTFLAF = mean(10*log10(error_mc_FxdLogTFLAF(end-mse_num_samples:end)))

