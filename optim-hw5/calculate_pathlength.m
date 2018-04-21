function dist = calculate_pathlength(path, proximity)
dist = 0;
n = length(path);

for i=1:n-1
    city1 = path(i);
    city2 = path(i+1);
    dist = dist + proximity(city1, city2);
end

