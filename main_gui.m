function varargout = main_gui(varargin)
% MAIN_GUI MATLAB code for main_gui.fig
%      MAIN_GUI, by itself, creates a new MAIN_GUI or raises the existing
%      singleton*.
%
%      H = MAIN_GUI returns the handle to a new MAIN_GUI or the handle to
%      the existing singleton*.
%
%      MAIN_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN_GUI.M with the given input arguments.
%
%      MAIN_GUI('Property','Value',...) creates a new MAIN_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main_gui

% Last Modified by GUIDE v2.5 14-May-2013 16:40:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @main_gui_OutputFcn, ...
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


% --- Executes just before main_gui is made visible.
function main_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main_gui (see VARARGIN)

% Choose default command line output for main_gui
handles.output = hObject;

% Updates handle structure
guidata(hObject, handles);

% UIWAIT makes main_gui wait for user response (see UIRESUME)
% uiwait(handles.figure_main);

function init()

hGuiStore.hListbox = findobj(gcf,'Tag','listbox_obj_browser');
hGuiStore.hAx = findobj(gcf,'Tag','axes_main');
hGuiStore.itemNames = cell(1,1)
hGuiStore.itemNames(1,1) = cellstr('root')
hGuiStore.cnt = 1;
set(hGuiStore.hListbox, 'String', hGuiStore.itemNames)

% Updates hGuiStore structure
guidata(gcf, hGuiStore);


function startJava3D(data)

if ~IsJava3DInstalled(true)
    return
end
% Z = membrane(1,25);
Z = mat2dataset(data);
Imin = min(Z(:));
Imax = max(Z(:));
I = uint8( 200 * (Z-Imin) / (Imax-Imin) );
Miji(false);
imp = MIJ.createImage('MATLAB peaks', I, false);
universe = ij3d.Image3DUniverse();
universe.show();
color = javax.vecmath.Color3f(240 / 255, 120 / 255, 20 / 255);
c = universe.addSurfacePlot(imp, ...
        javax.vecmath.Color3f(), ...
        'Matlab Peak in 3D', ...
        1, ...
        [true true true], ...
        1);
universe.resetView();
c.setColor(color);
c.setTransform([1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1]);
universe.fireContentChanged(c);
universe.centerSelected(c);
universe.rotateUniverse(javax.vecmath.Vector3d(-1, -0.5, +0.2), +120 * pi / 180);    


% --- Outputs from this function are returned to the command line.
function varargout = main_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
init();
% Get default command line output from handles structure
varargout{1} = handles.output;

% set(0, 'DefaultFigureRenderer', 'OpenGL');
% set(gcf, 'Renderer','OpenGL');
% set(gcf,'RendererMode','manual')
% opengl hardware 
opengl info


% --- Executes on button press in pushbtn_open.
function pushbtn_open_Callback(hObject, eventdata, handles)
% hObject    handle to pushbtn_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delimiterIn = '\t';
headerlinesIn = 18;

% [filename, pathname] = uigetfile({'*.txt'},'File Selector');
% valArray = importdata(fullfile(pathname, filename),delimiterIn,headerlinesIn);
% col_size = size(valArray.data,2);
% hGuiStore.mat = vec2mat(valArray.data, col_size);
% guidata(gcf,hGuiStore);

valArray = importdata('C:\Users\Avizo\Documents\MATLAB\Ascii_export_v1.txt',delimiterIn,headerlinesIn);
col_size = size(valArray.data,2);   %size of second dimension (column count)
disp(col_size)

% Store or retrieve GUI data
hGuiStore = guidata(gcf);
hGuiStore.mat = vec2mat(valArray.data, col_size);
hGuiStore.mat = hGuiStore.mat(:,5:end);
hGuiStore.root = hGuiStore.mat;
hGuiStore.matPreview = imresize(hGuiStore.mat, [200 200]);
guidata(gcf, hGuiStore);
displaydata(hGuiStore);
addData(hGuiStore);
%guidata(gcf, hGuiStore);
%msgbox('Disabled! Data already imported.','Information','warn','modal'); 


function displaydata(data)
hGuiStore = guidata(gcf);
hGuiStore.hMesh = mesh(data.hAx, data.mat); view(2);
guidata(gcf, hGuiStore);
% startJava3D(data.mat);



% add data to Object
function addData(data)
hGuiStore = guidata(gcf)
l = numel(get(data.hListbox, 'String'));
for i=1:l
    if i == l
        hGuiStore.itemNames(i+1,1) = num2cell(i);
        guidata(gcf, hGuiStore)
        set(hGuiStore.hListbox, 'String', hGuiStore.itemNames)    
    end
end
guidata(gcf, hGuiStore);


% --- Executes on selection change in listbox_obj_browser.
function listbox_obj_browser_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_obj_browser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_obj_browser contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_obj_browser
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function listbox_obj_browser_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_obj_browser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when figMain is resized.
function figure_main_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to main_fig (see GclcCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hGuiStore = guidata(gcf)
addData(hGuiStore);

% guidata(gcf, hGuiStore) 
% supresses hGuiStore update inside called function


% --- Executes on mouse press over axes background.
function axes_main_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes_main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over figure background.
function figure_main_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure_main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure_main_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure_main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hGuiStore = guidata(gcf)



if (gco == hGuiStore.hMesh || gco == hGuiStore.hAx) && strcmp(get(gcf,'SelectionType'),'normal')
    mesh(hGuiStore.hAx, hGuiStore.matPreview); view(2)
else
    mesh(hGuiStore.hAx, hGuiStore.mat);
end

guidata(gcf, hGuiStore);


% --- Executes on key release with focus on figure_main and none of its controls.
function figure_main_KeyReleaseFcn(hObject, eventdata, handles)
% hObject    handle to figure_main (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was released, in lower case
%	Character: character interpretation of the key(s) that was released
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) released
% handles    structure with handles and user data (see GUIDATA)

