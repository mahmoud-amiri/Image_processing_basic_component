close all
clear all
clc;

%***** Image Downsampling *****%

% Main function
function imageDownsampling()
    % Inputs
    [inputImage, scaleM, scaleN] = getInputs();

    % Size of Output Image
    [newRows, newCols] = computeOutputSize(inputImage, scaleM, scaleN);

    % Downsampling
    outputImage = downsampling(inputImage, scaleM, scaleN, newRows, newCols);

    % Plotting
    displayImages(inputImage, outputImage, scaleM, scaleN);
end

% Function to get inputs from the user
function [inputImage, scaleM, scaleN] = getInputs()
    inputImage = imread('cameraman.tif');
    scaleM = input('Enter Shrinking Scale (Ver) = ');
    scaleN = input('Enter Shrinking Scale (Hor) = ');

    assert(scaleM == floor(scaleM) && scaleM >= 1 && scaleN == floor(scaleN) && scaleN >= 1, ...
        'Scale values must be integers and greater than or equal to 1');
end

% Function to compute the size of the output image
function [newRows, newCols] = computeOutputSize(inputImage, scaleM, scaleN)
    [rows, cols] = size(inputImage);

    if mod(rows, scaleM) == 0 
       newRows = floor(rows / scaleM); 
    else 
       newRows = floor(rows / scaleM) + 1;
    end
    if mod(cols, scaleN) == 0 
       newCols = floor(cols / scaleN); 
    else 
       newCols = floor(cols / scaleN) + 1;
    end
end

% Function to perform downsampling
function outputImage = downsampling(inputImage, scaleM, scaleN, newRows, newCols)
    outputImage = zeros(newRows, newCols);
    
    k = 1;
    for i = 1 : scaleM : size(inputImage, 1)
        inputVecVer = inputImage(i, :);
        inputVecVerD = downSampleVector(scaleN, inputVecVer);
        outputImage(k, :) = inputVecVerD;
        k = k + 1;
    end
    
    k = 1;           
    for i = 1 : scaleN : size(inputImage, 2)
        inputVecHor = inputImage(:, i);
        inputVecHorD = downSampleVector(scaleM, inputVecHor);
        outputImage(:, k) = inputVecHorD;
        k = k + 1;
    end
end

% Function to downsample a vector
function inputVecD = downSampleVector(scale, inputVec)
    inputVecD = inputVec(1:scale:end);
end

% Function to display images
function displayImages(inputImage, outputImage, scaleM, scaleN)
    figure, imshow(inputImage), title('Original Image');
    figure, imshow(uint8(outputImage)), title(['Downsampled Image by Scale: (', num2str(scaleM), ', ', num2str(scaleN), ')']);
end

% Call the main function
imageDownsampling();
