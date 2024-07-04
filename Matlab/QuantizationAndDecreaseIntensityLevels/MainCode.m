close all;
clear;
clc;

% Main function
function quantization()
    % Inputs
    method = getMethod();
    inputImage = imread('Q1.tif');
    quantizationLevels = [2 4 8 16 32 64 128 256];

    % Perform Quantization
    performQuantization(method, inputImage, quantizationLevels);
end

% Function to get the method choice from the user
function method = getMethod()
    choice = menu('Choose Method', 'Method One', 'Method Two');
    if choice == 1
        method = 'Method One';
    elseif choice == 2
        method = 'Method Two';
    end
end

% Function to perform quantization
function performQuantization(method, inputImage, quantizationLevels)
    figure,
    subplot(2, 5, 1.5), imshow(inputImage), title('Main Image');

    for i = 1:length(quantizationLevels)
        if strcmp(method, 'Method One')
            outputImage = changeQuantizationLevel1(inputImage, quantizationLevels(i));
        elseif strcmp(method, 'Method Two')
            outputImage = changeQuantizationLevel2(inputImage, quantizationLevels(i));
        end
        subplot(2, 5, i + 2), imshow(outputImage), title(['Image in "', num2str(quantizationLevels(i)), '" intensity levels']);
    end
end

% Function to change quantization level (Method One)
function outputImage = changeQuantizationLevel1(inputImage, quantizationLevel)
    [rows, cols] = size(inputImage);
    inputImage = double(inputImage) / 255;
    outputImage = zeros(rows, cols);

    for i = 1:rows
        for j = 1:cols
            inputImage(i, j) = inputImage(i, j) * (0.5 * quantizationLevel);
            if inputImage(i, j) > 255
                outputImage(i, j) = 255;
            else
                outputImage(i, j) = inputImage(i, j);
            end
            outputImage(i, j) = round(outputImage(i, j));
            outputImage(i, j) = outputImage(i, j) / (0.5 * quantizationLevel);
        end
    end
end

% Function to change quantization level (Method Two)
function outputImage = changeQuantizationLevel2(inputImage, quantizationLevel)
    inputImage = double(inputImage) / 255;
    inputImage = uint8(inputImage * (0.5 * quantizationLevel));
    outputImage = double(inputImage) / (0.5 * quantizationLevel);
end

% Call the main function
quantization();
