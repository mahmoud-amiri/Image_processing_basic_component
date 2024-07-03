function improve_global_thresholding_using_edges
    close all
    clear all
    clc;

    %***** Using Edges To Improve Global Thresholding *****%

    %% Inputs
    inputImage = imread('UE.tif');
    [rows, cols] = size(inputImage);

    %% Applying Otsu Without Using Edges
    otsuThreshold = graythresh(inputImage);
    otsuOutput = im2bw(inputImage, otsuThreshold);

    %% Laplacian Or Gradient
    laplacianKernel = [1 1 1; 1 -8 1; 1 1 1]; % Equivalent to fspecial('laplacian')
    laplacianImage = imfilter(inputImage, laplacianKernel);

    [gradientMag, ~] = imgradient(inputImage);

    %% Find Boundary
    boundaryImageLaplacian = laplacianImage .* inputImage;
    boundaryImageGradient = uint8(gradientMag) .* inputImage;

    %% Using Otsu
    otsuThresholdLaplacian = graythresh(boundaryImageLaplacian);
    otsuOutputLaplacian = im2bw(inputImage, otsuThresholdLaplacian);

    otsuThresholdGradient = graythresh(boundaryImageGradient);
    otsuOutputGradient = im2bw(inputImage, otsuThresholdGradient);

    %% Plotting
    figure,
    subplot(231), imshow(inputImage); title('Main Image');
    subplot(232), imhist(inputImage); title('Histogram of Main Image');
    subplot(233), imshow(otsuOutput); title('Applying Otsu Without Using Edges');
    subplot(234), imshow(laplacianImage > 10, []); title('Edge Detection Using Laplacian');
    subplot(235), imhist(boundaryImageLaplacian); title('Histogram of Non-Zero Pixels in Image');
    subplot(236), imshow(otsuOutputLaplacian); title('Applying Otsu After Using Laplacian to Finding Edges');

    figure,
    subplot(231), imshow(inputImage); title('Main Image');
    subplot(232), imhist(inputImage); title('Histogram of Main Image');
    subplot(233), imshow(otsuOutput); title('Applying Otsu Without Using Edges');
    subplot(234), imshow(gradientMag > 50); title('Edge Detection Using Magnitude of Gradient');
    subplot(235), imhist(boundaryImageGradient); title('Histogram of Non-Zero Pixels in Image');
    subplot(236), imshow(otsuOutputGradient); title('Applying Otsu After Using Gradient to Finding Edges');
end
