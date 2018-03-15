function varargout=optimgui(varargin)
    % OPTIMGUI
    %  Graphical interface for Unconstrained optimization methods
    %  as found in chapters 8-11 in "An Introduction to
    %  Constrained Optimization" by Chong and Zak.
    %
    %  To start, simply type 'optimgui' at the command line.
    %  Requires MATLAB 5.2 (might run in 5.1 or even 5.0).
    %
    %  Uses Prof. Chong's secant based line search routine.
    %  Minimizes the Rosenbrock, or "banana" function.
    %  As soon as you drag the starting location, or change
    %  the method, the optimization begins.
    
    % T. Krauss  2/13/98
    
    %if ~exist('flag','persistent')
    %end
    
    if nargin == 0
        delete(findall(0,'Type','figure'));
        
        set_outfile('points.txt');
        % creat a new file or discard existing content
        fileID = fopen(get_outfile,'w');
        fclose(fileID);
        
        init
        setfunc
        return
    end
    
    if (nargout == 0)
        feval(varargin{:});
    else
        [varargout{1:nargout}] = feval(varargin{:});
    end
    
    
%------------------------------------------------------------
function setfunc
    % setfunc: set the function
    fprintf('"%s".\n', get_gname);
    
    funcMenu = findobj(gcf,'tag','PopupMenu2');
    algMenu = findobj(gcf,'tag','PopupMenu1');
    
    %get string of the selected menu
    contents = get(funcMenu,'String');
    popupmenuString = contents{get(funcMenu,'Value')};
    fprintf('The function "%s" is chosen.\n', popupmenuString);
    
    if get(funcMenu,'value')>2,
        fprintf('The function "%s" is not implemented yet.\n', popupmenuString);
        set(funcMenu,'value',1);
    else
        switch get(funcMenu,'value')
            case 1
                set_fname('f_rosenb');
                set_gname('g_rosenb');
                set_Fname('H_rosenb');
            case 2
                set_fname('f_rastrigin');
                set_gname('g_rastrigin');
                set_Fname('F_rastrigin');
        end
    end
    
    x0 = findobj(gcf,'tag','x0');
    y0 = findobj(gcf,'tag','y0');
    x0 = str2num (get(x0,'String'));
    y0 = str2num (get(y0,'String'));
    
    x=x0-4:.05:x0+4;
    y=y0-4:.05:y0+4;
    
    [X,Y]=meshgrid(x,y);
    f=feval(get_fname,[X(:)';  Y(:)']);
    hold off;
    f=reshape(f,length(y),length(x));
    %contour(x,y,f,[1 3 7 16 32 64 128])
    contour(x,y,f,[1:2:40])
    hold on;
    xlabel('x_1')
    ylabel('x_2')
    %title('Minimization of Rosenbrock function')
    %plot(1,1,'o')
    %text(1,1,'Solution')
    grid on
    
    %l = line(-1.2,2,'erasemode','xor','marker','o','linewidth',1.5,'color','r');
    %assignin('base','l',l)
    %h = line(-1.2,2,'erasemode','xor','linestyle','none','marker','x',...
    % 'markersize',14,'linewidth',1.5,'buttondownfcn','optimgui(''startdown'')');
    l = line(x0,y0,'erasemode','xor','marker','o','linewidth',1.5,'color','r');
    assignin('base','l',l)
    h = line(x0,y0,'erasemode','xor','linestyle','none','marker','x',...
        'markersize',14,'linewidth',1.5,'buttondownfcn','optimgui(''startdown'')');
    assignin('base','h',h)
    x0=findobj(gcf,'tag','x0');
    y0=findobj(gcf,'tag','y0');
    set(x0,'string',num2str(get(h,'xdata')))
    set(y0,'string',num2str(get(h,'ydata')))
    
    
%------------------------------------------------------------
function x0change
    h=evalin('base','h');
    set(h,'xdata',str2num(get(findobj(gcf,'tag','x0'),'string')))
    setfunc
    optimgui('optimize')
    
