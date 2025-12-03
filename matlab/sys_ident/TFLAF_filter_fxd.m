function [error, g_vec] = TFLAF_filter_fxd(x, d, w, g_vec, par, fraclen, lut_fraclen, wrdlen, sin16, cos16)

    x_fi = x .* 2^(fraclen);
    x_fi = nearest(x_fi);
    x = x_fi .* 2^(-fraclen);
    if(overflow_det(x,fraclen,wrdlen))
        x
    end

    d_fi = d .* 2^(fraclen);
    d_fi = nearest(d_fi);
    if(overflow_det(d,fraclen,wrdlen))
        d
    end
    
    w_fi = w .* 2^(fraclen);
    w_fi = nearest(w_fi);
    if(overflow_det(w,fraclen,wrdlen))
        w
    end

    g_vec_fi = g_vec .* 2^(fraclen);
    g_vec_fi = nearest(g_vec_fi);
    if(overflow_det(g_vec,fraclen,wrdlen))
        g_vec
    end

    Q_t = par.Q_t;

    g_val = zeros(1,Q_t);

%     for j = 0:Q_t-1
% 
%         p = ceil(j/2);
% 
%         switch(p)
%             case 0
%                 p_pi_fi = 0;
%             case 1
%                 p_pi_fi = 12868;
%             case 2
%                 p_pi_fi = 25735;
%             case 3
%                 p_pi_fi = 38604;
%         end
% 
%         p_fi = p * 2^(fraclen);
%         p_pi_fi = p_fi * pi;
%         p_pi_fi = nearest(p_pi_fi);
% %         if(overflow_det(p,fraclen,wrdlen))
% %             p
% %         end
% 
%         p_pi_x_fi = p_pi_fi * x_fi;
%         p_pi_x_fi_fraclen = fraclen + fraclen;
%         p_pi_x = p_pi_x_fi * 2^(-p_pi_x_fi_fraclen);
%         p_pi_x_fi_fraclen = fraclen;
%         p_pi_x_fi = p_pi_x * 2^(12);
%         p_pi_x_fi = nearest(p_pi_x_fi);
%         p_pi_x = p_pi_x_fi * 2^(-12);
% %         if(overflow_det(p_pi_x,fraclen,wrdlen))
% %             p_pi_x
% %             x
% %         end
% 
% %         sin16 = load('/home/user/pavan/phd/work/matlab/data/error_plot_nonl/sin_val.mat');
% %         cos16 = load('/home/user/pavan/phd/work/matlab/data/error_plot_nonl/cos_val.mat');
% 
%         if (j==0)
%             g_val(j+1) = x;
%         elseif( mod(j,2) == 1 )
% %             g_val(j+1) = sin(p*pi*x);
% %             g_val(j+1) = sin(p_pi_x);
% %             g_val(j+1) = sine_taylor16(p_pi_x);
%             g_val(j+1) = sin16.sin16(51001+p_pi_x_fi);
%         elseif( mod(j,2) == 0 )
% %             g_val(j+1) = cos(p*pi*x);
% %             g_val(j+1) = cos(p_pi_x);
% %             g_val(j+1) = cosine_taylor16(p_pi_x);
%             g_val(j+1) = cos16.cos16(51001+p_pi_x_fi);
%         end
% 
%     end

    
    g_val = lut_phi(x, Q_t, lut_fraclen, sin16, cos16);

    g_val_fi = g_val .* 2^(fraclen);
    g_val_fi = nearest(g_val_fi);
    if(overflow_det(g_val,fraclen,wrdlen))
        g_val
    end

    g_vec_fi = [g_val_fi, g_vec_fi(1:end-Q_t)];
    g_vec = g_vec_fi .* 2^(-fraclen);

    y_terms_fi = w_fi .* [1*2^(fraclen), g_vec_fi(1:length(w)-1)];
    y_terms_fraclen = fraclen + fraclen;
    y_terms = y_terms_fi * 2^(-y_terms_fraclen);
    y_terms_fraclen = fraclen;
    y_terms_fi = y_terms * 2^(y_terms_fraclen);
    y_terms_fi = nearest(y_terms_fi);
    if(overflow_det(y_terms,fraclen,wrdlen))
        y_terms
    end

    y_fi = sum(y_terms_fi);
    y_fraclen = fraclen;
    y = y_fi * 2^(-y_fraclen);
    y_fraclen = fraclen;
    y_fi = y * 2^(y_fraclen);
    if(overflow_underflow_det(y,fraclen,wrdlen))
        y
    end
    y_fi = nearest(y_fi);

    error_fi = d_fi - y_fi;
    error_fraclen = fraclen;
    error = error_fi * 2^(-error_fraclen);
    error_fraclen = fraclen;
    error_fi = error * 2^(error_fraclen);
    error_fi = nearest(error_fi);
    if(overflow_det(error,fraclen,wrdlen))
        error
    end

