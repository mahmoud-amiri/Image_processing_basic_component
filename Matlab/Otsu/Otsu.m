function Otsu
    close all
    clear all
    clc;

    %***** Otsu Thresholding Procedure *****%

    %% Inputs
    inputImage = imread('Otsu.tif');
    [rows, cols] = size(inputImage);

    % Compute normalized histogram
    normHist = imhist(inputImage) / (rows * cols);

    % Compute Otsu's threshold
    otsuThreshold = computeOtsuThreshold(normHist, rows, cols);

    % Segment the image using the computed threshold
    outputImage = applyThreshold(inputImage, otsuThreshold);

    % Use in-built MATLAB function for comparison
    builtInThreshold = graythresh(inputImage);
    builtInOutputImage = im2bw(inputImage, builtInThreshold);

    %% Plotting
    figure,
    subplot(131), imshow(inputImage); title('Main Image');
    subplot(132), imshow(outputImage); title(['Thresholding Image Using Otsu with T = ', num2str(otsuThreshold)]);
    subplot(133), imshow(builtInOutputImage); title(['Applying Otsu Using In-Built Function with T = ', num2str(builtInThreshold)]);
end

function otsuThreshold = computeOtsuThreshold(normHist, rows, cols)
    % Initialize variables
    meanValues = zeros(256, 1);
    meanValues(1) = normHist(1);

    % Compute cumulative means
    for k = 2:256
        meanValues(k) = meanValues(k - 1) + k * normHist(k);
    end

    globalMean = meanValues(256);

    % Compute cumulative probabilities
    cumulativeProbs = zeros(1, 255);
    for k = 1:255
        cumulativeProbs(k) = sum(normHist(1:k));
    end

    % Compute within-class variance
    sigma2 = zeros(254, 1);
    for k = 2:255
        sigma2(k) = (globalMean * cumulativeProbs(k) - meanValues(k)).^2 / (cumulativeProbs(k) * (1 - cumulativeProbs(k)));
    end

    % Find the threshold that maximizes the between-class variance
    [~, otsuThreshold] = max(sigma2);
end

function outputImage = applyThreshold(inputImage, threshold)
    % Get image dimensions
    [rows, cols] = size(inputImage);

    % Initialize output image
    outputImage = zeros(rows, cols);

    % Apply threshold to segment the image
    for i = 1:rows
        for j = 1:cols
            if inputImage(i, j) < threshold
                outputImage(i, j) = 0;
            else
                outputImage(i, j) = 1;
            end
        end
    end
end
