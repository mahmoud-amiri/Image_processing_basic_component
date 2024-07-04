close all
clear all
clc;

%***** Denoising Using Notch Filter *****%

% Main function
function notchFilterDenoising()
    % Inputs
    [kernelDims, noiseDiagonal, noiseAngle, noiseRatio, D0] = getInputs();

    % Read image
    inputImage = imread('cameraman.tif');
    [rows, cols] = size(inputImage);

    % Pad array
    [paddedImage, newRows, newCols] = padArray(inputImage, kernelDims);

    % Compute frequency domain image
    freqImage = fftshift(fft2(paddedImage));

    % Create noise model in frequency domain
    noisyFreqImage = addNoiseModel(freqImage, newRows, newCols, noiseDiagonal, noiseAngle, noiseRatio);

    % Compute noisy image
    noisyImage = real(ifft2(ifftshift(noisyFreqImage)));

    % Display results
    displayInitialImages(inputImage, noisyImage, noisyFreqImage);

    % Apply notch filter to find noise pattern
    noisePattern = findNoisePattern(newRows, newCols, noiseDiagonal, noiseAngle, D0, noisyFreqImage);

    % Apply optimum notch filter
    outputImage = applyOptimumNotchFilter(noisyImage, noisePattern, kernelDims, newRows, newCols);

    % Plot final results
    plotFinalResults(noisyImage, noisyFreqImage, outputImage, rows, cols);
end

% Function to get inputs from the user
function [kernelDims, noiseDiagonal, noiseAngle, noiseRatio, D0] = getInputs()
    prompt = {'Kernel Dimensions', 'Diagonal of Noise Ring:', 'Additive Noise Angle:', 'Noise Ratio:', 'D0:'};
    dlgTitle = 'Input';
    numLines = 1;
    def = {'[15 15]', '160', 'pi/4', '20000', '10'};
    answer = inputdlg(prompt, dlgTitle, numLines, def);
    kernelDims = str2num(answer{1});
    noiseDiagonal = str2double(answer{2});
    noiseAngle = str2num(answer{3});
    noiseRatio = str2double(answer{4});
    D0 = str2double(answer{5});
end

% Function to pad the array
function [paddedImage, newRows, newCols] = padArray(inputImage, kernelDims)
    [rows, cols] = size(inputImage);
    d1 = kernelDims(1);
    d2 = kernelDims(2);
    newRows = rows + d1 - mod(rows, d1);
    newCols = cols + d2 - mod(cols, d2);
    paddedImage = padarray(inputImage, [d1 - mod(rows, d1), d2 - mod(cols, d2)], 'replicate', 'post');
end

% Function to add noise model in frequency domain
function noisyFreqImage = addNoiseModel(freqImage, newRows, newCols, noiseDiagonal, noiseAngle, noiseRatio)
    r = noiseDiagonal / 2;
    noise = zeros(newRows, newCols);
    centerX = floor(newRows / 2 + 1);
    centerY = floor(newCols / 2 + 1);
    c = floor(r * cos(noiseAngle));
    d = floor(r * sin(noiseAngle));
    noisePoints = [
        centerX + r, centerY;
        centerX - r, centerY;
        centerX, centerY + r;
        centerX, centerY - r;
        centerX + c, centerY + d;
        centerX + c, centerY - d;
        centerX - c, centerY + d;
        centerX - c, centerY - d;
    ];

    for i = 1:size(noisePoints, 1)
        noise(noisePoints(i, 1), noisePoints(i, 2)) = 255;
    end

    noisyFreqImage = freqImage + noiseRatio * noise;
end

% Function to display initial images
function displayInitialImages(inputImage, noisyImage, noisyFreqImage)
    figure,
    subplot(131), imshow(inputImage); title('Original Image');
    subplot(132), imshow(uint8(noisyImage), []); title('Noisy Image (Periodic Noise)');
    subplot(133), imshow(log(abs(noisyFreqImage)), []); title('Image + Periodic Noise in Frequency Domain');
end

% Function to find noise pattern using notch filter
function noisePattern = findNoisePattern(newRows, newCols, noiseDiagonal, noiseAngle, D0, noisyFreqImage)
    r = noiseDiagonal / 2;
    c = floor(r * cos(noiseAngle));
    d = floor(r * sin(noiseAngle));

    [H1] = notchFilter(D0, r, 0, newRows, newCols);
    [H2] = notchFilter(D0, 0, r, newRows, newCols);
    [H3] = notchFilter(D0, c, d, newRows, newCols);
    [H4] = notchFilter(D0, -c, d, newRows, newCols);
    H = 1 - (H1 .* H2 .* H3 .* H4);

    noisePatternFreq = H .* noisyFreqImage;
    noisePattern = real(ifft2(ifftshift(noisePatternFreq)));
end

% Function to apply optimum notch filter
function outputImage = applyOptimumNotchFilter(noisyImage, noisePattern, kernelDims, newRows, newCols)
    d1 = kernelDims(1);
    d2 = kernelDims(2);
    halfD1 = floor(d1 / 2);
    halfD2 = floor(d2 / 2);
    a = 0.5 * (d1 - 1) + 1;
    b = 0.5 * (d2 - 1) + 1;
    W = zeros(1, (newRows / d1) * (newCols / d2));
    k = 1;
    outputImage = zeros(newRows, newCols);

    for i = a : d1 : newRows
        for j = b : d2 : newCols
            GLocal = noisyImage(i - halfD1 : i + halfD1, j - halfD2 : j + halfD2);
            EtaLocal = noisePattern(i - halfD1 : i + halfD1, j - halfD2 : j + halfD2);
            GBar = mean(GLocal(:));
            EtaBar = mean(EtaLocal(:));
            GEtaBar = mean(GLocal(:) .* EtaLocal(:));
            EtaLocal2 = EtaLocal .^ 2;
            Eta2Bar = mean(EtaLocal2(:));
            W(k) = (GEtaBar - GBar * EtaBar) / (Eta2Bar - EtaBar ^ 2);
            outputImage(i - halfD1 : i + halfD1, j - halfD2 : j + halfD2) = GLocal - W(k) .* EtaLocal;
            k = k + 1;
        end
    end
end

% Function to plot final results
function plotFinalResults(noisyImage, noisyFreqImage, outputImage, originalRows, originalCols)
    figure,
    subplot(131), imshow(uint8(noisyImage), []); title('Noisy Image (Periodic Noise)');
    subplot(132), imshow(log(abs(noisyFreqImage)), []); title('Image + Periodic Noise in Frequency Domain');
    subplot(133), imshow(uint8(outputImage(1:originalRows, 1:originalCols)), []); title('Estimated Image Using Optimum Notch Filtering');
end

% Function to create a notch filter
function [H] = notchFilter(D0, u0, v0, M, N)
    H = zeros(M, N);
    for i = 1 : M
        for j = 1 : N
            D1 = sqrt((i - floor(M / 2) - 1 - u0) ^ 2 + (j - floor(N / 2) - 1 - v0) ^ 2);
            D2 = sqrt((i - floor(M / 2) - 1 + u0) ^ 2 + (j - floor(N / 2) - 1 + v0) ^ 2);
            P = (D1 * D2) / (D0 * D0);
            H(i, j) = 1 - exp(-0.5 * P);
        end
    end
end

% Call the main function
notchFilterDenoising();
