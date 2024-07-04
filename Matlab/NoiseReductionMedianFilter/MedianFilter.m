clear all
clc;

%***** Median Filtering *****%

% Main function
function medianFiltering()
    % Inputs
    [windowDim, noiseDensity, inputImage] = getInputs();
    [rows, cols] = size(inputImage);

    % Add Salt & Pepper Noise
    noisyImage = imnoise(inputImage, 'Salt & Pepper', noiseDensity);

    % Apply Median Filter
    filteredImage = applyMedianFilter(noisyImage, windowDim, rows, cols);

    % Plotting
    displayImages(inputImage, noisyImage, filteredImage, noiseDensity);
end

% Function to get inputs from the user
function [windowDim, noiseDensity, inputImage] = getInputs()
    prompt = {'Enter Window Dimensions', 'Enter Noise Density'};
    dlgTitle = 'Enter Two Points for Transformation';
    numLines = 1;
    def = {'3', '0.1'};
    answer = inputdlg(prompt, dlgTitle, numLines, def);
    windowDim = str2double(answer{1});
    noiseDensity = str2double(answer{2});
    inputImage = imread('cameraman.tif');
end

% Function to apply median filter
function filteredImage = applyMedianFilter(noisyImage, windowDim, rows, cols)
    r = floor(windowDim / 2);
    filteredImage = zeros(rows - windowDim + 1, cols - windowDim + 1);

    for i = (windowDim - r):(rows - r)
        for j = (windowDim - r):(cols - r)
            localImage = noisyImage(i - r:i + r, j - r:j + r);
            medianVal = computeMedian(localImage, windowDim);
            filteredImage(i - r, j - r) = medianVal;
        end
    end
end

% Function to compute median value
function medianVal = computeMedian(localImage, windowDim)
    localVec = reshape(localImage', 1, []);
    sortedVec = sort(localVec);
    medianVal = sortedVec(floor((windowDim * windowDim) / 2) + 1);
end

% Function to display images
function displayImages(inputImage, noisyImage, filteredImage, noiseDensity)
    subplot(131), imshow(inputImage), title('Main Image');
    subplot(132), imshow(noisyImage), title(['Corrupted Image by Salt & Pepper Noise with Density = ', num2str(noiseDensity)]);
    subplot(133), imshow(uint8(filteredImage)), title('Corrected Image by Applying Median Filter');
end

% Call the main function
medianFiltering();
