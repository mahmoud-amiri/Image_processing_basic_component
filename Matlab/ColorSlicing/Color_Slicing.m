function Color_Slicing
    close all
    clear all
    clc;

    %***** Color Slicing *****%

    %% Inputs
    rgbImage = im2double(imread('s2.tif'));
    [rows, cols, ~] = size(rgbImage);

    %% Color Slicing - Red & Green Using Cube
    centerRed = [0.6863; 0.1608; 0.1922];
    centerGreen = [0.3863; 0.4608; 0.1022];
    widthRed = 0.2549;
    widthGreen = 0.2549;
    radiusRed = 0.1765;
    radiusGreen = 0.1765;
    covRed = [1 0 0; 0 0.16 0; 0 0 0.19];
    covGreen = [0.1 0 0; 0 1 0; 0 0 0.1];

    outCubeRed = sliceColor(rgbImage, rows, cols, centerRed, widthRed, 'cube');
    outSphereRed = sliceColor(rgbImage, rows, cols, centerRed, radiusRed, 'sphere');
    outEllipticRed = sliceColor(rgbImage, rows, cols, centerRed, radiusRed, 'elliptic', covRed);

    outCubeGreen = sliceColor(rgbImage, rows, cols, centerGreen, widthGreen, 'cube');
    outSphereGreen = sliceColor(rgbImage, rows, cols, centerGreen, radiusGreen, 'sphere');
    outEllipticGreen = sliceColor(rgbImage, rows, cols, centerGreen, radiusGreen, 'elliptic', covGreen);

    %% Plotting
    figure,
    subplot(231), imshow(outCubeRed); title('Image Slicing: Red - Using City Block');
    subplot(232), imshow(outSphereRed); title('Image Slicing: Red - Using Euclidean');
    subplot(233), imshow(outEllipticRed); title('Image Slicing: Red - Using Mahalanobis');
    subplot(234), imshow(outCubeGreen); title('Image Slicing: Green - Using City Block');
    subplot(235), imshow(outSphereGreen); title('Image Slicing: Green - Using Euclidean');
    subplot(236), imshow(outEllipticGreen); title('Image Slicing: Green - Using Mahalanobis');
end

function outputImage = sliceColor(inputImage, rows, cols, center, param, method, covMatrix)
    if nargin < 7
        covMatrix = [];
    end
    outputImage = zeros(rows, cols, 3);
    for i = 1:rows
        for j = 1:cols
            pixel = squeeze(inputImage(i, j, :));
            diff = pixel - center;
            switch method
                case 'cube'
                    if any(abs(diff) > 0.5 * param)
                        outputImage(i, j, :) = 0.5;
                    else
                        outputImage(i, j, :) = pixel;
                    end
                case 'sphere'
                    if sum(diff .^ 2) > param^2
                        outputImage(i, j, :) = 0.5;
                    else
                        outputImage(i, j, :) = pixel;
                    end
                case 'elliptic'
                    if diff' * covMatrix * diff > param^2
                        outputImage(i, j, :) = 0.5;
                    else
                        outputImage(i, j, :) = pixel;
                    end
            end
        end
    end
end
