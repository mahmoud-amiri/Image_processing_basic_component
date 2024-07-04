close all;
clear;
clc;

% Main function
function adaptiveLocalFilter()
    % Inputs
    [kernelDim, noiseMean, noiseVar, subImgDim, inputImage] = getInputs();
    [rows, cols] = size(inputImage);
    r = floor(kernelDim / 2);

    % Add Noise
    noisyImage = imnoise(inputImage, 'gaussian', noiseMean, noiseVar);
    paddedNoisyImage = replicatePadding(r, noisyImage, rows, cols);

    % Variance Estimation
    subImage = noisyImage(subImgDim(1):subImgDim(2), subImgDim(3):subImgDim(4));
    [imgMean, imgVar] = estimateVariance(subImage);

    % Apply Filters
    [adaptiveFilterImg, arithmeticMeanImg] = applyFilters(paddedNoisyImage, kernelDim, imgVar, r, rows, cols);

    % Display Images
    displayImages(inputImage, noisyImage, adaptiveFilterImg, arithmeticMeanImg);
end

% Function to get inputs from the user
function [kernelDim, noiseMean, noiseVar, subImgDim, inputImage] = getInputs()
    prompt = {'Enter Kernel Dimensions:', 'Enter Noise Mean:', 'Enter Noise Var:', 'Enter SubImage Dimensions:'};
    dlgTitle = 'Input';
    numLines = 1;
    def = {'7', '0', '0.001', '[30, 80, 190, 220]'};
    answer = inputdlg(prompt, dlgTitle, numLines, def);
    kernelDim = str2double(answer{1});
    noiseMean = str2double(answer{2});
    noiseVar = str2double(answer{3});
    subImgDim = str2num(answer{4});
    inputImage = imread('cameraman.tif');
end

% Function to replicate padding
function paddedImage = replicatePadding(r, inputImage, rows, cols)
    paddedImage = zeros(rows + 2 * r, cols + 2 * r);
    paddedImage(r + 1:rows + r, r + 1:cols + r) = inputImage;
    tempImage = paddedImage;

    for i = 1:r
        paddedImage(:, i) = tempImage(:, r + 1);
        paddedImage(:, cols + r + i) = tempImage(:, cols + r);
        paddedImage(i, :) = tempImage(r + 1, :);
        paddedImage(rows + r + i, :) = tempImage(rows + r, :);
    end
end

% Function to estimate variance
function [meanVal, varVal] = estimateVariance(subImage)
    [counts, ~] = imhist(subImage);
    normCounts = counts / sum(counts);
    
    meanVal = 0;
    for i = 2:256
        meanVal = meanVal + (i - 1) * normCounts(i);
    end

    varVal = 0;
    for i = 1:256
        varVal = varVal + ((i - 1 - meanVal) ^ 2) * normCounts(i);
    end
end

% Function to apply filters
function [adaptiveFilterImg, arithmeticMeanImg] = applyFilters(paddedImage, kernelDim, imgVar, r, rows, cols)
    adaptiveFilterImg = zeros(rows, cols);
    arithmeticMeanImg = zeros(rows, cols);

    for i = (kernelDim - r):(rows + r)
        for j = (kernelDim - r):(cols + r)
            localRegion = paddedImage(i - r:i + r, j - r:j + r);
            localMean = sum(localRegion(:)) / (kernelDim * kernelDim);
            localVar = sum(sum((localRegion - localMean) .^ 2)) / (kernelDim * kernelDim);
            
            adaptiveFilterImg(i - r, j - r) = paddedImage(i, j) - (imgVar / localVar) * (paddedImage(i, j) - localMean);
            arithmeticMeanImg(i - r, j - r) = localMean;
        end
    end
end

% Function to display images
function displayImages(inputImage, noisyImage, adaptiveFilterImg, arithmeticMeanImg)
    figure, imshow(noisyImage), title('Corrupted Image By Gaussian Noise');
    figure,
    subplot(121), imshow(uint8(adaptiveFilterImg)), title('Corrected Image By Applying Adaptive Local Filter');
    subplot(122), imshow(uint8(arithmeticMeanImg)), title('Corrected Image By Applying Arithmetic Mean Filter');
end

% Call the main function
adaptiveLocalFilter();
