close all
clear all
clc;

%***** Image High Pass Filtering *****%

% Main function
function highPassFiltering()
    % Inputs
    inputImage = imread('HFE.tif');
    [rows, cols] = size(inputImage);
    freqImage = fft2(fftshift(inputImage));
    D0 = 40;
    n = 2;

    % Butterworth High Pass Filtering
    butterworthFilter = createButterworthHPF(inputImage, n, D0);
    butterworthFilter = fftshift(butterworthFilter); 
    freqOutput1 = freqImage .* butterworthFilter;
    output1 = ifftshift(ifft2(freqOutput1));
    output1Scaled = scaleImage(output1);
    figure, imshow(uint8(output1Scaled)), title(['Result of Butterworth High Pass Filtering with n = ', num2str(n), ' and D0 = ', num2str(D0)]);

    % Gaussian High Pass Filtering
    gaussianFilter = createGaussianHPF(1, rows, cols, D0, 0.5, 0.5);
    gaussianFilter = fftshift(gaussianFilter);
    freqOutput2 = freqImage .* gaussianFilter;
    output2 = ifftshift(ifft2(freqOutput2));
    output2Scaled = scaleImage(output2);
    figure, imshow(uint8(output2Scaled)), title(['Result of Gaussian High Pass Filtering with D0 = ', num2str(D0)]);

    % High Frequency Emphasis Filtering
    k1 = 0.5;
    k2 = 0.75;
    H1 = k1 + k2 * butterworthFilter;
    H2 = k1 + k2 * gaussianFilter;
    freqOutput3 = freqImage .* H1;
    freqOutput4 = freqImage .* H2;
    output3 = ifftshift(ifft2(freqOutput3));
    output4 = ifftshift(ifft2(freqOutput4));
    output3Scaled = scaleImage(output3);
    output4Scaled = scaleImage(output4);
    figure, imshow(uint8(output3Scaled)), title(['Result of High Frequency Emphasis Filtering Using BHPF with k1 = ', num2str(k1), ' and k2 = ', num2str(k2)]);
    figure, imshow(uint8(output4Scaled)), title(['Result of High Frequency Emphasis Filtering Using GHPF with k1 = ', num2str(k1), ' and k2 = ', num2str(k2)]);

    % Display Original Image
    figure, imshow(inputImage), title('Original Image');
end

% Function to scale the image
function scaledImage = scaleImage(inputImage)
    minVal = min(inputImage(:));
    scaledImage = inputImage - minVal;
    maxVal = max(scaledImage(:));
    scaledImage = scaledImage * (255 / maxVal);
end

% Function to create Gaussian High Pass Filter
function gaussianFilter = createGaussianHPF(A, rows, cols, sigma, a, b)
    gaussianFilter = zeros(rows, cols);
    for i = 1:rows
        for j = 1:cols
            D = ((i - a * rows) ^ 2 + (j - b * cols) ^ 2) / (2 * sigma ^ 2);
            gaussianFilter(i, j) = 1 - A * exp(-D);
        end
    end
end

% Function to create Butterworth High Pass Filter
function butterworthFilter = createButterworthHPF(inputImage, n, D0)
    [rows, cols] = size(inputImage);
    butterworthFilter = zeros(rows, cols);
    for i = 1:rows
        for j = 1:cols
            D = sqrt((i - floor(rows / 2) - 1) ^ 2 + (j - floor(cols / 2) - 1) ^ 2);
            D = (D / D0) ^ (2 * n);
            butterworthFilter(i, j) = 1 - 1 / (1 + D);
        end
    end
end

% Call the main function
highPassFiltering();
