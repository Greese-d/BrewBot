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
    
    % Last Modified by GUIDE v2.5 30-Oct-2024 02:44:20
    
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

    
    % Create instance of movement class and inject robot objects and Arduino object
    handles.movement = BrewBotMovements(env, arduinoBoard);
    
    % Create empty list of orders
    handles.order_list = strings(0);
    handles.isBrewing = false;
    
    handles.isStopped = false; % flag for e-stop, set to false initially
    set(handles.btn_reset, "Enable", "off"); % deactivate reset button
    set(handles.btn_resume, "Enable", "off"); % deactivate resume button
    showTeachOff(handles)
    handles.isTeachOn = false;

    % UR3e sliders (q1_ur3e to q6_ur3e)
    for i = 1:6
        sliderName = sprintf('q%d_ur3e', i);  % Slider name (q1_ur3e, q2_ur3e, etc.)
        set(handles.(sliderName), 'Callback', @(src,~) updateJointAngle(handles, 'ur3e', i, src.Value));
        qlim = handles.movement.ur3e.model.qlim(i, :);
        set(handles.(sliderName), 'Min', qlim(1), 'Max', qlim(2));
    end

    % Nova2 sliders (q1_nova2 to q2_nova2)
    for i = 1:6
        sliderName = sprintf('q%d_nova2', i);  % Slider name (q1_nova2, q2_nova2)
        set(handles.(sliderName), 'Callback', @(src,~) updateJointAngle(handles, 'nova2', i, src.Value));
        qlim = handles.movement.nova2.model.qlim(i, :);
        set(handles.(sliderName), 'Min', qlim(1), 'Max', qlim(2));
    end

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
    handles.movement.handleEmergency(hObject);
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
    handles.order_list = strings(0);
    guidata(hObject, handles);
    handles.movement.handleReset(hObject);
    handles.movement.updateOrderListDisplay(hObject);
    
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
    
    % Enable menu options buttons again
    set(handles.btn_espresso, "Enable", "on");
    set(handles.btn_flatwhite, "Enable", "on");
    set(handles.btn_latte, "Enable", "on");
    set(handles.btn_icecoffee, "Enable", "on");
    set(handles.btn_tea, "Enable", "on");
    
    % Disable reset and resume buttons
    set(handles.btn_reset, "Enable", "off");
    set(handles.btn_resume, "Enable", "off");

    handles.isStopped = false;
    guidata(hObject, handles);
    handles.movement.handleResume(hObject);
    
    disp("System resumed.");


