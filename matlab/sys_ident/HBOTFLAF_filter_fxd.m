function [error, s_vec, g_vec] = HBOTFLAF_filter_fxd(x, d, w, a, s_vec, g_vec, par, fraclen, wrdlen, sin16, cos16, lut_fraclen)
% 
%     lut_fraclen = 5;
% 
    x_fi = x .* 2^(fraclen);
    x_fi = nearest(x_fi);
    x = x_fi .* 2^(-fraclen);

    d_fi = d .* 2^(fraclen);
    d_fi = nearest(d_fi);

    w_fi = w .* 2^(fraclen);
    w_fi = nearest(w_fi);

    a_fi = a .* 2^(fraclen);
    a_fi = nearest(a_fi);

    s_vec_fi = s_vec .* 2^(fraclen);
    s_vec_fi = nearest(s_vec_fi);

    g_vec_fi = g_vec .* 2^(fraclen);
    g_vec_fi = nearest(g_vec_fi);

    Q = par.Q;

    g_val = zeros(1,Q);


%     for j = 0:Q-1
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
% 
%         p_pi_x_fi = p_pi_fi * x_fi;
%         p_pi_x_fi_fraclen = fraclen + fraclen;
%         p_pi_x = p_pi_x_fi * 2^(-p_pi_x_fi_fraclen);
%         p_pi_x_fi_fraclen = fraclen;
%         p_pi_x_fi = p_pi_x * 2^(12);
%         p_pi_x_fi = nearest(p_pi_x_fi);
%         p_pi_x = p_pi_x_fi * 2^(-12);
%         
% %         ang = p*pi*x;
% %         ang_fi = ang.*2^(fraclen);
% %         ang_fi = nearest(ang_fi);
% %         ang = ang_fi.*2^(-fraclen);
% 
% %         sin16 = load('/home/user/pavan/phd/work/matlab/data/error_plot_nonl/sin_val.mat');
% %         cos16 = load('/home/user/pavan/phd/work/matlab/data/error_plot_nonl/cos_val.mat');
% % 
% %         sin16 = rtl_bin2dec_err('/home/user/pavan/projects/adaptfilt/ASIC/TFLAF/simulation/outputs/cos_theta_out.txt',15,16);
% %         cos16 = rtl_bin2dec_err('/home/user/pavan/projects/adaptfilt/ASIC/TFLAF/simulation/outputs/sin_theta_out.txt',15,16);
% 
%         if (j==0)
%             g_val(j+1) = x;
%         elseif( mod(j,2) == 0 )
% %             g_val(j+1) = sin(p*pi*x);
% %             g_val(j+1) = sine_taylor16(p_pi_x);
%             g_val(j+1) = sin16.sin16(51001+p_pi_x_fi);
% %             g_val(j+1) = sin_sign * sin16(p*x_fi + 1);
%         elseif( mod(j,2) == 1 )
% %             g_val(j+1) = cos(p*pi*x);
% %             g_val(j+1) = cosine_taylor16(p_pi_x);
%             g_val(j+1) = cos16.cos16(51001+p_pi_x_fi);
% % x_fi
% %             g_val(j+1) = cos_sign * cos16(p*x_fi + 1);
%         end
% 
%    end

%     g_val = log_trig_feb_fxd(x, fraclen, lut_fraclen, sin16, cos16, antilog_lut);

    g_val = lut_phi(x, Q, lut_fraclen, sin16, cos16);

    g_val_fi = g_val .* 2^(fraclen);
    if(overflow_underflow_det(g_val,fraclen,wrdlen))
        g_val
    end
    g_val_fi = nearest(g_val_fi);


    a_g_val_fi = a_fi .* g_val_fi;
    a_g_val_fraclen = fraclen + fraclen;
    a_g_val = a_g_val_fi * 2^(-a_g_val_fraclen);
    a_g_val_fraclen = fraclen;
    a_g_val_fi = a_g_val * 2^(a_g_val_fraclen);
    if(overflow_underflow_det(a_g_val,fraclen,wrdlen))
        s_vec
    end    
    a_g_val_fi = nearest(a_g_val_fi);


    s_fi = sum(a_g_val_fi);
    s_fraclen = fraclen;
    s = s_fi * 2^(-s_fraclen);
    s_fraclen = fraclen;
    s_fi = s * 2^(s_fraclen);
    if(overflow_underflow_det(s,fraclen,wrdlen))
        s
    end
    s_fi = nearest(s_fi);
    
    s_vec_fi = [s_fi, s_vec_fi(1:end-1)];
    s_vec = s_vec_fi .* 2^(-fraclen);
    if(overflow_underflow_det(s_vec,fraclen,wrdlen))
        s_vec
    end
    
    g_vec_fi = [g_val_fi; g_vec_fi(1:end-1,:)];
    g_vec = g_vec_fi .* 2^(-fraclen);

    w_s_vec_fi = w_fi .* [1*2^(fraclen),s_vec_fi(1:length(w)-1)];
    w_s_vec_fraclen = fraclen + fraclen;
    w_s_vec = w_s_vec_fi * 2^(-w_s_vec_fraclen);
    w_s_vec_fraclen = fraclen;
    w_s_vec_fi = w_s_vec * 2^(w_s_vec_fraclen);
    w_s_vec_fi = nearest(w_s_vec_fi);
    if(overflow_underflow_det(w_s_vec,fraclen,wrdlen))
        w_s_vec
    end

    y_fi = sum(w_s_vec_fi);
    y_fraclen = fraclen;
    y = y_fi * 2^(-y_fraclen);
    y_fraclen = fraclen;
    y_fi = y * 2^(y_fraclen);
    if(overflow_underflow_det(y,fraclen,wrdlen))
        y
    end
    y_fi = nearest(y_fi);


%         y = w * s_vec';

    error_fi = d_fi - y_fi;
    error_fraclen = fraclen;
    error = error_fi * 2^(-error_fraclen);
    error_fraclen = fraclen;
    error_fi = error * 2^(error_fraclen);
    if(overflow_underflow_det(error,fraclen,wrdlen))
        error
    end
    error_fi = nearest(error_fi);

      
        