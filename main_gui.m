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

% Last Modified by GUIDE v2.5 02-May-2013 14:55:21

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
hGuiStore.hListbox = findobj(gcf,'Tag','listbox_obj_browser');
hGuiStore.hAx(1) = findobj(gcf,'Tag','axes_main');
hGuiStore.itemNames = cell(1,1)
hGuiStore.itemNames(1,1) = cellstr('root')
hGuiStore.cnt = 1;
set(hGuiStore.hListbox, 'String', hGuiStore.itemNames)

% Updates hGuiStore structure
guidata(gcf, hGuiStore);




% --- Outputs from this function are returned to the command line.
function varargout = main_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


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

valArray = importdata('C:\Users\Avizo\Documents\MATLAB\CRD\Ascii_export_v1.txt',delimiterIn,headerlinesIn);
col_size = size(valArray.data,2);   %size of second dimension (column count)
disp(col_size)

% Store or retrieve GUI data
hGuiStore = guidata(gcf);
hGuiStore.mat(1) = vec2mat(valArray.data, col_size);
guidata(gcf, hGuiStore);
displaydata(hGuiStore);
addData(hGuiStore);


%msgbox('Disabled! Data already imported.','Information','warn','modal'); 

function displaydata(data)
mesh(data.mat(:, 5:end)); view(2)

% add data to Object
function addData(data)
hGuiStore= guidata(gcf);
l = numel(get(data.hListbox, 'String'));
for i=1:l
    if i == l
        hGuiStore.itemNames(i+1,1) = num2cell(i);
        guidata(gcf, hGuiStore)
        set(hGuiStore.hListbox, 'String', hGuiStore.itemNames)    
    end
end
guidata(gcf, hGuiStore)


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

