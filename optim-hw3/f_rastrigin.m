function f = f_rastrigin(x)
    if( numel(x) ~= 2 || ~iscolumn(x) )
        disp("f_rastrigin2(x), x must be column vector of size 2");
        return;
    end
    f = 20 + sum((x/10).^2 - 10*cos(x*pi/5));

