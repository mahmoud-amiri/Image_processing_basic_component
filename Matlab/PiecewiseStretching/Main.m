close all;
clear;
clc;

% Main function
function pieceWiseTransformation()
    % Inputs
    [inputImage, r1, s1, r2, s2] = getInputs();

    % Apply Piece-Wise Transformation
    outputImage = applyPieceWiseTransformation(r1, s1, r2, s2, inputImage);

    % Generate Transformation Function
    [x, y] = generateTransformationFunction(r1, s1, r2, s2);

    % Display Results
    displayResults(inputImage, outputImage, x, y);
end

% Function to get inputs from the user
function [inputImage, r1, s1, r2, s2] = getInputs()
    inputImage = imread('pout.tif');
    prompt = {'Enter r1:', 'Enter s1:', 'Enter r2:', 'Enter s2:'};
    dlgTitle = 'Enter Two Points for Transformation';
    numLines = 1;
    def = {'75', '10', '170', '240'};
    answer = inputdlg(prompt, dlgTitle, numLines, def);
    r1 = str2double(answer{1});
    s1 = str2double(answer{2});
    r2 = str2double(answer{3});
    s2 = str2double(answer{4});
end

% Function to apply piece-wise transformation
function outputImage = applyPieceWiseTransformation(r1, s1, r2, s2, inputImage)
    [rows, cols] = size(inputImage);
    outputImage = zeros(rows, cols);

    for i = 1:rows
        for j = 1:cols
            if inputImage(i, j) <= r1
                outputImage(i, j) = (s1 / r1) * inputImage(i, j);
            elseif inputImage(i, j) > r1 && inputImage(i, j) <= r2
                outputImage(i, j) = s1 + ((s2 - s1) / (r2 - r1)) * (inputImage(i, j) - r1);
            elseif inputImage(i, j) > r2
                outputImage(i, j) = s2 + ((255 - s2) / (255 - r2)) * (inputImage(i, j) - r2);
            end
        end
    end
end

% Function to generate transformation function
function [x, y] = generateTransformationFunction(r1, s1, r2, s2)
    x = 0:255;
    y = (s1 / r1) * x .* (x <= r1) + ...
        (s1 + ((s2 - s1) / (r2 - r1)) * (x - r1)) .* (x > r1 & x <= r2) + ...
        (s2 + ((255 - s2) / (255 - r2)) * (x - r2)) .* (x > r2);
end

% Function to display results
function displayResults(inputImage, outputImage, x, y)
    figure,
    subplot(3, 3, 1), imshow(inputImage), title('Main Image');
    subplot(3, 3, 7), imhist(inputImage), title('Histogram of Input Image');
    subplot(3, 3, 5), plot(x, y), title('Transformation'), xlim([0, 255]), ylim([0, 255]);
    subplot(3, 3, 3), imshow(uint8(outputImage)), title('Output Image');
    subplot(3, 3, 9), imhist(uint8(outputImage)), title('Histogram of Output Image');
end

% Call the main function
pieceWiseTransformation();
