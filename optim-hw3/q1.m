%f = @(x1,x2) 20 + (x1/10).^2 + (x2/10).^2 - 10*(cos(2*pi*x1/10) + cos(2*pi*x2/10));

syms x1 x2
f =  20 + (x1/10).^2 + (x2/10).^2 - 10*(cos(2*pi*x1/10) + cos(2*pi*x2/10));
g = gradient(f, [x1, x2])
p =  x1/50 + 2*pi*sin((pi*x1)/5)
F = gradient(p, [x1, x2])

X1 = (1:0.1:10);
X2 = X1;

G1 = subs(g(1), [x1 x2], {X1,X2});