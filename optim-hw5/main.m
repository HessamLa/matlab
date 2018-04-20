rangeX = [ 0 20];
rangeY = [-5 15];
n = 20;
xy = generate_points(n, rangeX, rangeY);

proximity = calculate_distance(xy);

% population count
popc = 24
for i=1:popc
    v = [1:n-1];
    v = v(randperm(length(v)));
    v = [n v n];
    pop(i,:)=v
end

%calculate_distance



