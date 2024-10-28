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
    
    % Last Modified by GUIDE v2.5 29-Oct-2024 01:26:36
    
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
    
    try
        availablePorts = serialportlist; % Get list of available serial ports
        if ismember('COM4', availablePorts) % Replace 'COM4' with the correct port for Arduino
            arduinoBoard = arduino('COM4', 'Uno', 'Libraries', 'Servo');  % Arduino is connected
            handles.isArduinoConnected = true;
            disp('Arduino connected successfully.');
        else
            handles.isArduinoConnected = false;
            arduinoBoard = [];
            disp('Arduino not connected.');
        end
    catch
        handles.isArduinoConnected = false;
        arduinoBoard = [];
        disp('Error: Unable to connect to Arduino.');
    end

    % Initialize the Environment class
    env = EnvSetup();
    
    % Access environment objects
    nova2 = env.nova2;
    ur3e = env.ur3e;
    cup = env.cup;
    cupLid = env.cupLid;
    milkJug = env.milkJug;
    portafilter = env.portafilter;
    teaBag = env.teaBag;
    cupWithLid = env.cupWithLid;
    
    % Create instance of movement class and inject robot objects and Arduino object
    handles.movement = BrewBotMovements(nova2, ur3e, cup, cupLid, milkJug, portafilter, teaBag, cupWithLid, arduinoBoard);
    
    % Create empty list of orders
    handles.order_list = strings(0);
    handles.isBrewing = false;
    
    handles.isStopped = false; % flag for e-stop, set to false initially
    set(handles.btn_reset, "Enable", "off"); % deactivate reset button
    set(handles.btn_resume, "Enable", "off"); % deactivate resume button
    
    % Update handles structure
    guidata(hObject, handles);


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
    % Add Espresso to list of orders
    handles.order_list(end+1) = "Espresso";
    guidata(hObject, handles);
    handles.movement.handleOrder(hObject);



% --- Executes on button press in btn_flatwhite.
function btn_flatwhite_Callback(hObject, eventdata, handles)
    % Add Flat white to list of orders
    handles.order_list(end+1) = "Flat white";
    guidata(hObject, handles);
    handles.movement.handleOrder(hObject);


% --- Executes on button press in btn_latte.
function btn_latte_Callback(hObject, eventdata, handles)
    % Add Latte to list of orders
    handles.order_list(end+1) = "Latte";
    guidata(hObject, handles);
    handles.movement.handleOrder(hObject);


% --- Executes on button press in btn_icecoffee.
function btn_icecoffee_Callback(hObject, eventdata, handles)
    % Add Ice coffee to list of orders
    handles.order_list(end+1) = "Ice coffee";
    guidata(hObject, handles);
    handles.movement.handleOrder(hObject);


% --- Executes on button press in btn_tea.
function btn_tea_Callback(hObject, eventdata, handles)
    % Add Tea to list of orders
    handles.order_list(end+1) = "Tea";
    guidata(hObject, handles);
    handles.movement.handleOrder(hObject);


% --- Executes on button press in btn_emstop.
function btn_emstop_Callback(hObject, eventdata, handles)
    
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
    
    % Enable reset button
    set(handles.btn_reset, "Enable", "on");
    set(handles.btn_resume, "Enable", "on");


% --- Executes on button press in btn_reset.
function btn_reset_Callback(hObject, eventdata, handles)
    handles.isStopped = false;
    
    % Reset movable objects in the environment
    if isfield(handles, 'env') && ~isempty(handles.env)
        handles.env = handles.env.initialEnvironment();  % Call the reset method
    end
    
    % Bring Brewbot to default position
    handles.isBrewing = false;
    handles.order_list = strings(0);
    guidata(hObject, handles);
    handles.movement.resetRobots();
    handles.movement.updateOrderListDisplay(hObject)
    
    % Enable menu options buttons again
    set(handles.btn_espresso, "Enable", "on");
    set(handles.btn_flatwhite, "Enable", "on");
    set(handles.btn_latte, "Enable", "on");
    set(handles.btn_icecoffee, "Enable", "on");
    set(handles.btn_tea, "Enable", "on");
    
    % Disable reset and resume buttons
    set(handles.btn_reset, "Enable", "off");
    set(handles.btn_resume, "Enable", "off");

    disp("System reset to default state.");



function ordersTxt_Callback(hObject, eventdata, handles)
    % hObject    handle to ordersTxt (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of ordersTxt as text
    %        str2double(get(hObject,'String')) returns contents of ordersTxt as a double


% --- Executes during object creation, after setting all properties.
function ordersTxt_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to ordersTxt (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on button press in btn_resume.
function btn_resume_Callback(hObject, eventdata, handles)
% hObject    handle to btn_resume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.isStopped = false;
    guidata(hObject, handles);
    
    % Enable menu options buttons again
    set(handles.btn_espresso, "Enable", "on");
    set(handles.btn_flatwhite, "Enable", "on");
    set(handles.btn_latte, "Enable", "on");
    set(handles.btn_icecoffee, "Enable", "on");
    set(handles.btn_tea, "Enable", "on");
    
    % Disable reset and resume buttons
    set(handles.btn_reset, "Enable", "off");
    set(handles.btn_resume, "Enable", "off");

    disp("System resumed.");
