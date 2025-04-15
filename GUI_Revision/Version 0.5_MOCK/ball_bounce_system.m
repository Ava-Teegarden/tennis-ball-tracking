% ball_bounce_system.m - Shams Belal [4/14/25]
% Description: Test Bench/Simulation to determine when a ball is in/out.

frameTimeMS = 1;
Iteration = 2;

% Parameters
f = 8;
ps = 0.006;
baseline = 1000;
xNumPix = 752;
yNumPix = 480;
cxLeft = xNumPix/2;
cyLeft = yNumPix/2;

cxRight = xNumPix/2;
cyRight = yNumPix/2;

camDepth = 42;

% Load in left camera images from set #1
load_leftImg_name = sprintf('imgData\\leftCam_Set_%d.mat', Iteration);
load(load_leftImg_name, 'imageLeft');

load_rightImg_name = sprintf('imgData\\rightCam_Set_%d.mat', Iteration);
load(load_rightImg_name, 'imageRight');

load_serve_name = sprintf('datFiles\\serve%d.dat', Iteration);

currentServe = readmatrix(load_serve_name);
dataSize = size(currentServe);
numFrames = dataSize(1);

for frameCounter = 1:frameTimeMS:numFrames
    subplot(2,2,1)
    imagesc(imageLeft(:,:,:, frameCounter))
    
    subplot(2,2,2)
    imagesc(imageRight(:,:,:, frameCounter))

    leftNormalImage = mat2gray(imageLeft(:,:,:, frameCounter));
    leftGray = rgb2gray(leftNormalImage);

    leftKernel = [1 1 1;
                  1 1 1;
                  1 1 1;];

    avgImgLeft = conv2(leftGray, leftKernel);
    leftEdgeDetect = edge(avgImgLeft, 1);

    [leftCenters, leftRadii] = my_imfindcircles(leftEdgeDetect, [6 752], 'Sensitivity', 0.845);
    subplot(2,2,3)
    imagesc(leftEdgeDetect);
    viscircles(leftCenters,leftRadii, 'EdgeColor', 'b');
    colormap("Gray");

    rightNormalImage = mat2gray(imageRight(:,:,:, frameCounter));
    rightGray = rgb2gray(rightNormalImage);

    rightKernel = [1 1 1;
                  1 1 1;
                  1 1 1;];

    avgImgRight = conv2(rightGray, rightKernel);
    rightEdgeDetect = edge(avgImgRight);

    [rightCenters, rightRadii] = my_imfindcircles(rightEdgeDetect, [6 752], 'Sensitivity', 0.845);
    subplot(2,2,4)
    imagesc(rightEdgeDetect);
    viscircles(rightCenters,rightRadii, 'EdgeColor', 'b');
    colormap("Gray");
    
    rightCenters_Status = isempty(rightCenters);
    leftCenters_Status = isempty(leftCenters);
    if ((frameCounter > 31) && (frameCounter < 390))
        if ((rightCenters_Status == 0) && (leftCenters_Status == 0))
            % Store values
            xRight = rightCenters(1);
            yRight = rightCenters(2);

            xLeft = leftCenters(1);
            yLeft = leftCenters(2);
            
            d = (abs((xLeft - cxLeft) - (xRight - cxRight)) * ps);
            calcZCam = ((baseline * f)/d)/1000;
            calcZ = camDepth - calcZCam;
            
            % Calc Y
            calcYLeft = calcZCam * ((xLeft - cxLeft) * ps) / f;
            calcYRight = calcZCam * ((xRight - cxRight) * ps) / f;
            CalcY = (calcYLeft + calcYRight) / 2;
            % Calc X
            calcXLeft = calcZCam * ((yLeft - cyLeft) * ps) / f;
            calcXRight = calcZCam * ((yRight - cyRight) * ps) / f;
            CalcX = (calcXLeft + calcXRight) / 2;

            disp("At Frame #" + frameCounter + " . X = " + CalcX + "[m], Y = " + CalcY + "[m], Z = " + calcZ + "[m]")

            %Store Z Axis with frame number.
            % Compare with last 3, if previous aren't going downhill then
            % clear after 3 elements. If it goes uphill and previous 3 are
            % are lower then it is a bounce, save X and Y + frame number.
        else
            if (leftCenters_Status == 1)
                disp("Missed Ball detection on left Cam at Frame#" + frameCounter)
                % save_missing_left_frame = sprintf('CamLeft_Missing_Frame_%d', frameCounter);
                
            end
            if (rightCenters_Status == 1)
                disp("Missed Ball detection on right Cam at Frame #" + frameCounter)
            end
        end
     end

    pause(0.033);
end