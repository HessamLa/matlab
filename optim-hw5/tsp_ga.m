function [best bestp] = tsp_ga(xy, varargin)
% Traveling Sales Person with Genetic Algorithm
    if( length( xy(1,:) ) == 2 )
        n = length( xy(:,1) );
    elseif( length( xy(:,1) ) == 2 )
        xy = xy';
        n = length( xy(:,1) );
    else disp("tsp_ga(): xy must be a 2xN or Nx2 matrix");
        return;
    end
    
    % make the proximity matrix
    proximity = calculate_distance(xy);

    N = 80; % population size
    bestN = 0; % numebr of the fittest members of the previous generation
               % to be passed to the next
    best = realmax;

    %% generate the first population p(0)
    for i=1:N
        v = [1:n-1];
        v = v(randperm(length(v)));
        v = [n v n];
        p(i,:)=v; % each row is a path
    end
    for i=1:N
        f(i) = calculate_pathlength(p(i,:), proximity);
    end
    
    if( min(f) < best)
        [best I] = min(f);
        bestp = p(I,:);
    end

    %% start with the algorithm
    gen = 1; % generation
    while( gen < 1000 )
        F = sum(f);
        prob = f/F;
        %fprintf("Processing Generation %d\n", gen);
        for i=1:N-bestN
            % randomly select a parent index
            index = RouletteWheelSelection(prob);

            % do the single parent cross-over
            p1(i,:) = crossover(p(index,:));
        end
        if( i < N )
            p1(i+1:N,:) = bestp; % keep the best parent in the previous gen in the new one
        end

        for i=1:N
            f(i) = calculate_pathlength(p1(i,:), proximity);
        end

        bestgen(gen) = min(f);
        worst(gen) = max(f);
        average(gen) = mean(f);

        if( bestgen(gen) < best)
            [best I] = min(f);
            bestp = p1(I,:);
        end

        gen = gen + 1;
        p = p1;
    end

    if( nargin > 1 && strcmp(varargin(1), 'withplot') )
        figure
        set(gcf, 'Position', [400, 400, 1200, 500])
        subplot(1,2,1)
        hold on
        plot(bestgen, '-or', 'LineWidth', 1.5, 'MarkerSize', 3);
        plot(worst, '-*g', 'LineWidth', 1.5, 'MarkerSize', 3);
        plot(average, '-xb', 'LineWidth', 1.5, 'MarkerSize', 3);
        legend('Best', 'Worst', 'Average');

        subplot(1,2,2) 
        scatter(xy(:,1), xy(:,2));
        hold on
        v = zeros(size(xy));
        for i=1:n+1
            v(i,:) = xy(bestp(i), :);
        end
        plot(v(:,1), v(:,2));
    end

end

