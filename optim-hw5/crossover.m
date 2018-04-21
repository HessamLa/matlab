function v1 = crossover(v)
len = length(v);
%generate two different random numbers in range [0, len-2)
r1 = 0;
while( r1 == 0 || r1 == len-2 ) 
    r1 = floor( rand() * (len-2) );
r2 = r1;
while(r2 == r1 || r2 == len-2 )
    r2 = floor( rand() * (len-2) );
end
% offset the numbers to be in range [2, len)
r1 = r1 + 2;
r2 = r2 + 2;

%fprintf("%5.2f %5.2f\n", r1,r2);

% swap the two randomly chosen positions
v1 = v;
v1(r1) = v(r2);
v1(r2) = v(r1);
end

