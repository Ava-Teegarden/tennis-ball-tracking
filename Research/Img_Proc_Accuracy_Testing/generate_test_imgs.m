%Test script to generate a series of images
%for testing accuracy

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

ballx = [-1 -4 4 2];
bally = [1 -2 -5 6];
ballz = [2 3 2 2];

%move ball 4 times each
for ball_pozish = 1:4

        current_position = [ ballx(ball_pozish) bally(ball_pozish) ballz(ball_pozish) ]; %dont need oops
        %set position
        throwaway = blenderLink(client,width,height,ballx(ball_pozish),bally(ball_pozish),ballz(ball_pozish),0,0,0,"tennisBall");


        for counter = 0:60:180 %baseline 60, 120, 180 mm
            
            %camera pozish update
            Camera1_baseline = (counter/2)/1000;
            Camera2_baseline = -(counter/2)/1000;
        
            %take pics at current baselines
            image1 = blenderLink(client,width,height,0,Camera1_baseline,32,0,0,90,"Camera1");
            image2 = blenderLink(client,width,height,0,Camera2_baseline,32,0,0,90,"Camera2");
            
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



            imagesc(image1)
            set(gcf, 'Position', get(0, 'Screensize'));
            axis off
            imagesc(image2)
        end
end

fprintf("/ncompleted printing your images sir")