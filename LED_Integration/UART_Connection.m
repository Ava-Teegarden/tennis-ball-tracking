% Santiago Sanchez

% Starter script to connect to COM Port

% Create COM Port
port = serialport("COM13",9600, "Timeout",5);

% Write something to COM Port
write(port, 1,"uint8");

% Clear when done communicating to reuse script
clear;


