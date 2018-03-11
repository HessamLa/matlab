%% FW2 - Q5
clear;

x0 = [0.8, -0.25];
x = (-3:6/49:3); % make x to be 49 elements, same as default peaks
%% find closest indices to x0=[0.8, -0.25]
[v i] = min(abs(x-x0(1)));
x0(1) = x(i);
[v i] = min(abs(x-x0(2)));
x0(2) = x(i);

%% make matrix of values of peaks and its gradient
[Z] = peaks(x);
[X Y] = meshgrid(x);

[FX FY] = gradient(Z);
contour(X,Y,Z, 20);
hold on
quiver(X,Y,FX,FY)
hold off

alpha = 0.2;

ax = X-alpha*FX;
ay = Y-alpha*FY;
z = peaks(ax,ay);
[m k] = min(z);