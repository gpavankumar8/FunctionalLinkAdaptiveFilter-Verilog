function [error, g_vec, y] = TFLAF_filter(x, d, w, g_vec, par)

    Q_t = par.Q_t;

    g_val = zeros(1,Q_t);

    for j = 0:Q_t-1

        p = ceil(j/2);
        if (j==0)
            g_val(j+1) = x;
        elseif( mod(j,2) == 1 )
%             g_val(j+1) = sine_taylor(p*pi*x);
            g_val(j+1) = sin(p*pi*x);
        elseif( mod(j,2) == 0 )
%             g_val(j+1) = cosine_taylor(p*pi*x);
            g_val(j+1) = cos(p*pi*x);
        end

    end

    g_vec = [g_val, g_vec(1:end-Q_t)];

    y = w * [1,g_vec(1:length(w)-1)]';
    error = d - y;
