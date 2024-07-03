function morphological_closing
    close all
    clear all
    clc;

    %******* Closing *******%

    %% Inputs
    inputImage = ~imread('Op2.tif');
    [rows, cols] = size(inputImage);
    prompt = {'Radius of Disk'};
    dlg_title = 'Enter Info';
    num_lines = 1;
    def = {'31'};
    answer = inputdlg(prompt, dlg_title, num_lines, def);
    radius = str2double(answer{1});

    %% Structure Element
    structElem = strel('disk', radius);
    nhood = getnhood(structElem);
    [seRows, seCols] = size(nhood);
    padding = max(floor(seRows / 2), floor(seCols / 2));
    [paddedImage, newRows, newCols] = zeroPad(padding, inputImage, rows, cols);

    %% Closing
    dilatedImage = dilation(paddedImage, newRows, newCols, padding, nhood);
    [paddedDilatedImage, newRows, newCols] = zeroPad(padding, dilatedImage, rows, cols);
    outputImage = erosion(paddedDilatedImage, newRows, newCols, padding, nhood);

    %% MATLAB Command
    matlabOutput = imclose(inputImage, structElem);

    %% Plotting
    figure,
    subplot(131), imshow(~inputImage); title('Main Image');
    subplot(132), imshow(~outputImage); title('Closing Using Custom Erode and Dilate Functions');
    subplot(133), imshow(~matlabOutput); title('Closing Using MATLAB Command');
end

function [zeroPaddedImage, newRows, newCols] = zeroPad(padding, inputImage, rows, cols)
    zeroPaddedImage = zeros(rows + 2 * padding, cols + 2 * padding);
    zeroPaddedImage(padding + 1:rows + padding, padding + 1:cols + padding) = inputImage;
    [newRows, newCols] = size(zeroPaddedImage);
end

function dilatedImage = dilation(paddedImage, rows, cols, padding, structElem)
    [seRows, seCols] = size(structElem);
    dilatedImage = zeros(rows - 2 * padding, cols - 2 * padding);
    for i = padding + 1:rows - padding
        for j = padding + 1:cols - padding
            localRegion = paddedImage(i - padding:i + padding, j - padding:j + padding);
            if any(localRegion(structElem))
                dilatedImage(i - padding, j - padding) = 1;
            else
                dilatedImage(i - padding, j - padding) = 0;
            end
        end
    end
end

function erodedImage = erosion(paddedImage, rows, cols, padding, structElem)
    [seRows, seCols] = size(structElem);
    erodedImage = zeros(rows - 2 * padding, cols - 2 * padding);
    for i = padding + 1:rows - padding
        for j = padding + 1:cols - padding
            localRegion = paddedImage(i - padding:i + padding, j - padding:j + padding);
            if all(localRegion(structElem))
                erodedImage(i - padding, j - padding) = 1;
            else
                erodedImage(i - padding, j - padding) = 0;
            end
        end
    end
end
