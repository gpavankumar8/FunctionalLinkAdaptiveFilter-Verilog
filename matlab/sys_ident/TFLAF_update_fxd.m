function [w_upd] = TFLAF_update_fxd(w, error, g_vec, par, fraclen, wrdlen)

    w_fi = w .* 2^(fraclen);
    w_fi = nearest(w_fi);

    error_fi = error .* 2^(fraclen);
    error_fi = nearest(error_fi);

    g_vec_fi = g_vec .* 2^(fraclen);
    g_vec_fi = nearest(g_vec_fi);
    
    mu = par.mu;

    error_mu_fi = 2^(nearest(log2(mu))) * error_fi;
    error_mu_fraclen = fraclen;
    error_mu = error_mu_fi * 2^(-error_mu_fraclen);
    error_mu_fraclen = fraclen;
    error_mu_fi = error_mu * 2^(error_mu_fraclen);
    error_mu_fi = nearest(error_mu_fi);
    error_mu = error_mu_fi * 2^(-error_mu_fraclen);
    if(overflow_det(error_mu,fraclen,wrdlen))
        error_mu
    end

    g_vec_mu_err_fi = [1*2^(fraclen), g_vec_fi(1:length(w)-1)] * error_mu_fi;
    g_vec_mu_err_fraclen = fraclen + error_mu_fraclen;
    g_vec_mu_err = g_vec_mu_err_fi .* 2^(-g_vec_mu_err_fraclen);
    g_vec_mu_err_fraclen = fraclen;
    g_vec_mu_err_fi = g_vec_mu_err .* 2^(g_vec_mu_err_fraclen);
    g_vec_mu_err_fi = nearest(g_vec_mu_err_fi);
    g_vec_mu_err = g_vec_mu_err_fi .* 2^(-g_vec_mu_err_fraclen);
    if(overflow_det(g_vec_mu_err,fraclen,wrdlen))
        g_vec_mu_err
    end
%     disp("Iter");
%     g_vec_mu_err_fi(1:10)

%     g_vec_mu_err_fi = [1*2^(fraclen), g_vec_fi(1:length(w)-1)] * error_fi;
%     g_vec_mu_err_fraclen = fraclen + fraclen;
%     g_vec_mu_err = g_vec_mu_err_fi .* 2^(-g_vec_mu_err_fraclen) .* 2^(nearest(log2(mu)));
%     g_vec_mu_err_fraclen = fraclen;
%     g_vec_mu_err_fi = g_vec_mu_err .* 2^(g_vec_mu_err_fraclen);
%     g_vec_mu_err_fi = nearest(g_vec_mu_err_fi);
%     g_vec_mu_err = g_vec_mu_err_fi .* 2^(-g_vec_mu_err_fraclen);
%     if(overflow_det(g_vec_mu_err,fraclen,wrdlen))
%         g_vec_mu_err
%     end

%     g_vec_mu_err_fi(1:10)

    w_upd_fi = w_fi + g_vec_mu_err_fi;
    w_upd_fraclen = fraclen;
    w_upd = w_upd_fi * 2^(-w_upd_fraclen);
    w_upd_fraclen = fraclen;
    w_upd_fi = w_upd * 2^(w_upd_fraclen);
    w_upd_fi = nearest(w_upd_fi);
    w_upd = w_upd_fi * 2^(-w_upd_fraclen);
    if(overflow_det(w_upd,fraclen,wrdlen))
        w_upd
    end


% function [w_upd, g_vec_mu_err] = TFLAF_update_fxd(w, error, g_vec, par, fraclen, wrdlen)
% 
%     w_fraclen = 2*fraclen;
%     w_wrdlen  = 2*wrdlen;
% 
%     w_fi = w .* 2^(w_fraclen);
%     w_fi = nearest(w_fi);
% 
%     error_fi = error .* 2^(fraclen);
%     error_fi = nearest(error_fi);
% 
%     g_vec_fi = g_vec .* 2^(fraclen);
%     g_vec_fi = nearest(g_vec_fi);
%     
%     mu = par.mu;
% 
% %     error_mu_fi = 2^(nearest(log2(mu))) * error_fi;
% %     error_mu_fraclen = fraclen;
% %     error_mu = error_mu_fi * 2^(-error_mu_fraclen);
% %     error_mu_fraclen = fraclen;
% %     error_mu_fi = error_mu * 2^(error_mu_fraclen);
% %     error_mu_fi = nearest(error_mu_fi);
% %     if(overflow_det(error_mu,fraclen,wrdlen))
% %         error_mu
% %     end
% 
% %     g_vec_mu_err_fi = [1*2^(fraclen), g_vec_fi(1:length(w)-1)] * error_mu_fi;
% %     g_vec_mu_err_fraclen = fraclen + error_mu_fraclen;
% %     g_vec_mu_err = g_vec_mu_err_fi .* 2^(-g_vec_mu_err_fraclen);
% %     g_vec_mu_err_fraclen = fraclen;
% %     g_vec_mu_err_fi = g_vec_mu_err .* 2^(g_vec_mu_err_fraclen);
% %     g_vec_mu_err_fi = nearest(g_vec_mu_err_fi);
% %     if(overflow_det(g_vec_mu_err,fraclen,wrdlen))
% %         g_vec_mu_err
% %     end
% 
%     g_vec_mu_err_fi = [1*2^(fraclen), g_vec_fi(1:length(w)-1)] * error_fi;
%     g_vec_mu_err_fraclen = fraclen + fraclen - (nearest(log2(mu)));
%     g_vec_mu_err = g_vec_mu_err_fi .* 2^(-g_vec_mu_err_fraclen);
% %     tmp = g_vec_mu_err;
%     g_vec_mu_err_fraclen = w_fraclen;
%     g_vec_mu_err_fi = g_vec_mu_err .* 2^(g_vec_mu_err_fraclen);
%     g_vec_mu_err_fi = nearest(g_vec_mu_err_fi);
%     g_vec_mu_err = g_vec_mu_err_fi .* 2^(-g_vec_mu_err_fraclen);
% %     max(abs(tmp - g_vec_mu_err))
%     if(overflow_det(g_vec_mu_err,w_fraclen,w_wrdlen))
%         g_vec_mu_err
%     end
% 
%     w_upd_fi = w_fi + g_vec_mu_err_fi;
%     w_upd_fraclen = w_fraclen;
%     w_upd = w_upd_fi * 2^(-w_upd_fraclen);
%     w_upd_fraclen = w_fraclen;
%     w_upd_fi = w_upd * 2^(w_upd_fraclen);
%     w_upd_fi = nearest(w_upd_fi);
%     w_upd = w_upd_fi * 2^(-w_upd_fraclen);
%     if(overflow_det(w_upd,w_fraclen,w_wrdlen))
%         w_upd
%     end