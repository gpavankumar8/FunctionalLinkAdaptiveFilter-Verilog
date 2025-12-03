function [w_upd, a_upd] = LogRCTFLAF_update_fxd(w, a, log_s_vec, log_s_vec_sign, log_s_vec_zero, log_g_vec, log_g_vec_sign, log_g_vec_zero, error, par, fraclen, wrdlen, log_lut, antilog_lut, log_acc_lut, log_fraclen)

    log_wrdlen = 17;

    mu_w = par.mu_w;
    mu_a = par.mu_a;
    Q = par.Q;

    w_fi = w .* 2^(fraclen);
    w_fi = nearest(w_fi);

    a_fi = a .* 2^(fraclen);
    a_fi = nearest(a_fi);

    error_fi = error .* 2^(log_fraclen);
    error_fi = nearest(error_fi);

    error_mu_w_fi = error .* 2^(log_fraclen) * mu_w;
    error_mu_w_fi = nearest(error_mu_w_fi);

    error_mu_a_fi = error .* 2^(log_fraclen) * mu_a;
    error_mu_a_fi = nearest(error_mu_a_fi);

    log_s_vec_fi = log_s_vec .* 2^(fraclen);
    log_s_vec_fi = nearest(log_s_vec_fi);

    log_g_vec_fi = log_g_vec .* 2^(fraclen);
    log_g_vec_fi = nearest(log_g_vec_fi);

    log_error = log_acc_lut(abs(error_fi) + 1);
%     log_error = log2(abs(error)); 
    log_error_fraclen = fraclen;
    log_error_fi = log_error * 2^(log_error_fraclen);
    log_error_fi = nearest(log_error_fi);
    log_error_fraclen = fraclen;
    log_error = log_error_fi * 2^(-log_error_fraclen);
    if(overflow_det(log_error,fraclen,log_wrdlen))
        log_error
    end
    
    log_error_mu_w = log_acc_lut(abs(error_mu_w_fi) + 1);
%     log_error = log2(abs(error)); 
    log_error_mu_w_fraclen = fraclen;
    log_error_mu_w_fi = log_error_mu_w * 2^(log_error_mu_w_fraclen);
    log_error_mu_w_fi = nearest(log_error_mu_w_fi);
    log_error_mu_w_fraclen = fraclen;
    log_error_mu_w = log_error_mu_w_fi * 2^(-log_error_mu_w_fraclen);
    if(overflow_det(log_error_mu_w,fraclen,log_wrdlen))
        log_error
    end


    log_error_mu_a = log_acc_lut(abs(error_mu_a_fi) + 1);
%     log_error = log2(abs(error)); 
    log_error_mu_a_fraclen = fraclen;
    log_error_mu_a_fi = log_error_mu_a * 2^(log_error_mu_a_fraclen);
    log_error_mu_a_fi = nearest(log_error_mu_a_fi);
    log_error_mu_a_fraclen = fraclen;
    log_error_mu_a = log_error_mu_a_fi * 2^(-log_error_mu_a_fraclen);
    if(overflow_det(log_error_mu_a,fraclen,log_wrdlen))
        log_error
    end

    log_error = log_acc_lut(abs(error_fi) + 1);
%     log_error = log2(abs(error)); 
    log_error_fraclen = fraclen;
    log_error_fi = log_error * 2^(log_error_fraclen);
    log_error_fi = nearest(log_error_fi);
    log_error_fraclen = fraclen;
    log_error = log_error_fi * 2^(-log_error_fraclen);
    if(overflow_det(log_error,fraclen,log_wrdlen))
        log_error
    end

    log_w = log_lut(abs(w_fi) + 1);
    log_w_fraclen = fraclen;
    log_w_fi = log_w .* 2^(log_w_fraclen);
    log_w_fi = sign(log_w_fi).*floor(abs(log_w_fi));
    log_w_fraclen = fraclen;
    log_w = log_w_fi .* 2^-log_w_fraclen;
    if(overflow_det(log_w,fraclen,log_wrdlen))
        log_w
    end

    log_w_sign = sign(w_fi);
    log_w_zero = (w_fi == 0);

    % A update

    % Method 1

