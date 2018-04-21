% This function generates a random map of all connected cities
function XY = generate_points(n, rangex, rangey)
    % n is the number of cities
    % c is the number of connections between cities
    % rangex is a 2-element array, indicating range in x axis
    % rangey is a 2-element array, indicating range in y axis
    % XY would be the array of (x,y) coordinates of each city on the map
    % PROXIMITY would be the symmetric weighted proximity matrix. If two cities are
    % connected, their corresponding element in this matrix would be the
    % distance. Initially it is set to -1
    if ( length (rangex) < 2 )
        disp("rangex must have two elements");
        return;
    end
    if ( length (rangey) < 2 )
        disp("rangey must have two elements");
        return;
    end
    % generate random x-y points in rangex and rangey
    r = rangex(2) - rangex(1);
    x = rand(n,1)*r + rangex(1);
    
    r = rangey(2) - rangey(1);
    y = rand(n,1)*r + rangey(1);
    
    XY = [x y];
    %figure
    %scatter(x,y);
    