function boundary_extraction
    close all
    clear all
    clc;

    %***** Boundary Extraction *****%

    %% Inputs
    inputImage = imread('BE.tif');
    [rows, cols] = size(inputImage);

    %% Erosion
    structElem = strel('square', 3);
    nhood = getnhood(structElem);
    [seRows, seCols] = size(nhood);
    padding = max(floor(seRows / 2), floor(seCols / 2));
    [paddedImage, newRows, newCols] = zeroPad(padding, inputImage, rows, cols);
    erodedImage = erosion(paddedImage, newRows, newCols, padding, nhood);

    %% Boundary Extraction
    outputImage = inputImage - erodedImage;

    %% Plotting
    plotResults(inputImage, outputImage);
end

function [paddedImage, newRows, newCols] = zeroPad(padding, inputImage, rows, cols)
    paddedImage = zeros(rows + 2 * padding, cols + 2 * padding);
    paddedImage(padding + 1:rows + padding, padding + 1:cols + padding) = inputImage;
    [newRows, newCols] = size(paddedImage);
end

function erodedImage = erosion(paddedImage, rows, cols, padding, nhood)
    erodedImage = zeros(rows - 2 * padding, cols - 2 * padding);
    for i = padding + 1:rows - padding
        for j = padding + 1:cols - padding
            localRegion = paddedImage(i - padding:i + padding, j - padding:j + padding);
            if all(localRegion(nhood == 1))
                erodedImage(i - padding, j - padding) = 1;
            else
                erodedImage(i - padding, j - padding) = 0;
            end
        end
    end
end

function plotResults(inputImage, outputImage)
    figure,
    subplot(121), imshow(inputImage); title('Main Image');
    subplot(122), imshow(outputImage); title('Boundary of Main Image');
end
