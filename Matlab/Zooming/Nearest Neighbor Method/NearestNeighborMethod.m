close all;
clear;
clc;

% Main function
function nearestNeighborScaling()
    % Inputs
    [inputImage, scaleM, scaleN] = getInputs();
    [rows, cols] = size(inputImage);

    % Size of Output Image
    newRows = floor(scaleM * rows);
    newCols = floor(scaleN * cols);
    outputImage = zeros(newRows, newCols);

    % Nearest Neighbor Method
    outputImage = nearestNeighborInterpolation(inputImage, newRows, newCols, scaleM, scaleN);

    % Display Results
    displayResults(inputImage, outputImage, scaleM, scaleN);
end

% Function to get inputs from the user
function [inputImage, scaleM, scaleN] = getInputs()
    inputImage = imread('Cameraman.tif');
    prompt = {'Enter m:', 'Enter n:'};
    dlgTitle = 'Enter Two Scale Values';
    numLines = 1;
    def = {'1', '1'};
    answer = inputdlg(prompt, dlgTitle, numLines, def);
    scaleM = str2double(answer{1});
    scaleN = str2double(answer{2});
end

% Function to perform nearest neighbor interpolation
function outputImage = nearestNeighborInterpolation(inputImage, newRows, newCols, scaleM, scaleN)
    outputImage = zeros(newRows, newCols);

    for i = 1:newRows
        for j = 1:newCols
            x = i / scaleM;
            y = j / scaleN;
            if x < 0.5
                x = x + 0.5;
            end
            if y < 0.5
                y = y + 0.5;
            end
            x = round(x);
            y = round(y);
            outputImage(i, j) = inputImage(x, y);
        end
    end
end

% Function to display results
function displayResults(inputImage, outputImage, scaleM, scaleN)
    figure, imshow(inputImage), title('Original Image');
    if scaleM > 1 && scaleN > 1
        figure, imshow(uint8(outputImage)), title(['Zoomed Image By Nearest Neighbor Method with Scale: (', num2str(scaleM), ', ', num2str(scaleN), ')']);
    elseif scaleM < 1 && scaleN < 1
        figure, imshow(uint8(outputImage)), title(['Shrunk Image By Nearest Neighbor Method with Scale: (', num2str(scaleM), ', ', num2str(scaleN), ')']);
    else
        figure, imshow(uint8(outputImage)), title(['Scaled Image By Nearest Neighbor Method with Scale: (', num2str(scaleM), ', ', num2str(scaleN), ')']);
    end
end

% Call the main function
nearestNeighborScaling();
