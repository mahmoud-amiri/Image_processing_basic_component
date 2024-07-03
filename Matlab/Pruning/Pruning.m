function pruning_operation
    close all
    clear all
    clc;

    %***** Pruning *****%

    %% Inputs
    inputImage = imread('a.bmp');
    [rows, cols] = size(inputImage);

    %% Structure Elements
    B = createStructureElements();

    %% Thinning - Three Times
    thinnedImage = performThinning(inputImage, B, 3);

    %% Hit-Or-Miss: Find End Points
    endPoints = findEndPoints(thinnedImage, B, rows, cols);

    %% Dilation & Intersection
    prunedImage = performPruning(inputImage, thinnedImage, endPoints, rows, cols);

    %% Plotting
    plotResults(inputImage, thinnedImage, endPoints, prunedImage);
end

function B = createStructureElements()
    B = zeros(3, 3, 8);
    B(:, :, 1) = [0 -1 -1; 1 1 -1; 0 -1 -1];
    B(:, :, 2) = rot90(B(:, :, 1), 3);
    B(:, :, 3) = fliplr(B(:, :, 1));
    B(:, :, 4) = flipud(B(:, :, 2));
    B(:, :, 5) = [1 -1 -1; -1 1 -1; -1 -1 -1];
    B(:, :, 6) = rot90(B(:, :, 5), 3);
    B(:, :, 7) = rot90(B(:, :, 5));
    B(:, :, 8) = flipud(B(:, :, 6));
end

function thinnedImage = performThinning(inputImage, B, iterations)
    thinnedImage = inputImage;

    for k = 1:iterations
        for i = 1:8
            b = B(:, :, i);
            X1 = bwhitmiss(thinnedImage, b);
            X1 = and(thinnedImage, not(X1));
            thinnedImage = X1;
        end
    end
end

function endPoints = findEndPoints(thinnedImage, B, rows, cols)
    endPoints = false(rows, cols);

    for i = 1:8
        b = B(:, :, i);
        tempEndPoints = bwhitmiss(thinnedImage, b);
        tempEndPoints = padarray(tempEndPoints, [rows - size(tempEndPoints, 1), cols - size(tempEndPoints, 2)], 'post');
        endPoints = endPoints | tempEndPoints;  % Use logical OR to accumulate end points
    end
end

function prunedImage = performPruning(inputImage, thinnedImage, endPoints, rows, cols)
    se = strel('square', 3);
    X3 = false(rows, cols);
    tempX3 = endPoints;

    for i = 1:3
        F = imdilate(tempX3, se);
        F = padarray(F, [rows - size(F, 1), cols - size(F, 2)], 'post');  % Ensure the size matches the original image
        tempX3 = F & inputImage;
        X3 = X3 | tempX3;  % Use logical OR to accumulate pruned points
    end

    prunedImage = or(thinnedImage, X3);
end

function plotResults(inputImage, thinnedImage, endPoints, prunedImage)
    figure,
    subplot(231), imshow(inputImage); title('Main Image');
    subplot(232), imshow(thinnedImage); title('Thinning (3-Times)');
    subplot(233), imshow(endPoints); title('End Points Of Thinning Result');
    subplot(2, 3, 4.5), imshow(prunedImage); title('Dilation Of End Points Conditioned On Main Image (3-Times)');
    subplot(2, 3, 5.5), imshow(prunedImage); title('Pruned Image');
end
