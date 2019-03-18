function varargout = ravens(varargin)
% RAVENS Ravens Matrix solver using Vector Symbolic Architectures


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @ravens_OpeningFcn, ...
    'gui_OutputFcn',  @ravens_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% Callbacks ---------------------------------------------------------------

% --- Executes just before ravens is made visible.
function ravens_OpeningFcn(hObject, eventdata, handles, varargin)

set(gcf, 'Name', 'Ravens Matrices with VSA')

% Start with Circles
set(handles.circle_radiobutton, 'Value', 1)

% Start with empty matrix
reset(handles)

% Choose default command line output for ravens
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = ravens_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% Pushbutton callbacks ----------------------------------------------------

function solve_pushbutton_Callback(hObject, eventdata, handles)
matrix = get(gcf, 'UserData');
set(gcf, 'UserData', solveravens(get(gcf, 'UserData')));
draw_matrix

function reset_pushbutton_Callback(hObject, eventdata, handles)
reset(handles)
draw_matrix


% Radiobutton callbacks ---------------------------------------------------

function circle_radiobutton_Callback(hObject, eventdata, handles)
turnoff(handles.diamond_radiobutton)
turnoff(handles.triangle_radiobutton)

function triangle_radiobutton_Callback(hObject, eventdata, handles)
turnoff(handles.circle_radiobutton)
turnoff(handles.diamond_radiobutton)


function diamond_radiobutton_Callback(hObject, eventdata, handles)
turnoff(handles.circle_radiobutton)
turnoff(handles.triangle_radiobutton)

% Callback for clicks on matrix -------------------------------------------

function axes1_ButtonDownFcn(hObject, eventdata, handles)

% Convert cursor position to row, column
pt = get(gca,'CurrentPoint');
row = coord2index(1-pt(1,2));
col = coord2index(pt(1,1));

% Lower-right is reserved
if row == 3 && col == 3
    return
end

% Grab current matrix from figure
matrix = get(gcf, 'UserData');

% Left or right mouse button?
mousebutton = get(gcf, 'SelectionType');

% Left: add to cell
if strcmp(mousebutton, 'normal')
    
    celli = matrix{row, col};
    
    % Cell is empty: initialize it with shape
    if isempty(celli)
        
        % Grab active shape from radiobuttons
        shape = 'D';
        if ison(handles.circle_radiobutton)
            shape = 'C';
        elseif ison(handles.triangle_radiobutton)
            shape = 'T';
        end
        
        matrix{row,col} = shape;
        
        % Cell not empty: add from current shape
    else
        
        shape = celli(1);
        
        % Max three shapes per cell
        if length(celli) < 3
            celli = [celli shape];
        end
        
        matrix{row, col} = celli;
        
    end
    
    
    % Right: erase cell
elseif strcmp(mousebutton, 'alt')
    matrix{row, col} = '';
end

% Save matrix back to figure
set(gcf, 'UserData', matrix)

% Enable solving when enough cells are filled
ready = 'off';
if nnz(cellfun(@nnz,matrix)) == 8
    ready = 'on';
end
set(handles.solve_pushbutton, 'Enable', ready)

% Redraw the matrix
draw_matrix



% Helpers -----------------------------------------------------------------

function turnoff(radiobutton)
set(radiobutton, 'Value', 0)

function yn = ison(radiobutton)
yn = get(radiobutton, 'Value');

function k = coord2index(c)
k = fix(3 * c + 1);



function draw_matrix

SIZE = .0375;

matrix = get(gcf, 'UserData');

cla
hold on

for j = 1:3
    for k = 1:3
        celli = matrix{j,k};
        
        y = (3-j)/3 + 1/6;
        x = (k - 1)/3;
        
        for c = celli
            
            x = x + 1/(length(celli)+1)/3;
            
            switch c
                case 'D'
                    siz = SIZE * 1.125; % Diamonds appear small otherwise
                    xs = [x-siz x      x+siz x];
                    ys = [y     y+siz  y     y-siz];
                case 'T'
                    xs = [x-SIZE x+SIZE x];
                    ys = [y-SIZE y-SIZE y+SIZE];
                case 'C'
                    theta = linspace(0, 2*pi, 1000);
                    xs = x + SIZE * cos(theta);
                    ys = y + SIZE * sin(theta);
            end
            
            fill(xs, ys, 'k')
            
        end
    end
end

xlim([0,1])
ylim([0,1])
axis('square')


function reset(handles)
set(gcf, 'UserData', cell(3,3))
set(handles.solve_pushbutton, 'Enable', 'off')