%     log_w_mu_error_fi = log_w_fi(2:end) + repmat(log_error_fi, size(log_w_fi(2:end))) + nearest(log2(mu_a))*2^fraclen;
%     log_w_mu_error_fraclen = fraclen;
%     log_w_mu_error = log_w_mu_error_fi .* 2^(-log_w_mu_error_fraclen);
%     if(overflow_det(log_w_mu_error,fraclen,wrdlen))
%         log_w_mu_error
%     end
% 
%     log_w_mu_err_zero_det = (error_fi == 0) | log_w_zero(2:end);
%     log_w_mu_err_sign_det = sign(error_fi) .* log_w_sign(2:end);
% 
% % 
% %     w_mu_err = antilog_lut(log_w_mu_error_fi + 131073);
% % %     g_vec_mu_err = 2.^(log_g_vec_mu_err);
% %     
% %     zero_det = (error_fi == 0) | log_w_zero;
% %     sign_det = sign(error_fi) .* log_w_sign;
% % 
% %     w_mu_err(zero_det) = 0;
% %     w_mu_err(sign_det == -1) = -w_mu_err(sign_det == -1);
% % 
% %     w_mu_err_fraclen = fraclen;
% %     w_mu_err_fi = w_mu_err * 2^(w_mu_err_fraclen);
% %     w_mu_err_fi = nearest(w_mu_err_fi);
% %     w_mu_err_fraclen = fraclen;
% %     w_mu_err = w_mu_err_fi * 2^(-w_mu_err_fraclen);
% %     if(overflow_det(w_mu_err,fraclen,wrdlen))
% %         w_mu_err
% %     end
% 
%     log_w_mu_error_g_vec_fi = log_w_mu_error_fi' + log_g_vec_fi;
%     log_w_mu_error_g_vec_fraclen = fraclen;
%     log_w_mu_error_g_vec = log_w_mu_error_g_vec_fi * 2^(-log_w_mu_error_g_vec_fraclen);
%     log_w_mu_error_g_vec_fraclen = fraclen;
%     log_w_mu_error_g_vec_fi = log_w_mu_error_g_vec * 2^(log_w_mu_error_g_vec_fraclen);
%     log_w_mu_error_g_vec_fi = nearest(log_w_mu_error_g_vec_fi);
%     if(overflow_underflow_det(log_w_mu_error_g_vec,fraclen,wrdlen))
%         log_w_mu_error_g_vec
%     end
% 
%     log_w_mu_error_g_vec_fi(log_w_mu_error_g_vec_fi < -32*2^12) = -32*2^12;
%     a_terms = antilog_lut(log_w_mu_error_g_vec_fi + 131073);
% %     y_terms = 2.^(log_y);
%     
%     zero_det = log_w_mu_err_zero_det' | log_g_vec_zero;
%     sign_det = log_w_mu_err_sign_det' .* log_g_vec_sign;
% 
%     a_terms(zero_det) = 0;
%     a_terms(sign_det == -1) = -a_terms(sign_det == -1);
% 
%     a_terms_fraclen = fraclen;
%     a_terms_fi = a_terms * 2^(a_terms_fraclen);
%     a_terms_fi = nearest(a_terms_fi);
%     a_terms_fraclen = fraclen;
%     a_terms = a_terms_fi * 2^(-a_terms_fraclen);
%     if(overflow_det(a_terms,fraclen,wrdlen))
%         a_terms
%     end
% 
%     w_g_vec_mu_a_err_fi = sum(a_terms_fi);        
%     w_g_vec_mu_a_err_fraclen = fraclen;
%     w_g_vec_mu_a_err = w_g_vec_mu_a_err_fi * 2^(-w_g_vec_mu_a_err_fraclen);
%     if(overflow_det(w_g_vec_mu_a_err,fraclen,wrdlen))
%         w_g_vec_mu_a_err
%     end

    % Method 2 

