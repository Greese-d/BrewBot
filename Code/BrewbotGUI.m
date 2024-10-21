function varargout = BrewbotGUI(varargin)
% BREWBOTGUI MATLAB code for BrewbotGUI.fig
%      BREWBOTGUI, by itself, creates a new BREWBOTGUI or raises the existing
%      singleton*.
%
%      H = BREWBOTGUI returns the handle to a new BREWBOTGUI or the handle to
%      the existing singleton*.
%
%      BREWBOTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BREWBOTGUI.M with the given input arguments.
%
%      BREWBOTGUI('Property','Value',...) creates a new BREWBOTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BrewbotGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BrewbotGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BrewbotGUI

% Last Modified by GUIDE v2.5 15-Oct-2024 12:42:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BrewbotGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @BrewbotGUI_OutputFcn, ...
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


% --- Executes just before BrewbotGUI is made visible.
function BrewbotGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BrewbotGUI (see VARARGIN)

% Choose default command line output for BrewbotGUI
handles.output = hObject;

 % Initialize Robot Models
[nova2, ur3e] = EnvSetup; % create environment, stash robot objects
arduinoBoard = arduino('COM4', 'Uno', 'Libraries', 'Servo');  % Replace 'COM3' with the correct port

% Create instance of movement class and inject robot objects and Arduino object
handles.movement = BrewbotTestMovements(nova2, ur3e, arduinoBoard);

handles.isStopped = false; % flag for e-stop, set to false initially
set(handles.btn_reset, "Enable", "off"); % deactivate reset button

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BrewbotGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BrewbotGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_espresso.
function btn_espresso_Callback(hObject, eventdata, handles)
% hObject    handle to btn_espresso (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Execture espresso-making function
disp("Making espresso")
handles.movement.espresso_test(hObject); %test function for simple movement



% --- Executes on button press in btn_flatwhite.
function btn_flatwhite_Callback(hObject, eventdata, handles)
% hObject    handle to btn_flatwhite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp("Making flat white")


% --- Executes on button press in btn_latte.
function btn_latte_Callback(hObject, eventdata, handles)
% hObject    handle to btn_latte (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Execute latte-making function
disp("Making latte")
handles.movement.latte_test(hObject); %test function for simple movement


% --- Executes on button press in btn_icecoffee.
function btn_icecoffee_Callback(hObject, eventdata, handles)
% hObject    handle to btn_icecoffee (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp("Making iced coffee")


% --- Executes on button press in btn_tea.
function btn_tea_Callback(hObject, eventdata, handles)
% hObject    handle to btn_tea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp("Making tea")


% --- Executes on button press in btn_emstop.
function btn_emstop_Callback(hObject, eventdata, handles)
% hObject    handle to btn_emstop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Changes e-stop flag to true
disp("Emergency stop")
handles.isStopped = true;
guidata(hObject, handles);

% Disables menu options buttons
set(handles.btn_espresso, "Enable", "off")
set(handles.btn_flatwhite, "Enable", "off")
set(handles.btn_latte, "Enable", "off")
set(handles.btn_icecoffee, "Enable", "off")
set(handles.btn_tea, "Enable", "off")

% Enables reset button
set(handles.btn_reset, "Enable", "on");


% --- Executes on button press in btn_close.
function btn_close_Callback(hObject, eventdata, handles)
% hObject    handle to btn_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp("Request to close GUI")
close


% --- Executes on button press in btn_reset.
function btn_reset_Callback(hObject, eventdata, handles)
% hObject    handle to btn_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.isStopped = false;
handles.movement.resetRobots();
guidata(hObject, handles);

% Enable menu options buttons again
set(handles.btn_espresso, "Enable", "on");
set(handles.btn_flatwhite, "Enable", "on");
set(handles.btn_latte, "Enable", "on");
set(handles.btn_icecoffee, "Enable", "on");
set(handles.btn_tea, "Enable", "on");

% Disable reset buttons
set(handles.btn_reset, "Enable", "off");

disp("System reset to default state.");

