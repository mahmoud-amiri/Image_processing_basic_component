function gaussian_filtering
    clear all;
    close all;
    clc;

    %% Gaussian Filter
    prompt = {'Enter Window Dimensions', 'Enter Variance of the Gaussian Filter', 'Enter the Mean of the Noise', 'Enter the Variance of the Noise'};
    dlg_title = 'Gaussian Filter Parameters';
    num_lines = 1;
    def = {'3', '1', '0', '0.01'};
    answer = inputdlg(prompt, dlg_title, num_lines, def);
    windowSize = str2double(answer{1});
    sigma = str2double(answer{2});
    noiseMean = str2double(answer{3});
    noiseVariance = str2double(answer{4});

    inputImage = imread('cameraman.tif');
    [rows, cols] = size(inputImage);

    %% Add Gaussian Noise
    noisyImage = imnoise(inputImage, 'gaussian', noiseMean, noiseVariance);
    gaussianWindow = create_gaussian_window(windowSize, sigma);
    padSize = floor(windowSize / 2);

    %% Apply Gaussian Filter
    outputImage = apply_gaussian_filter(noisyImage, gaussianWindow, rows, cols, windowSize, padSize);

    %% Plotting
    figure;
    subplot(131), imshow(inputImage); title('Original Image');
    subplot(132), imshow(noisyImage); title('Image With Gaussian Noise');
    subplot(133), imshow(uint8(outputImage)); title('Output Image Using Gaussian Filter');
end

function gaussianWindow = create_gaussian_window(windowSize, sigma)
    padSize = floor(windowSize / 2);
    gaussianWindow = zeros(windowSize, windowSize);

    for i = 1:windowSize
        for j = 1:windowSize
            x = i - padSize - 1;
            y = j - padSize - 1;
            gaussianWindow(i, j) = exp(-(x * x + y * y) / (2 * sigma * sigma));
        end
    end
end

function outputImage = apply_gaussian_filter(noisyImage, gaussianWindow, rows, cols, windowSize, padSize)
    outputImage = zeros(rows - windowSize + 1, cols - windowSize + 1);

    for i = (windowSize - padSize):(rows - padSize)
        for j = (windowSize - padSize):(cols - padSize)
            localRegion = noisyImage(i - padSize:i + padSize, j - padSize:j + padSize);
            filteredValue = sum(sum(double(localRegion) .* gaussianWindow)) / sum(gaussianWindow(:));
            outputImage(i - padSize, j - padSize) = round(filteredValue);
        end
    end
end