%     log_w_error_fi = log_w_fi(2:end) + repmat(log_error_fi, size(log_w_fi(2:end)));
%     log_w_error_fraclen = fraclen;
%     log_w_error = log_w_error_fi .* 2^(-log_w_error_fraclen);
%     log_w_error_fraclen = fraclen;
%     log_w_error_fi = log_w_error .* 2^(log_w_error_fraclen);
%     log_w_error_fi(log_w_error_fi < -16*2^12) = -16*2^12;
%     log_w_error_fraclen = fraclen;
%     log_w_error = log_w_error_fi * 2^(-log_w_error_fraclen);
%     if(overflow_det(log_w_error,fraclen,log_wrdlen))
%         log_w_error
%     end
% 
%     log_w_err_zero_det = (error_fi == 0) | log_w_zero(2:end);
%     log_w_err_sign_det = sign(error_fi) .* log_w_sign(2:end);
% 
% 
%     log_w_error_g_vec_fi = log_w_error_fi' + log_g_vec_fi;
%     log_w_error_g_vec_fraclen = fraclen;
%     log_w_error_g_vec = log_w_error_g_vec_fi * 2^(-log_w_error_g_vec_fraclen);
%     log_w_error_g_vec_fraclen = fraclen;
%     log_w_error_g_vec_fi = log_w_error_g_vec * 2^(log_w_error_g_vec_fraclen);
%     log_w_error_g_vec_fi = nearest(log_w_error_g_vec_fi);
%     log_w_error_g_vec_fi(log_w_error_g_vec_fi < -16*2^12) = -16*2^12;
%     log_w_error_g_vec_fraclen = fraclen;
%     log_w_error_g_vec = log_w_error_g_vec_fi * 2^(-log_w_error_g_vec_fraclen);
%     if(overflow_underflow_det(log_w_error_g_vec,fraclen,log_wrdlen))
%         log_w_error_g_vec
%     end
% 
% %     log_w_error_g_vec_fi(log_w_error_g_vec_fi < -32*2^12) = -32*2^12;
%     a_terms = antilog_lut(log_w_error_g_vec_fi + 131073);
% %     y_terms = 2.^(log_y);
%     
%     zero_det = log_w_err_zero_det' | log_g_vec_zero;
%     sign_det = log_w_err_sign_det' .* log_g_vec_sign;
% 
%     a_terms(zero_det) = 0;
%     a_terms(sign_det == -1) = -a_terms(sign_det == -1);
% 
%     a_terms_fraclen = fraclen;
%     a_terms_fi = a_terms * 2^(a_terms_fraclen);
%     a_terms_fi = sign(a_terms_fi).*floor(abs(a_terms_fi));
%     a_terms_fraclen = fraclen;
%     a_terms = a_terms_fi * 2^(-a_terms_fraclen);
%     if(overflow_det(a_terms,fraclen,wrdlen))
%         a_terms
%     end
% 
%     w_g_vec_mu_a_err_fi = sum(a_terms_fi).*mu_a;        
%     w_g_vec_mu_a_err_fraclen = fraclen;
%     w_g_vec_mu_a_err = w_g_vec_mu_a_err_fi * 2^(-w_g_vec_mu_a_err_fraclen);
%     if(overflow_det(w_g_vec_mu_a_err,fraclen,wrdlen))
%         w_g_vec_mu_a_err
%     end


    % Method 3

