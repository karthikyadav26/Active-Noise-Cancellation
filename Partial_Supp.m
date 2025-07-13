    function s_hat = Partial_Supp(x, d, lambda, delta, M)
        s_hat = zeros(length(x),1);
        xvec_filt = zeros(M,1);
        Fs = 44100; %Hz
        notch_freq = 2728; %Hz
        bandwidth = 5; %Hz
        w0 = 2 * pi* notch_freq/Fs;
        bw = bandwidth/Fs;
        r = 1 - bw;
        b = [1, -2*cos(w0), 1];
        a = [1, -2*r*cos(w0), r*r];
        gain = (1 - 2*r*cos(w0) + r*r)/(2 - 2*cos(w0));
        b = b/gain; 
        n = 1;
        buffer_x = [0;0];
        buffer_y = [0;0];
        while n <= M
            x_rn = x(n);
            x_filt_rn = b(1)*x_rn + b(2)*buffer_x(2) + b(3)*buffer_x(1)...
                - a(2)*buffer_y(2) - a(3)*buffer_y(1);  
            xvec_filt = [xvec_filt(2:M);x_filt_rn];
            buffer_x = [buffer_x(2);x_rn];
            buffer_y = [buffer_y(2); x_filt_rn];
            n = n + 1;
        end
        %n = M;
        P = (1/delta)*eye(M);
        Wz = zeros(M,1);   
        while n <= length(x)
            x_rn = x(n);
            x_filt_rn = b(1)*x_rn + b(2)*buffer_x(2) + b(3)*buffer_x(1)...
                - a(2)*buffer_y(2) - a(3)*buffer_y(1); 
            xvec_filt = [xvec_filt(2:M);x_filt_rn];
            buffer_x = [buffer_x(2);x_rn];
            buffer_y = [buffer_y(2); x_filt_rn];
            xvec = flip(xvec_filt);
            z = P * xvec;
            %epsilon = 1e-12
            g = (1/(lambda + xvec' * z))*z;
            alpha = d(n) - Wz' * xvec;
            Wz = Wz + alpha*g;
            P = (1/lambda)*(P - g * xvec' * P);
            s_hat(n) = d(n) - (Wz' * xvec);
            if isnan(s_hat(n))
                fprintf("At n = %d, it becomes NaN\n", n);
                break;
            end
            n = n + 1;
        end

    end
    
    