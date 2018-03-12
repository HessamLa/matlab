function x=linesearch_fibonacci(func, a, b, n)
a0 = a;
b0 = b;
rho = 1-fibonacci(n)/fibonacci(n+1);

%b0 = a0 - 1;
a1 = a0 + rho*(b0-a0);
b1 = b0 - rho*(b0-a0);

i = 0;
fprintf("Fibonacci method\n");
fprintf("dir|it|   a_k           |   b_k           |");
fprintf("f(a_k)|f(b_k)| width| rho\n");
fprintf("------|-----------------|------------------");
fprintf("------|------|------|----\n");
fprintf(" ><|%2d| [%6.3f %6.3f] | [%6.3f %6.3f] |%6.3f|%6.3f|%6.3f|%6.3f\n", ...
  i, a0, b0, feval(func,a0), feval(func,b0), norm(a0-b0),rho);  
while n > 1
  i = i+1;
  n = n-1;
  rho = 1-fibonacci(n)/fibonacci(n+1);
  if rho == 0.5
    rho = 0.5 -0.01;
  end
  if feval(func,a1) < feval(func,b1) % the range will reduce to [a0 , b1]
    fprintf("a0<");
    b0 = b1;
    b1 = a1;
    a1 = a0 + rho*(b0-a0);
  else % the range will reduce to [a1, b0]
    fprintf("b0<");
    a0 = a1;
    a1 = b1;
    b1 = b0 - rho*(b0-a0);
  end
  
  fprintf("|%2d| [%6.3f %6.3f] | [%6.3f %6.3f] |%6.3f|%6.3f|%6.3f|%6.3f\n", ...
    i, a0, b0, feval(func,a0), feval(func,b0), norm(a0-b0),rho);
end
v=[feval(func,a0), feval(func,a1), feval(func,b1), feval(func,b0)];
i = find(v==min(v));
%v = [a0, a1, b1, b0];
switch i(1)
    case 1
        x=a0;
    case 2
        x=a1;
    case 3
        x=b1;
    case 4
        x=b0;
end