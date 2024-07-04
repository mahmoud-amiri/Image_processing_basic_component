function noise_filtering
    close all;
    clear;
    clc;

    %% Inputs
    saltImage = imread('Salt.tif');
    pepperImage = imread('Pepper.tif');
    uniNoiseImage = imread('UniNoise.tif');
    
    [rowsSalt, colsSalt] = size(saltImage);
    [rowsPepper, colsPepper] = size(pepperImage);
    [rowsUniNoise, colsUniNoise] = size(uniNoiseImage);
    
    prompt = {'Enter Kernel Dimensions:'};
    dlg_title = 'Input';
    num_lines = 1;
    def = {'3'};
    answer = inputdlg(prompt, dlg_title, num_lines, def);
    kernelSize = str2double(answer{1});

    %% Max, Min, and Midpoint Filter
    padSize = floor(kernelSize / 2);

    % Apply Min Filter to Salt Image
    paddedSaltImage = replicate_padding(padSize, saltImage, rowsSalt, colsSalt);
    saltOutImage = apply_filter(paddedSaltImage, rowsSalt, colsSalt, kernelSize, padSize, 'min');

    % Apply Max Filter to Pepper Image
    paddedPepperImage = replicate_padding(padSize, pepperImage, rowsPepper, colsPepper);
    pepperOutImage = apply_filter(paddedPepperImage, rowsPepper, colsPepper, kernelSize, padSize, 'max');

    % Apply Midpoint Filter to Uniform Noise Image
    paddedUniNoiseImage = replicate_padding(padSize, uniNoiseImage, rowsUniNoise, colsUniNoise);
    uniNoiseOutImage = apply_filter(paddedUniNoiseImage, rowsUniNoise, colsUniNoise, kernelSize, padSize, 'midpoint');

    %% Display Results
    figure,
    subplot(121), imshow(saltImage); title('Main Image With Salt Noise');
    subplot(122), imshow(uint8(saltOutImage)); title('Apply Min Filter');
    
    figure,
    subplot(121), imshow(pepperImage); title('Main Image With Pepper Noise');
    subplot(122), imshow(uint8(pepperOutImage)); title('Apply Max Filter');
    
    figure,
    subplot(121), imshow(uniNoiseImage); title('Main Image With Uniform Noise');
    subplot(122), imshow(uint8(uniNoiseOutImage)); title('Apply Midpoint Filter');
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

function outputImage = apply_filter(paddedImage, rows, cols, kernelSize, padSize, filterType)
    outputImage = zeros(rows, cols);

    for i = padSize + 1:rows + padSize
        for j = padSize + 1:cols + padSize
            localRegion = paddedImage(i - padSize:i + padSize, j - padSize:j + padSize);
            
            switch filterType
                case 'min'
                    filterValue = min(min(localRegion));
                case 'max'
                    filterValue = max(max(localRegion));
                case 'midpoint'
                    filterValue = 0.5 * (max(max(localRegion)) + min(min(localRegion)));
            end
            
            outputImage(i - padSize, j - padSize) = filterValue;
        end
    end
end
