function H=H_rosenb(x)
% Hessian of rosenblatt's "banana" function
H = [-400*(x(2,:)-3*x(1,:).^2)+2    -400*x(1,:);
      -400*x(1,:)   200];