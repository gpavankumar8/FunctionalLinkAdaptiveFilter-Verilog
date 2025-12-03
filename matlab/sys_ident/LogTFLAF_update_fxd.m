% function [w_upd] = LogTFLAF_update_fxd(w, error, log_g_vec, log_g_vec_zero, log_g_vec_sign, log_par, fraclen, wrdlen,  log_lut, antilog_lut)
% 
%     w_fi = w .* 2^(fraclen);
%     w_fi = nearest(w_fi);
% 
%     error_fi = error .* 2^(fraclen);
%     error_fi = nearest(error_fi);
% 
%     log_g_vec_fi = log_g_vec .* 2^(fraclen);
%     log_g_vec_fi = nearest(log_g_vec_fi);
%     
%     mu = log_par.mu;
% %     error_fi
% 
%     log_error = log_lut(abs(error_fi) + 1);
%     log_error_fraclen = fraclen;
%     log_error_fi = log_error * 2^(log_error_fraclen);
%     log_error_fi = nearest(log_error_fi);
%     log_error_fraclen = fraclen;
%     if(overflow_underflow_det(log_error,fraclen,wrdlen))
%         log_error
%     end
%     log_error = log_error_fi * 2^(-log_error_fraclen);
% 
% % log_error_fi
%     % Method 1
% %     log_g_vec_ext_fi = [0, log_g_vec_fi(1:length(w)-1)];
% % 
% %     log_g_vec_mu_err_fi = log_g_vec_ext_fi + repmat(log_error_fi, size(log_g_vec_ext_fi)) + nearest(log2(mu))*2^fraclen;
% %     log_g_vec_mu_err_fraclen = fraclen;
% %     log_g_vec_mu_err = log_g_vec_mu_err_fi .* 2^(-log_g_vec_mu_err_fraclen);
% %     log_g_vec_mu_err_fraclen = fraclen;
% %     log_g_vec_mu_err_fi = log_g_vec_mu_err .* 2^(log_g_vec_mu_err_fraclen);
% %     log_g_vec_mu_err_fi = nearest(log_g_vec_mu_err_fi);
% %     log_g_vec_mu_err = log_g_vec_mu_err_fi .* 2^(-log_g_vec_mu_err_fraclen);
% %     if(overflow_underflow_det(log_g_vec_mu_err,fraclen,wrdlen))
% %         log_g_vec_mu_err
% %     end
% % 
% %     g_vec_mu_err = antilog_lut(log_g_vec_mu_err_fi + 131073);
% % %     g_vec_mu_err = 2.^(log_g_vec_mu_err);
% %     
% %     zero_det = (error_fi == 0) | [0, log_g_vec_zero];
% %     sign_det = sign(error_fi) .* [1, log_g_vec_sign];
% % 
% %     g_vec_mu_err(zero_det) = 0;
% %     g_vec_mu_err(sign_det == -1) = -g_vec_mu_err(sign_det == -1);
% % 
% %     g_vec_mu_err_fraclen = fraclen;
% %     g_vec_mu_err_fi = g_vec_mu_err * 2^(g_vec_mu_err_fraclen);
% %     g_vec_mu_err_fi = nearest(g_vec_mu_err_fi);
% %     g_vec_mu_err_fraclen = fraclen;
% %     g_vec_mu_err = g_vec_mu_err_fi * 2^(-g_vec_mu_err_fraclen);
% %     if(overflow_underflow_det(g_vec_mu_err,fraclen,wrdlen))
% %         g_vec_mu_err
% %     end
% 
%     % Method 2
%     log_g_vec_ext_fi = [0, log_g_vec_fi(1:length(w)-1)];
% 
%     log_g_vec_mu_err_fi = log_g_vec_ext_fi + repmat(log_error_fi, size(log_g_vec_ext_fi));
%     log_g_vec_mu_err_fraclen = fraclen;
%     log_g_vec_mu_err = log_g_vec_mu_err_fi .* 2^(-log_g_vec_mu_err_fraclen);
%     log_g_vec_mu_err_fraclen = fraclen;
%     log_g_vec_mu_err_fi = log_g_vec_mu_err .* 2^(log_g_vec_mu_err_fraclen);
%     log_g_vec_mu_err_fi = nearest(log_g_vec_mu_err_fi);
%     if(overflow_underflow_det(log_g_vec_mu_err,fraclen,wrdlen))
%         log_g_vec_mu_err
%     end
%     log_g_vec_mu_err = log_g_vec_mu_err_fi .* 2^(-log_g_vec_mu_err_fraclen);
% 
% % log_g_vec_mu_err_fi(1:10)
%     g_vec_mu_err = antilog_lut(log_g_vec_mu_err_fi + 131073);
% %     g_vec_mu_err = 2.^(log_g_vec_mu_err);
%     
%     zero_det = (error_fi == 0) | [0, log_g_vec_zero];
%     sign_det = sign(error_fi) .* [1, log_g_vec_sign];
% 
%     g_vec_mu_err(zero_det) = 0;
%     g_vec_mu_err(sign_det == -1) = -g_vec_mu_err(sign_det == -1);
% 
%     g_vec_mu_err_fraclen = fraclen;
%     g_vec_mu_err_fi = g_vec_mu_err * 2^(g_vec_mu_err_fraclen);
%     g_vec_mu_err_fi = sign(g_vec_mu_err_fi).*floor(abs(g_vec_mu_err_fi));
%     g_vec_mu_err_fraclen = fraclen;
%     if(overflow_underflow_det(g_vec_mu_err,fraclen,wrdlen))
%         g_vec_mu_err
%     end
%     g_vec_mu_err = g_vec_mu_err_fi * 2^(-g_vec_mu_err_fraclen);
% % 
% %     log_error_fi
% %     g_vec_mu_err_fi(5:7:40)
%     w_upd_fi = w_fi + g_vec_mu_err_fi.*mu;
%     w_upd_fraclen = fraclen;
%     w_upd = w_upd_fi * 2^(-w_upd_fraclen);
%     w_upd_fraclen = fraclen;
%     w_upd_fi = w_upd * 2^(w_upd_fraclen);
%     w_upd_fi = nearest(w_upd_fi);
%     if(overflow_underflow_det(w_upd,fraclen,wrdlen))
%         w_upd
%     end
%     w_upd = w_upd_fi * 2^(-w_upd_fraclen);
% %     g_vec_mu_err_fi(1:80)
% end



