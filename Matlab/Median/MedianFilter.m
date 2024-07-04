function median_filtering
    clear all;
    clc;

    %% Inputs
    prompt = {'Enter Kernel Dimensions :'};
    dlg_title = 'Input';
    num_lines = 1;
    def = {'3'};
    answer = inputdlg(prompt, dlg_title, num_lines, def);
    kernelSize = str2double(answer{1});
    inputImage = imread('SP.tif');
    [rows, cols] = size(inputImage);

    %% Replicate padding
    padSize = floor(kernelSize / 2);
    paddedImage = replicate_padding(padSize, inputImage, rows, cols);

    %% Apply median filter
    outputImage = apply_median_filter(paddedImage, rows, cols, kernelSize, padSize);

    %% Display results
    figure;
    subplot(121), imshow(inputImage); title('Corrupted Image By Salt & Pepper Noise');
    subplot(122), imshow(uint8(outputImage)); title('Applying Median Filter');
end

function paddedImage = replicate_padding(padSize, inputImage, rows, cols)
    paddedImage = zeros(rows + 2 * padSize, cols + 2 * padSize);
    paddedImage(padSize + 1:rows + padSize, padSize + 1:cols + padSize) = inputImage;

    % Replicate padding
    for i = 1:padSize
        paddedImage(:, i) = paddedImage(:, padSize + 1);
        paddedImage(:, cols + padSize + i) = paddedImage(:, cols + padSize);
        paddedImage(i, :) = paddedImage(padSize + 1, :); 
        paddedImage(rows + padSize + i, :) = paddedImage(rows + padSize, :); 
    end
end

function outputImage = apply_median_filter(paddedImage, rows, cols, kernelSize, padSize)
    outputImage = zeros(rows, cols);

    for i = padSize + 1:rows + padSize
        for j = padSize + 1:cols + padSize
            localRegion = paddedImage(i - padSize:i + padSize, j - padSize:j + padSize);
            medianValue = calculate_median(localRegion, kernelSize);
            outputImage(i - padSize, j - padSize) = medianValue;
        end
    end
end

function medianValue = calculate_median(localRegion, kernelSize)
    localVector = reshape(localRegion', 1, []);
    sortedVector = sort(localVector);
    medianValue = sortedVector(floor((kernelSize * kernelSize) / 2) + 1);
end
