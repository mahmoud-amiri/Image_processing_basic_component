function image_histogram
    close all
    clear all
    clc;

    %***** Histogram *****%

    % Input Image
    inputImage = imread('cameraman.tif');
    yAxesScale = 0; % Change to desired y-axis scale if needed
    [rows, cols] = size(inputImage);

    % Calculate histogram
    histVector = calculateHistogram(inputImage, rows, cols);

    % Plotting
    plotHistograms(inputImage, histVector, yAxesScale);
end

function histVector = calculateHistogram(inputImage, rows, cols)
    histVector = zeros(1, 256);

    for i = 1:rows
        for j = 1:cols
            histVector(inputImage(i, j) + 1) = histVector(inputImage(i, j) + 1) + 1;
        end
    end
end

function plotHistograms(inputImage, histVector, yAxesScale)
    t = 0:255;

    subplot(2, 2, 3);
    if yAxesScale == 0
        stem(t, histVector, 'Marker', 'none'); xlim([0, 256]); title('Image Histogram');
    else
        stem(t, histVector, 'Marker', 'none'); xlim([0, 256]); ylim([0, yAxesScale]); title('Image Histogram');
    end

    subplot(2, 2, 4);
    imhist(inputImage); title('Using Imhist Command');

    subplot(2, 2, [1, 2]);
    imshow(inputImage);
end
