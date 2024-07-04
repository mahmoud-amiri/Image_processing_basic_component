close all;
clear;
clc;

% Main function
function templateMatching()
    % Inputs
    [comImage, eImage, paddedComImage, paddedEImage] = getInputs();
    
    % Spatial Domain Correlation
    spatialCorr = spatialCorrelation(paddedComImage, paddedEImage);

    % Frequency Domain Correlation
    freqCorr = frequencyCorrelation(paddedComImage, paddedEImage);

    % Display Results
    displayResults(spatialCorr, freqCorr);
end

% Function to get inputs
function [comImage, eImage, paddedComImage, paddedEImage] = getInputs()
    comImage = rgb2gray(imread('Computer.tif'));
    eImage = rgb2gray(imread('e1.tif'));
    [m1, n1] = size(comImage);
    [m2, n2] = size(eImage);
    paddedComImage = zeroPad(comImage, m2, n2);
    paddedEImage = zeroPad(eImage, m1, n1);
end

% Function to perform zero padding
function paddedImage = zeroPad(inputImage, padRows, padCols)
    [m, n] = size(inputImage);
    paddedImage = zeros(m + padRows - 1, n + padCols - 1);
    paddedImage(1:m, 1:n) = inputImage;
end

% Function to perform spatial correlation
function spatialCorr = spatialCorrelation(comImage, eImage)
    spatialCorr = xcorr2(comImage, eImage);
end

% Function to perform frequency correlation
function freqCorr = frequencyCorrelation(comImage, eImage)
    FT_ComR = fft2(fftshift(comImage));
    FT_ER = fft2(fftshift(eImage));
    FT_ER = conj(FT_ER);
    FT_Corr = FT_ER .* FT_ComR;
    freqCorr = abs(real(ifft2(FT_Corr)));
end

% Function to display results
function displayResults(spatialCorr, freqCorr)
    figure, imshow(spatialCorr, []), title('Template Matched in Spatial Domain');
    figure, imshow(freqCorr, []), title('Template Matched in Frequency Domain');
end

% Function to scale image (not used in this script, but included for completeness)
function scaledImage = scaleImage(inputImage)
    minVal = min(min(inputImage));
    scaledImage = inputImage - minVal;
    maxVal = max(max(scaledImage));
    scaledImage = scaledImage * (255 / maxVal);
end

% Call the main function
templateMatching();
