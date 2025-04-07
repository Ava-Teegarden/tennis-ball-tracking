%Test script to generate a series of images
%for testing accuracy

clc;
clear all;
close all;

%Server Initialization Parameters
server_ip   = '127.0.0.1';     %IP address of the Unity Server
server_port = 55001;           %Server Port of the Unity Sever

client = tcpclient(server_ip,server_port,"Timeout",20);
fprintf(1,"Connected to server\n");

% Camera Parameters
width = 1920;
height = 1080;

CamY = 0;
CamZ = 32;
CamPitch = 0;
CamRoll = 0;
CamYaw = 0;

ballx = [-1 -4 4 2];
bally = [1 -2 -5 5];
ballz = [2 3 2 2];

%move ball 4 times each
for ball_pozish = 1:4

        current_position = [ ballx(ball_pozish) bally(ball_pozish) ballz(ball_pozish) ]; %dont need oops
        %set position
        throwaway = blenderLink(client,width,height,ballx(ball_pozish),bally(ball_pozish),ballz(ball_pozish),0,0,0,"tennisBall");


        for counter = 1:1:3 %baseline 1, 2, 3 m
            
            %camera pozish update
            Camera1_baseline = (counter/2);
            Camera2_baseline = -(counter/2);
        
            %take pics at current baselines
            image1 = blenderLink(client,width,height,Camera1_baseline,CamY,CamZ,CamPitch,CamRoll,CamYaw,"Camera");
            image2 = blenderLink(client,width,height,Camera2_baseline,CamY,CamZ,CamPitch,CamRoll,CamYaw,"Camera");
            
            %save image in [baseline]_Cam[L/R]_[Ball x]_[Ball Y]_[Ball Z].png
            file_name_right = sprintf('BL%s_CamRight_%s_%s_%s.png', num2str(counter), num2str(ballx(ball_pozish)), num2str(bally(ball_pozish)), num2str(ballz(ball_pozish)));

            %file_name_right = sprintf('BL', num2str(counter), "_CamRight_", num2str(ballx(ball_pozish)), num2str(bally(ball_pozish)), num2str(ballz(ball_pozish)), ".png" );
            
            %file_name_left = sprintf('BL', num2str(counter), "_CamLeft_", num2str(ballx(ball_pozish)), num2str(bally(ball_pozish)), num2str(ballz(ball_pozish)), ".png" );

            file_name_left = sprintf('BL%s_CamLeft_%s_%s_%s.png', num2str(counter), num2str(ballx(ball_pozish)), num2str(bally(ball_pozish)), num2str(ballz(ball_pozish)));

            fprintf(file_name_right);
            fprintf("/n");
            fprintf(file_name_left);
            fprintf("/n");
            
            imwrite(image1, file_name_right);
            imwrite(image2, file_name_left);

            axis tight
            subplot(1,2,1);
            imagesc(image1)
            set(gcf, 'Position', get(0, 'Screensize'));
            axis off
            subplot(1,2,2);
            imagesc(image2)
        end
end

fprintf("/ncompleted printing your images sir")