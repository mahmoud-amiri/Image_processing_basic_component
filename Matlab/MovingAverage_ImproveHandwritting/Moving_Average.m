function moving_average_filter
    close all
    clear all
    clc;

    %******* Moving Average *******%

    %% Inputs
    inputImage = imread('1.tif');
    [rows, cols] = size(inputImage);

    %% Structure Element - Square
    prompt = {'n', 'b'};
    dlg_title = 'Enter Info';
    num_lines = 1;
    def = {'20', '0.5'};
    answer = inputdlg(prompt, dlg_title, num_lines, def);
    n = str2double(answer{1});
    b = str2double(answer{2});

    %% Moving Average
    outputImage = movingAverage(inputImage, rows, cols, n, b);

    %% Plotting
    plotResults(inputImage, outputImage);
end

function outputImage = movingAverage(inputImage, rows, cols, n, b)
    paddedImage = padarray(inputImage, [0, n-1], 'replicate', 'post');
    outputImage = zeros(rows, cols);

    for i = 1:rows
        for j = n:cols + n - 1
            localRegion = paddedImage(i, j - n + 1:j);
            meanValue = mean(localRegion);
            T = b * meanValue;
            if paddedImage(i, j) >= T
                outputImage(i, j - n + 1) = 1;
            else
                outputImage(i, j - n + 1) = 0;
            end
        end
    end
end

function plotResults(inputImage, outputImage)
    figure,
    subplot(121), imshow(inputImage); title('Text Image Corrupted by Spot Shading');
    subplot(122), imshow(outputImage); title('Corrected Image');
end
