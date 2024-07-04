function laplacian_filtering
    clear all;
    close all;
    clc;

    %% Inputs
    inputImage = imread('Laplacian.tif');
    [rows, cols] = size(inputImage);
    kernelSize = 3;

    %% Laplacian Kernels
    laplacianKernel = [0 1 0; 1 -4 1; 0 1 0];
    isotropicLaplacianKernel = [1 1 1; 1 -8 1; 1 1 1];
    padSize = floor(kernelSize / 2);

    %% Apply Laplacian Filters
    [outputImageLaplacian, laplacianResult] = apply_laplacian(inputImage, laplacianKernel, rows, cols, padSize);
    [outputImageIsotropic, isotropicResult] = apply_laplacian(inputImage, isotropicLaplacianKernel, rows, cols, padSize);

    %% Scaling Laplacian Results
    scaledLaplacian = scale_image(laplacianResult);
    scaledIsotropicLaplacian = scale_image(isotropicResult);

    %% Plotting
    plot_results(inputImage, outputImageLaplacian, outputImageIsotropic, laplacianResult, scaledLaplacian, isotropicResult, scaledIsotropicLaplacian);
end

function [outputImage, laplacianResult] = apply_laplacian(inputImage, kernel, rows, cols, padSize)
    laplacianResult = zeros(rows - padSize * 2, cols - padSize * 2);
    outputImage = zeros(rows - padSize * 2, cols - padSize * 2);

    for i = (padSize + 1):(rows - padSize)
        for j = (padSize + 1):(cols - padSize)
            localRegion = double(inputImage(i - padSize:i + padSize, j - padSize:j + padSize));
            laplacianValue = sum(sum(localRegion .* kernel));
            laplacianResult(i - padSize, j - padSize) = laplacianValue;
            outputImage(i - padSize, j - padSize) = double(inputImage(i, j)) - laplacianValue;
        end
    end
end

function scaledImage = scale_image(inputImage)
    minVal = min(min(inputImage));
    scaledImage = inputImage - minVal;
    maxVal = max(max(scaledImage));
    scaledImage = scaledImage * (255 / maxVal);
end

function plot_results(inputImage, outputImageLaplacian, outputImageIsotropic, laplacianResult, scaledLaplacian, isotropicResult, scaledIsotropicLaplacian)
    figure,
    subplot(131), imshow(inputImage); title('Main Image');
    subplot(132), imshow(uint8(outputImageLaplacian)); title('Output Image By Laplacian');
    subplot(133), imshow(uint8(outputImageIsotropic)); title('Output Image By Isotropic Laplacian');

    figure, imshow(uint8(laplacianResult)); title('Laplacian Without Scaling');
    figure, imshow(uint8(scaledLaplacian)); title('Laplacian With Scaling');
    figure, imshow(uint8(isotropicResult)); title('Isotropic Laplacian Without Scaling');
    figure, imshow(uint8(scaledIsotropicLaplacian)); title('Isotropic Laplacian With Scaling');
end
