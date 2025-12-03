function [g_val, log_g_val_zero, log_g_val_sign] = log_lut_phi(x, Q, log_fraclen, lut_fraclen, logsin16, logcos16, log_lut)

    g_val = zeros(1,Q);
    log_g_val_zero = zeros(1,Q);
    log_g_val_sign = ones(1,Q);

    x_log_fi = x .* 2^(log_fraclen);
    x_log_fi = nearest(x_log_fi);
    
    x_fi = x .* 2^(lut_fraclen);
    x_fi = nearest(x_fi);
    x_lut    = x_fi * 2^(-lut_fraclen);


    for j = 0:Q-1

        p = ceil(j/2);

        sign_x = sign(x_lut);
        x_abs = abs(p*x_lut);
    
        if ( x_abs > 2)
            x_abs = x_abs - 2;
        end
        
        if( x_abs > 0.5 && x_abs <= 1 )
            x_map = 1 - x_abs;
            sin_sign = sign_x;
            cos_sign = -1;
    
        elseif( x_abs > 1 && x_abs <= 1.5 )
            x_map = x_abs - 1;
            sin_sign = -sign_x;
            cos_sign = -1;
    
        elseif( x_abs > 1.5 && x_abs <= 2 )
            x_map = 2 - x_abs;
            sin_sign = -sign_x;
            cos_sign = 1;
        else
            x_map = x_abs;
            sin_sign = sign_x;
            cos_sign = 1;
        end
    
        % Type 3 (log_trig LUT sin & cos + identity)
    
        x_map_fi = x_map .* 2^(lut_fraclen);
        x_map_fi = nearest(x_map_fi);

        if (j==0)
            g_val(j+1) = log_lut(abs(x_log_fi) + 1);
%             g_val(j+1) = log2(abs(x_log_fi.*2^(-log_fraclen)));
            log_g_val_zero(j+1) = (x_log_fi == 0);
            log_g_val_sign(j+1) = sign(x_log_fi);

        elseif( mod(j,2) == 1 )
            g_val(j+1) = logsin16(x_map_fi + 1);
            if( x_map == 0 )
                log_g_val_zero(j+1) = 1;
            end
            log_g_val_sign(j+1) = sin_sign;

        elseif( mod(j,2) == 0 )
            g_val(j+1) = logcos16(x_map_fi + 1);
            if( x_map == 0.5 )
                log_g_val_zero(j+1) = 1;
            end
            log_g_val_sign(j+1) = cos_sign;

        end

   end