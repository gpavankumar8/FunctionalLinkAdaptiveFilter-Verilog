function [w_upd, a_upd] = RCTFLAF_update_fxd(w, a, s_vec, g_vec, error, par, fraclen, wrdlen)

    mu_w = par.mu_w;
    mu_a = par.mu_a;

    w_fi = w .* 2^(fraclen);
    w_fi = nearest(w_fi);

    a_fi = a .* 2^(fraclen);
    a_fi = nearest(a_fi);

    error_fi = error .* 2^(fraclen);
    error_fi = nearest(error_fi);

    s_vec_fi = s_vec .* 2^(fraclen);
    s_vec_fi = nearest(s_vec_fi);

    g_vec_fi = g_vec .* 2^(fraclen);
    g_vec_fi = nearest(g_vec_fi);

    % A update

    error_mu_a_fi = 2^(nearest(log2(mu_a))) * error_fi;
    error_mu_a_fraclen = fraclen;
    error_mu_a = error_mu_a_fi * 2^(-error_mu_a_fraclen);
    error_mu_a_fraclen = fraclen;
    error_mu_a_fi = error_mu_a * 2^(error_mu_a_fraclen);
    error_mu_a_fi = nearest(error_mu_a_fi);
    if(overflow_det(error_mu_a,fraclen,wrdlen))
        error_mu_a
    end

%     g_vec_mu_a_err_fi = g_vec_fi * error_mu_a_fi;
%     g_vec_mu_a_err_fraclen = fraclen + error_mu_a_fraclen;
%     g_vec_mu_a_err = g_vec_mu_a_err_fi .* 2^(-g_vec_mu_a_err_fraclen);
%     g_vec_mu_a_err_fraclen = fraclen;
%     g_vec_mu_a_err_fi = g_vec_mu_a_err .* 2^(g_vec_mu_a_err_fraclen);
%     g_vec_mu_a_err_fi = nearest(g_vec_mu_a_err_fi);
%     if(overflow_det(g_vec_mu_a_err,fraclen,wrdlen))
%         g_vec_mu_a_err
%     end


%     g_vec_mu_a_err_fi = w_fi(2:end) * g_vec_fi;
%     g_vec_mu_a_err_fraclen = fraclen + fraclen;
%     g_vec_mu_a_err = g_vec_mu_a_err_fi .* 2^(-g_vec_mu_a_err_fraclen);
%     g_vec_mu_a_err_fraclen = fraclen;
%     g_vec_mu_a_err_fi = g_vec_mu_a_err .* 2^(g_vec_mu_a_err_fraclen);
%     g_vec_mu_a_err_fi = nearest(g_vec_mu_a_err_fi);
%     if(overflow_det(g_vec_mu_a_err,fraclen,wrdlen))
%         g_vec_mu_a_err
%     end


    w_g_vec_fi = w_fi(2:end) .* g_vec_fi';
    w_g_vec_fraclen = fraclen + fraclen;
    w_g_vec = w_g_vec_fi .* 2^(-w_g_vec_fraclen);
    w_g_vec_fraclen = fraclen;
    w_g_vec_fi = w_g_vec .* 2^(w_g_vec_fraclen);
    w_g_vec_fi = nearest(w_g_vec_fi);
    if(overflow_det(w_g_vec,fraclen,wrdlen))
        w_g_vec
    end

    w_g_vec_sum_fi = sum(w_g_vec_fi,2)';
    w_g_vec_sum_fraclen = fraclen;
    w_g_vec_sum = w_g_vec_sum_fi .* 2^(-w_g_vec_sum_fraclen);
    w_g_vec_sum_fraclen = fraclen;
    w_g_vec_sum_fi = w_g_vec_sum .* 2^(w_g_vec_sum_fraclen);
    w_g_vec_sum_fi = nearest(w_g_vec_sum_fi);
    if(overflow_det(w_g_vec_sum,fraclen,wrdlen))
        w_g_vec_sum
    end

    w_g_vec_mu_a_err_fi = w_g_vec_sum_fi * error_mu_a_fi;
    w_g_vec_mu_a_err_fraclen = w_g_vec_sum_fraclen + error_mu_a_fraclen;
    w_g_vec_mu_a_err = w_g_vec_mu_a_err_fi .* 2^(-w_g_vec_mu_a_err_fraclen);
    w_g_vec_mu_a_err_fraclen = fraclen;
    w_g_vec_mu_a_err_fi = w_g_vec_mu_a_err .* 2^(w_g_vec_mu_a_err_fraclen);
    w_g_vec_mu_a_err_fi = nearest(w_g_vec_mu_a_err_fi);
    if(overflow_det(w_g_vec_mu_a_err,fraclen,wrdlen))
        w_g_vec_mu_a_err
    end

    a_upd_fi = a_fi + w_g_vec_mu_a_err_fi;
    a_upd_fraclen = fraclen;
    a_upd = a_upd_fi * 2^(-a_upd_fraclen);
    a_upd_fraclen = fraclen;
    a_upd_fi = a_upd * 2^(a_upd_fraclen);
    a_upd_fi = nearest(a_upd_fi);
    if(overflow_det(a_upd,fraclen,wrdlen))
        a_upd
    end

