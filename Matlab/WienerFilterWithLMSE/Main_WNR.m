clear all
clc;

%***** Image Restoration Using Various Filters *****%

% Main function
function imageRestoration()
    % Inputs
    [P, K, D, n, inputImage] = getInputs();
    [rows, cols] = size(inputImage);
    imgFFT = fft2(inputImage);

    % Apply Atmospheric Turbulence
    [H, absH, conjH] = applyTurbulenceNoise(K, rows, cols);

    % Add Random Noise
    noise = 5 * randn(size(inputImage));
    noiseFreq = fft2(noise);

    % Corrupted Image
    corruptedFreq = fftshift(H) .* imgFFT + noiseFreq;
    corruptedImg = real(ifft2(corruptedFreq));

    % Restoration - Using Inverse Filter
    restoredInvFilt = restoreUsingInverseFilter(corruptedFreq, H);

    % Restoration - Using Inverse Filter and LowPass Filtering
    butterworthLPF = createButterworthLPF(rows, cols, n, D);
    restoredImg = restoreUsingLowPassFilter(corruptedFreq, butterworthLPF, H);

    % Restoration Using Wiener Filter and MSE
    restoredWiener = restoreUsingWienerFilter(corruptedFreq, conjH, absH, P);

    % Plotting
    displayImages(inputImage, corruptedImg, restoredInvFilt, restoredImg, restoredWiener, K, D, P);
end

% Function to get inputs from the user
function [P, K, D, n, inputImage] = getInputs()
    prompt = {'P:', 'K:', 'D:', 'n:'};
    dlgTitle = 'Input';
    numLines = 1;
    def = {'0.1', '0.0025', '50', '10'};
    answer = inputdlg(prompt, dlgTitle, numLines, def);
    P = str2double(answer{1});
    K = str2double(answer{2});
    D = str2double(answer{3});
    n = str2double(answer{4});
    inputImage = imread('Turb.tif');
end

% Function to apply atmospheric turbulence noise
function [H, absH, conjH] = applyTurbulenceNoise(K, rows, cols)
    H = zeros(rows, cols);
    for i = 1:rows
        for j = 1:cols
            D = ((i - floor(rows / 2) - 1) ^ 2 + (j - floor(cols / 2) - 1) ^ 2) ^ (5 / 6);
            H(i, j) = exp(-K * D);
        end
    end
    absH = abs(fftshift(H));
    conjH = conj(fftshift(H));
end

% Function to restore image using inverse filter
function restoredImg = restoreUsingInverseFilter(corruptedFreq, H)
    finvFilt = corruptedFreq ./ fftshift(H);
    restoredImg = real(ifft2(finvFilt));
end

% Function to create Butterworth Low Pass Filter
function butterworthLPF = createButterworthLPF(rows, cols, n, D0)
    butterworthLPF = zeros(rows, cols);
    for i = 1:rows
        for j = 1:cols
            D = sqrt((i - floor(rows / 2) - 1) ^ 2 + (j - floor(cols / 2) - 1) ^ 2);
            D = (D / D0) ^ (2 * n);
            butterworthLPF(i, j) = 1 / (1 + D);
        end
    end
end

% Function to restore image using low pass filter
function restoredImg = restoreUsingLowPassFilter(corruptedFreq, butterworthLPF, H)
    F = (corruptedFreq .* fftshift(butterworthLPF)) ./ fftshift(H);
    restoredImg = real(ifft2(F));
end

% Function to restore image using Wiener filter
function restoredImg = restoreUsingWienerFilter(corruptedFreq, conjH, absH, P)
    estimatedF = corruptedFreq .* (conjH ./ (absH .* absH + P));
    restoredImg = real(ifft2(estimatedF));
end

% Function to display images
function displayImages(inputImage, corruptedImg, restoredInvFilt, restoredImg, restoredWiener, K, D, P)
    figure,
    subplot(231), imshow(uint8(inputImage)), title('Main Image');
    subplot(233), imshow(uint8(corruptedImg), []), title(['Image + Noise and Severe Turbulence with K = ', num2str(K)]);
    subplot(234), imshow(uint8(restoredInvFilt), []), title('Restored Image Using Inverse Filter');
    subplot(235), imshow(uint8(restoredImg), []), title(['Restored Image & Applying Butterworth LPF with D0 = ', num2str(D)]);
    subplot(236), imshow(uint8(restoredWiener), []), title(['Restored Image Using Wiener Filter (MSE) with SNR = ', num2str(P)]);
end

% Call the main function
imageRestoration();
