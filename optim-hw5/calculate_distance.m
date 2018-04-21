function prox = calculate_distance(xy)
    %CALCULATE_DISTANCE Summary of this function goes here
    %   Detailed explanation goes here
    if( length( xy(1,:) ) == 2 )
        n = length( xy(:,1) );
    elseif( length( xy(:,1) ) == 2 )
        xy = xy';
        n = length( xy(:,1) );
    else disp("xy must be a 2xN or Nx2 matrix");
        return;
    end
    
    prox = zeros(n);
    for i = 1:n
        for j =1:n
            v = xy(i,:) - xy(j,:);
            prox(i,j) = norm(v);
        end
    end
end