%         a = a + mu_a * error * w * g_vec;

    % W update

    error_mu_w_fi = 2^(nearest(log2(mu_w))) * error_fi;
    error_mu_w_fraclen = fraclen;
    error_mu_w = error_mu_w_fi * 2^(-error_mu_w_fraclen);
    error_mu_w_fraclen = fraclen;
    error_mu_w_fi = error_mu_w * 2^(error_mu_w_fraclen);
    error_mu_w_fi = nearest(error_mu_w_fi);
    if(overflow_det(error_mu_w,fraclen,wrdlen))
        error_mu_w
    end

    s_vec_mu_w_err_fi = [1*2^(fraclen), s_vec_fi(1:length(w)-1)] * error_mu_w_fi;
    s_vec_mu_w_err_fraclen = fraclen + error_mu_w_fraclen;
    s_vec_mu_w_err = s_vec_mu_w_err_fi .* 2^(-s_vec_mu_w_err_fraclen);
    s_vec_mu_w_err_fraclen = fraclen;
    s_vec_mu_w_err_fi = s_vec_mu_w_err .* 2^(s_vec_mu_w_err_fraclen);
    s_vec_mu_w_err_fi = nearest(s_vec_mu_w_err_fi);
    if(overflow_det(s_vec_mu_w_err,fraclen,wrdlen))
        s_vec_mu_w_err
    end

    % Mu shifting after en*sn
%     s_vec_mu_w_err_fi = [1*2^(fraclen), s_vec_fi(1:length(w)-1)] * error_fi;
%     s_vec_mu_w_err_fraclen = fraclen + fraclen;
%     s_vec_mu_w_err = s_vec_mu_w_err_fi .* 2^(-s_vec_mu_w_err_fraclen) .* 2^(nearest(log2(mu_w)));
%     s_vec_mu_w_err_fraclen = fraclen;
%     s_vec_mu_w_err_fi = s_vec_mu_w_err .* 2^(s_vec_mu_w_err_fraclen);
%     s_vec_mu_w_err_fi = nearest(s_vec_mu_w_err_fi);
%     if(overflow_det(s_vec_mu_w_err,fraclen,wrdlen))
%         s_vec_mu_w_err
%     end

    w_upd_fi = w_fi + s_vec_mu_w_err_fi;
    w_upd_fraclen = fraclen;
    w_upd = w_upd_fi * 2^(-w_upd_fraclen);
    w_upd_fraclen = fraclen;
    w_upd_fi = w_upd * 2^(w_upd_fraclen);
    w_upd_fi = nearest(w_upd_fi);
    if(overflow_det(w_upd,fraclen,wrdlen))
        w_upd
    end

%         w = w + mu_w * error * s_vec;