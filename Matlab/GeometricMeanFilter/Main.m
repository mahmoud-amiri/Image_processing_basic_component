function geometric_mean_filter
    close all
    clear all
    clc;

    %% Inputs
    inputImage = imread('cameraman.tif');
    [rows, cols] = size(inputImage);
    prompt = {'Enter Kernel Dimensions ='};
    dlg_title = 'Input';
    num_lines = 1;
    def = {'3'};
    answer = inputdlg(prompt, dlg_title, num_lines, def);
    kernelDim = str2double(answer{1});

    %% Geometric Mean Filter
    outputImage = applyGeometricMeanFilter(inputImage, kernelDim, rows, cols);

    %% Plotting
    figure;
    subplot(121), imshow(inputImage); title('Main Image');
    subplot(122), imshow(uint8(outputImage)); title('Apply Geometric Mean Filter');
end

function outputImage = applyGeometricMeanFilter(inputImage, kernelDim, rows, cols)
    r = floor(kernelDim / 2);
    paddedImage = replicatePadding(r, inputImage, rows, cols);
    outputImage = zeros(rows, cols);

    for i = (kernelDim - r):(rows + r)
        for j = (kernelDim - r):(cols + r)
            localRegion = paddedImage(i - r:i + r, j - r:j + r);
            outputImage(i - r, j - r) = (prod(prod(localRegion))) ^ (1 / (kernelDim * kernelDim));
        end
    end
end

function paddedImage = replicatePadding(r, inputImage, rows, cols)
    paddedImage = zeros(rows + 2 * r, cols + 2 * r);
    paddedImage(r + 1:rows + r, r + 1:cols + r) = inputImage;

    % Replicate borders
    for i = 1:r
        paddedImage(:, i) = paddedImage(:, r + 1);
        paddedImage(:, cols + r + i) = paddedImage(:, cols + r);
        paddedImage(i, :) = paddedImage(r + 1, :);
        paddedImage(rows + r + i, :) = paddedImage(rows + r, :);
    end
end
