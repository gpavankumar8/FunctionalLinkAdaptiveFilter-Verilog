function [error, log_s_vec, log_s_vec_sign, log_s_vec_zero, log_g_vec, log_g_vec_sign, log_g_vec_zero] = LogHBOTFLAF_filter_fxd(x, d, w, a, log_s_vec, log_s_vec_sign, log_s_vec_zero, log_g_vec, log_g_vec_sign, log_g_vec_zero, par, fraclen, wrdlen, logsin16, logcos16, antilog_lut, log_lut, lut_fraclen, log_acc_lut, log_fraclen)
% 
%     lut_fraclen = 5;
% 
    log_wrdlen = 17;

    x_fi = x .* 2^(fraclen);
    x_fi = nearest(x_fi);
    x = x_fi .* 2^(-fraclen);

    d_fi = d .* 2^(fraclen);
    d_fi = nearest(d_fi);

    w_fi = w .* 2^(fraclen);
    w_fi = nearest(w_fi);

    a_fi = a.* 2^(fraclen);
    a_fi = nearest(a_fi);

    log_s_vec_fi = log_s_vec .* 2^(fraclen);
    log_s_vec_fi = nearest(log_s_vec_fi);

    log_g_vec_fi = log_g_vec .* 2^(fraclen);
    log_g_vec_fi = nearest(log_g_vec_fi);

    Q = par.Q;

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% log2(cos/sin) LUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [log_g_val, log_g_val_zero, log_g_val_sign] = log_lut_phi(x, Q, log_fraclen, lut_fraclen, logsin16, logcos16, log_acc_lut);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sin/cos LUT + Mitchell log
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     log_fraclen = 12;
% 
%     g_val = lut_phi(x, Q, lut_fraclen, logsin16, logcos16);
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
    log_g_val_fi = sign(log_g_val_fi).*floor(abs(log_g_val_fi));
    if(overflow_underflow_det(log_g_val,fraclen,log_wrdlen))
        log_g_val
    end
    log_g_val_fi = nearest(log_g_val_fi);

    log_g_vec_fi = [log_g_val_fi; log_g_vec_fi(1:end-1,:)];
    log_g_vec = log_g_vec_fi .* 2^(-fraclen);
    log_g_vec_sign = [log_g_val_sign; log_g_vec_sign(1:end-1,:)];
    log_g_vec_zero = [log_g_val_zero; log_g_vec_zero(1:end-1,:)];

    log_a = log_lut(abs(a_fi) + 1);
    log_a_fraclen = fraclen;
    log_a_fi = log_a .* 2^(log_a_fraclen);
    log_a_fi = sign(log_a_fi).*floor(abs(log_a_fi));
    log_a_fraclen = fraclen;
    log_a = log_a_fi .* 2^-log_a_fraclen;
    if(overflow_det(log_a,fraclen,log_wrdlen))
        log_a
    end

    log_a_g_val_fi = log_a_fi + log_g_val_fi;
    log_a_g_val_fraclen = fraclen;
    log_a_g_val = log_a_g_val_fi * 2^(-log_a_g_val_fraclen);
    log_a_g_val_fraclen = fraclen;
    log_a_g_val_fi = log_a_g_val * 2^(log_a_g_val_fraclen);
    if(overflow_underflow_det(log_a_g_val,fraclen,log_wrdlen))
        log_s_vec
    end    
    log_a_g_val_fi = nearest(log_a_g_val_fi);

    log_a_g_val_fi(log_a_g_val_fi==-Inf) = 0;
    a_g_val = antilog_lut(log_a_g_val_fi + 131073);

    zero_det = (a_fi == 0) | log_g_val_zero;
    sign_det = sign(a_fi) .* log_g_val_sign;

    a_g_val(zero_det) = 0;
    a_g_val(sign_det == -1) = -a_g_val(sign_det == -1);

    a_g_val_fraclen = fraclen;
    a_g_val_fi = a_g_val * 2^(a_g_val_fraclen);
    a_g_val_fi = sign(a_g_val_fi).*floor(abs(a_g_val_fi));
    a_g_val_fraclen = fraclen;
    a_g_val = a_g_val_fi * 2^(-a_g_val_fraclen);
    if(overflow_det(a_g_val,fraclen,wrdlen))
        a_g_val
    end

    s_fi = sum(a_g_val_fi);        
    s_fraclen = fraclen;
    s = s_fi * 2^(-s_fraclen);
    if(overflow_det(s,fraclen,wrdlen))
        s
    end
    
    log_s = log_lut(abs(s_fi) + 1);
    log_s_fraclen = fraclen;
    log_s_fi = log_s .* 2^(log_s_fraclen);
    log_s_fi = sign(log_s_fi).*floor(abs(log_s_fi));
    log_s_fraclen = fraclen;
    log_s = log_s_fi .* 2^-log_s_fraclen;
    if(overflow_det(log_s,fraclen,log_wrdlen))
        log_s
    end

    log_s_sign = sign(s_fi);
    log_s_zero = (s_fi == 0);

    log_s_vec_fi = [log_s_fi, log_s_vec_fi(1:end-1)];
    log_s_vec = log_s_vec_fi .* 2^(-fraclen);
    if(overflow_underflow_det(log_s_vec,fraclen,log_wrdlen))
        log_s_vec
    end
    
    log_s_vec_sign = [log_s_sign, log_s_vec_sign(1:end-1)];
    log_s_vec_zero = [log_s_zero, log_s_vec_zero(1:end-1)];

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

    log_w_s_vec_fi = log_w_fi + [1*2^fraclen, log_s_vec_fi(1:length(w)-1)];
    log_w_s_vec_fraclen = fraclen;
    log_w_s_vec = log_w_s_vec_fi * 2^(-log_w_s_vec_fraclen);
    log_w_s_vec_fraclen = fraclen;
    log_w_s_vec_fi = log_w_s_vec * 2^(log_w_s_vec_fraclen);
    log_w_s_vec_fi = nearest(log_w_s_vec_fi);
    if(overflow_underflow_det(log_w_s_vec,fraclen,log_wrdlen))
        log_w_s_vec
    end

    a_terms = antilog_lut(log_w_s_vec_fi + 131073);