% function [error, g_vec] = TFLAF_filter_fxd(x, d, w, g_vec, par, fraclen, wrdlen, sin16, cos16)
% 
%     w_fraclen = fraclen;
%     w_wrdlen  = wrdlen;
% 
%     x_fi = x .* 2^(fraclen);
%     x_fi = nearest(x_fi);
%     x = x_fi .* 2^(-fraclen);
%     if(overflow_det(x,fraclen,wrdlen))
%         x
%     end
% 
%     d_fi = d .* 2^(fraclen);
%     d_fi = nearest(d_fi);
%     if(overflow_det(d,fraclen,wrdlen))
%         d
%     end
%     
%     w_fi = w .* 2^(w_fraclen);
%     w_fi = nearest(w_fi);
%     if(overflow_det(w,w_fraclen,w_wrdlen))
%         w
%     end
% 
%     g_vec_fi = g_vec .* 2^(fraclen);
%     g_vec_fi = nearest(g_vec_fi);
%     if(overflow_det(g_vec,fraclen,wrdlen))
%         g_vec
%     end
% 
%     Q_t = par.Q_t;
% 
%     g_val = zeros(1,Q_t);
% 
%     for j = 0:Q_t-1
% 
%         p = ceil(j/2);
% 
% %         switch(p)
% %             case 0
% %                 p_pi_fi = 0;
% %             case 1
% %                 p_pi_fi = 12868;
% %             case 2
% %                 p_pi_fi = 25735;
% %             case 3
% %                 p_pi_fi = 38604;
% %         end
% 
%         p_fi = p * 2^(fraclen);
%         p_pi_fi = p_fi * pi;
%         p_pi_fi = nearest(p_pi_fi);
%         if(overflow_det(p,fraclen,wrdlen))
%             p
%         end
% 
%         p_pi_x_fi = p_pi_fi * x_fi;
%         p_pi_x_fi_fraclen = fraclen + fraclen;
%         p_pi_x = p_pi_x_fi * 2^(-p_pi_x_fi_fraclen);
%         p_pi_x_fi_fraclen = fraclen;
%         p_pi_x_fi = p_pi_x * 2^(12);
%         p_pi_x_fi = nearest(p_pi_x_fi);
%         p_pi_x = p_pi_x_fi * 2^(-12);
% %         if(overflow_det(p_pi_x,fraclen,wrdlen))
% %             p_pi_x
% %             x
% %         end
% 
% %         sin16 = load('/home/user/pavan/phd/work/matlab/data/error_plot_nonl/sin_val.mat');
% %         cos16 = load('/home/user/pavan/phd/work/matlab/data/error_plot_nonl/cos_val.mat');
% 
%         if (j==0)
%             g_val(j+1) = x;
%         elseif( mod(j,2) == 1 )
%             g_val(j+1) = sin(p_pi_x);
% %             g_val(j+1) = sine_taylor16(p_pi_x);
% %             g_val(j+1) = sin16.sin16(51001+p_pi_x_fi);
%         elseif( mod(j,2) == 0 )
%             g_val(j+1) = cos(p_pi_x);
% %             g_val(j+1) = cosine_taylor16(p_pi_x);
% %             g_val(j+1) = cos16.cos16(51001+p_pi_x_fi);
%         end
% 
%     end
% 
%     g_val_fi = g_val .* 2^(fraclen);
%     g_val_fi = nearest(g_val_fi);
%     if(overflow_det(g_val,fraclen,wrdlen))
%         g_val
%     end
% 
%     g_vec_fi = [g_val_fi, g_vec_fi(1:end-Q_t)];
%     g_vec = g_vec_fi .* 2^(-fraclen);
% 
%     
%     y_fi = w_fi * [1*2^(fraclen), g_vec_fi(1:length(w)-1)]';
%     y_fraclen = w_fraclen + fraclen;
%     y = y_fi * 2^(-y_fraclen);
%     y_fraclen = fraclen;
%     y_fi = y * 2^(y_fraclen);
%     y_fi = nearest(y_fi);
%     y = y_fi * 2^(-y_fraclen);
%     if(overflow_det(y,fraclen,wrdlen))
%         y
%     end
% 
%     error_fi = d_fi - y_fi;
%     error_fraclen = fraclen;
%     error = error_fi * 2^(-error_fraclen);
%     error_fraclen = fraclen;
%     error_fi = error * 2^(error_fraclen);
%     error_fi = nearest(error_fi);
%     error = error_fi * 2^(-error_fraclen);
%     if(overflow_det(error,fraclen,wrdlen))
%         error
%     end
    