function detect_lines_hough_transform
    close all
    clear all
    clc;

    %***** Detecting Line Using Hough Transform *****%

    %% Inputs
    inputImage = imread('HL.tif');
    [rows, cols] = size(inputImage);

    diagonal = 2 * max(rows, cols);
    theta = linspace(-90, 90, 181);
    thetaRad = deg2rad(theta);

    %% Edge Detection Using Canny's Algorithm
    edgeImage = edge(inputImage, 'canny', 0.2);

    %% Hough Transform
    accumulator = computeHoughTransform(edgeImage, rows, cols, thetaRad, diagonal);

    %% Finding All Lines Correspond to Maximum Interception Points
    edgeImageNew = findLines(accumulator, rows, cols, diagonal, thetaRad, edgeImage, 0.85);

    %% Finding Line Correspond to Airport Landing Zone Or Band
    [edgeImageBand, outputImage] = findLandingZoneLines(accumulator, rows, cols, diagonal, thetaRad, inputImage, 0.85);

    %% Final Combined Edge Image
    edgeImageFinal = or(edgeImage, edgeImageNew);

    %% Plotting
    plotResults(inputImage, accumulator, edgeImageNew, edgeImageBand, edgeImageFinal, outputImage);
end

function accumulator = computeHoughTransform(edgeImage, rows, cols, thetaRad, diagonal)
    accumulator = zeros(2 * diagonal, 181);
    for i = 1:rows
        for j = 1:cols
            if edgeImage(i, j) ~= 0
                rho = i * cos(thetaRad) + j * sin(thetaRad);
                for t = -90:90
                    rhoVal = round(rho(t + 91));
                    accumulator(rhoVal + diagonal, t + 91) = accumulator(rhoVal + diagonal, t + 91) + 1;
                end
            end
        end
    end
end

function edgeImageNew = findLines(accumulator, rows, cols, diagonal, thetaRad, edgeImage, thresholdRatio)
    maxVal = max(max(accumulator));
    threshold = round(thresholdRatio * maxVal);
    indices = (accumulator >= threshold);
    numLines = sum(sum(indices));
    indx = zeros(numLines, 2);
    k = 1;

    for i = 1:2 * diagonal
        for j = 1:181
            if indices(i, j) ~= 0
                indx(k, :) = [i, j];
                k = k + 1;
            end
        end
    end

    edgeImageNew = zeros(rows, cols);
    for i = 1:numLines
        theta = indx(i, 2) - 91;
        radTheta = deg2rad(theta);
        rho = indx(i, 1) - diagonal;
        for m = 1:rows
            for n = 1:cols
                r = m * cos(radTheta) + n * sin(radTheta);
                if abs(r - rho) < 0.8
                    edgeImageNew(m, n) = 1;
                end
            end
        end
    end
end

function [edgeImageBand, outputImage] = findLandingZoneLines(accumulator, rows, cols, diagonal, thetaRad, inputImage, thresholdRatio)
    maxVal = max(max(accumulator));
    indices = (accumulator >= thresholdRatio * maxVal);
    numLines = sum(sum(indices));
    indx = zeros(numLines, 2);
    k = 1;

    for i = 0.5 * cols + diagonal:0.5 * cols + diagonal + 100
        for j = 175:181
            if indices(i, j) ~= 0
                indx(k, :) = [i, j];
                k = k + 1;
            end
        end
    end

    edgeImageBand = zeros(rows, cols);
    outputImage = repmat(inputImage, [1, 1, 3]);

    for i = 1:numLines
        theta = indx(i, 2) - 91;
        radTheta = deg2rad(theta);
        rho = indx(i, 1) - diagonal;
        for m = 1:rows
            for n = 1:cols
                r = m * cos(radTheta) + n * sin(radTheta);
                if abs(r - rho) < 1
                    edgeImageBand(m, n) = 1;
                    outputImage(m, n, 1) = 255;
                    outputImage(m, n, 2) = 0;
                    outputImage(m, n, 3) = 0;
                end
            end
        end
    end
end

function plotResults(inputImage, accumulator, edgeImageNew, edgeImageBand, edgeImageFinal, outputImage)
    figure;
    subplot(231), imshow(inputImage); title('Main Image');
    subplot(232), imagesc(accumulator); title('\rho\theta Plane');
    subplot(233), imshow(edgeImageNew); title('All Lines with Maximum Interception');
    subplot(234), imshow(edgeImageBand); title('Airport Landing Zone');
    subplot(235), imshow(edgeImageFinal); title('Distinguishing Lines');
    subplot(236), imshow(outputImage); title('Specifying Airport Band in Image');
end
