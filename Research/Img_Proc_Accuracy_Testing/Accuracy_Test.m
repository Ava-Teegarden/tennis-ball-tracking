% Shams Belal, CPET 563.01L02 - 2/16/25

leftarrImg = {'BL1_CamLeft_4_-5_2.png', 'BL1_CamLeft_-4_-2_3.png', 'BL1_CamLeft_2_5_2.png', 'BL1_CamLeft_-1_1_2.png';
              'BL2_CamLeft_4_-5_2.png', 'BL2_CamLeft_-4_-2_3.png', 'BL2_CamLeft_2_5_2.png', 'BL2_CamLeft_-1_1_2.png';
              'BL3_CamLeft_4_-5_2.png', 'BL3_CamLeft_-4_-2_3.png', 'BL3_CamLeft_2_5_2.png', 'BL3_CamLeft_-1_1_2.png'};

rightarrImg = {'BL1_CamRight_4_-5_2.png', 'BL1_CamRight_-4_-2_3.png', 'BL1_CamRight_2_5_2.png', 'BL1_CamRight_-1_1_2.png';
              'BL2_CamRight_4_-5_2.png', 'BL2_CamRight_-4_-2_3.png', 'BL2_CamRight_2_5_2.png', 'BL2_CamRight_-1_1_2.png';
              'BL3_CamRight_4_-5_2.png', 'BL3_CamRight_-4_-2_3.png', 'BL3_CamRight_2_5_2.png', 'BL3_CamRight_-1_1_2.png'};


BallXcoord = {4, -4, 2, -1};    CalcX = {0, 0, 0, 0};   ErrorXPerc = {0, 0, 0, 0};
BallYcoord = {-5, -2, 5, 1};    CalcY = {0, 0, 0, 0};   ErrorYPerc = {0, 0, 0, 0};
BallZcoord = {2, 3, 2, 2};      CalcZCameraPers = {0, 0, 0, 0};   CalcZWorldPers = {0, 0, 0, 0}; ErrorZPerc = {0, 0, 0, 0};

baseline = {1000, 2000, 3000};

XErrorPercAVG = {0, 0, 0};
YErrorPercAVG = {0, 0, 0};
ZErrorPercAVG = {0, 0, 0};

f = 8;                 % focal length [mm]
ps = .003;             % pixel size [mm]
xNumPix = 1920;        % total number of pixels in x direction of the sensor [px]
yNumPix = 1080;        % total number of pixels in y direction of the sensor [py]
cxLeft = xNumPix/2;    % left camera x center [px]
cxRight = xNumPix/2;   % right camera x center [px]
cyLeft = yNumPix/2;    % left camera y center [py]
cyRight = yNumPix/2;   % right camera y center [py]
camDepth = 32;         % Distance between Camera sensor and court floor [m]

% 3 Baseline changes

% Accuracy = (|IMGMask_Calc - Actual|)/Actual * 100