function [w_upd] = LogTFLAF_update_fxd(w, error, log_g_vec, log_g_vec_zero, log_g_vec_sign, log_par, fraclen, wrdlen,  log_lut, antilog_lut)

    mu = log_par.mu;

    w_fi = w .* 2^(fraclen);
    w_fi = nearest(w_fi);

    error_fi = error .* 2^(fraclen)* mu;
    error_fi = nearest(error_fi);

    log_g_vec_fi = log_g_vec .* 2^(fraclen);
    log_g_vec_fi = nearest(log_g_vec_fi);
    
%     error_fi

    log_error = log_lut(abs(error_fi) + 1);
    log_error_fraclen = fraclen;
    log_error_fi = log_error * 2^(log_error_fraclen);
    log_error_fi = nearest(log_error_fi);
    log_error_fraclen = fraclen;
    if(overflow_underflow_det(log_error,fraclen,wrdlen))
        log_error
    end
    log_error = log_error_fi * 2^(-log_error_fraclen);

% log_error_fi
    % Method 1
    log_g_vec_ext_fi = [0, log_g_vec_fi(1:length(w)-1)];

    log_g_vec_mu_err_fi = log_g_vec_ext_fi + repmat(log_error_fi, size(log_g_vec_ext_fi));
    log_g_vec_mu_err_fraclen = fraclen;
    log_g_vec_mu_err = log_g_vec_mu_err_fi .* 2^(-log_g_vec_mu_err_fraclen);
    log_g_vec_mu_err_fraclen = fraclen;
    log_g_vec_mu_err_fi = log_g_vec_mu_err .* 2^(log_g_vec_mu_err_fraclen);
    log_g_vec_mu_err_fi = nearest(log_g_vec_mu_err_fi);
    log_g_vec_mu_err = log_g_vec_mu_err_fi .* 2^(-log_g_vec_mu_err_fraclen);
    if(overflow_underflow_det(log_g_vec_mu_err,fraclen,wrdlen))
        log_g_vec_mu_err
    end

    log_g_vec_mu_err_fi(log_g_vec_mu_err_fi<-131072) = -131072;
    g_vec_mu_err = antilog_lut(log_g_vec_mu_err_fi + 131073);