%------------------------------------------------------------
function y0change
    h=evalin('base','h');
    set(h,'ydata',str2num(get(findobj(gcf,'tag','y0'),'string')))
    setfunc
    optimgui('optimize')
    
%------------------------------------------------------------
function startdown
    % startdown.m:  button down function for starting point line
    % of optim demo
    
    set(gcf,'windowbuttonmotionfcn','set(h,''userdata'',''motion'')')
    set(gcf,'windowbuttonupfcn','set(h,''userdata'',''up'')')
    
    h=evalin('base','h');
    x0=findobj(gcf,'tag','x0');
    y0=findobj(gcf,'tag','y0');
    f_h=findobj(gcf,'tag','f');
    
    done=0;
    while ~done
        waitfor(h,'userdata')
        msg = get(h,'userdata');
        switch msg
            case 'motion'
                pt = get(gca,'currentpoint');
                set(h,'xdata',pt(1,1),'ydata',pt(1,2))
                set(x0,'string',num2str(pt(1,1)))
                set(y0,'string',num2str(pt(1,2)))
                %set(f_h,'string',num2str(optimgui('f_rosenb',[pt(1,1); pt(1,2)])))
                set(f_h,'string',num2str(optimgui(get_fname,[pt(1,1); pt(1,2)])))
                
            case 'up'
                done = 1;
        end
        set(h,'userdata',[])
    end
    
    set(gcf,'windowbuttonmotionfcn','')
    set(gcf,'windowbuttonupfcn','')
    optimgui('optimize')
    
