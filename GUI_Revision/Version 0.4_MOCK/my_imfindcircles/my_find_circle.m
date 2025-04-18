function [center, radius] = my_find_circle(im)


[center, radius] = my_imfindcircles(im, [30,120], 'Sensitivity', 0.95, 'EdgeThreshold', 0.3);

[center2, radius2] = imfindcircles(im, [30,120], 'Sensitivity', 0.95, 'EdgeThreshold', 0.3);


figure(142); clf; hold on
imshow(im); viscircles(center, radius)

figure(143); clf; hold on
imshow(im); viscircles(center2, radius2)

x = 1;