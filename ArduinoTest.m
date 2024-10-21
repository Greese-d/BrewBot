% Create a serial object
arduinoComPort = 'COM4'; % Replace with your Arduino's COM port
baudRate = 9600;
serialObj = serialport(arduinoComPort, baudRate);

% Setup to read data in a loop
while true
    if serialObj.NumBytesAvailable > 0
        % Read incoming data
        data = readline(serialObj);
        disp(['Received: ' data]);
    end
    pause(0.1); % Small delay
end

% When done, clear the serial object
clear serialObj;
