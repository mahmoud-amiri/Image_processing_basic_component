function image_smoothing
    clear all
    clc;

    %% Inputs
    windowSize = input('Enter Window Size = ');
    inputImage = imread('Fig3.35(a).jpg');
    [rows, cols] = size(inputImage);

    %% Uniform Filter (Smoothing)
    uniformOutputImage = applyUniformFilter(inputImage, windowSize, rows, cols);

    %% Non-Uniform Filter
    nonUniformOutputImage = applyNonUniformFilter(inputImage, windowSize, rows, cols);

    %% Plotting
    plotResults(inputImage, uniformOutputImage, nonUniformOutputImage, windowSize);
end

function outputImage = applyUniformFilter(inputImage, windowSize, rows, cols)
    padSize = floor(windowSize / 2);
    outputImage = zeros(rows - windowSize + 1, cols - windowSize + 1);

    for i = (windowSize - padSize):(rows - padSize)
        for j = (windowSize - padSize):(cols - padSize)
            localRegion = inputImage(i - padSize:i + padSize, j - padSize:j + padSize);
            outputImage(i - padSize, j - padSize) = sum(localRegion(:)) / (windowSize * windowSize);
        end
    end
end

function outputImage = applyNonUniformFilter(inputImage, windowSize, rows, cols)
    if windowSize == 3
        weightMatrix = [1 2 1; 2 4 2; 1 2 1];
    elseif windowSize == 5
        weightMatrix = [1 1 2 1 1; 1 2 4 2 1; 2 4 6 4 2; 1 2 4 2 1; 1 1 2 1 1];
    elseif windowSize == 7
        weightMatrix = [1 1 1 2 1 1 1; 1 1 2 4 2 1 1; 1 2 4 6 4 2 1; 2 4 6 8 6 4 2; 1 2 4 6 4 2 1; 1 1 2 4 2 1 1; 1 1 1 2 1 1 1];
    else
        error('Unsupported window size');
    end

    padSize = floor(windowSize / 2);
    outputImage = zeros(rows - windowSize + 1, cols - windowSize + 1);

    for i = (windowSize - padSize):(rows - padSize)
        for j = (windowSize - padSize):(cols - padSize)
            localRegion = double(inputImage(i - padSize:i + padSize, j - padSize:j + padSize));
            localRegion = localRegion .* weightMatrix;
            outputImage(i - padSize, j - padSize) = sum(localRegion(:)) / sum(weightMatrix(:));
        end
    end
end

function plotResults(inputImage, uniformOutputImage, nonUniformOutputImage, windowSize)
    figure;
    subplot(131), imshow(inputImage); title('Main Image');
    subplot(132), imshow(uint8(uniformOutputImage)); title(['Smoothing By Uniform Filter & Window size = ', num2str(windowSize)]);
    subplot(133), imshow(uint8(nonUniformOutputImage)); title(['Smoothing By Non-Uniform Filter & Window size = ', num2str(windowSize)]);
end
