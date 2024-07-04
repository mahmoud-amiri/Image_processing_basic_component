close all
clear all
clc;

%***** Image Shrinking by Bilinear Interpolation *****%

% Main function
function bilinearShrinking()
    % Inputs
    [inputImage, scaleM, scaleN, filterDim] = getInputs();

    % Smoothing
    averagedImage = applySmoothing(inputImage, filterDim);

    % Replicating Boundary
    replicatedImage1 = replicateBoundary(inputImage);
    replicatedImage2 = replicateBoundary(averagedImage);

    % Size of Output Image
    [newRows, newCols] = computeOutputSize(inputImage, scaleM, scaleN);

    % Bilinear Method
    outputImage1 = bilinearInterpolation(replicatedImage1, scaleM, scaleN, newRows, newCols);
    outputImage2 = bilinearInterpolation(replicatedImage2, scaleM, scaleN, newRows, newCols);

    % Plotting
    displayImages(inputImage, outputImage1, outputImage2, scaleM, scaleN);
end

% Function to get inputs from the user
function [inputImage, scaleM, scaleN, filterDim] = getInputs()
    inputImage = imread('Cameraman.tif');
    prompt = {'Enter m:', 'Enter n:', 'Enter Averaging Filter Dimension:'};
    dlgTitle = 'Enter Two Scale Values';
    numLines = 1;
    def = {'m', 'n', 'D'};
    answer = inputdlg(prompt, dlgTitle, numLines, def);
    scaleM = str2double(answer{1});
    scaleN = str2double(answer{2});
    filterDim = str2double(answer{3});
end

% Function to apply smoothing using an averaging filter
function averagedImage = applySmoothing(inputImage, filterDim)
    filter = ones(filterDim, filterDim) / (filterDim * filterDim);
    averagedImage = imfilter(inputImage, filter, 'same');
end

% Function to replicate boundary
function replicatedImage = replicateBoundary(inputImage)
    [rows, cols] = size(inputImage);
    padSize = 1;
    paddedImage = padarray(inputImage, [padSize, padSize], 'replicate', 'both');
    replicatedImage = paddedImage;
end

% Function to compute the size of the output image
function [newRows, newCols] = computeOutputSize(inputImage, scaleM, scaleN)
    [rows, cols] = size(inputImage);
    newRows = floor(scaleM * rows);
    newCols = floor(scaleN * cols);
end

% Function for bilinear interpolation
function outputImage = bilinearInterpolation(inputImage, scaleM, scaleN, newRows, newCols)
    outputImage = zeros(newRows, newCols);
    for i = 1 : newRows
        for j = 1 : newCols
            x = i / scaleM + 1;
            y = j / scaleN + 1;
            if x > size(inputImage, 1)
                x = x - 1;
            end
            if y > size(inputImage, 2)
                y = y - 1;
            end
            coefMat = computeBilinearCoefficients(inputImage, x, y);
            outputImage(i, j) = coefMat(1) * x + coefMat(2) * y + coefMat(3) * x * y + coefMat(4);
        end
    end
end

% Function to compute bilinear interpolation coefficients
function coefMat = computeBilinearCoefficients(inputImage, x, y)
    x1 = floor(x);
    y1 = floor(y);
    x2 = x1 + 1;
    y2 = y1 + 1;

    inputMat = double([x1 y1 x1*y1 1; x1 y2 x1*y2 1; x2 y1 x2*y1 1; x2 y2 x2*y2 1]);
    V = double([inputImage(x1, y1); inputImage(x1, y2); inputImage(x2, y1); inputImage(x2, y2)]);
    coefMat = pinv(inputMat) * V;
end

% Function to display images
function displayImages(inputImage, outputImage1, outputImage2, scaleM, scaleN)
    figure, imshow(inputImage), title('Original Image');
    figure, imshow(uint8(outputImage1)), title(['Shrunk Image with Scale (', num2str(scaleM), ', ', num2str(scaleN), ')']);
    figure, imshow(uint8(outputImage2)), title('Shrunk Image After Smoothing');
end

% Call the main function
bilinearShrinking();
