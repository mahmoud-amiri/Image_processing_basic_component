close all;
clear;
clc;

% Main function
function bitPlane()
    % Inputs
    [method, bitPlaneLevel] = getInputs();
    inputImage = imread('D.tif');

    % Perform Bit Plane Slicing
    performBitPlaneSlicing(method, inputImage, bitPlaneLevel);
end

% Function to get the method choice and bit plane level from the user
function [method, bitPlaneLevel] = getInputs()
    choice = menu('Choose How to Display', 'All 8 Bit Planes', 'Just One Bit Plane');
    bitPlaneLevel = [];

    if choice == 1
        method = 'All 8 Bit Planes';
    elseif choice == 2
        method = 'Just One Bit Plane';
        prompt = {'Enter Bit Plane Level'};
        dlgTitle = 'Enter Info';
        numLines = 1;
        def = {'8'};
        answer = inputdlg(prompt, dlgTitle, numLines, def);
        bitPlaneLevel = str2double(answer{1});
    end
end

% Function to perform bit plane slicing
function performBitPlaneSlicing(method, inputImage, bitPlaneLevel)
    if strcmp(method, 'All 8 Bit Planes') == 1
        for k = 1:2
            switch k
                case 1
                    figure(k),
                    subplot(3, 3, 1), imshow(inputImage), title('Main Image');
                    for bpl = 1:8
                        outImgFirst = firstBitPlane(inputImage, bpl);
                        subplot(3, 3, bpl + 1), imshow(outImgFirst), title(['BitPlane ', num2str(bpl)]);
                    end
                case 2
                    figure(k),
                    subplot(3, 3, 1), imshow(inputImage), title('Main Image');
                    for bpl = 1:8
                        outputImgSecond = secondBitPlane(inputImage, bpl);
                        subplot(3, 3, bpl + 1), imshow(outputImgSecond), title(['BitPlane ', num2str(bpl)]);
                    end
            end
        end
    elseif strcmp(method, 'Just One Bit Plane') == 1
        outImgFirst = firstBitPlane(inputImage, bitPlaneLevel);
        outImgSecond = secondBitPlane(inputImage, bitPlaneLevel);
        figure,
        subplot(211), imshow(outImgFirst), title(['BitPlane ', num2str(bitPlaneLevel), ' By Code One']);
        subplot(212), imshow(outImgSecond), title(['BitPlane ', num2str(bitPlaneLevel), ' By Code Two']);
    end
end

% Function to perform first bit plane slicing
function outputImageFirst = firstBitPlane(inputImage, bitPlaneLevel)
    [rows, cols] = size(inputImage);
    outputImageFirst = zeros(rows, cols);
    numIntervals = (2^(9 - bitPlaneLevel));
    lengthIntervals = 2^(bitPlaneLevel - 1);

    for i = 1:rows
        for j = 1:cols
            for k = 1:numIntervals
                if ((k - 1) * lengthIntervals <= inputImage(i, j) && inputImage(i, j) < k * lengthIntervals)
                    if (mod(k, 2) == 0)
                        outputImageFirst(i, j) = 255;
                    else
                        outputImageFirst(i, j) = 0;
                    end
                end
            end
        end
    end
end

% Function to perform second bit plane slicing
function outputImageSecond = secondBitPlane(inputImage, bitPlaneLevel)
    [rows, cols] = size(inputImage);
    outputImageSecond = zeros(rows, cols);
    lengthIntervals = 2^(bitPlaneLevel - 1);

    for i = 1:rows
        for j = 1:cols
            m = mod(inputImage(i, j), lengthIntervals);
            k = ((inputImage(i, j) - m) / lengthIntervals) + 1;
            if mod(k, 2) == 0
                outputImageSecond(i, j) = 255;
            else
                outputImageSecond(i, j) = 0;
            end
        end
    end
end

% Call the main function
bitPlane();
