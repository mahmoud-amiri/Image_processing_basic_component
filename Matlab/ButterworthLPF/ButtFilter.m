function butterworth_low_pass_filter
    close all;
    clear all;
    clc;

    %************ Butterworth Low Pass Filter ************%
    %% A : Low Pass Butterworth with n = 2 and D0 = 10, 30, 60, 160, 460
    inputImage = imread('BLPF.tif');
    [rows, cols] = size(inputImage);
    freqImage = fft2(fftshift(inputImage));
    cutoffFrequencies = [10, 30, 60, 160, 460];
    figure, subplot(2, 3, 1), imshow(inputImage); title('Original Image');

    for i = 1:length(cutoffFrequencies)
        butterworthFilter = butterworth_lpf(inputImage, 2, cutoffFrequencies(i));    
        butterworthFilter = fftshift(butterworthFilter); 
        freqOutput = freqImage .* butterworthFilter;
        outputImage = ifftshift(ifft2(freqOutput));
        subplot(2, 3, i+1), imshow(uint8(outputImage), []); title(['Butterworth Low Pass Filter with n=2 and D0 = ', num2str(cutoffFrequencies(i))]);
    end

    %% B : Low Pass Butterworth with D0 = 30 and n = 1, 2, 4, 8, 32
    cutoffFrequency = 30;
    filterOrders = [1, 2, 4, 8, 32];
    figure, subplot(2, 3, 1), imshow(inputImage); title('Original Image');

    for i = 1:length(filterOrders)
        butterworthFilter = butterworth_lpf(inputImage, filterOrders(i), cutoffFrequency);    
        butterworthFilter = fftshift(butterworthFilter); 
        freqOutput = freqImage .* butterworthFilter;
        outputImage = ifftshift(ifft2(freqOutput));
        subplot(2, 3, i+1), imshow(uint8(outputImage), []); title(['Butterworth Low Pass Filter with D0 = 30 and n = ', num2str(filterOrders(i))]);
    end
end

function butterworthFilter = butterworth_lpf(inputImage, order, cutoffFrequency)
    [rows, cols] = size(inputImage);
    butterworthFilter = zeros(rows, cols);

    for i = 1:rows
        for j = 1:cols
            distance = sqrt((i - floor(rows / 2) - 1)^2 + (j - floor(cols / 2) - 1)^2);
            distance = (distance / cutoffFrequency) ^ (2 * order);
            butterworthFilter(i, j) = 1 / (1 + distance);
        end
    end
end

function scaledImage = scale_image(inputImage)
    minVal = min(min(inputImage));
    scaledImage = inputImage - minVal;
    maxVal = max(max(scaledImage));
    scaledImage = scaledImage * (255 / maxVal);
end

function paddedImage = zero_pad(inputImage, padRows, padCols)
    [rows, cols] = size(inputImage);
    paddedImage = zeros(rows + padRows - 1, cols + padCols - 1);
    rowOffset = floor(padRows / 2);
    colOffset = floor(padCols / 2);
    paddedImage(rowOffset + 1:rows + rowOffset, colOffset + 1:cols + colOffset) = inputImage;
end