%     g_vec_mu_err(abs(log_g_vec_mu_err_fi)>131072) = 0;
%     g_vec_mu_err = 2.^(log_g_vec_mu_err);
    
    zero_det = (error_fi == 0) | [0, log_g_vec_zero];
    sign_det = sign(error_fi) .* [1, log_g_vec_sign];

    g_vec_mu_err(zero_det) = 0;
    g_vec_mu_err(sign_det == -1) = -g_vec_mu_err(sign_det == -1);

    g_vec_mu_err_fraclen = fraclen;
    g_vec_mu_err_fi = g_vec_mu_err * 2^(g_vec_mu_err_fraclen);
    g_vec_mu_err_fi = nearest(g_vec_mu_err_fi);
    g_vec_mu_err_fraclen = fraclen;
    g_vec_mu_err = g_vec_mu_err_fi * 2^(-g_vec_mu_err_fraclen);
    if(overflow_underflow_det(g_vec_mu_err,fraclen,wrdlen))
        g_vec_mu_err
    end

    % Method 2
%     log_g_vec_ext_fi = [0, log_g_vec_fi(1:length(w)-1)];
% 
%     log_g_vec_mu_err_fi = log_g_vec_ext_fi + repmat(log_error_fi, size(log_g_vec_ext_fi)) + repmat(nearest(log2(mu))*2^fraclen, size(log_g_vec_ext_fi));
%     log_g_vec_mu_err_fraclen = fraclen;
%     log_g_vec_mu_err = log_g_vec_mu_err_fi .* 2^(-log_g_vec_mu_err_fraclen);
%     log_g_vec_mu_err_fraclen = fraclen;
%     log_g_vec_mu_err_fi = log_g_vec_mu_err .* 2^(log_g_vec_mu_err_fraclen);
%     log_g_vec_mu_err_fi = nearest(log_g_vec_mu_err_fi);
%     if(overflow_underflow_det(log_g_vec_mu_err,fraclen,wrdlen))
%         log_g_vec_mu_err
%     end
%     log_g_vec_mu_err = log_g_vec_mu_err_fi .* 2^(-log_g_vec_mu_err_fraclen);
% 
%     log_g_vec_mu_err_fi(log_g_vec_mu_err_fi<-131072) = 0;
%     g_vec_mu_err = antilog_lut(log_g_vec_mu_err_fi + 131073);
%     g_vec_mu_err(log_g_vec_mu_err_fi<-131072) = 0;
% %     g_vec_mu_err = 2.^(log_g_vec_mu_err);
%     
%     zero_det = (error_fi == 0) | [0, log_g_vec_zero];
%     sign_det = sign(error_fi) .* [1, log_g_vec_sign];
% 
%     g_vec_mu_err(zero_det) = 0;
%     g_vec_mu_err(sign_det == -1) = -g_vec_mu_err(sign_det == -1);
% 
%     g_vec_mu_err_fraclen = fraclen;
%     g_vec_mu_err_fi = g_vec_mu_err * 2^(g_vec_mu_err_fraclen);
%     g_vec_mu_err_fi = sign(g_vec_mu_err_fi).*floor(abs(g_vec_mu_err_fi));
%     g_vec_mu_err_fraclen = fraclen;
%     if(overflow_underflow_det(g_vec_mu_err,fraclen,wrdlen))
%         g_vec_mu_err
%     end
%     g_vec_mu_err = g_vec_mu_err_fi * 2^(-g_vec_mu_err_fraclen);
% 
%     log_error_fi
%     g_vec_mu_err_fi(5:7:40)
    w_upd_fi = w_fi + g_vec_mu_err_fi ;
    w_upd_fraclen = fraclen;
    w_upd = w_upd_fi * 2^(-w_upd_fraclen);
    w_upd_fraclen = fraclen;
    w_upd_fi = w_upd * 2^(w_upd_fraclen);
    w_upd_fi = nearest(w_upd_fi);
    if(overflow_underflow_det(w_upd,fraclen,wrdlen))
        w_upd
    end
    w_upd = w_upd_fi * 2^(-w_upd_fraclen);
%     g_vec_mu_err_fi(1:80)
end
