close all;
clear;
clc;

% Main function
function highBoostFiltering()
    % Inputs
    [inputImage, k, windowDim, sigma] = getInputs();
    [rows, cols] = size(inputImage);

    % Generate Gaussian Window
    gaussianWin = generateGaussianWindow(windowDim, sigma);
    r = floor(windowDim / 2);

    % Initialize Output Images
    blurredImg = zeros(rows, cols);
    mask = zeros(rows, cols);
    unsharpImg = zeros(rows, cols);
    highBoostImg = zeros(rows, cols);

    % Apply High-Boost Filtering
    [blurredImg, mask, unsharpImg, highBoostImg] = applyHighBoostFilter(inputImage, gaussianWin, rows, cols, r, k, windowDim);

    % Scale Images for Display
    scaledUnsharp = scaleImage(unsharpImg);
    scaledHighBoostImg = scaleImage(highBoostImg);

    % Plot Results
    plotResults(inputImage, blurredImg, mask, scaledUnsharp, scaledHighBoostImg, k);
end

% Function to get inputs from the user
function [inputImage, k, windowDim, sigma] = getInputs()
    inputImage = imread('HighBoosting.tif');
    k = input('Enter High-Boosting Factor = ');
    windowDim = input('Enter Window Dimension = ');
    sigma = input('Enter Sigma = ');
end

% Function to generate Gaussian window
function gaussianWin = generateGaussianWindow(windowDim, sigma)
    r = floor(windowDim / 2);
    gaussianWin = zeros(windowDim);

    for i = 1:windowDim
        for j = 1:windowDim
            x = i - r - 1;
            y = j - r - 1;
            gaussianWin(i, j) = exp(-(x * x + y * y) / (2 * sigma * sigma));
        end
    end
end

% Function to apply high-boost filtering
function [blurredImg, mask, unsharpImg, highBoostImg] = applyHighBoostFilter(inputImage, gaussianWin, rows, cols, r, k, windowDim)
    for i = (windowDim - r):(rows - r)
        for j = (windowDim - r):(cols - r)
            localRegion = double(inputImage(i-r:i+r, j-r:j+r)) .* gaussianWin;
            blurredImg(i-r, j-r) = round(sum(localRegion(:)) / (windowDim * windowDim));
            mask(i-r, j-r) = double(inputImage(i, j)) - blurredImg(i-r, j-r);
            unsharpImg(i-r, j-r) = double(inputImage(i, j)) + mask(i-r, j-r);
            highBoostImg(i-r, j-r) = (k - 1) * double(inputImage(i, j)) + mask(i-r, j-r);
        end
    end
end

% Function to scale image
function scaledImage = scaleImage(inputImage)
    minVal = min(inputImage(:));
    scaledImage = inputImage - minVal;
    maxVal = max(scaledImage(:));
    scaledImage = scaledImage * (255 / maxVal);
end

% Function to plot results
function plotResults(inputImage, blurredImg, mask, scaledUnsharp, scaledHighBoostImg, k)
    figure,
    subplot(5, 1, 1), imshow(inputImage), title('Main Image');
    subplot(5, 1, 2), imshow(uint8(blurredImg)), title('Blurred Image By Gaussian Filter');
    subplot(5, 1, 3), imshow(uint8(mask)), title('Mask');
    subplot(5, 1, 4), imshow(uint8(scaledUnsharp)), title('Result of Using Unsharp Mask');
    subplot(5, 1, 5), imshow(uint8(scaledHighBoostImg)), title(['Output Image By High-Boosting with k = ', num2str(k)]);
end

% Call the main function
highBoostFiltering();