%------------------------------------------------------------
function optimize
    funcMenu = findobj(gcf,'tag','PopupMenu2');
    algMenu = findobj(gcf,'tag','PopupMenu1');
    iter_h=findobj(gcf,'tag','iter');
    f_h=findobj(gcf,'tag','f');
    step_h=findobj(gcf,'tag','step');
    steplabel_h=findobj(gcf,'tag','steplabel');
    Pushbutton1_h = findobj(gcf,'tag','Pushbutton1');
    set(Pushbutton1_h,'visible','on','userdata',[])
    x0=findobj(gcf,'tag','x0');
    y0=findobj(gcf,'tag','y0');
    
    h=evalin('base','h');
    set(h,'buttondownfcn','optimgui(''startdown''), optimgui(''stop'')')
    set([x0 y0 step_h],'enable','off')
    
    l=evalin('base','l');
    
    am = get(algMenu,'value');
    algname = get(algMenu,'String');
    x = [get(h,'xdata'); get(h,'ydata')];
    
    fileID = fopen(get_outfile,'a');
    fprintf(fileID, '\n-----------------------------------------------\n');
    fprintf(fileID, 'funciton:%s \nMethod:%s \nX0=[%.2f;%.2f]\n', ...
        get_fname, char(algname(am)), x(1), x(2));
    frmt = "%4d | [%9.3e , %9.3e]' | %17.10e | [%17.10e , %17.10e]'\n";
    switch am
        case {1,2,3,4,5,6}  % gradient or conjugate gradient
            k=0;
            x = [get(h,'xdata'); get(h,'ydata')];
            set(l,'xdata',x(1),'ydata',x(2))
            % find a bracket
            %x = b_bracket;
            
            %g = g_rosenb(x);
            g = feval(get_gname, x);
            d = -g;
            while norm(g)>1e-6
                set(iter_h, 'string',num2str(k))
                %set(f_h,'string',num2str(optimgui('f_rosenb',x)))
                set(f_h, 'string',num2str(optimgui(get_fname,x)))
                
                if am==1  % fixed step size
                    alpha=str2num(get(step_h,'string'));
                else  % do line search
                    %alpha = linesearch('secant', get_gname, x,d);
                    
                    [a_bracket, c_bracket, b_bracket] = bracket_alpha(get_fname, x, 0.001, d);
                    alpha = linesearch('fibonacci', get_fname, x, d, a_bracket, b_bracket, 10);
                end
                if alpha==0
                    break;
                end
                x = x + alpha*d;
                
                %g1 = g_rosenb(x);
                g1 = feval(get_gname, x);
                %disp(['x=', x, '| alpha=', alpha, '| g(x)=', g1]);
                %disp([x', alpha, g1']);
                switch am
                    case {1,2}  % gradient
                        beta = 0;
                    case 3  % hestenes-stiefel
                        beta = g1'*(g1-g)/(d'*(g1-g));
                    case 4  % polak-ribiere
                        beta = g1'*(g1-g)/(g'*g);
                    case 5  % fletcher-reeves
                        beta = (g1'*g1)/(g'*g);
                    case 6  % powell
                        beta = max(0,g1'*(g1-g)/(g'*g));
                end
                k = k+1;
                if rem(k,6)==0
                    beta = 0;
                end
                g = g1;
                d = -g + beta*d;
                xd = get(l,'xdata'); yd=get(l,'ydata');
                set(l,'xdata',[xd(:); x(1)],'ydata',[yd(:); x(2)])
                
                % iteration|[Xk] | f(Xk)| g(Xk)
                fprintf(fileID, frmt,...
                    k, x(1), x(2), feval(get_fname, x), g(1), g(2));
                drawnow
                if ~isempty(get(Pushbutton1_h,'userdata'))
                    break
                end
            end
            
        case {7,8,9}  % quasi-newton
            k=0;
            H=eye(2);
            x = [get(h,'xdata'); get(h,'ydata')];
            set(l,'xdata',x(1),'ydata',x(2))
            %g = g_rosenb(x);
            g = feval(get_gname, x);
            d = -H*g;
            while norm(g)>1e-6
                set(iter_h,'string',num2str(k))
                %set(f_h,'string',num2str(optimgui('f_rosenb',x)))
                set(f_h,'string',num2str(optimgui(get_fname,x)))
                
                %alpha=linesearch_secant('g_rosenb',x,d);
                %alpha=linesearch_secant(get_gname,x,d);
                [a_bracket, c_bracket, b_bracket] = bracket_alpha(get_fname, x, 0.001, d);
                alpha = linesearch('fibonacci', get_fname, x, d, a_bracket, b_bracket, 10);
                
                delx = alpha*d;
                x = x + delx;
                %g1=g_rosenb(x)
                g1 = feval(get_gname, x);
                delg = g1-g;
                if delg==0
                    break;
                end
                switch am
                    case 7  % rank-1
                        z = delx - H*delg;
                        H1 = H + (z*z')/(delg'*z);
                    case 8  % DFP
                        H1 = H + (delx*delx')/(delx'*delg) - (H*delg)*(H*delg)'/(delg'*H*delg);
                    case 9  % BFGS
                        H1 = H + (1+(delg'*H*delg)/(delg'*delx))*(delx*delx')/(delx'*delg) - ...
                            (H*delg*delx'+(H*delg*delx')')/(delg'*delx);
                end
                k = k+1;
                if rem(k,6)==0
                    H1 = eye(2);
                end
                H = H1;
                g = g1;
                d = -H*g;
                xd = get(l,'xdata'); yd=get(l,'ydata');
                set(l,'xdata',[xd(:); x(1)],'ydata',[yd(:); x(2)])
                
                % iteration|[Xk] | f(Xk)| g(Xk)
                fprintf(fileID, frmt,...
                    k, x(1), x(2), feval(get_fname, x), g(1), g(2));
                drawnow
                if ~isempty(get(Pushbutton1_h,'userdata'))
                    break
                end
                
            end
        case 10  % newton
            k=0;
            x = [get(h,'xdata'); get(h,'ydata')];
            set(l,'xdata',x(1),'ydata',x(2))
            %g = g_rosenb(x)
            g = feval(get_gname, x);
            %d = -inv(H_rosenb(x))*g;
            d = -inv(feval(get_Fname,x))*g;
            while norm(g)>1e-6
                set(iter_h,'string',num2str(k))
                %set(f_h,'string',num2str(optimgui('f_rosenb',x)))
                set(f_h,'string',num2str(optimgui(get_fname,x)))
                
                %alpha=linesearch_secant('g_rosenb',x,d);
                alpha=linesearch_secant(get_gname,x,d);
                x = x + alpha*d;
                
                %g = g_rosenb(x);
                g = feval(get_gname, x);
                %d = -inv(H_rosenb(x))*g;
                d = -inv(feval(get_Fname, x))*g;
                
                xd = get(l,'xdata'); yd=get(l,'ydata');
                set(l,'xdata',[xd(:); x(1)],'ydata',[yd(:); x(2)])
                k=k+1;
                
                fprintf(fileID, frmt,...
                    k, x(1), x(2), feval(get_fname, x), g(1), g(2));                
                drawnow
                if ~isempty(get(Pushbutton1_h,'userdata'))
                    break
                end
            end
    end
    fclose(fileID);
    set(Pushbutton1_h,'visible','off','userdata',[])
    set(h,'buttondownfcn','optimgui(''startdown'')')
    set([x0 y0],'enable','on')
    if am==1
        set([step_h steplabel_h],'enable','on')
    else
        set([step_h steplabel_h],'enable','off')
    end
    
    
    
