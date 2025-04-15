% Santiago Sanchez

% This program reverses his .dat files to be correct to our correct

datData = load("Volley5.dat");
[numRows, numCols] = size(datData);
temp = zeros(numRows, numCols);

temp(:,1) = datData(:,3); % X
temp(:,2) = -(datData(:,1)); % Y
temp(:,3) = datData(:,2); % Z

writematrix(temp, "newVolley5.dat")