%     log_w_g_vec_fi = log_w_fi(2:end)' + log_g_vec_fi;
%     log_w_g_vec_fraclen = fraclen;
%     log_w_g_vec = log_w_g_vec_fi * 2^(-log_w_g_vec_fraclen);
%     log_w_g_vec_fraclen = fraclen;
%     log_w_g_vec_fi = log_w_g_vec * 2^(log_w_g_vec_fraclen);
%     log_w_g_vec_fi = nearest(log_w_g_vec_fi);
%     if(overflow_underflow_det(log_w_g_vec,fraclen,wrdlen))
%         log_w_g_vec
%     end
% 
% %     log_w_g_vec_fi(log_w_g_vec_fi < -32*2^12) = -32*2^12;
%     w_g_vec_terms = antilog_lut(log_w_g_vec_fi + 131073);
% %     w_g_vec_terms = 2.^(w_g_vec_terms);
%     
%     zero_det = log_w_zero(2:end)' | log_g_vec_zero;
%     sign_det = log_w_sign(2:end)' .* log_g_vec_sign;
% 
%     w_g_vec_terms(zero_det) = 0;
%     w_g_vec_terms(sign_det == -1) = -w_g_vec_terms(sign_det == -1);
% 
%     w_g_vec_terms_fraclen = fraclen;
%     w_g_vec_terms_fi = w_g_vec_terms * 2^(w_g_vec_terms_fraclen);
%     w_g_vec_terms_fi = nearest(w_g_vec_terms_fi);
%     w_g_vec_terms_fraclen = fraclen;
%     w_g_vec_terms = w_g_vec_terms_fi * 2^(-w_g_vec_terms_fraclen);
%     if(overflow_det(w_g_vec_terms,fraclen,wrdlen))
%         w_g_vec_terms
%     end
% 
%     w_g_vec_fi = sum(w_g_vec_terms_fi);        
%     w_g_vec_fraclen = fraclen;
%     w_g_vec = w_g_vec_fi * 2^(-w_g_vec_fraclen);
%     if(overflow_det(w_g_vec,fraclen,wrdlen))
%         w_g_vec
%     end
% 
%     log_w_g_vec = log_lut(abs(w_g_vec_fi) + 1);
%     log_w_g_vec_fraclen = fraclen;
%     log_w_g_vec_fi = log_w_g_vec * 2^(log_w_g_vec_fraclen);
%     log_w_g_vec_fi = nearest(log_w_g_vec_fi);
%     log_w_g_vec_fraclen = fraclen;
%     log_w_g_vec = log_w_g_vec_fi * 2^(-log_w_g_vec_fraclen);
%     if(overflow_det(log_w_g_vec,fraclen,wrdlen))
%         log_w_g_vec
%     end
% 
%     log_w_g_vec_mu_error_fi = log_w_g_vec_fi + repmat(log_error_fi, size(log_w_g_vec)) + nearest(log2(mu_a))*2^fraclen;
%     log_w_g_vec_mu_error_fraclen = fraclen;
%     log_w_g_vec_mu_error = log_w_g_vec_mu_error_fi .* 2^(-log_w_g_vec_mu_error_fraclen);
%     if(overflow_det(log_w_g_vec_mu_error,fraclen,wrdlen))
%         log_w_g_vec_mu_error
%     end
% 
%     w_g_vec_mu_a_err = antilog_lut(log_w_g_vec_mu_error_fi + 131073);
% 
%     zero_det = (error_fi == 0)  | (w_g_vec == 0);
%     sign_det = sign(error_fi)  .* sign(w_g_vec);
% 
%     w_g_vec_mu_a_err(zero_det) = 0;
%     w_g_vec_mu_a_err(sign_det == -1) = -w_g_vec_mu_a_err(sign_det == -1);
% 
%     w_g_vec_mu_a_err_fraclen = fraclen;
%     w_g_vec_mu_a_err_fi = w_g_vec_mu_a_err * 2^(w_g_vec_mu_a_err_fraclen);
%     w_g_vec_mu_a_err_fi = nearest(w_g_vec_mu_a_err_fi);
%     w_g_vec_mu_a_err_fraclen = fraclen;
%     w_g_vec_mu_a_err = w_g_vec_mu_a_err_fi * 2^(-w_g_vec_mu_a_err_fraclen);
%     if(overflow_det(w_g_vec_mu_a_err,fraclen,wrdlen))
%         w_g_vec_mu_a_err
%     end

    % Method 4

    log_w_g_vec_fi = log_w_fi(2:end)' + log_g_vec_fi;
    log_w_g_vec_fraclen = fraclen;
    log_w_g_vec = log_w_g_vec_fi * 2^(-log_w_g_vec_fraclen);
    log_w_g_vec_fraclen = fraclen;
    log_w_g_vec_fi = log_w_g_vec * 2^(log_w_g_vec_fraclen);
    log_w_g_vec_fi = sign(log_w_g_vec_fi).*floor(abs(log_w_g_vec_fi));
    if(overflow_underflow_det(log_w_g_vec,fraclen,log_wrdlen))
        log_w_g_vec
    end

    log_w_g_vec_fi(log_w_g_vec_fi < -32*2^12) = -32*2^12;
    w_g_vec_terms = antilog_lut(log_w_g_vec_fi + 131073);
%     w_g_vec_terms = 2.^(w_g_vec_terms);
    
    zero_det = log_w_zero(2:end)' | log_g_vec_zero;
    sign_det = log_w_sign(2:end)' .* log_g_vec_sign;

    w_g_vec_terms(zero_det) = 0;
    w_g_vec_terms(sign_det == -1) = -w_g_vec_terms(sign_det == -1);

    w_g_vec_terms_fraclen = fraclen;
    w_g_vec_terms_fi = w_g_vec_terms * 2^(w_g_vec_terms_fraclen);
    w_g_vec_terms_fi = sign(w_g_vec_terms_fi).*nearest(abs(w_g_vec_terms_fi));
    w_g_vec_terms_fraclen = fraclen;
    w_g_vec_terms = w_g_vec_terms_fi * 2^(-w_g_vec_terms_fraclen);
    if(overflow_det(w_g_vec_terms,fraclen,wrdlen))
        w_g_vec_terms
    end

    w_g_vec_fi = sum(w_g_vec_terms_fi);        
    w_g_vec_fraclen = fraclen;
    w_g_vec = w_g_vec_fi * 2^(-w_g_vec_fraclen);
    if(overflow_det(w_g_vec,fraclen,wrdlen))
        w_g_vec
    end

    log_w_g_vec = log_lut(abs(w_g_vec_fi) + 1);
