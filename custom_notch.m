function op_signal = custom_notch(b ,a , unfiltered_signal, buffer_y, buffer_x)
        op_signal = zeros(size(unfiltered_signal));
        for n = 1:length(unfiltered_signal)
            first_idx = n - 2;
            second_idx = n - 1;
            if(first_idx < 1)
                first = buffer_y(first_idx + 2); %if say n-2 is -1, then we pick 1st element.
                first_x = buffer_x(first_idx + 2);
            else
                first = op_signal(first_idx);
                first_x = unfiltered_signal(first_idx);
            end
            if (second_idx < 1)
                second = buffer_y(second_idx + 2); %same philosophy as first case
                second_x = buffer_x(second_idx + 2);
            else
                second = op_signal(second_idx);
                second_x = unfiltered_signal(second_idx);
            end
            op_signal(n) = b(1)*unfiltered_signal(n) + b(2)*second_x + ...
                b(3)*first_x - a(2)*second - a(3)*first;
        end
    end