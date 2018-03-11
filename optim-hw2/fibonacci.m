function f = fibonacci(n)
if (n == 1)
   f = 1;
elseif (n == 2)
   f = 2;
else
   fOld = 2;
   fOlder = 1;
   for i = 3 : n
     f = fOld + fOlder;
     fOlder = fOld;
     fOld = f;
   end
end
end