%     log_w_g_vec = log2(abs(w_g_vec));
    log_w_g_vec_fraclen = fraclen;
    log_w_g_vec_fi = log_w_g_vec * 2^(log_w_g_vec_fraclen);
    log_w_g_vec_fi = sign(log_w_g_vec_fi).*floor(abs(log_w_g_vec_fi));
    log_w_g_vec_fraclen = fraclen;
    log_w_g_vec = log_w_g_vec_fi * 2^(-log_w_g_vec_fraclen);
    if(overflow_det(log_w_g_vec,fraclen,log_wrdlen))
        log_w_g_vec
    end

    %   MU Shifting after antilog

%     log_w_g_vec_mu_error_fi = log_w_g_vec_fi + repmat(log_error_fi, size(log_w_g_vec));
%     log_w_g_vec_mu_error_fraclen = fraclen;
%     log_w_g_vec_mu_error = log_w_g_vec_mu_error_fi .* 2^(-log_w_g_vec_mu_error_fraclen);
%     log_w_g_vec_mu_error_fraclen = fraclen;
%     log_w_g_vec_mu_error_fi = log_w_g_vec_mu_error .* 2^(log_w_g_vec_mu_error_fraclen);
%     log_w_g_vec_mu_error_fi(log_w_g_vec_mu_error_fi < -32*2^12) = -32*2^12;
%     log_w_g_vec_mu_error_fraclen = fraclen;
%     log_w_g_vec_mu_error = log_w_g_vec_mu_error_fi * 2^(-log_w_g_vec_mu_error_fraclen);
% %     if(overflow_det(log_w_g_vec_mu_error,fraclen,log_wrdlen))
% %         log_w_g_vec_mu_error
% %     end
% 
%     log_w_g_vec_mu_error_fi(log_w_g_vec_mu_error_fi==-Inf) = 0;    
%     w_g_vec_mu_a_err = antilog_lut(log_w_g_vec_mu_error_fi + 131073);
% 
%     zero_det = (error_fi == 0)  | (w_g_vec == 0);
%     sign_det = sign(error_fi)  .* sign(w_g_vec);
% 
%     w_g_vec_mu_a_err(zero_det) = 0;
%     w_g_vec_mu_a_err(sign_det == -1) = -w_g_vec_mu_a_err(sign_det == -1);
% 
%     w_g_vec_mu_a_err_fraclen = fraclen;
%     w_g_vec_mu_a_err_fi = w_g_vec_mu_a_err * 2^(w_g_vec_mu_a_err_fraclen);
%     w_g_vec_mu_a_err_fi = nearest(sign(w_g_vec_mu_a_err_fi).*floor(abs(w_g_vec_mu_a_err_fi)).*mu_a);
%     w_g_vec_mu_a_err_fraclen = fraclen;
%     w_g_vec_mu_a_err = w_g_vec_mu_a_err_fi * 2^(-w_g_vec_mu_a_err_fraclen);
%     if(overflow_det(w_g_vec_mu_a_err,fraclen,wrdlen))
%         w_g_vec_mu_a_err
%     end