%     y_terms = 2.^(log_y);
    
    zero_det = log_w_zero | [0, log_s_vec_zero(1:length(w)-1)];
    sign_det = log_w_sign .* [1, log_s_vec_sign(1:length(w)-1)];

    a_terms(zero_det) = 0;
    a_terms(sign_det == -1) = -a_terms(sign_det == -1);

    a_terms_fraclen = fraclen;
    a_terms_fi = a_terms * 2^(a_terms_fraclen);
    a_terms_fi = sign(a_terms_fi).*floor(abs(a_terms_fi));
    a_terms_fraclen = fraclen;
    a_terms = a_terms_fi * 2^(-a_terms_fraclen);
    if(overflow_det(a_terms,fraclen,wrdlen))
        a_terms
    end

    y_fi = sum(a_terms_fi);        
    y_fraclen = fraclen;
    y = y_fi * 2^(-y_fraclen);
    if(overflow_det(y,fraclen,wrdlen))
        y
    end

    error_fi = d_fi - y_fi;
    error_fraclen = fraclen;
    error = error_fi * 2^(-error_fraclen);
    error_fraclen = fraclen;
    error_fi = error * 2^(error_fraclen);
    if(overflow_underflow_det(error,fraclen,wrdlen))
        error
    end
    error_fi = nearest(error_fi);
%     dec2hex(error_fi,4)
%     s_fi
%     log_s_fi
%     y_fi
%     log_w_fi(108)
%     log_s_vec_fi(1:10)
%     disp(lower(dec2hex(error_fi,4)))
end
      
        