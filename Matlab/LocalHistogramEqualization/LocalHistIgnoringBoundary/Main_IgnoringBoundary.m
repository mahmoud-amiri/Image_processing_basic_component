function histogram_equalization_masking
    clear all;
    close all;
    clc;

    %% Inputs
    inputImage = imread('HistEQMasking.tif');
    [rows, cols] = size(inputImage);
    kernelSize = input('Enter Kernel Function dimensions = ');
    padSize = floor(kernelSize / 2);

    %% Histogram Equalization By Masking (Ignoring Boundary)
    outputImage = apply_histogram_equalization(inputImage, rows, cols, kernelSize, padSize);

    %% Plotting
    figure, imshow(inputImage); title('Main Image');
    figure, imshow(outputImage); title(['Output Image by Kernel Dimensions = ', num2str(kernelSize)]);
    figure, imhist(inputImage); title('Histogram of Input Image');
    figure, imhist(outputImage); title('Histogram of Output Image');
end

function outputImage = apply_histogram_equalization(inputImage, rows, cols, kernelSize, padSize)
    outputImage = zeros(rows - kernelSize + 1, cols - kernelSize + 1);

    for i = (kernelSize - padSize):(rows - padSize)
        for j = (kernelSize - padSize):(cols - padSize)
            localRegion = inputImage(i - padSize:i + padSize, j - padSize:j + padSize);
            histEqRegion = histogram_equalize(localRegion, kernelSize);
            outputImage(i - padSize, j - padSize) = histEqRegion(padSize + 1, padSize + 1);
        end
    end
end

function histEqRegion = histogram_equalize(localRegion, kernelSize)
    histEqRegion = zeros(kernelSize, kernelSize);

    %% Calculate Histogram
    histVec = zeros(1, 256);
    for i = 1:kernelSize
        for j = 1:kernelSize
            histVec(localRegion(i, j) + 1) = histVec(localRegion(i, j) + 1) + 1;
        end
    end

    %% Histogram Equalization
    probVec = histVec / (kernelSize * kernelSize);
    cumHist = zeros(1, 256);
    cumHist(1) = probVec(1);
    for i = 2:256
        cumHist(i) = cumHist(i - 1) + probVec(i);
    end

    for i = 1:kernelSize
        for j = 1:kernelSize
            histEqRegion(i, j) = cumHist(localRegion(i, j) + 1);
        end
    end
end