%   MU Shifting before antilog
%     log_w_g_vec_mu_error_fi = log_w_g_vec_fi + repmat(log_error_fi, size(log_w_g_vec)) + repmat(nearest(log2(mu_a))*2^fraclen, size(log_w_g_vec));
%     log_w_g_vec_mu_error_fraclen = fraclen;
%     log_w_g_vec_mu_error = log_w_g_vec_mu_error_fi .* 2^(-log_w_g_vec_mu_error_fraclen);
%     log_w_g_vec_mu_error_fraclen = fraclen;
%     log_w_g_vec_mu_error_fi = log_w_g_vec_mu_error .* 2^(log_w_g_vec_mu_error_fraclen);
%     log_w_g_vec_mu_error_fi(log_w_g_vec_mu_error_fi < -32*2^12) = -32*2^12;
%     log_w_g_vec_mu_error_fraclen = fraclen;
%     log_w_g_vec_mu_error = log_w_g_vec_mu_error_fi * 2^(-log_w_g_vec_mu_error_fraclen);
% %     if(overflow_det(log_w_g_vec_mu_error,fraclen,log_wrdlen))
% %         log_w_g_vec_mu_error
% %     end
% 
%     log_w_g_vec_mu_error_fi(log_w_g_vec_mu_error_fi==-Inf) = 0;    
%     w_g_vec_mu_a_err = antilog_lut(log_w_g_vec_mu_error_fi + 131073);
% 
%     zero_det = (error_fi == 0)  | (w_g_vec == 0);
%     sign_det = sign(error_fi)  .* sign(w_g_vec);
% 
%     w_g_vec_mu_a_err(zero_det) = 0;
%     w_g_vec_mu_a_err(sign_det == -1) = -w_g_vec_mu_a_err(sign_det == -1);
% 
%     w_g_vec_mu_a_err_fraclen = fraclen;
%     w_g_vec_mu_a_err_fi = w_g_vec_mu_a_err * 2^(w_g_vec_mu_a_err_fraclen);
%     w_g_vec_mu_a_err_fi = nearest(sign(w_g_vec_mu_a_err_fi).*floor(abs(w_g_vec_mu_a_err_fi)));
%     w_g_vec_mu_a_err_fraclen = fraclen;
%     w_g_vec_mu_a_err = w_g_vec_mu_a_err_fi * 2^(-w_g_vec_mu_a_err_fraclen);
%     if(overflow_det(w_g_vec_mu_a_err,fraclen,wrdlen))
%         w_g_vec_mu_a_err
%     end

    %   MU Shifting before log

    log_w_g_vec_mu_error_fi = log_w_g_vec_fi + repmat(log_error_mu_a_fi, size(log_w_g_vec));
    log_w_g_vec_mu_error_fraclen = fraclen;
    log_w_g_vec_mu_error = log_w_g_vec_mu_error_fi .* 2^(-log_w_g_vec_mu_error_fraclen);
    log_w_g_vec_mu_error_fraclen = fraclen;
    log_w_g_vec_mu_error_fi = log_w_g_vec_mu_error .* 2^(log_w_g_vec_mu_error_fraclen);
    log_w_g_vec_mu_error_fi(log_w_g_vec_mu_error_fi < -32*2^12) = -32*2^12;
    log_w_g_vec_mu_error_fraclen = fraclen;
    log_w_g_vec_mu_error = log_w_g_vec_mu_error_fi * 2^(-log_w_g_vec_mu_error_fraclen);
%     if(overflow_det(log_w_g_vec_mu_error,fraclen,log_wrdlen))
%         log_w_g_vec_mu_error
%     end

    log_w_g_vec_mu_error_fi(log_w_g_vec_mu_error_fi==-Inf) = 0;    
    w_g_vec_mu_a_err = antilog_lut(log_w_g_vec_mu_error_fi + 131073);

    zero_det = (error_mu_a_fi == 0)  | (w_g_vec == 0);
    sign_det = sign(error_mu_a_fi)  .* sign(w_g_vec);

    w_g_vec_mu_a_err(zero_det) = 0;
    w_g_vec_mu_a_err(sign_det == -1) = -w_g_vec_mu_a_err(sign_det == -1);

    w_g_vec_mu_a_err_fraclen = fraclen;
    w_g_vec_mu_a_err_fi = w_g_vec_mu_a_err * 2^(w_g_vec_mu_a_err_fraclen);
    w_g_vec_mu_a_err_fi = nearest(sign(w_g_vec_mu_a_err_fi).*floor(abs(w_g_vec_mu_a_err_fi)));
    w_g_vec_mu_a_err_fraclen = fraclen;
    w_g_vec_mu_a_err = w_g_vec_mu_a_err_fi * 2^(-w_g_vec_mu_a_err_fraclen);
    if(overflow_det(w_g_vec_mu_a_err,fraclen,wrdlen))
        w_g_vec_mu_a_err
    end

    % Final 'a(n+1)' update

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

    % Method 1

