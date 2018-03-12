function varargout=hw3(varargin)

[varargout{1:nargout}] = varargin{:};

set_fname('f_rastrigin');
set_gname('g_rastrigin');
set_Fname('H_rastrigin');
            
x=-3:.05:3;
y=-3:.05:3;

[X,Y]=meshgrid(x,y);
f=feval(get_fname,[X(:)';  Y(:)']);
hold off;
f=reshape(f,length(y),length(x));
contour(x,y,f,[1 3 7 16 32 64 128])
hold on;
xlabel('x_1')
ylabel('x_2')
%title('Minimization of Rosenbrock function')
plot(1,1,'o')
text(1,1,'Solution')
grid on
l = line(-1.2,2,'erasemode','xor','marker','o','linewidth',1.5,'color','r');
assignin('base','l',l)
h = line(-1.2,2,'erasemode','xor','linestyle','none','marker','x',...
 'markersize',14,'linewidth',1.5,'buttondownfcn','optimgui(''startdown'')');
assignin('base','h',h)
%end % function hw3

%%Global variables
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
