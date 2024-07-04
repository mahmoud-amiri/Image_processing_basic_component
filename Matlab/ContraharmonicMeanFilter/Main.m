close all;
clear;
clc;

% Main function
function applyContraHarmonicFilter()
    % Inputs
    [saltImage, pepperImage, kernelDim, QValues] = getInputs();
    [rowsSalt, colsSalt] = size(saltImage);
    [rowsPepper, colsPepper] = size(pepperImage);

    % Apply ContraHarmonic Filter
    outputSalt = contraHarmonicFilter(kernelDim, saltImage, rowsSalt, colsSalt, QValues(1));
    outputPepper = contraHarmonicFilter(kernelDim, pepperImage, rowsPepper, colsPepper, QValues(2));

    % Display Results
    displayResults(saltImage, outputSalt, pepperImage, outputPepper);
end

% Function to get inputs from the user
function [saltImage, pepperImage, kernelDim, QValues] = getInputs()
    saltImage = imread('Salt.tif');
    pepperImage = imread('Pepper.tif');
    prompt = {'Enter Kernel Dimensions:', 'Enter Q:'};
    dlgTitle = 'Input';
    numLines = 1;
    def = {'3', '[-1 1]'};
    answer = inputdlg(prompt, dlgTitle, numLines, def);
    kernelDim = str2double(answer{1});
    QValues = str2num(answer{2});
end

% Function to perform zero padding
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

% Function to apply ContraHarmonic filter
function outputImage = contraHarmonicFilter(kernelDim, inputImage, rows, cols, Q)
    r = floor(kernelDim / 2);
    paddedImage = replicatePadding(r, inputImage, rows, cols);
    outputImage = zeros(rows, cols);

    for i = (kernelDim - r):(rows + r)
        for j = (kernelDim - r):(cols + r)
            localRegion = paddedImage(i - r:i + r, j - r:j + r);
            localRegionQ = localRegion .^ Q;
            localRegionQ1 = localRegion .^ (Q + 1);
            outputImage(i - r, j - r) = sum(localRegionQ1(:)) / sum(localRegionQ(:));
        end
    end
end

% Function to display results
function displayResults(saltImage, outputSalt, pepperImage, outputPepper)
    figure,
    subplot(121), imshow(saltImage), title('Main Image');
    subplot(122), imshow(uint8(outputSalt)), title('Apply Contraharmonic Mean Filter');
    
    figure,
    subplot(121), imshow(pepperImage), title('Main Image');
    subplot(122), imshow(uint8(outputPepper)), title('Apply Contraharmonic Mean Filter');
end

% Call the main function
applyContraHarmonicFilter();
