function thinning_operation
    close all
    clear all
    clc;

    %***** Thinning *****%

    %% Inputs
    inputImage = ~imread('c.tif');
    [rows, cols] = size(inputImage);

    %% Structure Elements
    B = createStructureElements();

    %% Thinning
    randVec = randperm(8);
    thinnedImage = performThinning(inputImage, B, randVec);

    %% Plotting
    plotResults(inputImage, thinnedImage, randVec);
end

function B = createStructureElements()
    B = zeros(3, 3, 8);
    B(:, :, 1) = [-1 -1 -1; 0 1 0; 1 1 1];
    B(:, :, 3) = rot90(B(:, :, 1), 3);
    B(:, :, 5) = flipud(B(:, :, 1));
    B(:, :, 7) = rot90(B(:, :, 1));
    B(:, :, 2) = [0 -1 -1; 1 1 -1; 1 1 0];
    B(:, :, 4) = rot90(B(:, :, 2), 3);
    B(:, :, 6) = fliplr(B(:, :, 4));
    B(:, :, 8) = rot90(B(:, :, 2));
end

function thinnedImage = performThinning(inputImage, B, randVec)
    thinnedImage = inputImage;

    for i = 1:8
        b = B(:, :, randVec(i));

        while true
            X = bwhitmiss(thinnedImage, b);
            X = and(thinnedImage, not(X));

            if isequal(X, thinnedImage)
                break
            end

            thinnedImage = X;
        end
    end
end

function plotResults(inputImage, thinnedImage, randVec)
    figure,
    subplot(121); imshow(inputImage); title('Main Image');
    subplot(122); imshow(thinnedImage); title('Thinned Image');
    xlabel(['Order Of Applying SEs: [ ', num2str(randVec), ' ]']);
end
