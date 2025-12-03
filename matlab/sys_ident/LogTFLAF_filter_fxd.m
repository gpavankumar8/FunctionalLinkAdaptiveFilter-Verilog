function [error, log_g_vec, log_g_vec_sign, log_g_vec_zero] = LogTFLAF_filter_fxd(x, d, w, log_g_vec, log_g_vec_zero, log_g_vec_sign, par, fraclen, lut_fraclen, wrdlen, logsin16, logcos16,  log_lut, antilog_lut, log_acc_lut)

    x_fi = x .* 2^(fraclen);
    x_fi = nearest(x_fi);
    x = x_fi .* 2^(-fraclen);
    if(overflow_underflow_det(x,fraclen,wrdlen))
        x
    end

    d_fi = d .* 2^(fraclen);
    d_fi = nearest(d_fi);
    if(overflow_underflow_det(d,fraclen,wrdlen))
        d
    end
    
    w_fi = w .* 2^(fraclen);
    w_fi = nearest(w_fi);
    if(overflow_underflow_det(w,fraclen,wrdlen))
        w
    end

    log_g_vec_fi = log_g_vec .* 2^(fraclen);
    log_g_vec_fi = nearest(log_g_vec_fi);
    if(overflow_underflow_det(log_g_vec,fraclen,wrdlen))
        log_g_vec
    end

    Q_t = par.Q_t;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% log2(cos/sin) LUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [log_g_val, log_g_val_zero, log_g_val_sign] = log_lut_phi(x, Q_t, fraclen, lut_fraclen, logsin16, logcos16, log_acc_lut);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sin/cos LUT + Mitchell log
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     log_fraclen = 12;
% 
%     g_val = lut_phi(x, Q_t, lut_fraclen, logsin16, logcos16);
%     g_val_fi = g_val .* 2^(log_fraclen);
%     g_val_fi = nearest(g_val_fi);
%     if(overflow_det(g_val(2:end),log_fraclen,wrdlen))
%         g_val
%     end
% 
%     log_g_val        = zeros(1,length(g_val));
%     log_g_val(2:end) = log_acc_lut(abs(g_val_fi(2:end)) + 1);
%     log_g_val(1)     = log_lut(abs(x_fi(1)) + 1);
%     log_g_val_sign = sign(g_val_fi);
%     log_g_val_zero = (g_val_fi == 0);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    log_g_val_fi = log_g_val .* 2^(fraclen);
    log_g_val_fi = nearest(log_g_val_fi);
    if(overflow_underflow_det(log_g_val,fraclen,wrdlen))
        log_g_val
    end

    log_g_vec_fi = [log_g_val_fi, log_g_vec_fi(1:end-Q_t)];
    log_g_vec = log_g_vec_fi .* 2^(-fraclen);
    log_g_vec_sign = [log_g_val_sign, log_g_vec_sign(1:end-Q_t)];
    log_g_vec_zero = [log_g_val_zero, log_g_vec_zero(1:end-Q_t)];

    log_w = log_lut(abs(w_fi) + 1);
    log_w_fraclen = fraclen;
    log_w_fi = log_w .* 2^(log_w_fraclen);
    log_w_fi = nearest(log_w_fi);
    log_w_fraclen = fraclen;
    if(overflow_underflow_det(log_w,fraclen,wrdlen))
        log_w
    end
    log_w = log_w_fi .* 2^-log_w_fraclen;


    log_y_fi = log_w_fi + [0, log_g_vec_fi(1:length(w)-1)];
    log_y_fraclen = fraclen;
    log_y = log_y_fi * 2^(-log_y_fraclen);
    log_y_fraclen = fraclen;
    log_y_fi = log_y * 2^(log_y_fraclen);
    log_y_fi = nearest(log_y_fi);
    if(overflow_underflow_det(log_y,fraclen,wrdlen))
        log_y
    end
% log_y_fi(1:50)
    y_terms = antilog_lut(log_y_fi + 131073);
%     y_terms = 2.^(log_y);
    
    zero_det = (w_fi == 0) | [0, log_g_vec_zero(1:length(w)-1)];
    sign_det = sign(w_fi) .* [1, log_g_vec_sign(1:length(w)-1)];

    y_terms(zero_det) = 0;
    y_terms(sign_det == -1) = -y_terms(sign_det == -1);

    y_terms_fraclen = fraclen;
    y_terms_fi = y_terms * 2^(y_terms_fraclen);
    y_terms_fi = sign(y_terms_fi).*floor(abs(y_terms_fi));
    y_terms_fraclen = fraclen;
    if(overflow_underflow_det(y_terms,fraclen,wrdlen))
        y_terms
    end
    y_terms = y_terms_fi * 2^(-y_terms_fraclen);

    y_fi = sum(y_terms_fi);        
    y_fraclen = fraclen;
    y = y_fi * 2^(-y_fraclen);
    if(overflow_underflow_det(y,fraclen,wrdlen))
        y
    end

    error_fi = d_fi - y_fi;
    error_fraclen = fraclen;
    error = error_fi * 2^(-error_fraclen);
    error_fraclen = fraclen;
    error_fi = error * 2^(error_fraclen);
    error_fi = nearest(error_fi);
    if(overflow_underflow_det(error,fraclen,wrdlen))
        error
    end
%     log_w_fi(2:7:60) .*(w_fi(2:7:60)~=0)
%     log_g_vec_fi(1:7:60).*(~log_g_vec_zero(1:7:60))
%     y_terms_fi(2:7:60)
%     log_w_fi(1) .*(w_fi(1)~=0)
%     y_terms_fi(1)
%     error_fi
%     w_fi(1:80)
%     error_fi
end
    
    