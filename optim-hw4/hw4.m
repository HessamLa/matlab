function output=pso(varargin)
    f = @Griewank; % use f instead of the full name

    objective = 'Min'; % use 'Min' or 'Max'

    % set comparison (comp) and anti-comparison (acomp) functions according to the objective
    fprintf('Setting objective to \"%s\"\n', objective);
    if( strcmp(objective,'Min'))
        comp = @min; acomp = @max;
    elseif( strcmp(objective,'Max'))
        comp = @max; acomp = @min;
    else
        fprintf('Wrong objective value. Must be "Min" or "Max"\n');
        fprintf('objective is \"%s\"\n', objective);
        return;
    end

    % do the settings
    N = 25; % number of points, the 'd' value
    rep = 80; % number of max repetitions
    c1 = 2; % cognitive coeff
    c2 = 2; % social coeff
    w = 0.94; % omega: inertial constant ,slightly less than 1
    k = 0.729 % kappa: constriction coefficient

    % initialize the random initial positions in range [-5,5]
    R = 10;
    x = R*(rand(N,2) - 0.5);
    p = x; % set all personal bests to the initial values
    g = x(1,:); % set the global best as the first one, randomly

    % initialize the random initial velocities in range [-Vmin, +Vmax]
    Vmax = 5;
    Vmin = -5;
    v = Vmax * (rand(N,2) - 0.5);
    v = min(Vmax, max(Vmin,v)) % clamp velocity

    % find the global best
    t = arrayfun(@(n) f(x(n,:)), 1:size(x,1))';
    [M I]=comp(t);
    g = x(I,:); 

    fprintf("Best     Worst      average\n");
    % evaluate the function in the given positions

    figure;
    xlabel('Iteration'); ylabel('Objective function value');

    hold on
    for i = 1:rep
        % generate random vectors r and s
        r = rand(N,1);
        s = rand(N,1);

        % Calculating new velocity:
        % with intertial constant
        %v1 = w*v + c1*r.*(p-x) + c2*s.*(g-x);
        % with constriction coefficient
        v1 = k*(v + c1*r.*(p-x) + c2*s.*(g-x));

        % clamp velocity
        v1 = min(Vmax, max(Vmin,v1)); % clamp velocity
        x1 = x + v1;

        % f(x1) < f(p) 
        tx1 = arrayfun(@(n) f(x1(n,:)), 1:size(x1,1))';
        tp = arrayfun(@(n) f(p(n,:)), 1:size(p,1))';
        M = comp(tx1,tp); % find min/max values (depending on the goal)
        I = M==tx1;      % index of points that f(x1) < f(p) 
        p1 = p;          % update p1 according to f(x1) < f(p)
        p1(I,:) = x1(I,:);

        t = arrayfun(@(n) f(x1(n,:)), 1:size(x1,1))';
        [M I]=comp(t);
        g1 = x1(I,:);  

        x = x1;
        p = p1;
        v = v1;
        g = g1;

        best(i) = comp(t); % comp() is min() or max(), depending on the goal
        worst(i) = acomp(t);
        average(i) = mean(t);
        fprintf("%f | %f | %f \n", comp(t), acomp(t), mean(t));
    end
    r = 1:rep;
    plot(r, best, '-or', 'LineWidth', 1.5, 'MarkerSize', 3);
    plot(r, worst, '-*g', 'LineWidth', 1.5, 'MarkerSize', 3);
    plot(r, average, '-xb', 'LineWidth', 1.5, 'MarkerSize', 3);
    legend('Best', 'Worst', 'Average');

end

function y=Griewank(xx)
    % xx = [x1, x2, ..., xd]
    d = length(xx);
    sum = 0;
    prod = 1;
    for ii = 1:d
    xi = xx(ii);
    sum = sum + xi^2/4000;
    prod = prod * cos(xi/sqrt(ii));
    end
    y = sum - prod + 1;
end
