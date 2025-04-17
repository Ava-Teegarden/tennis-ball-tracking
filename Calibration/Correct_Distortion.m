% Santiago Sanchez

% After calibration values have been loaded,
% this script can be ran to undistort images

% Load images
imLeft = imread("ImageCalLeft\CamLeft_-0.53654_0.55605_3.png");
imRight = imread("ImageCalRight\CamRight_-0.53654_0.55605_3.png");

% Undistort Images
undistortedLeft = undistortImage(imLeft, stereoParams.CameraParameters1);
undistortedRight = undistortImage(imRight, stereoParams.CameraParameters2);

% Plot images
subplot(2,2,1);
imagesc(imLeft);
title('Left Camera OG');

subplot(2,2,2);
imagesc(undistortedLeft);
title('Left Camera undistorted');

subplot(2,2,3);
imagesc(imRight);
title('Right Camera OG');

subplot(2,2,4);
imagesc(undistortedRight);
title('Right Camera undistorted');