%% FW2 - Q4
clear;
% a) 
x = (-3:0.06:3);
[Z] = peaks(x);
[X Y] = meshgrid(x);
mesh(X,Y,Z);

% b)
contour(Z, 20);