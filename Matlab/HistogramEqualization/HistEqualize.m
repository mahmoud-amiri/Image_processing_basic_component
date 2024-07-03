function histogram_equalization
    close all
    clear all
    clc

    %***** Histogram Equalization *****%

    inputImage = imread('1.jpg');
    [rows, cols] = size(inputImage);

    % Perform Histogram Equalization
    outputImage = equalizeHistogram(inputImage, rows, cols);

    % Calculate cumulative histogram
    cumulativeHistogram = calculateCumulativeHistogram(inputImage, rows, cols);

    % Plotting
    plotResults(inputImage, outputImage, cumulativeHistogram);
end

function outputImage = equalizeHistogram(inputImage, rows, cols)
    pr = imhist(inputImage) / (rows * cols);
    s = cumsum(pr);
    outputImage = zeros(rows, cols);

    for i = 1:rows
        for j = 1:cols
            outputImage(i, j) = s(double(inputImage(i, j)) + 1);
        end
    end
end

function cumulativeHistogram = calculateCumulativeHistogram(inputImage, rows, cols)
    pr = imhist(inputImage) / (rows * cols);
    cumulativeHistogram = cumsum(pr);
end

function plotResults(inputImage, outputImage, cumulativeHistogram)
    t = 0:255;

    figure;
    subplot(2, 3, 1), imshow(inputImage); title('Original Image')
    subplot(2, 3, 3), imshow(outputImage, []); title('Output Image By Histogram Equalization')
    subplot(2, 3, 5), stem(t, cumulativeHistogram, 'Marker', 'none'); xlim([0, 255]); ylim([0, 1.1]); title('Cumulative Histogram')
    subplot(2, 3, 4), imhist(inputImage); title('Main Image Histogram')
    subplot(2, 3, 6), imhist(outputImage); title('Output Image Histogram')
end
