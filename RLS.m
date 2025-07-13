    function s_hat = RLS(x, d, lambda, delta, M,choice)
        s_hat = zeros(length(x),1);
        n = 1;
        while n <= M-1
            s_hat(n) = x(n);
            n = n + 1;
        end
        %n = M;
        P = (1/delta)*eye(M);
        Wz = zeros(M,1);
        fs = 44100;
        fp = [900 1100]; %this is our passband btw
        fsb = [950 1050]; %stopband
        Wp = fp/(fs/2);
        Ws = fsb/(fs/2);

        Rp = 1;
        Rs = 60; 

        [n_init,Wn] = buttord(Wp, Ws, Rp, Rs);
        [z,p,k] = butter(n_init, Wn, 'stop');
        [b,a] = zp2tf(z,p,k);
        while n <= length(x)
            xvec_init = x(n:-1:n-M+1);
            if choice == 0
                xvec = filter(b, a, xvec_init);
            else
                xvec = xvec_init;
            end
            z = P * xvec;
            g = (1/(lambda + xvec' * z))*z;
            alpha = d(n) - Wz' * xvec;
            Wz = Wz + alpha*g;
            P = (1/lambda)*(P - g * xvec' * P);
            s_hat(n) = d(n) - (Wz' * xvec);
            if isnan(s_hat(n))
                fprintf("At n = %d, it becomes NaN", n);
            end
            n = n + 1;
        end

    end