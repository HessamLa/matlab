%% FW2 - Q3 
clear;
Q = [4 1;1 6];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (a) - Fibonacci method
n = 8;
rho = 1-fibonacci(n)/fibonacci(n+1);

a0 = [ 0.8 -0.25]';
b0 = [0.0173843 -0.0050162]';
%b0 = a0 - 1;
a1 = a0 + rho*(b0-a0);
b1 = b0 - rho*(b0-a0);

i = 0;
printf("Fibonacci method\n");
printf("dir|it|   a_k           |   b_k           |");
printf("f(a_k)|f(b_k)| width| rho\n");
printf("------|-----------------|------------------");
printf("------|------|------|----\n");
printf(" ><|%2d| [%6.3f %6.3f] | [%6.3f %6.3f] |%6.3f|%6.3f|%6.3f|%6.3f\n",
  i, a0, b0, f(a0,Q), f(b0,Q), norm(a0-b0),rho);  
while n > 1
  i++;
  n--;
  rho = 1-fibonacci(n)/fibonacci(n+1);
  if rho == 0.5
    rho = 0.5 -0.01;
  end
  if f(a1,Q) < f(b1,Q) % the range will reduce to [a0 , b1]
    printf("a0<");
    b0 = b1;
    b1 = a1;
    a1 = a0 + rho*(b0-a0);
  else % the range will reduce to [a1, b0]
    printf("b0<");
    a0 = a1;
    a1 = b1;
    b1 = b0 - rho*(b0-a0);
  end
  
  printf("|%2d| [%6.3f %6.3f] | [%6.3f %6.3f] |%6.3f|%6.3f|%6.3f|%6.3f\n",
    i, a0, b0, f(a0,Q), f(b0,Q), norm(a0-b0),rho);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (b) - Newton's method

printf("Newton's method\n");
x = [ 0.8 -0.25]';
x = x - inv(Hf(x,Q))*df(x,Q);
printf("x* = [%6.3f %6.3f]\n", x);