%     log_s_vec_ext_fi = [1*2^fraclen, log_s_vec_fi(1:length(w)-1)];
% 
%     log_s_vec_mu_err_fi = log_s_vec_ext_fi + repmat(log_error_fi, size(log_s_vec_ext_fi)) + repmat(nearest(log2(mu_w))*2^fraclen, size(log_s_vec_ext_fi));
%     log_s_vec_mu_err_fraclen = fraclen;
%     log_s_vec_mu_err = log_s_vec_mu_err_fi .* 2^(-log_s_vec_mu_err_fraclen);
%     log_s_vec_mu_err_fraclen = fraclen;
%     log_s_vec_mu_err_fi = log_s_vec_mu_err .* 2^(log_s_vec_mu_err_fraclen);
%     log_s_vec_mu_err_fi = nearest(log_s_vec_mu_err_fi);
%     log_s_vec_mu_err_fi(log_s_vec_mu_err_fi < -16*2^12) = -16*2^12;
%     log_s_vec_mu_err = log_s_vec_mu_err_fi .* 2^(-log_s_vec_mu_err_fraclen);
%     if(overflow_det(log_s_vec_mu_err,fraclen,wrdlen+1))
%         log_s_vec_mu_err
%     end
% 
%     log_s_vec_mu_err_fi(log_s_vec_mu_err_fi==-Inf) = 0;
%     s_vec_mu_err = antilog_lut(log_s_vec_mu_err_fi + 131073);
% %     g_vec_mu_err = 2.^(log_g_vec_mu_err);
%     
%     zero_det = (error_fi == 0) | [0, log_s_vec_zero];
%     sign_det = sign(error_fi) .* [1, log_s_vec_sign];
% 
%     s_vec_mu_err(zero_det) = 0;
%     s_vec_mu_err(sign_det == -1) = -s_vec_mu_err(sign_det == -1);
% 
%     s_vec_mu_err_fraclen = fraclen;
%     s_vec_mu_err_fi = s_vec_mu_err * 2^(s_vec_mu_err_fraclen);
%     s_vec_mu_err_fi = sign(s_vec_mu_err_fi).*floor(abs(s_vec_mu_err_fi));
%     s_vec_mu_err_fraclen = fraclen;
%     s_vec_mu_err = s_vec_mu_err_fi * 2^(-s_vec_mu_err_fraclen);
%     if(overflow_det(s_vec_mu_err,fraclen,wrdlen))
%         s_vec_mu_err
%     end
% 
%     w_upd_fi = w_fi + s_vec_mu_err_fi;
%     w_upd_fraclen = fraclen;
%     w_upd = w_upd_fi * 2^(-w_upd_fraclen);
%     w_upd_fraclen = fraclen;
%     w_upd_fi = w_upd * 2^(w_upd_fraclen);
%     w_upd_fi = nearest(w_upd_fi);
%     if(overflow_det(w_upd,fraclen,wrdlen))
%         w_upd
%     end

    % Method 2
     
    log_s_vec_ext_fi = [1*2^fraclen, log_s_vec_fi(1:length(w)-1)];
    log_s_vec_mu_err_fi = log_s_vec_ext_fi + repmat(log_error_fi, size(log_s_vec_ext_fi));
    log_s_vec_mu_err_fraclen = fraclen;
    log_s_vec_mu_err = log_s_vec_mu_err_fi .* 2^(-log_s_vec_mu_err_fraclen);
    log_s_vec_mu_err_fraclen = fraclen;
    log_s_vec_mu_err_fi = log_s_vec_mu_err .* 2^(log_s_vec_mu_err_fraclen);
    log_s_vec_mu_err_fi = nearest(log_s_vec_mu_err_fi);
    log_s_vec_mu_err_fi(log_s_vec_mu_err_fi < -32*2^12) = -32*2^12;
    log_s_vec_mu_err = log_s_vec_mu_err_fi .* 2^(-log_s_vec_mu_err_fraclen);
%     if(overflow_det(log_s_vec_mu_err,fraclen,log_wrdlen))
%         log_s_vec_mu_err
%     end

    log_s_vec_mu_err_fi(log_s_vec_mu_err_fi==-Inf) = 0;
    s_vec_mu_err = antilog_lut(log_s_vec_mu_err_fi + 131073);