%------------------------------------------------------------
function stop
    Pushbutton1_h = findobj(gcf,'tag','Pushbutton1');
    set(Pushbutton1_h,'userdata','stop')
    
%------------------------------------------------------------
function f=f_rosenb(x)
% rosenblatt's "banana" function
f = 100*(x(2,:)-x(1,:).^2).^2+(1-x(1,:)).^2;
    
    
function g=g_rosenb(x)
% Gradient of rosenblatt's "banana" function
    g = [-400*(x(2,:)-x(1,:).^2).*x(1,:)-2*(1-x(1,:));
        200*(x(2,:)-x(1,:).^2) ];
    
function H=H_rosenb(x)
    % Hessian of rosenblatt's "banana" function
    H = [-400*(x(2,:)-3*x(1,:).^2)+2    -400*x(1,:);
        -400*x(1,:)   200];
    
%%
%------------------------------------------------------------
%%Line search algorithms
    
function [a c b] = bracket(func, grad,x, alpha)
    % a: left bracket, b: right bracket, c: intermediate node
    epsilon = alpha;
    a = x;
    c = a;
    d = feval(grad, x);
    b = x - epsilon * d/norm(d);
    
    res = realmax;
    while res > feval(func, b)
        res = feval(func, b);
        a = c;
        c = b;
        d = feval(grad, b);
        b = b - epsilon * d/norm(d);
        epsilon = epsilon * 2;
    end
    
function [a c b] = bracket_alpha(func, x, epsilon, d)
    % one dimensional line search for alpha
    d = d/norm(d);
    %initially alpha is in range [a=0, b=epsilon]
    a = 0;
    c = 0;
    b = epsilon;
    p = epsilon*d; % using this to increase speed
    
    res = realmax;
    while res > feval(func, x+p)
        res = feval(func, x+p);
        a = c;
        c = b;
        b = b+b;
        p = p+p;
        %epsilon = epsilon * 2;
    end
    
%------------------------------------------------------------
function varargout=linesearch(varargin)
% linesearch('secant', grad, x,d);
    % linesearch('fibonacci', func, x, d, alpha0, alpha1, N);
    if nargin == 0
        disp('Wrong number of arguments passed to linesearch');
        return;
    end
    
    if strcmp(varargin{1}, 'secant')
        grad = varargin{2};
        x = varargin{3};
        d= varargin{4};
        alpha=linesearch_secant(grad,x,d);
        
    elseif strcmp(varargin{1}, 'fibonacci')
        %func = varargin{2};
        %a = varargin{3};
        %b = varargin{4};
        %n = varargin{5};
        %alpha=linesearch_fibonacci(func, a, b, n);
        alpha=linesearch_fibonacci(varargin{2:nargin});
    end
    varargout{1} = alpha;
    
    
