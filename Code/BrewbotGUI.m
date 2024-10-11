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

% Last Modified by GUIDE v2.5 01-Oct-2024 19:28:25

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

 % Initialize Robot Model
[handles.espressoman, handles.milkman] = EnvSetup;

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

disp("Making espresso")
espresso_test(handles.espressoman)



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
disp("Making latte")
latte_test(handles.espressoman)


% --- Executes on button press in btn_icedcoffee.
function btn_icedcoffee_Callback(hObject, eventdata, handles)
% hObject    handle to btn_icedcoffee (see GCBO)
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
disp("Emergency stop")


% --- Executes on button press in btn_close.
function btn_close_Callback(hObject, eventdata, handles)
% hObject    handle to btn_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp("Request to close GUI")
close
