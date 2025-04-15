% D. Kaputa
% serveBall.m
% Ravvenlabs

clc;
clear all;
close all;

%Initialization Parameters
server_ip   = '127.0.0.1';     %IP address of the Unity Server
server_port = 55001;           %Server Port of the Unity Sever

client = tcpclient(server_ip,server_port,"Timeout",20);
fprintf(1,"Connected to server\n");

width = 1920;
height = 1080;

baseline = 1000;

camOneY = 0; camOneZ = 32;
camOnePitch = 0; camOneRoll = 0; camOneYaw = 0;

camTwoY = 0; camTwoZ = 32;
camTwoPitch = 0; camTwoRoll = 0; camTwoYaw = 0;

camCrwdX = -15.084; camCrwdY = 24.032; camCrwdZ = 16.532;
camCrwdPitch = 58.801; camCrwdRoll = 1.0106; camCrwdYaw = -149.18;

frameTimeMS = 50;
%servesArr = zeros(1500,3,5);
%imageArrLive = zeros(1080,1920,3,1500,"uint8");
%imageArrLeft = zeros(1080,1920,3,1500, "uint8");
%imageArrRight = zeros(1080,1920,3,1500, "uint8");

for serveCounter = 5:5
    currentServe = readmatrix("datFiles\serve" + serveCounter + ".dat"); % Store serves.dat in a 3D array
    dataSize = size(currentServe);  % Get size of serveX.dat file at current iteration
    numFrames = dataSize(1);                           % Take X Axis for total number of Frames

    servesArr = zeros(numFrames,3,5);
    servesArr(:,:,serveCounter) = currentServe;
    imageArrLive = zeros(1080,1920,3,numFrames,"uint8");
    imageArrLeft = zeros(1080,1920,3,numFrames, "uint8");
    imageArrRight = zeros(1080,1920,3,numFrames, "uint8");

        for imageCounter = 1:frameTimeMS:numFrames % Loop until end of frames and increment based on frameTimes
            % Ball position in serveX.dat file
            x = currentServe(imageCounter, 1);
            y = currentServe(imageCounter, 3);
            z = currentServe(imageCounter, 2);

            blenderLink(client,width, height, (y), -(x), z, 0, 0, 0, "tennisBall");

            % Crowd Cam
            imageArrLive(:,:,:, imageCounter) = blenderLink(client,width, height, camCrwdX, camCrwdY, camCrwdZ, camCrwdPitch, camCrwdRoll, camCrwdYaw, "Camera");
            % Cam One
            imageArrLeft(:,:,:, imageCounter) = blenderLink(client,width, height, ((baseline/1000)/2), camOneY, camOneZ, camOnePitch, camOneRoll, camOneYaw, "Camera");
            % Cam Two
            imageArrRight(:,:,:, imageCounter) = blenderLink(client,width, height, -((baseline/1000)/2), camTwoY, camTwoZ, camTwoPitch, camTwoRoll, camTwoYaw, "Camera");  
            

            disp("Frame #" + imageCounter + " has Passed!");

        end % Frame Reciever [For Loop]
        %resizeArr = resize(imageArrLive(:,:,:, 1), numFrames);
        file_name_live = sprintf('LiveTV_Set_%d.mat', serveCounter);
        save(file_name_live, 'imageArrLive', '-v7.3');
        %save("CamLeft_Set" + serveCounter + ".mat", imageArrLive);
    disp("Serve #" + serveCounter + " Complete");
end % serveCounter [For Loop]







%
%serve = readmatrix("datFiles\volley1.dat");
%
%dataSize = size(serve);
%numFrames = dataSize(1);
%
%sampledServeCounter = 1;
%frameTimeMs = 50;
%
%for counter = 1:frameTimeMs:numFrames
%    x = serve(counter,1);
%    y = serve(counter,3);
%    z = serve(counter,2);
%
%
%    image = blenderLink(client,width,height,(y),-(x),z,0,0,0,"tennisBall"); % SRV
%    imageL = blenderLink(client,width,height,.500,0,32,0,0,0,"Camera"); % SRV
%    imageR = blenderLink(client,width,height,-.500,0,32,0,0,0,"Camera"); % SRV
%    %image = blenderLink(client,width,height,x,y,z,0,0,0,"tennisBall"); % VLLY
%    imagesc(image)
%    set(gcf, 'Position', get(0, 'Screensize'));
%    axis off
%
%    imagesc(imageL)
%    set(gcf, 'Position', get(0, 'Screensize'));
%    axis off
%
%    imagesc(imageR)
%    set(gcf, 'Position', get(0, 'Screensize'));
%    axis off
%end