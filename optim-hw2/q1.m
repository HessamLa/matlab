%% FW2 - Q1
clear;
epsilon = 0.075;
%epsilon = 0.2;
Q = [4 1; 1 6];
x = [0.8 -0.25]';
df(x,Q)

lbracket = x;
x = x - epsilon * df(x,Q);
rbracket = x;

res = realmax;
while res > f(x,Q)
  res = f(x,Q);
  lbracket = rbracket;
  rbracket = x;
  x = x - epsilon * df(x,Q);
  epsilon = epsilon * 2;
  fprintf("epsilon = %6.3f\n",epsilon);
  fprintf("   left = [%6.3f %6.3f]\n",lbracket);
  fprintf("  right = [%6.3f %6.3f]\n",rbracket);
  fprintf("      x = [%6.3f %6.3f]\n",x);
  fprintf(" f(left)= %6.3f \n",f(lbracket,Q));
  fprintf("f(right)= %6.3f \n",f(rbracket,Q));
  fprintf("    f(x)= %6.3f \n",f(x,Q));
  fprintf(" region width = %6.3f\n", norm(lbracket-x));
  fprintf("\n");
end

rbracket = x;




