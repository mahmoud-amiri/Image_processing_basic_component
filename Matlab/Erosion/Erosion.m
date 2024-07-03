close all
clear all
clc;

%******* Erosion *******%

%% Inputs

% Read and convert the input image
inputImage = imread('E1.tif');
[numRows, numCols] = size(inputImage);

%% Structure Element - Square

% Get the size of the square structuring element from the user
method = 'Square';
prompt = {'Size of Square'};
dlgTitle = 'Enter Info';
numLines = 1;
default = {'45'};
answer = inputdlg(prompt, dlgTitle, numLines, default);
structElemSize = str2double(answer{1});
paddingSize = floor(structElemSize / 2);

% Zero pad the input image
[zeroPaddedImage, newNumRows, newNumCols] = ZeroPad(paddingSize, inputImage, numRows, numCols);
mainParam = ['Size of Square = ', num2str(structElemSize)];

%% Dilation

% Create a square structuring element
structElem = ones(structElemSize, structElemSize);
outputImage = zeros(numRows, numCols); % Initialize the output image

% Perform erosion
for i = paddingSize + 1 : newNumRows - paddingSize
    for j = paddingSize + 1 : newNumCols - paddingSize
        localRegion = zeroPaddedImage(i - paddingSize : i + paddingSize, j - paddingSize : j + paddingSize);
        localRegion = localRegion .* structElem;
        sumLocal = sum(localRegion(:));
        
        if sumLocal == structElemSize * structElemSize
            outputImage(i - paddingSize, j - paddingSize) = 1;
        else
            outputImage(i - paddingSize, j - paddingSize) = 0;
        end
    end
end

% Matlab built-in erosion command for comparison
matlabStructElem = strel('square', structElemSize);
outputMatlab = imerode(inputImage, matlabStructElem);

%% Plotting

figure,
subplot(131), imshow(inputImage); title('Main Image');
subplot(132), imshow(outputImage); title({['Eroded Image Using ', method, ' Structure Element'], mainParam});
subplot(133), imshow(outputMatlab); title('Eroded Image Using Matlab Command and Same Structure Element');
