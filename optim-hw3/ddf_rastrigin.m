function F = ddf_rastrigin(x1,x2)
F =  [(1/50) + 2*pi^2*cos(pi*x1/5)/5, 0                        ;
      0                       , (1/50) + 2*pi^2*cos(pi*x2/5)/5];