% --- Executes on slider movement.
function q1_ur3e_Callback(hObject, eventdata, handles)
% hObject    handle to q1_ur3e (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function q1_ur3e_CreateFcn(hObject, eventdata, handles)
% hObject    handle to q1_ur3e (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function q3_ur3e_Callback(hObject, eventdata, handles)
% hObject    handle to q3_ur3e (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function q3_ur3e_CreateFcn(hObject, eventdata, handles)
% hObject    handle to q3_ur3e (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function q4_ur3e_Callback(hObject, eventdata, handles)
% hObject    handle to q4_ur3e (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function q4_ur3e_CreateFcn(hObject, eventdata, handles)
% hObject    handle to q4_ur3e (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function q2_ur3e_Callback(hObject, eventdata, handles)
% hObject    handle to q2_ur3e (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function q2_ur3e_CreateFcn(hObject, eventdata, handles)
% hObject    handle to q2_ur3e (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function q5_ur3e_Callback(hObject, eventdata, handles)
% hObject    handle to q5_ur3e (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function q5_ur3e_CreateFcn(hObject, eventdata, handles)
% hObject    handle to q5_ur3e (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function q6_ur3e_Callback(hObject, eventdata, handles)
% hObject    handle to q6_ur3e (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function q6_ur3e_CreateFcn(hObject, eventdata, handles)
% hObject    handle to q6_ur3e (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function q1_nova2_Callback(hObject, eventdata, handles)
% hObject    handle to q1_nova2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function q1_nova2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to q1_nova2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function q2_nova2_Callback(hObject, eventdata, handles)
% hObject    handle to q2_nova2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function q2_nova2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to q2_nova2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function q3_nova2_Callback(hObject, eventdata, handles)
% hObject    handle to q3_nova2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function q3_nova2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to q3_nova2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function q4_nova2_Callback(hObject, eventdata, handles)
% hObject    handle to q4_nova2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function q4_nova2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to q4_nova2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function q5_nova2_Callback(hObject, eventdata, handles)
% hObject    handle to q5_nova2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function q5_nova2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to q5_nova2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function q6_nova2_Callback(hObject, eventdata, handles)
% hObject    handle to q6_nova2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function q6_nova2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to q6_nova2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function x_ur3e_Callback(hObject, eventdata, handles)
% hObject    handle to x_ur3e (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_ur3e as text
%        str2double(get(hObject,'String')) returns contents of x_ur3e as a double


% --- Executes during object creation, after setting all properties.
function x_ur3e_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_ur3e (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y_ur3e_Callback(hObject, eventdata, handles)
% hObject    handle to y_ur3e (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_ur3e as text
%        str2double(get(hObject,'String')) returns contents of y_ur3e as a double


% --- Executes during object creation, after setting all properties.
function y_ur3e_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_ur3e (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function z_ur3e_Callback(hObject, eventdata, handles)
% hObject    handle to z_ur3e (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z_ur3e as text
%        str2double(get(hObject,'String')) returns contents of z_ur3e as a double


% --- Executes during object creation, after setting all properties.
function z_ur3e_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_ur3e (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x_nova2_Callback(hObject, eventdata, handles)
% hObject    handle to x_nova2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_nova2 as text
%        str2double(get(hObject,'String')) returns contents of x_nova2 as a double


% --- Executes during object creation, after setting all properties.
function x_nova2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_nova2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y_nova2_Callback(hObject, eventdata, handles)
% hObject    handle to y_nova2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_nova2 as text
%        str2double(get(hObject,'String')) returns contents of y_nova2 as a double


% --- Executes during object creation, after setting all properties.
function y_nova2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_nova2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function z_nova2_Callback(hObject, eventdata, handles)
% hObject    handle to z_nova2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z_nova2 as text
%        str2double(get(hObject,'String')) returns contents of z_nova2 as a double


% --- Executes during object creation, after setting all properties.
function z_nova2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_nova2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_teach.
function btn_teach_Callback(hObject, eventdata, handles)
% hObject    handle to btn_teach (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.isTeachOn 
    handles.isTeachOn = false;
    showTeachOff(handles);
    guidata(hObject, handles)
else
 handles.isTeachOn = true;
 showTeachOn(handles);
 guidata(hObject, handles)
end


function showTeachOff(handles)
for i = 1:6
    sliderName = sprintf('q%d_ur3e', i);  % Generate names q1_ur3e, q2_ur3e, ..., q6_ur3e
    set(handles.(sliderName), 'Visible', 'off');
    set(handles.(['q', num2str(i), 's_ur3e']), 'Visible', 'off');
end

% Disable sliders for nova2 (q1_nova2 to q2_nova2)
for i = 1:6
    sliderName = sprintf('q%d_nova2', i);  % Generate names q1_nova2 and q2_nova2
    set(handles.(sliderName), 'Visible', 'off');
    set(handles.(['q', num2str(i), 's_nova2']), 'Visible', 'off');
    
end

% Disable text fields for UR3e (x_ur3e, y_ur3e, z_ur3e)
textFieldsUR3e = {'x_ur3e', 'y_ur3e', 'z_ur3e'};
for i = 1:length(textFieldsUR3e)
    set(handles.(textFieldsUR3e{i}), 'Visible', 'off');
end

% Disable text fields for nova2 (x_nova2, y_nova2, z_nova2)
textFieldsNova2 = {'x_nova2', 'y_nova2', 'z_nova2'};
for i = 1:length(textFieldsNova2)
    set(handles.(textFieldsNova2{i}), 'Visible', 'off');
end

for i = 5:24
    set(handles.(['text', num2str(i)]), 'Visible', 'off');
end

set(handles.btn_espresso, "Visible", "on")
set(handles.btn_flatwhite, "Visible", "on")
set(handles.btn_latte, "Visible", "on")
set(handles.btn_icecoffee, "Visible", "on")
set(handles.btn_tea, "Visible", "on")


function showTeachOn(handles)
for i = 1:6
    sliderName = sprintf('q%d_ur3e', i);  % Generate names q1_ur3e, q2_ur3e, ..., q6_ur3e
    set(handles.(sliderName), 'Visible', 'on');
    set(handles.(['q', num2str(i), 's_ur3e']), 'Visible', 'on');
end

% Disable sliders for nova2 (q1_nova2 to q2_nova2)
for i = 1:6
    sliderName = sprintf('q%d_nova2', i);  % Generate names q1_nova2 and q2_nova2
    set(handles.(sliderName), 'Visible', 'on');
    set(handles.(['q', num2str(i), 's_nova2']), 'Visible', 'on');
end

updateData(handles);

% Disable text fields for UR3e (x_ur3e, y_ur3e, z_ur3e)
textFieldsUR3e = {'x_ur3e', 'y_ur3e', 'z_ur3e'};
for i = 1:length(textFieldsUR3e)
    set(handles.(textFieldsUR3e{i}), 'Visible', 'on');
end

% Disable text fields for nova2 (x_nova2, y_nova2, z_nova2)
textFieldsNova2 = {'x_nova2', 'y_nova2', 'z_nova2'};
for i = 1:length(textFieldsNova2)
    set(handles.(textFieldsNova2{i}), 'Visible', 'on');
end

for i = 5:24
    set(handles.(['text', num2str(i)]), 'Visible', 'on');
end

set(handles.btn_espresso, "Visible", "off")
set(handles.btn_flatwhite, "Visible", "off")
set(handles.btn_latte, "Visible", "off")
set(handles.btn_icecoffee, "Visible", "off")
set(handles.btn_tea, "Visible", "off")
    
function updateJointAngle(handles, robotName, jointIndex, jointValue)
    % Updates the joint angle in the specified robot's model
    if strcmp(robotName, 'ur3e')
        % Update the UR3e robot's joint angles
        q = handles.movement.ur3e.model.getpos();
        q(jointIndex) = jointValue;
        % Update robot visualization (optional)
        handles.movement.ur3e.model.animate(q);
        
    elseif strcmp(robotName, 'nova2')
        % Update the Nova2 robot's joint angles
        q = handles.movement.nova2.model.getpos();
        q(jointIndex) = jointValue;
        % Update robot visualization (optional)
        handles.movement.nova2.model.animate(q);
    end

    updateData(handles);
    
    % Save updated handles structure
    %guidata(handles.figure1, handles);  % Replace 'figure1' with your figure name


function updateData(handles)
for i = 1:6
    % Get slider position
    slider_value_ur3e = get(handles.(['q', num2str(i), '_ur3e']), 'Value');
    % Set corresponding text field with slider value
    set(handles.(['q', num2str(i), 's_ur3e']), 'String', num2str(round(rad2deg(slider_value_ur3e))));

    % Get slider position
    slider_value_nova2 = get(handles.(['q', num2str(i), '_nova2']), 'Value');
    % Set corresponding text field with slider value
    set(handles.(['q', num2str(i), 's_nova2']), 'String', num2str(round(rad2deg(slider_value_nova2))));
end

for i = 1:6
    q_nova2(i) = get(handles.(['q', num2str(i), '_nova2']), 'Value');
    q_ur3e(i) = get(handles.(['q', num2str(i), '_ur3e']), 'Value');
end

% Calculate the end-effector position for nova2
cords_nova2 = handles.movement.nova2.model.fkine(q_nova2).t;
x_nova2 = round(cords_nova2(1), 2);  % X-coordinate of the end-effector
y_nova2 = round(cords_nova2(2), 2);  % Y-coordinate of the end-effector
z_nova2 = round(cords_nova2(3), 2);  % Z-coordinate of the end-effector

% Populate the x, y, and z fields for nova2
set(handles.x_nova2, 'String', num2str(x_nova2));
set(handles.y_nova2, 'String', num2str(y_nova2));
set(handles.z_nova2, 'String', num2str(z_nova2));

% Calculate the end-effector position for ur3e
cords_ur3e = handles.movement.ur3e.model.fkine(q_ur3e).t;
x_ur3e = round(cords_ur3e(1), 2);  % X-coordinate of the end-effector
y_ur3e = round(cords_ur3e(2), 2);  % Y-coordinate of the end-effector
z_ur3e = round(cords_ur3e(3), 2);  % Z-coordinate of the end-effector

% Populate the x, y, and z fields for ur3e
set(handles.x_ur3e, 'String', num2str(x_ur3e));
set(handles.y_ur3e, 'String', num2str(y_ur3e));
set(handles.z_ur3e, 'String', num2str(z_ur3e));
