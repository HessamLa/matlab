clear;
delete(findall(0,'Type','figure'))

rangeX = [ 0 20];
rangeY = [-5 15];
n = 20;
for k=1:8
xy = generate_points(n, rangeX, rangeY);
sum = 0;
for i=1:20
    %[best bestp] = tsp_ga(xy, 'withplot');
    [best bestp] = tsp_ga(xy);
    best;
    sum = sum + best;
end
sum/20
end
