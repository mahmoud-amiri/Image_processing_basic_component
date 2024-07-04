clear all;
close all;
clc;

% Main function
function statisticalEnhancement()
    % Inputs
    [inputImage, k0, k1, k2, E, kernelDim] = getInputs();
    [rows, cols] = size(inputImage);

    % Calculating Histogram Statistics 
    [inputMean, inputDeviation] = calculateHistogramStatistics(inputImage, rows, cols);

    % Using Histogram Statistics for Enhancement (Ignoring Boundary)
    outputImage = enhanceImage(inputImage, inputMean, inputDeviation, k0, k1, k2, E, kernelDim, rows, cols);

    % Displaying Images
    displayImages(inputImage, outputImage);
end

% Function to get inputs from the user
function [inputImage, k0, k1, k2, E, kernelDim] = getInputs()
    inputImage = double(imread('tungsten.jpg'));
    prompt = {'Enter k0:', 'Enter k1:', 'Enter k2:', 'Enter E:', 'Enter Kernel Dimension'};
    dlgTitle = 'Enter Parameters for Transformation';
    numLines = 1;
    def = {'0.4', '0.02', '0.4', '4', '3'};
    answer = inputdlg(prompt, dlgTitle, numLines, def);
    k0 = str2double(answer{1});
    k1 = str2double(answer{2});
    k2 = str2double(answer{3});
    E = str2double(answer{4});
    kernelDim = str2double(answer{5});
end

% Function to calculate histogram statistics
function [inputMean, inputDeviation] = calculateHistogramStatistics(inputImage, rows, cols)
    inputMean = sum(sum(inputImage)) / (rows * cols);
    inputVar = sum(sum((inputImage - inputMean).^2)) / (rows * cols);
    inputDeviation = sqrt(inputVar);
end

% Function to enhance the image using statistical parameters
function outputImage = enhanceImage(inputImage, inputMean, inputDeviation, k0, k1, k2, E, kernelDim, rows, cols)
    r = floor(kernelDim / 2);
    outputImage = zeros(rows - kernelDim + 1, cols - kernelDim + 1);

    for i = (kernelDim - r):(rows - r)
        for j = (kernelDim - r):(cols - r)
            localRegion = inputImage(i - r:i + r, j - r:j + r);
            localMean = sum(sum(localRegion)) / (kernelDim * kernelDim);
            localVar = sum(sum((localRegion - localMean).^2)) / (kernelDim * kernelDim);
            localDeviation = sqrt(localVar);
            if (localMean <= k0 * inputMean) && (k1 * inputDeviation <= localDeviation) && (k2 * inputDeviation >= localDeviation)
                outputImage(i - r, j - r) = E * inputImage(i, j);
            else
                outputImage(i - r, j - r) = inputImage(i, j);
            end
        end
    end
end

% Function to display images
function displayImages(inputImage, outputImage)
    figure,
    subplot(1, 2, 1), imshow(uint8(inputImage)), title('Main Image');
    subplot(1, 2, 2), imshow(uint8(outputImage)), title('Output Using Statistical Enhancement');
end

% Call the main function
statisticalEnhancement();
