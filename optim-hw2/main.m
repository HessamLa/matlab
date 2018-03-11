%% FW2 - Q3
clear;
[x1 x2] = meshgrid(-3: 0.1: 3);
z = x1.^2 + x2.^2;
meshc(x1,x2,z);