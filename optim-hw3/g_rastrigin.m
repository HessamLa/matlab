function g = g_rastrigin(x)
    g = [x(1,:)/50 + 2*pi*sin(x(1,:)*pi/5);
         x(2,:)/50 + 2*pi*sin(x(2,:)*pi/5)]; 