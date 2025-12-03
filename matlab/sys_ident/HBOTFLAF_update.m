function [w, a] = RCTFLAF_update(w, a, s_vec, g_vec, error, par)

    mu_w = par.mu_w;
    mu_a = par.mu_a;

    % A update
    a = a + mu_a * error * w(2:end) * g_vec;
%         a = a + mu_a * error * w * g_vec;

    % W update
    w = w + mu_w * error * [1,s_vec];
%         w = w + mu_w * error * s_vec;