for counter = 1:3
    
    for framecounter = 1:4

        leftImage = imread(leftarrImg{counter, framecounter});
        %imagesc(leftImage);
        leftNormalImage = mat2gray(leftImage);
        leftGray = rgb2gray(leftNormalImage);
        leftKernel = [1 1 1;
                  1 1 1;
                  1 1 1];
        avgImgLeft = conv2(leftGray, leftKernel);
        Leftedgedet = edge(avgImgLeft);
        [Leftcenters, Leftradii] = imfindcircles(Leftedgedet, [5 1920], 'Sensitivity', 0.70);
        xLeft = Leftcenters(1);
        yLeft = Leftcenters(2);

        % PLOT
        subplot(1,2,1)
        imagesc(Leftedgedet);
        hold on;
        scatter(Leftcenters(1), Leftcenters(2), "red");
        hold off;
        viscircles(Leftcenters, Leftradii,'EdgeColor','b');
        colormap("Gray")
        
        rightImage = imread(rightarrImg{counter, framecounter});
        %imagesc(rightImage);
        rightNormalImage = mat2gray(rightImage);
        rightGray = rgb2gray(rightNormalImage);
        rightKernel = [1 1 1;
                  1 1 1;
                  1 1 1];
        avgImgRight = conv2(rightGray, rightKernel);
        Rightedgedet = edge(avgImgRight);
        [Rightcenters, Rightradii] = imfindcircles(Rightedgedet, [5 1920], 'Sensitivity', 0.60);
        xRight = Rightcenters(1);
        yRight = Rightcenters(2);

        % PLOT
        subplot(1,2,2)
        imagesc(Rightedgedet);
        hold on;
        scatter(Rightcenters(1), Rightcenters(2), "red");
        hold off;
        viscircles(Rightcenters, Rightradii,'EdgeColor','b');
        colormap("Gray")

        d = (abs((xLeft - cxLeft) - (xRight - cxRight)) * ps); % disparity [mm]
        CalcZCameraPers{framecounter} = ((baseline{counter} * f)/d)/1000;                % depth [m]
        CalcZWorldPers{framecounter} = camDepth - CalcZCameraPers{framecounter};         % World Z [m]
        CalcX{framecounter} = CalcZCameraPers{framecounter} * ((xLeft - cxLeft) * ps) / f;
        CalcY{framecounter} = CalcZCameraPers{framecounter} * ((cyLeft - yLeft) * ps) / f;  % REVERSED because (0,0) in image is top left
        
        

        % Debug
        fprintf('Baseline: %d[mm], Calculated X: %d[m], Calculated Y: %d[m], Calculated Z: %d[m]', baseline{counter}, CalcX{framecounter}, CalcY{framecounter}, CalcZWorldPers{framecounter})
        
        % Calculate Percent Error
        ErrorXPerc{framecounter} = ((abs(CalcX{framecounter} - BallXcoord{framecounter}))/abs(BallXcoord{framecounter})) * 100;
        ErrorYPerc{framecounter} = ((abs(CalcY{framecounter} - BallYcoord{framecounter}))/abs(BallYcoord{framecounter})) * 100;
        ErrorZPerc{framecounter} = ((abs(CalcZWorldPers{framecounter} - BallZcoord{framecounter}))/abs(BallZcoord{framecounter})) * 100;

        fprintf('\nPercent Error X: %.2d[perc], Percent Error Y: %.2d[perc], Percent Error Z: %.2d[perc]', ErrorXPerc{framecounter}, ErrorYPerc{framecounter}, ErrorZPerc{framecounter})
    end
    XErrorPercAVG{counter} = (ErrorXPerc{1} + ErrorXPerc{2} + ErrorXPerc{3} + ErrorXPerc{4})/4;
    YErrorPercAVG{counter} = (ErrorYPerc{1} + ErrorYPerc{2} + ErrorYPerc{3} + ErrorYPerc{4})/4;
    ZErrorPercAVG{counter} = (ErrorZPerc{1} + ErrorZPerc{2} + ErrorZPerc{3} + ErrorZPerc{4})/4;
    
end
save("Accuracy_AVGS.mat", "XErrorPercAVG","YErrorPercAVG","ZErrorPercAVG");


