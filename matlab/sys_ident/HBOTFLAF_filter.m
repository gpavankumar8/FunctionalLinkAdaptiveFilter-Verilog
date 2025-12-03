function [error, s_vec, g_vec,s,y] = RCTFLAF_filter(x, d, w, a, s_vec, g_vec, par)

    Q = par.Q;

    g_val = zeros(1,Q);

    for j = 0:Q-1

        p = ceil(j/2);
        ang = p*pi*x;
%             ang_fi = ang.*2^(fraclen);
%             ang_fi = round(ang_fi);
%             ang = ang_fi.*2^(-fraclen);

        if (j==0)
            g_val(j+1) = x;
        elseif( mod(j,2) == 1 )
%             g_val(j+1) = sine_taylor(ang);
            g_val(j+1) = sin(ang);
        elseif( mod(j,2) == 0 )
%             g_val(j+1) = cosine_taylor(ang);
            g_val(j+1) = cos(ang);
        end

   end

        s = a * g_val';
        s_vec = [s, s_vec(1:end-1)];
        g_vec = [g_val; g_vec(1:end-1,:)];

        y = w * [1,s_vec(1:length(w)-1)]';
%         y = w * s_vec(1:length(w))';
        error = d - y;


% Sparse RC-TFLAF partial update


% function [error, s_vec, g_vec, mask] = RCTFLAF_filter(x, d, w, a, s_vec, g_vec, par)
% 
%     Q = par.Q;
% 
%     g_val = zeros(1,Q);
% 
%     for j = 0:Q-1
% 
%         p = ceil(j/2);
%         ang = p*pi*x;
% %             ang_fi = ang.*2^(fraclen);
% %             ang_fi = round(ang_fi);
% %             ang = ang_fi.*2^(-fraclen);
% 
%         if (j==0)
%             g_val(j+1) = x;
%         elseif( mod(j,2) == 1 )
% %             g_val(j+1) = sine_taylor(ang);
%             g_val(j+1) = sin(ang);
%         elseif( mod(j,2) == 0 )
% %             g_val(j+1) = cosine_taylor(ang);
%             g_val(j+1) = cos(ang);
%         end
% 
%    end
% 
%         s = a * g_val';
%         s_vec = [s, s_vec(1:end-1)];
%         g_vec = [g_val; g_vec(1:end-1,:)];
% 
%         mask = zeros(1,length(w)-1);
%         [~, pos] = sort(abs(s_vec),"descend");
%         mask(pos(1:length(s_vec)-50)) = 1;
% 
%         y = w * [1,s_vec(1:length(w)-1) .* mask]';
% %         y = w * s_vec(1:length(w))';
%         error = d - y;
%       
      
        