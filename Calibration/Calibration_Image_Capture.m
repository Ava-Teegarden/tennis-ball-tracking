%Test script to generate a series of images
%for testing accuracy

clc;
clear all;
close all;

% Camera Parameters
width = 752;  % 480p: 752, 480
height = 480; % 1080p: 1920, 1080

baseline = 1000;  % Keeping baseline constant 
CamLeftX = - (baseline / 2);  
CamRightX = (baseline / 2);
CamY = 0;
CamZ = 42;  % 480p: 42m, 1080p: 32m 
CamPitch = 0;
CamRoll = 0;
CamYaw = 0;

% Pattern XYZ (5x4 Values to keep the pattern inside the camera)
Xmin = -7.63; Xmax = 7.63;
Ymin = -2.86; Ymax = 2.86; 
Zmin = 3;
patternX = Xmin + (Xmax-Xmin).*rand(5,4);
patternY = Ymin + (Ymax-Ymin).*rand(5,4);
patternZ = 3 .* ones(5,4);  % Keep constant for now at 3m

% Pattern Pitch, Roll, Yaw (% 5 row x 4 Column of random angles)
angleMin = 0; angleMax = 45;
patternPitch = randi([angleMin,angleMax], [5,4]);  
patternRoll  = randi([angleMin,angleMax], [5,4]);
patternYaw   = randi([angleMin,angleMax], [5,4]);

%Server Initialization Parameters
server_ip   = '127.0.0.1';     %IP address of the Unity Server
server_port = 55001;           %Server Port of the Unity Sever

client = tcpclient(server_ip,server_port,"Timeout",20);
fprintf(1,"Connected to server\n");

%move ball 4 times each
for pattern_pozish = 1:20

    %set position
    throwaway = blenderLink(client,width,height,patternX(pattern_pozish),patternY(pattern_pozish),patternZ ...
        (pattern_pozish),patternPitch,patternRoll,patternYaw,"Calibration_Pattern");

    %take pics at current baselines
    leftImage = blenderLink(client,width,height,CamLeftX,CamY,CamZ,CamPitch,CamRoll,CamYaw,"Camera");
    rightImage = blenderLink(client,width,height,CamRightX,CamY,CamZ,CamPitch,CamRoll,CamYaw,"Camera");

    %save image in [baseline]_Cam[L/R]_[Ball x]_[Ball Y]_[Ball Z].png
    file_name_right = sprintf('CamRight_%s_%s_%s.png', num2str(patternX(pattern_pozish)), num2str(patternY(pattern_pozish)), num2str(patternZ(pattern_pozish)));

    file_name_left = sprintf('CamLeft_%s_%s_%s.png', num2str(patternX(pattern_pozish)), num2str(patternY(pattern_pozish)), num2str(patternZ(pattern_pozish)));

    fprintf(file_name_right);
    fprintf("/n");
    fprintf(file_name_left);
    fprintf("/n");

    imwrite(leftImage, file_name_right);
    imwrite(rightImage, file_name_left);

    axis tight
    subplot(1,2,1);
    imagesc(leftImage)
    set(gcf, 'Position', get(0, 'Screensize'));
    axis off
    subplot(1,2,2);
    imagesc(rightImage)
end

fprintf("/ncompleted printing your images sir")