function alpha=linesearch_secant(grad,x,d)
    %Line search using secant method
    %Note: I'm not checking for alpha > 0.
    
    epsilon=10^(-5); %line search tolerance
    max = 200; %maximum number of iterations
    alpha_curr=0;
    alpha=10^(-5);
    dphi_zero=feval(grad,x)'*d;
    dphi_curr=dphi_zero;
    
    i=0;
    while abs(dphi_curr)>epsilon*abs(dphi_zero),
        alpha_old=alpha_curr;
        alpha_curr=alpha;
        dphi_old=dphi_curr;
        dphi_curr=feval('optimgui',grad,x+alpha_curr*d)'*d;
        alpha=(dphi_curr*alpha_old-dphi_old*alpha_curr)/(dphi_curr-dphi_old);
        i=i+1;
        if (i >= max) & (abs(dphi_curr)>epsilon*abs(dphi_zero)),
            disp('Line search terminating with number of iterations:');
            disp(i);
            break;
        end
    end %while
    
%%------------------------------------------------------------
function init
    
    h0 = figure('Position',[176 62 672 646], ...
        'Tag','Fig1');
    mat3=[0.119047   0.1532507    0.77529 0.719814];
    
    h1 = axes('Parent',h0, ...
        'Position',mat3, ...
        'Tag','Axes1');
    
    mat60 = {  'Gradient, fixed step'    %1
        'Steepest Descent'               %2
        'CG: Hestenes-Stiefel'           %3
        'CG: Polak-Ribiere'              %4
        'CG: Fletcher-Reeves'            %5
        'CG: Powell'                     %6
        'Quasi-Newton: rank-1'           %7
        'Quasi-Newton: DFP'              %8
        'Quasi-Newton: BFGS'             %9
        'Newton''s Method'};             %10
    
    h1 = uicontrol('Parent',h0, ...
        'Units','normalized', ...
        'Callback','optimgui(''optimize'')', ...
        'FontSize',10, ...
        'FontWeight','bold', ...
        'ListboxTop',0, ...
        'Position',[0.3675595238095238 0.03869969040247678 0.3898809523809523 0.03095975232198142], ...
        'String',mat60, ...
        'Style','popupmenu', ...
        'Tag','PopupMenu1', ...
        'Value',1);
    
    h1 = uicontrol('Parent',h0, ...
        'Units','normalized', ...
        'Callback','optimgui(''setfunc'')', ...
        'FontSize',10, ...
        'FontWeight','bold', ...
        'ListboxTop',0, ...
        'Position',[0.1220238095238095 0.04024767801857585 0.1830357142857143 0.03095975232198142], ...
        'String',{'banana';'rastrigin';'peaks'}, ...
        'Style','popupmenu', ...
        'Tag','PopupMenu2', ...
        'Value',1);
    h1 = uicontrol('Parent',h0, ...
        'Units','normalized', ...
        'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
        'FontSize',10, ...
        'FontWeight','bold', ...
        'ListboxTop',0, ...
        'Position',[0.1339285714285714 0.9411764705882353 0.07291666666666666 0.03869969040247678], ...
        'String','X0', ...
        'Style','text', ...
        'Tag','StaticText1');
    h1 = uicontrol('Parent',h0, ...
        'Units','normalized', ...
        'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
        'FontSize',10, ...
        'FontWeight','bold', ...
        'ListboxTop',0, ...
        'Position',[0.130952380952381 0.8947368421052629 0.07291666666666666 0.03869969040247678], ...
        'String','Y0', ...
        'Style','text', ...
        'Tag','StaticText1');
    
    %This was excluded from the following: 'Callback','optimgui(''x0change'')', ...
    h1 = uicontrol('Parent',h0, ...
        'Units','normalized', ...
        'BackgroundColor',[1 1 1], ...
        'Callback','optimgui(''x0change'')', ...
        'FontSize',10, ...
        'FontWeight','bold', ...
        'ListboxTop',0, ...
        'Position',[0.21131      0.93808      0.23958       0.0387], ...
        'String','-1.2', ...
        'Style','edit', ...
        'Tag','x0');
    %This was excluded from the following: 'Callback','optimgui(''y0change'')', ...
    h1 = uicontrol('Parent',h0, ...
        'Units','normalized', ...
        'BackgroundColor',[1 1 1], ...
        'Callback','optimgui(''y0change'')', ...
        'FontSize',10, ...
        'FontWeight','bold', ...
        'ListboxTop',0, ...
        'Position',[ 0.21131      0.89474      0.23958       0.0387], ...
        'String','2', ...
        'Style','edit', ...
        'Tag','y0');
    h1 = uicontrol('Parent',h0, ...
        'Units','normalized', ...
        'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
        'Enable','inactive', ...
        'FontSize',10, ...
        'FontWeight','bold', ...
        'ListboxTop',0, ...
        'Position',[0.6205357142857143 0.8947368421052631 0.2410714285714286 0.03869969040247678], ...
        'String','2.1895', ...
        'Style','edit', ...
        'Tag','f');
    h1 = uicontrol('Parent',h0, ...
        'Units','normalized', ...
        'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
        'Enable','inactive', ...
        'FontSize',10, ...
        'FontWeight','bold', ...
        'ListboxTop',0, ...
        'Position',[0.6205357142857143 0.9380804953560371 0.2410714285714286 0.03869969040247678], ...
        'String','0', ...
        'Style','edit', ...
        'Tag','iter');
    h1 = uicontrol('Parent',h0, ...
        'Units','normalized', ...
        'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
        'FontSize',10, ...
        'FontWeight','bold', ...
        'ListboxTop',0, ...
        'Position',[0.4672619047619048 0.8947368421052629 0.1488095238095238 0.03869969040247678], ...
        'String','f(Xn)', ...
        'Style','text', ...
        'Tag','StaticText1');
    h1 = uicontrol('Parent',h0, ...
        'Units','normalized', ...
        'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
        'FontSize',10, ...
        'FontWeight','bold', ...
        'ListboxTop',0, ...
        'Position',[0.4672619047619048 0.9380804953560373 0.1488095238095238 0.03869969040247678], ...
        'String','Iterations', ...
        'Style','text', ...
        'Tag','StaticText1');
    h1 = uicontrol('Parent',h0, ...
        'Units','normalized', ...
        'BackgroundColor',[1 1 1], ...
        'Callback','optimgui(''optimize'')', ...
        'FontSize',10, ...
        'FontWeight','bold', ...
        'ListboxTop',0, ...
        'Position',[0.7901785714285714 0.02631578947368422 0.1904761904761905 0.03869969040247678], ...
        'String','.001', ...
        'Style','edit', ...
        'Tag','step');
    h1 = uicontrol('Parent',h0, ...
        'Units','normalized', ...
        'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
        'FontSize',10, ...
        'FontWeight','bold', ...
        'ListboxTop',0, ...
        'Position',[0.79018     0.066563      0.16964       0.0387], ...
        'String','Step size:', ...
        'Style','text', ...
        'Tag','steplabel');
    h1 = uicontrol('Parent',h0, ...
        'Units','points', ...
        'Callback','optimgui(''stop'')', ...
        'FontSize',10, ...
        'FontWeight','bold', ...
        'ListboxTop',0, ...
        'Position',[286.7586206896552 82.55172413793105 54.62068965517243 21.72413793103449], ...
        'String','STOP', ...
        'Tag','Pushbutton1', ...
        'Visible','off');

%%
%Global variables
function set_fname(value)
    global fname
    fname=value;
function r = get_fname
    global fname
    r=fname;
    
function set_gname(value)
    global g__name
    g__name=value;
function r = get_gname
    global g__name
    r=g__name;
    
function set_Fname(value)
    global Fname
    Fname=value;
function r = get_Fname
    global Fname
    r=Fname;
    
function set_outfile(value)
    global outfile
    outfile=value;
function r = get_outfile
    global outfile
    r=outfile;
%%