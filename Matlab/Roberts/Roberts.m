close all;
clear;
clc;

% Main function
function robertsOperator()
    % Inputs
    inputImage = imread('sobel.tif');
    [rows, cols] = size(inputImage);
    filterSize = 3;

    % Roberts Operators
    WN = [0 0 0; 0 -1 0; 0 0 1];
    WP = [0 0 0; 0 0 -1; 0 1 0];
    r = floor(filterSize / 2);

    % Initialize Output Images
    outputImage = zeros(rows - filterSize + 1, cols - filterSize + 1);
    outputImage1 = zeros(rows - filterSize + 1, cols - filterSize + 1);
    outputImage2 = zeros(rows - filterSize + 1, cols - filterSize + 1);

    % Apply Roberts Operator
    [outputImage, outputImage1, outputImage2] = applyRobertsOperator(inputImage, rows, cols, filterSize, WN, WP, r);

    % Plot Results
    plotResults(inputImage, outputImage, outputImage1, outputImage2);
end

% Function to apply Roberts operator
function [outputImage, outputImage1, outputImage2] = applyRobertsOperator(inputImage, rows, cols, filterSize, WN, WP, r)
    for i = (filterSize - r):(rows - r)
        for j = (filterSize - r):(cols - r)
            localRegion = double(inputImage(i - r:i + r, j - r:j + r));
            localRegion1 = localRegion .* WN;
            localRegion2 = localRegion .* WP;
            outputImage1(i - r, j - r) = sum(sum(localRegion1));
            outputImage2(i - r, j - r) = sum(sum(localRegion2));
            outputImage(i - r, j - r) = abs(outputImage1(i - r, j - r)) + abs(outputImage2(i - r, j - r));
        end
    end
end

% Function to plot results
function plotResults(inputImage, outputImage, outputImage1, outputImage2)
    figure,
    subplot(221), imshow(inputImage), title('Main Image');
    subplot(222), imshow(uint8(outputImage)), title('Output Image by Roberts Operators');
    subplot(223), imshow(uint8(outputImage2)), title('Vertical Edge');
    subplot(224), imshow(uint8(outputImage1)), title('Horizontal Edge');
end

% Call the main function
robertsOperator();
