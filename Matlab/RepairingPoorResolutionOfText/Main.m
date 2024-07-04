close all;
clear all;
clc;

% Main function
function repairPoorResolutionText()
    % Inputs
    [inputImage, D0, A] = getInputs();
    [rows, cols] = size(inputImage);

    % Apply Gaussian Low Pass Filter
    outputImage = applyGaussianLowPassFilter(inputImage, rows, cols, D0, A);

    % Display Images
    displayImages(inputImage, outputImage, D0);
end

% Function to get inputs from the user
function [inputImage, D0, A] = getInputs()
    inputImage = imread('TextGaps.tif');
    prompt = {'Enter D0:', 'Enter A:'};
    dlgTitle = 'Enter Standard Deviation';
    numLines = 1;
    def = {'80', '1'};
    answer = inputdlg(prompt, dlgTitle, numLines, def);
    D0 = str2double(answer{1});
    A = str2double(answer{2});
end

% Function to apply Gaussian Low Pass Filter
function outputImage = applyGaussianLowPassFilter(inputImage, rows, cols, D0, A)
    gaussianFilter = createGaussianFilter(A, rows, cols, D0, 0.5, 0.5);
    gaussianFilter = fftshift(gaussianFilter);
    freqImage = fft2(fftshift(inputImage));
    filteredImage = freqImage .* gaussianFilter;
    outputImage = ifftshift(real(ifft2(filteredImage)));
    outputImage = scaleImage(outputImage);
end

% Function to create Gaussian Filter
function gaussianFilter = createGaussianFilter(A, rows, cols, sigma, a, b)
    gaussianFilter = zeros(rows, cols);
    for i = 1:rows
        for j = 1:cols
            distance = (i - a * rows)^2 + (j - b * cols)^2;
            distance = distance / (2 * sigma^2);
            gaussianFilter(i, j) = A * exp(-distance);
        end
    end
end

% Function to scale image
function scaledImage = scaleImage(inputImage)
    minVal = min(min(inputImage));
    scaledImage = inputImage - minVal;
    maxVal = max(max(scaledImage));
    scaledImage = scaledImage * (255 / maxVal);
end

% Function to display images
function displayImages(inputImage, outputImage, D0)
    figure,
    subplot(121), imshow(inputImage), title('Poor Resolution Text');
    subplot(122), imshow(uint8(outputImage)), title(['Repaired Text Using Gaussian Low Pass Filter with D0 = ', num2str(D0)]);
end

% Call the main function
repairPoorResolutionText();
