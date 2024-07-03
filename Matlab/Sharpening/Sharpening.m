function sharpening_image
    close all
    clear all
    clc;

    %***** Sharpening *****%

    %% Inputs
    inputImage = imread('lenna.tif');
    [rows, cols, ~] = size(inputImage);

    %% Sharpening in RGB
    rgbSharpenedImage = sharpenRGB(inputImage, rows, cols);

    %% Sharpening in HSI
    hsiSharpenedImage = sharpenHSI(inputImage);

    %% Difference
    differenceImage = hsiSharpenedImage - rgbSharpenedImage;

    %% Plotting
    plotResults(inputImage, rgbSharpenedImage, hsiSharpenedImage, differenceImage);
end

function sharpenedImage = sharpenRGB(inputImage, rows, cols)
    laplacianFilter = fspecial('laplacian');
    sharpenedImage = zeros(rows, cols, 3);

    for i = 1:3
        sharpenedImage(:, :, i) = imfilter(inputImage(:, :, i), laplacianFilter);
    end

    sharpenedImage = uint8(-sharpenedImage + double(inputImage));
end

function sharpenedImage = sharpenHSI(inputImage)
    laplacianFilter = fspecial('laplacian');
    hsiImage = rgb2hsv(inputImage);
    hsiSharpened = hsiImage;
    hsiSharpened(:, :, 3) = imfilter(hsiImage(:, :, 3), laplacianFilter);

    sharpenedImage = hsv2rgb(hsiSharpened);
    sharpenedImage = uint8(-sharpenedImage + double(inputImage));
end

function plotResults(inputImage, rgbSharpenedImage, hsiSharpenedImage, differenceImage)
    figure,
    subplot(221), imshow(inputImage); title('Main Image');
    subplot(222), imshow(rgbSharpenedImage); title('Sharpening in RGB Coordinate');
    subplot(223), imshow(hsiSharpenedImage); title('Sharpening in HSI Coordinate');
    subplot(224), imshow(differenceImage); title('Difference Between Two Results');
end
