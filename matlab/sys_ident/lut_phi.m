function [g_val] = lut_phi(x, Q, lut_fraclen, sin16, cos16)

    g_val = zeros(1,Q);

    x_fi = x .* 2^(lut_fraclen);
    x_fi = nearest(x_fi);
    x_trunc = x_fi * 2^(-lut_fraclen);

    for j = 0:Q-1

        p = ceil(j/2);

        sign_x = sign(x_trunc);
        x_abs = abs(p*x_trunc);
    
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
    
        x_fi = x_map .* 2^(lut_fraclen);
        x_fi = nearest(x_fi);
        
        if (j==0)
            g_val(j+1) = x;
        elseif( mod(j,2) == 0 )
            g_val(j+1) = sin_sign * sin16(x_fi + 1);
        elseif( mod(j,2) == 1 )
            g_val(j+1) = cos_sign * cos16(x_fi + 1);
        end

   end