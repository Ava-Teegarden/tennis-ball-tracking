% Santiago Sanchez

% Starter script to connect to COM Port

% Create COM Port
port = serialport("COM5",9600, "Timeout",5);

data = read(port,3,"string");

disp(data)


