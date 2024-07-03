function skeleton_extraction
    close all
    clear all
    clc;

    %***** Skeleton *****%

    %% Inputs
    inputImage = ~imread('Sk.tif');
    [rows, cols] = size(inputImage);

    %% Structure Element
    structElem = strel('square', 3);

    %% Skeleton
    skeletonImage = computeSkeleton(inputImage, structElem);

    %% Plotting
    plotResults(inputImage, skeletonImage);
end

function skeletonImage = computeSkeleton(inputImage, structElem)
    A = inputImage;
    B = imopen(A, structElem);
    skeletonImage = and(A, not(B));

    while true
        A = imerode(A, structElem);
        if all(A(:) == 0)
            break;
        end
        B = imopen(A, structElem);
        B = and(A, not(B));
        skeletonImage = skeletonImage | B;
    end
end

function plotResults(inputImage, skeletonImage)
    figure,
    subplot(121), imshow(inputImage); title('Main Image');
    subplot(122), imshow(skeletonImage); title('Skeleton Of Main Image');
end
