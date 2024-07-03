function fft2_example
    close all
    clear all
    clc;

    %% FFT2 with FFT
    inputImage = imread('cameraman.tif');
    [rows, cols] = size(inputImage);

    % Initialize output images
    outputImage1 = zeros(rows, cols);
    outputImage2 = zeros(rows, cols);

    % Apply FFT row-wise
    for i = 1:rows
        outputImage1(i, :) = fft(inputImage(i, :));
    end

    % Apply FFT column-wise on the result of row-wise FFT
    for j = 1:cols
        outputImage2(:, j) = fft(outputImage1(:, j));
    end

    % Apply MATLAB's built-in 2D FFT
    outputImage3 = fft2(inputImage);

    %% Plotting
    figure;
    subplot(221), imshow(inputImage, []), title('Main Image');
    subplot(223), imshow(log(abs(outputImage1)), []), title('Vertical FFT');
    subplot(224), imshow(log(abs(outputImage2)), []), title('Horizontal FFT (After Vertical FFT)');
    subplot(222), imshow(log(abs(outputImage3)), []), title('Using FFT2');
end
