%% FW2 - Q2
clear;
Q = [4 1;1 6];

rho = (3-sqrt(5))/2;

a0 = [ 0.8 -0.25]';
b0 = [0.0173843 -0.0050162]';
%b0 = a0 - 1;
a1 = a0 + rho*(b0-a0);
b1 = b0 - rho*(b0-a0);

i = 0;
printf(" ><|%2d| [%6.3f %6.3f] | [%6.3f %6.3f] |%6.3f|%6.3f|%6.3f\n",
  i, a0, b0, f(a0,Q), f(b0,Q), norm(a0-b0));  
while norm(a0 - b0) > 0.2
  i++;
  if f(a1,Q) < f(b1,Q) % the range will be [a0 , b1]
    printf("a0<");
    b0 = b1;
    b1 = a1;
    a1 = a0 + rho*(b0-a0);
  else % the range will be [a1, b0]
    printf("b0<");
    a0 = a1;
    a1 = b1;
    b1 = b0 - rho*(b0-a0);
  end
  
  printf("|%2d| [%6.3f %6.3f] | [%6.3f %6.3f] |%6.3f|%6.3f|%6.3f\n",
    i, a0, b0, f(a0,Q), f(b0,Q), norm(a0-b0));  
end


