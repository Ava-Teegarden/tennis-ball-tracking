% Oran Betz
% Sobel Demo Setup File
coefficients = [1 0 -1;
                2 0 -2;
                1 0 -1];

coefficients_sobel = [1 0 -1;
                      2 0 -2;
                      1 0 -1];
coefficients_sobel_vert = [1 2 1;
                           0 0 0;
                           -1 -2 -2];
coefficients_gaussian = [1/16 1/8 1/16;
                         1/8 1/4 1/8;
                         1/16 1/8 1/16];

input_selection = 1;
R = 752;%240 752
C = 480;%135 480
R_total = 752; 
C_total = 480;