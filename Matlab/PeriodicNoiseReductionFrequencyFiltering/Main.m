close all;
clear;
clc;

% Main function
function periodicNoiseRemoval()
    % Inputs
    inputImage = imread('cameraman.tif');
    [rows, cols] = size(inputImage);
    D0 = 85;
    W = 30;
    buttOrder = 4;

    % Generate Periodic Noise In Spatial
    noisyImage = generatePeriodicNoise(inputImage, rows, cols);
    
    % Band Reject Filtering
    [filteredImages, filterTitles] = applyBandRejectFiltering(noisyImage, rows, cols, D0, W, buttOrder);

    % Plotting Results
    plotResults(noisyImage, filteredImages, filterTitles);
end

% Function to generate periodic noise in spatial domain
function noisyImage = generatePeriodicNoise(inputImage, rows, cols)
    img = zeros(rows, cols);
    for i = 1:3:rows
        img(i, :) = 100;
    end
    img2 = imrotate(img, 90) + img;
    buttF = butterworthHPF(rows, cols, 2, 50);
    freqImg2 = fftshift(fft2(img2));
    freqNoise = buttF .* freqImg2;
    noise = real(ifft2(ifftshift(freqNoise)));
    noisyImage = noise + double(inputImage);
    
    figure, imshow(abs(freqNoise), []), title('Frequency Domain of Noise');
    figure, imshow(abs(fftshift(fft2(noisyImage))), []), title('FFT of Noisy Image');
end

% Function to create Butterworth high-pass filter
function buttF = butterworthHPF(rows, cols, n, D0)
    buttF = zeros(rows, cols);
    for i = 1:rows
        for j = 1:cols
            D = sqrt((i - floor(rows / 2) - 1)^2 + (j - floor(cols / 2) - 1)^2);
            D = (D / D0) ^ (2 * n);
            buttF(i, j) = 1 - 1 / (1 + D);
        end
    end
end

% Function to apply band reject filtering
function [filteredImages, filterTitles] = applyBandRejectFiltering(noisyImage, rows, cols, D0, W, buttOrder)
    FFTNoisyImg = fftshift(fft2(noisyImage));
    
    [H1, H2, H3] = bandRejectFilter(D0, W, rows, cols, buttOrder);
    
    output1 = H1 .* FFTNoisyImg;
    output2 = H2 .* FFTNoisyImg;
    output3 = H3 .* FFTNoisyImg;
    
    filteredImages = {
        real(ifft2(ifftshift(output1))),
        real(ifft2(ifftshift(output2))),
        real(ifft2(ifftshift(output3)))
    };
    
    filterTitles = {
        ['Apply Band Reject Gaussian Filter with W = ', num2str(W)],
        ['Apply Band Reject Butterworth Filter with degree = ', num2str(buttOrder), ' and W = ', num2str(W)],
        ['Apply Band Reject Ideal Filter with W = ', num2str(W)]
    };
end

% Function to create band reject filters
function [H1, H2, H3] = bandRejectFilter(D0, W, rows, cols, buttOrder)
    H1 = zeros(rows, cols);
    H2 = zeros(rows, cols);
    H3 = zeros(rows, cols);
    
    for i = 1:rows
        for j = 1:cols
            D = sqrt((i - floor(rows / 2) - 1)^2 + (j - floor(cols / 2) - 1)^2);
            P = (D^2 - D0^2) / (D * W);
            
            H1(i, j) = 1 - exp(-0.5 * P^2);
            H2(i, j) = 1 / (1 + P^(-2 * buttOrder));
            
            if D < (D0 - 0.5 * W) || D > (D0 + 0.5 * W)
                H3(i, j) = 1;
            else
                H3(i, j) = 0;
            end
        end
    end
end

% Function to plot results
function plotResults(noisyImage, filteredImages, filterTitles)
    figure,
    subplot(2, 2, 1), imshow(uint8(noisyImage)), title('Noisy Image (Periodic Noise)');
    for k = 1:3
        subplot(2, 2, k+1), imshow(uint8(filteredImages{k}), []), title(filterTitles{k});
    end
end

% Call the main function
periodicNoiseRemoval();
