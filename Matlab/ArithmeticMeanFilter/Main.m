close all;
clear;
clc;

% Main function
function applyArithmeticMeanFilter()
    % Inputs
    [inputImage, kernelDim] = getInputs();
    [rows, cols] = size(inputImage);

    % Apply Arithmetic Mean Filter
    outputImage = arithmeticMeanFilter(inputImage, kernelDim, rows, cols);

    % Display Images
    displayImages(inputImage, outputImage);
end

% Function to get inputs from the user
function [inputImage, kernelDim] = getInputs()
    inputImage = imread('cameraman.tif');
    prompt = {'Enter Kernel Dimensions ='};
    dlgTitle = 'Input';
    numLines = 1;
    def = {'3'};
    answer = inputdlg(prompt, dlgTitle, numLines, def);
    kernelDim = str2double(answer{1});
end

% Function to apply arithmetic mean filter
function outputImage = arithmeticMeanFilter(inputImage, kernelDim, rows, cols)
    r = floor(kernelDim / 2);
    paddedImage = replicatePadding(inputImage, r, rows, cols);
    outputImage = zeros(rows, cols);
    
    for i = (kernelDim - r):(rows + r)
        for j = (kernelDim - r):(cols + r)
            localRegion = paddedImage(i - r:i + r, j - r:j + r);
            outputImage(i - r, j - r) = sum(localRegion(:)) / (kernelDim * kernelDim);
        end
    end
end

% Function to replicate padding
function paddedImage = replicatePadding(inputImage, r, rows, cols)
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

% Function to display images
function displayImages(inputImage, outputImage)
    figure,
    subplot(121), imshow(inputImage), title('Main Image');
    subplot(122), imshow(uint8(outputImage)), title('Apply Arithmetic Mean Filter');
end

% Call the main function
applyArithmeticMeanFilter();
