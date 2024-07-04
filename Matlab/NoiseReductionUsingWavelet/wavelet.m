close all
clear all
clc;

%***** Denoising Using Wavelet *****%

% Main function
function waveletDenoising()
    % Inputs
    image = imread('cameraman.tif');
    [rows, cols] = size(image);

    % Adding Noise
    noisyImage = addNoise(image);

    % Using Wavelet
    displayImages(image, noisyImage);
    performWaveletDenoising(image);
end

% Function to add noise to the image
function noisyImage = addNoise(image)
    noisyImage = imnoise(image, 'gaussian', 0, 0.5);
end

% Function to display original and noisy images
function displayImages(image, noisyImage)
    figure,
    subplot(231), imshow(image); title('Original Image');
    subplot(232), imshow(noisyImage); title('Noisy Image');
end

% Function to perform wavelet denoising and display results
function performWaveletDenoising(image)
    for level = 1:4
        % Decomposition
        [coeffs, sizes] = wavedec2(image, level, 'db3');

        % Reconstruction
        reconstructedImage = waverec2(coeffs, sizes, 'db3');

        % Plotting
        subplot(2, 3, level + 2), imshow(uint8(reconstructedImage));
        title(['Reconstruction Using db3 at Level: ', num2str(level)]);
    end
end

% Call the main function
waveletDenoising();
