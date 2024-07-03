function sobel_edge_detection
    clear all
    close all
    clc

    % Input Image
    inputImage = imread('sobel.tif');
    [rows, cols] = size(inputImage);
    filterSize = 3;

    % Sobel Operators
    sobelHorizontal = [-1 -2 -1; 0 0 0; 1 2 1];
    sobelVertical = [-1 0 1; -2 0 2; -1 0 1];
    padSize = floor(filterSize / 2);

    % Apply Sobel Operators
    [outputImage, outputImageHorizontal, outputImageVertical] = applySobel(inputImage, rows, cols, sobelHorizontal, sobelVertical, padSize);

    % Plotting
    plotResults(inputImage, outputImage, outputImageHorizontal, outputImageVertical);
end

function [outputImage, outputImageHorizontal, outputImageVertical] = applySobel(inputImage, rows, cols, sobelHorizontal, sobelVertical, padSize)
    outputImage = zeros(rows - 2 * padSize, cols - 2 * padSize);
    outputImageHorizontal = zeros(rows - 2 * padSize, cols - 2 * padSize);
    outputImageVertical = zeros(rows - 2 * padSize, cols - 2 * padSize);

    for i = padSize + 1:rows - padSize
        for j = padSize + 1:cols - padSize
            localRegion = double(inputImage(i - padSize:i + padSize, j - padSize:j + padSize));
            localHorizontal = localRegion .* sobelHorizontal;
            localVertical = localRegion .* sobelVertical;
            outputImageHorizontal(i - padSize, j - padSize) = sum(localHorizontal(:));
            outputImageVertical(i - padSize, j - padSize) = sum(localVertical(:));
            outputImage(i - padSize, j - padSize) = abs(outputImageHorizontal(i - padSize, j - padSize)) + abs(outputImageVertical(i - padSize, j - padSize));
        end
    end
end

function plotResults(inputImage, outputImage, outputImageHorizontal, outputImageVertical)
    figure
    subplot(2, 2, 1), imshow(inputImage); title('Main Image');
    subplot(2, 2, 2), imshow(uint8(outputImage)); title('Output Image by Sobel Operators');
    subplot(2, 2, 3), imshow(uint8(outputImageVertical)); title('Vertical Edge');
    subplot(2, 2, 4), imshow(uint8(outputImageHorizontal)); title('Horizontal Edge');
end