%     g_vec_mu_err = 2.^(log_g_vec_mu_err);
    
    zero_det = (error_fi == 0) | [0, log_s_vec_zero];
    sign_det = sign(error_fi) .* [1, log_s_vec_sign];

    s_vec_mu_err(zero_det) = 0;
    s_vec_mu_err(sign_det == -1) = -s_vec_mu_err(sign_det == -1);

    s_vec_mu_err_fraclen = fraclen;
    s_vec_mu_err_fi = s_vec_mu_err * 2^(s_vec_mu_err_fraclen);
    s_vec_mu_err_fi = sign(s_vec_mu_err_fi).*floor(abs(s_vec_mu_err_fi));
    s_vec_mu_err_fraclen = fraclen;
    s_vec_mu_err = s_vec_mu_err_fi * 2^(-s_vec_mu_err_fraclen);
    if(overflow_det(s_vec_mu_err,fraclen,wrdlen))
        s_vec_mu_err
    end

    w_upd_fi = w_fi + s_vec_mu_err_fi.*mu_w;
    w_upd_fraclen = fraclen;
    w_upd = w_upd_fi * 2^(-w_upd_fraclen);
    w_upd_fraclen = fraclen;
    w_upd_fi = w_upd * 2^(w_upd_fraclen);
    w_upd_fi = nearest(w_upd_fi);
    if(overflow_det(w_upd,fraclen,wrdlen))
        w_upd
    end

 % Method 3 (mu before log_error)
     
%     log_s_vec_ext_fi = [1*2^fraclen, log_s_vec_fi(1:length(w)-1)];
%     log_s_vec_mu_err_fi = log_s_vec_ext_fi + repmat(log_error_mu_w_fi, size(log_s_vec_ext_fi));
%     log_s_vec_mu_err_fraclen = fraclen;
%     log_s_vec_mu_err = log_s_vec_mu_err_fi .* 2^(-log_s_vec_mu_err_fraclen);
%     log_s_vec_mu_err_fraclen = fraclen;
%     log_s_vec_mu_err_fi = log_s_vec_mu_err .* 2^(log_s_vec_mu_err_fraclen);
%     log_s_vec_mu_err_fi = nearest(log_s_vec_mu_err_fi);
%     log_s_vec_mu_err_fi(log_s_vec_mu_err_fi < -32*2^12) = -32*2^12;
%     log_s_vec_mu_err = log_s_vec_mu_err_fi .* 2^(-log_s_vec_mu_err_fraclen);
% %     if(overflow_det(log_s_vec_mu_err,fraclen,log_wrdlen))
% %         log_s_vec_mu_err
% %     end
% 
%     log_s_vec_mu_err_fi(log_s_vec_mu_err_fi==-Inf) = 0;
%     s_vec_mu_err = antilog_lut(log_s_vec_mu_err_fi + 131073);
% %     g_vec_mu_err = 2.^(log_g_vec_mu_err);
%     
%     zero_det = (error_mu_w_fi == 0) | [0, log_s_vec_zero];
%     sign_det = sign(error_mu_w_fi) .* [1, log_s_vec_sign];
% 
%     s_vec_mu_err(zero_det) = 0;
%     s_vec_mu_err(sign_det == -1) = -s_vec_mu_err(sign_det == -1);
% 
%     s_vec_mu_err_fraclen = fraclen;
%     s_vec_mu_err_fi = s_vec_mu_err * 2^(s_vec_mu_err_fraclen);
%     s_vec_mu_err_fi = sign(s_vec_mu_err_fi).*floor(abs(s_vec_mu_err_fi));
%     s_vec_mu_err_fraclen = fraclen;
%     s_vec_mu_err = s_vec_mu_err_fi * 2^(-s_vec_mu_err_fraclen);
%     if(overflow_det(s_vec_mu_err,fraclen,wrdlen))
%         s_vec_mu_err
%     end
% 
%     w_upd_fi = w_fi + s_vec_mu_err_fi;
%     w_upd_fraclen = fraclen;
%     w_upd = w_upd_fi * 2^(-w_upd_fraclen);
%     w_upd_fraclen = fraclen;
%     w_upd_fi = w_upd * 2^(w_upd_fraclen);
%     w_upd_fi = nearest(w_upd_fi);
%     if(overflow_det(w_upd,fraclen,wrdlen))
%         w_upd
%     end

%     a_upd_fi(1:5)
%     % log_g_vec_fi(1:10,:)
%     disp(strcat('1',lower(dec2hex(log_error_fi,4))))

end
