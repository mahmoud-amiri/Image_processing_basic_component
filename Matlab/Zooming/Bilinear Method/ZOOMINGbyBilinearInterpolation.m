close all;
clear;
clc;

% Main function
function zoomByBilinearInterpolation()
    % Inputs
    [inputImage, scaleM, scaleN] = getInputs();
    [rows, cols] = size(inputImage);

    % Replicate Boundary
    paddedImage = replicatePadding(1, inputImage, rows, cols);

    % Size of Output Image
    newRows = floor(scaleM * rows);
    newCols = floor(scaleN * cols);
    outputImage = zeros(newRows, newCols);

    % Bilinear Interpolation
    outputImage = bilinearInterpolation(paddedImage, newRows, newCols, scaleM, scaleN, rows, cols);

    % Display Results
    displayResults(inputImage, outputImage, scaleM, scaleN);
end

% Function to get inputs from the user
function [inputImage, scaleM, scaleN] = getInputs()
    inputImage = imread('Cameraman.tif');
    prompt = {'Enter m:', 'Enter n:'};
    dlgTitle = 'Enter Two Scale Values';
    numLines = 1;
    def = {'2', '2'};
    answer = inputdlg(prompt, dlgTitle, numLines, def);
    scaleM = str2double(answer{1});
    scaleN = str2double(answer{2});
end

% Function to replicate padding
function paddedImage = replicatePadding(r, inputImage, rows, cols)
    paddedImage = zeros(rows + 2 * r, cols + 2 * r);
    paddedImage(r + 1:rows + r, r + 1:cols + r) = inputImage;
    tempImage = paddedImage;

    for i = 1:r
        paddedImage(:, i) = tempImage(:, r + 1);
        paddedImage(:, cols + r + i) = tempImage(:, cols + r);
        paddedImage(i, :) = tempImage(r + 1, :);
        paddedImage(rows + r + i, :) = tempImage(rows + r, :);
    end
end

% Function to perform bilinear interpolation
function outputImage = bilinearInterpolation(paddedImage, newRows, newCols, scaleM, scaleN, rows, cols)
    outputImage = zeros(newRows, newCols);

    for i = 1:newRows
        for j = 1:newCols
            x = i / scaleM + 1;
            y = j / scaleN + 1;

            if x > rows
                x = x - 1;
            end
            if y > cols
                y = y - 1;
            end

            coefMat = bilinearCoefficients(paddedImage, x, y);
            outputImage(i, j) = coefMat(1) * x + coefMat(2) * y + coefMat(3) * x * y + coefMat(4);
        end
    end
end

% Function to compute bilinear coefficients
function coefMat = bilinearCoefficients(paddedImage, x, y)
    x1 = floor(x);
    y1 = floor(y);
    x2 = x1 + 1;
    y2 = y1 + 1;

    inputMat = [x1, y1, x1 * y1, 1; x1, y2, x1 * y2, 1; x2, y1, x2 * y1, 1; x2, y2, x2 * y2, 1];
    V = [paddedImage(x1, y1); paddedImage(x1, y2); paddedImage(x2, y1); paddedImage(x2, y2)];
    coefMat = inputMat \ V;  % More efficient than inv(inputMat) * V
end

% Function to display results
function displayResults(inputImage, outputImage, scaleM, scaleN)
    figure, imshow(inputImage), title('Main Image');
    figure, imshow(uint8(outputImage)), title(['Zoomed Image With Scale (', num2str(scaleM), ', ', num2str(scaleN), ')']);
end

% Call the main function
zoomByBilinearInterpolation();
