function f=f_rosenb(x)
% rosenblatt's "banana" function
f = 100*(x(2,:)-x(1,:).^2).^2+(1-x(1,:)).^2;