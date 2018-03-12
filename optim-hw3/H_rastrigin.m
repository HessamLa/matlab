% Hermitian function.Same as F function of f
function H = H_rastrigin(x)
    H = [1/50 + 2*pi^2/5*cos(x(1,:)*pi/5),         0                        ;
              0                        ,    1/50 + 2*pi^2/5*cos(x(1,:)*pi/5)];
 
