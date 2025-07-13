    function s_hat = Full_Supp(x, d, lambda, delta, M)
        s_hat = zeros(length(x),1);
        n = 1;
        while n <= M-1
            s_hat(n) = x(n);
            n = n + 1;
        end
        %n = M;
        P = (1/delta)*eye(M);
        Wz = zeros(M,1);

        while n <= length(x)
            xvec = x(n:-1:n-M+1);
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