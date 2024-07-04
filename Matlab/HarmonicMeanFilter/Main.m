close all
clear all
clc;

% Main function
function harmonicMeanFiltering()
    % Inputs
    [inputImage, kernelDim] = getInputs();
    [rows, cols] = size(inputImage);
    epsilon = 10 ^ -10;

    % Replicate Boundary
    paddedImage = replicateBoundary(inputImage, kernelDim, rows, cols);

    % Harmonic Filter
    outputImage = applyHarmonicFilter(paddedImage, kernelDim, rows, cols, epsilon);

    % Plotting
    displayImages(inputImage, outputImage);
end

% Function to get inputs from the user
function [inputImage, kernelDim] = getInputs()
    inputImage = imread('Salt.tif');
    prompt = {'Enter Kernel Dimensions ='};
    dlgTitle = 'Input';
    numLines = 1;
    def = {'3'};
    answer = inputdlg(prompt, dlgTitle, numLines, def);
    kernelDim = str2double(answer{1});
end

% Function to replicate boundary
function paddedImage = replicateBoundary(inputImage, kernelDim, rows, cols)
    r = floor(kernelDim / 2);
    paddedImage = zeros(rows + 2 * r, cols + 2 * r);
    paddedImage(r + 1 : rows + r, r + 1 : cols + r) = inputImage;
    tempImage = paddedImage;
    for i = 1 : r
        paddedImage(:, i) = tempImage(:, r + 1);
        paddedImage(:, cols + r + i) = tempImage(:, cols + r);
        paddedImage(i, :) = tempImage(r + 1, :); 
        paddedImage(rows + r + i, :) = tempImage(rows + r, :); 
    end
end

% Function to apply harmonic filter
function outputImage = applyHarmonicFilter(paddedImage, kernelDim, rows, cols, epsilon)
    r = floor(kernelDim / 2);
    outputImage = zeros(rows, cols);
    for i = (kernelDim - r) : (rows + r)
        for j = (kernelDim - r) : (cols + r)
            localImage = paddedImage(i - r : i + r, j - r : j + r);
            localImage(localImage == 0) = epsilon;
            localImage = 1 ./ localImage;
            outputImage(i - r, j - r) = (kernelDim * kernelDim) / sum(localImage(:));
        end
    end
end

% Function to display images
function displayImages(inputImage, outputImage)
    figure,
    subplot(121), imshow(inputImage), title('Main Image');
    subplot(122), imshow(uint8(outputImage)), title('Apply Harmonic Mean Filter');
end

% Call the main function
harmonicMeanFiltering();
