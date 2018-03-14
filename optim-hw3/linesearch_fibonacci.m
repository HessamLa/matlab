function alpha=linesearch_fibonacci(func, x, d, a, b, n)
% func is the the function to be minimized.
% x is the starting point and d is the direction
% [x+a*d ,x+b*d] is the range of the line search.
% alpha is in range [a, b]

fib = fibonacci(1:n+1); % to increase speed of this function
rho = 1-fib(n)/fib(n+1);


a0 = x+a*d/norm(d);
b0 = x+b*d/norm(d);

a1 = a0 + rho*(b0-a0);
b1 = b0 - rho*(b0-a0);

i = 0;

% These two variables are used to increase speed of this function by
% decreasing number of function calls.
fa1 = feval(func,a1);  
fb1 = feval(func,b1);
while n > 1
  
  i = i+1;
  n = n-1;
  rho = 1-fib(n)/fib(n+1);

  if rho == 0.5
    rho = 0.5 -0.01;
  end
  if fa1 < fb1 % the range will reduce to [a0 , b1]
    b0 = b1;
    b1 = a1;
    a1 = a0 + rho*(b0-a0);
    fa1 = feval(func,a1);
  else % the range will reduce to [a1, b0]
    a0 = a1;
    a1 = b1;
    b1 = b0 - rho*(b0-a0);
    fb1 = feval(func,b1);
  end
end
%v=[feval(func,a0), fa1, fb1, feval(func,b0)];
v=[feval(func,a0), feval(func,a1), feval(func,b1), feval(func,b0)];
i = find(v==min(v),1);
%v = [a0, a1, b1, b0];
switch i
    case 1
        p=a0;
    case 2
        p=a1;
    case 3
        p=b1;
    case 4
        p=b0;
end
% Now we have the best p=x+alpha*d. We need to get the value of alpha.
% Value of only one of the coordinates will suffice for calculation.
alpha = (p(1)-x(1))/d(1);

    