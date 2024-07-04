close all;
clear;
clc;

% Main function
function geodesicOpeningByReconstruction()
    % Inputs
    inputImage = imread('GD.tif');
    [rows, cols] = size(inputImage);

    % Structure Element
    SE1 = strel('line', 51, 90);
    SE2 = strel('square', 3);

    % Opening By Reconstruction
    [erosionImage, reconstructionImage, numIterations] = openingByReconstruction(inputImage, SE1, SE2);

    % Opening
    openingImage = imopen(inputImage, SE1);

    % Plotting Results
    plotResults(inputImage, erosionImage, openingImage, reconstructionImage, numIterations);
end

% Function to perform opening by reconstruction
function [erosionImage, reconstructionImage, numIterations] = openingByReconstruction(inputImage, SE1, SE2)
    erosionImage = imerode(inputImage, SE1);
    X = imdilate(erosionImage, SE2);
    reconstructionImage = X & inputImage;
    numIterations = 1;

    while true
        X = imdilate(reconstructionImage, SE2);
        X = X & inputImage;

        if isequal(X, reconstructionImage)
            break;
        end

        reconstructionImage = X;
        numIterations = numIterations + 1;
    end
end

% Function to plot results
function plotResults(inputImage, erosionImage, openingImage, reconstructionImage, numIterations)
    figure,
    subplot(221), imshow(inputImage), title('Main Image');
    subplot(222), imshow(erosionImage), title('Erosion Using Line SE (51 x 1)');
    subplot(223), imshow(openingImage), title('Opening with Line SE (51 x 1)');
    subplot(224), imshow(reconstructionImage), title(['Opening By Reconstruction with Square SE (3 x 3), Iterations: ', num2str(numIterations)]);
end

% Call the main function
geodesicOpeningByReconstruction();
