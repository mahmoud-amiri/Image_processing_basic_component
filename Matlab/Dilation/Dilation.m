function dilation
    close all
    clear all
    clc;

    %******* Dilation *******%

    %% Inputs
    inputImage = imread('D1.tif');
    [rows, cols] = size(inputImage);

    %% Structure Element - Square
    method = 'Square';
    prompt = {'Size of Square'};
    dlg_title = 'Enter Info';
    num_lines = 1;
    def = {'3'};
    answer = inputdlg(prompt, dlg_title, num_lines, def);
    structElemSize = str2double(answer{1});
    radius = floor(structElemSize / 2);

    [paddedImage, newRows, newCols] = zeroPad(radius, inputImage, rows, cols);
    mainParam = ['Size of Square = ', num2str(structElemSize)];

    %% Dilation
    structElem = [0 1 0; 1 1 1; 0 1 0];

    outputImage = performDilation(paddedImage, structElem, radius, newRows, newCols);

    % Matlab Command
    matlabStructElem = strel('square', structElemSize);
    matlabOutput = imdilate(inputImage, matlabStructElem, 'same');

    %% Plotting
    figure,
    subplot(131), imshow(inputImage); title('Main Image');
    subplot(132), imshow(outputImage); title({['Dilated Image Using ', method, ' Structure Element'], mainParam});
    subplot(133), imshow(matlabOutput); title('Dilated Image Using Matlab Command and Same Struct Element');
end

function [zeroPaddedImage, newRows, newCols] = zeroPad(radius, inputImage, rows, cols)
    zeroPaddedImage = zeros(rows + 2 * radius, cols + 2 * radius);
    zeroPaddedImage(radius + 1 : rows + radius, radius + 1 : cols + radius) = inputImage;
    [newRows, newCols] = size(zeroPaddedImage);
end

function outputImage = performDilation(paddedImage, structElem, radius, newRows, newCols)
    outputImage = zeros(newRows - 2 * radius, newCols - 2 * radius);

    for i = radius + 1 : newRows - radius
        for j = radius + 1 : newCols - radius
            localRegion = paddedImage(i - radius : i + radius, j - radius : j + radius);
            localRegion = localRegion .* structElem;
            if sum(localRegion(:)) ~= 0
                outputImage(i - radius, j - radius) = 1;
            else
                outputImage(i - radius, j - radius) = 0;
            end
        end
    end
end
