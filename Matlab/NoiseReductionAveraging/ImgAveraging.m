function image_noise_averaging
    close all
    clear all
    clc;

    %% Inputs
    inputImage = imread('a.jpg');
    [rows, cols] = size(inputImage);

    prompt = {'Enter Noise Mean:', 'Enter Noise Variance:', 'Enter Number Of Averaging:'};
    dlg_title = 'Enter Parameters';
    num_lines = 1;
    def = {'0', '0.01', '50'};
    answer = inputdlg(prompt, dlg_title, num_lines, def);
    noiseMean = str2double(answer{1});
    noiseVariance = str2double(answer{2});
    numOfAveraging = str2double(answer{3});

    %% Adding Gaussian Noise and Averaging
    noisyImages = addGaussianNoise(inputImage, noiseMean, noiseVariance, numOfAveraging, rows, cols);
    averagedImage = averageImages(noisyImages, numOfAveraging, rows, cols);

    %% Plotting
    plotResults(inputImage, noisyImages, averagedImage, noiseMean, noiseVariance, numOfAveraging);
end

function noisyImages = addGaussianNoise(inputImage, noiseMean, noiseVariance, numOfAveraging, rows, cols)
    noisyImages = zeros(rows, cols, numOfAveraging);
    for i = 1:numOfAveraging
        noisyImages(:, :, i) = imnoise(inputImage, 'gaussian', noiseMean, noiseVariance);
    end
end

function averagedImage = averageImages(noisyImages, numOfAveraging, rows, cols)
    summedImage = zeros(rows, cols);
    for i = 1:numOfAveraging
        summedImage = summedImage + noisyImages(:, :, i);
    end
    averagedImage = summedImage / numOfAveraging;
end

function plotResults(inputImage, noisyImages, averagedImage, noiseMean, noiseVariance, numOfAveraging)
    figure;
    subplot(1, 3, 1), imshow(inputImage); title('Main Image');
    subplot(1, 3, 2), imshow(uint8(noisyImages(:, :, 1))); title(['Image Corrupted By Gaussian Noise (Mean = ', num2str(noiseMean), ', Variance = ', num2str(noiseVariance), ')']);
    subplot(1, 3, 3), imshow(uint8(averagedImage)); title(['Image Averaging Output (Noise Added ', num2str(numOfAveraging), ' Times)']);
end
