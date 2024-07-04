close all;
clear;
clc;

% Main function
function discreteFourierTransform()
    % Load and process the input image
    inputImage = imread('DFT.tif');
    [rows, cols] = size(inputImage);
    
    % Compute Fourier Transform and its components
    [phase, spectrum, iPhase, iSpectrum] = computeFourierComponents(inputImage);
    
    % Create and process a rectangle image
    [rectImage, rectAmpPhase, rectPhaseAmp] = processRectangle(rows, cols, spectrum, phase);
    
    % Scale images for display
    scaledIPhase = scaleImage(iPhase);
    scaledPhase = scaleImage(phase);
    scaledISpectrum = scaleImage(iSpectrum);
    scaledRectAmpPhase = scaleImage(rectAmpPhase);
    scaledRectPhaseAmp = scaleImage(rectPhaseAmp);
    
    % Plot the results
    plotResults(inputImage, scaledPhase, scaledISpectrum, scaledIPhase, scaledRectAmpPhase, scaledRectPhaseAmp);
end

% Function to compute Fourier components
function [phase, spectrum, iPhase, iSpectrum] = computeFourierComponents(image)
    FT = fft2(image);
    phase = angle(FT);
    spectrum = abs(FT);
    iPhase = ifft2(exp(1i * phase));
    iSpectrum = ifft2(spectrum);
end

% Function to create and process a rectangle image
function [rectImage, rectAmpPhase, rectPhaseAmp] = processRectangle(rows, cols, spectrum, phase)
    rectImage = zeros(rows, cols);
    rectImage(floor(rows/2 - 30):floor(rows/2 + 30), floor(cols/2 - 10):floor(cols/2 + 10)) = 255;
    
    phaseRect = angle(fftshift(fft2(rectImage)));
    specRect = abs(fft2(rectImage));
    
    rectAmpImg = specRect .* exp(1i * phase);
    rectPhaseImg = spectrum .* exp(1i * phaseRect);
    
    rectAmpPhase = ifft2(rectAmpImg);
    rectPhaseAmp = ifft2(rectPhaseImg);
end

% Function to scale image
function scaledImage = scaleImage(image)
    minVal = min(min(image));
    scaledImage = image - minVal;
    maxVal = max(max(scaledImage));
    scaledImage = scaledImage * (255 / maxVal);
end

% Function to plot the results
function plotResults(inputImage, phase, iSpectrum, iPhase, rectAmpPhase, rectPhaseAmp)
    figure,
    subplot(231), imshow(inputImage), title('Main Image');
    subplot(232), imshow(uint8(phase)), title('Phase of Main Image');
    subplot(233), imshow(uint8(abs(iPhase))), title('Reconstructed Using Only Phase Angle');
    subplot(234), imshow(uint8(fftshift(iSpectrum))), title('Reconstructed Using Only Spectrum');
    subplot(235), imshow(uint8(rectAmpPhase)), title('Reconstructed Using Spectrum of Rectangle and Image Phase');
    subplot(236), imshow(uint8(rectPhaseAmp)), title('Reconstructed Using Rectangle Phase and Image Spectrum');
end

% Call the main function
discreteFourierTransform();
