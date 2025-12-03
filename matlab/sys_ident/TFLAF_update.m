function [w] = TFLAF_update(w, error, g_vec, par)

%     mu = par.mu;
%     w = w + mu * error * [0,g_vec];

    mu = par.mu;
    mu_g_vec = mu * error * [1,g_vec];
    w = w + mu_g_vec;