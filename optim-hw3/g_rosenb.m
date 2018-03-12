function g=g_rosenb(x)
% Gradient of rosenblatt's "banana" function
g = [-400*(x(2,:)-x(1,:).^2).*x(1,:)-2*(1-x(1,:));
      200*(x(2,:)-x(1,:).^2) ];