%image = imread(rightImg{5});
%%sobelImage = filter2(fspecial('sobel'),image);
%normalImage = mat2gray(image);
%leftGray = rgb2gray(normalImage);
%%threshold = graythresh(leftGray);
%%BW = imbinarize(threshold, 0.4);
%edgedet = edge(leftGray);
%[centers, radii] = imfindcircles(edgedet, [45 77], 'Sensitivity', 0.93);
%
%subplot(1,2,1)
%imagesc(image);
%viscircles(centers, radii,'EdgeColor','b');
%subplot(1,2,2)
%%hold on
%imagesc(edgedet);
%colormap("Gray")
%viscircles(centers, radii,'EdgeColor','b');
%
%
%% Shams Belal, CPET 563.01L02 - 1/25/25 LAB #1
%
%% Corke Toolbox:
%% X: Left (-) and Right (+)
%% Y: Up   (-) and Down  (+)
%% Z: Close(-) and Away  (+)
%
%% Focal Length at Loop Counter
%fspecs = [6, 10];
%
%for counter = 1:2
%    % Parameters
%    b = 60;                 % Baseline [mm]
%    f = fspecs(counter);    % focal length [mm]
%    ps = .006;              % pixel size [mm]
%    xNumPix = 752;          % total number of pixels in x direction of the sensor [px]
%    yNumPix = 480;          % total number of pixels in y direction of the sensor [py]
%    cxLeft = xNumPix/2;     % left camera x center [px]
%    cxRight = xNumPix/2;    % right camera x center [px]
%    cyLeft = yNumPix/2;     % left camera y center [py]
%    cyRight = yNumPix/2;    % right camera y center [py]
%
%    % V Camera (Left Camera) Parameters
%    camLeft = CentralCamera('focal', f/1000, 'pixel', ps/1000, 'resolution', [xNumPix,yNumPix], 'centre', [cxLeft,cyLeft], 'name', 'Left Camera');
%    Tcam = SE3(-.03, 0, 0);
%    camLeft.T = Tcam;
%
%    % V Camera (Right Camera) Parameters
%    camRight = CentralCamera('focal', f/1000, 'pixel', ps/1000, 'resolution', [xNumPix,yNumPix], 'centre', [cxRight,cyRight], 'name', 'Right Camera');
%    Tcam = SE3(.03, 0, 0);
%    camRight.T = Tcam;
%
%    % Depth paramaters
%    depth = 0:.1:10;
%    numPoints = length(depth);
%    x = zeros(1,numPoints);         % Allocation/Pre-population
%    y = zeros(1, numPoints);        % Allocation/Pre-population
%
%    % Pixel Array/Vector
%    P = [x;y;depth];
%    leftPixel = camLeft.project(P);
%    rightPixel = camRight.project(P);
%
%    xLeft = leftPixel(1,:);
%    xRight = rightPixel(1,:);
%
%    d = (abs((xLeft - cxLeft) - (xRight - cxRight)) * ps);  % disparity [mm]
%    Z = (b * f)./d;                                         % depth [mm]
%    calcDepth = Z/1000;                                     % depth [m]
%
%    % Plot Creation
%    subplot(2,1,1)
%    hold on
%    plot(depth,d)
%    xlabel("depth [m]")
%    ylabel("disparity [mm]")
%    subplot(2,1,2)
%    hold on
%    plot(depth, calcDepth - depth);
%    xlabel ("depth [m]")
%    ylabel("depth error [m]")
%
%end
%
%% Legend for Plot (TO AVOID WARNINGS)
%subplot(2,1,1)
%title("Depth vs Disparity")
%legend("f = 6mm", "f = 10mm")
%subplot(2,1,2)
%title("Depth Error")
%legend("f = 6mm", "f = 10mm")
%
%
%%              REFRENCES
%% Plots + V Camera (Right Camera)
%camRight = CentralCamera('focal', f/1000, 'pixel', ps/1000, 'resolution', [xNumPix,yNumPix], 'centre', [cxRight,cyRight], 'name', 'Right Camera');
%Tcam = SE3(.03, 0, 0);
%camRight.T = Tcam;
%right = camRight.project(P);
%camRight.plot(P);

%% For Loop Parameters
%depth = 1:10;
%numPoints = length(depth);
%xLeft = zeros(1,numPoints);
%xRight = zeros(1,numPoints);
%calcDepth = zeros(1,numPoints);

%for counter = 1:numPoints
    %P = [0,0,depth(counter)]';
    %leftPixel = camLeft.project(P);
    %rightPixel = camRight.project(P);

    %xLeft(counter) = leftPixel(1);
    %xRight(counter) = rightPixel(1);

    %d = (abs((xLeft(counter) - cxLeft) - (xRight(counter) - cxRight)) * ps);  % disparity [mm]
    %Z = (b * f)/d;                                                            % depth [mm]
    %calcDepth(counter) = Z/1000;
%end

%error = depth - calcDepth;

%% X - Axis
%xLeft = left(1);
%xRight = right(1);

%% depth equations
%d = (abs((xLeft - cxLeft) - (xRight - cxRight)) * ps);  % disparity [mm]
%Z = (b * f)/d;                                          % depth [mm]
%Z = Z/1000                                              % depth [m]