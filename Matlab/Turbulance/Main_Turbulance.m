close all;
clear;
clc;

% Main function
function imageRestoration()
    % Inputs
    [K1, K2, R1, R2, R3, n, inputImage, M, N] = getInputs();

    % Atmospheric Turbulence
    H1 = applyTurbulenceNoise(K1, M, N);
    H2 = applyTurbulenceNoise(K2, M, N);

    % Add Random Noise
    noise = 5 * randn(size(inputImage));
    noiseFreq = fft2(noise);

    % Corrupted Image
    ImFFT = fft2(inputImage);
    corruptedFreq1 = fftshift(H1) .* ImFFT + noiseFreq; 
    corruptedFreq2 = fftshift(H2) .* ImFFT + noiseFreq;
    corruptedImg1 = real(ifft2(corruptedFreq1));
    corruptedImg2 = real(ifft2(corruptedFreq2));

    % Restoration - Using Inverse Filter
    D1 = R1(1); D2 = R2(1); D3 = R3(1);
    D4 = R1(2); D5 = R2(2); D6 = R3(2);

    ButtF1 = buttLPF(M, N, n, D1);
    ButtF2 = buttLPF(M, N, n, D2);
    ButtF3 = buttLPF(M, N, n, D3);
    ButtF4 = buttLPF(M, N, n, D4);
    ButtF5 = buttLPF(M, N, n, D5);
    ButtF6 = buttLPF(M, N, n, D6);

    FinvFilt1 = corruptedFreq1 ./ fftshift(H1);
    FinvFilt2 = corruptedFreq2 ./ fftshift(H2);

    F1 = (corruptedFreq1 .* fftshift(ButtF1)) ./ fftshift(H1);
    F2 = (corruptedFreq1 .* fftshift(ButtF2)) ./ fftshift(H1);
    F3 = (corruptedFreq1 .* fftshift(ButtF3)) ./ fftshift(H1);
    F4 = (corruptedFreq2 .* fftshift(ButtF4)) ./ fftshift(H2);
    F5 = (corruptedFreq2 .* fftshift(ButtF5)) ./ fftshift(H2);
    F6 = (corruptedFreq2 .* fftshift(ButtF6)) ./ fftshift(H2);

    restoredInvFilt1 = real(ifft2(FinvFilt1));
    restoredInvFilt2 = real(ifft2(FinvFilt2));
    restoredImg1 = real(ifft2(F1));
    restoredImg2 = real(ifft2(F2));
    restoredImg3 = real(ifft2(F3));
    restoredImg4 = real(ifft2(F4));
    restoredImg5 = real(ifft2(F5));
    restoredImg6 = real(ifft2(F6));

    % Plotting
    plotResults(inputImage, corruptedImg1, corruptedImg2, restoredInvFilt1, restoredInvFilt2, restoredImg1, restoredImg2, restoredImg3, restoredImg4, restoredImg5, restoredImg6, K1, K2, D1, D2, D3, D4, D5, D6);
end

% Function to get inputs from the user
function [K1, K2, R1, R2, R3, n, inputImage, M, N] = getInputs()
    prompt = {'K1 :', 'K2 :', 'D1 :', 'D2 :', 'D3 :', 'n :'};
    dlg_title = 'Input';
    num_lines = 1;
    def = {'0.001', '0.0025', '[40 20]', '[70 50]', '[140 85]', '10'};
    answer = inputdlg(prompt, dlg_title, num_lines, def);
    K1 = str2double(answer{1});
    K2 = str2double(answer{2});
    R1 = str2num(answer{3});
    R2 = str2num(answer{4});
    R3 = str2num(answer{5});
    n = str2double(answer{6});
    inputImage = imread('Turb.tif');
    [M, N] = size(inputImage);
end

% Function to apply turbulence noise
function H = applyTurbulenceNoise(K, M, N)
    H = zeros(M, N);
    for i = 1:M
        for j = 1:N
            D = ((i - floor(M / 2) - 1)^2 + (j - floor(N / 2) - 1)^2) ^ (5 / 6);
            H(i, j) = exp(-K * D);
        end
    end
end

% Function to create Butterworth low-pass filter
function ButtF = buttLPF(M, N, n, D0)
    ButtF = zeros(M, N);
    for i = 1:M
        for j = 1:N
            D = sqrt((i - floor(M / 2) - 1)^2 + (j - floor(N / 2) - 1)^2);
            D = (D / D0) ^ (2 * n);
            ButtF(i, j) = 1 / (1 + D);
        end
    end
end

% Function to plot results
function plotResults(inputImage, corruptedImg1, corruptedImg2, restoredInvFilt1, restoredInvFilt2, restoredImg1, restoredImg2, restoredImg3, restoredImg4, restoredImg5, restoredImg6, K1, K2, D1, D2, D3, D4, D5, D6)
    figure,
    subplot(131), imshow(uint8(inputImage)), title('Main Image');
    subplot(132), imshow(uint8(corruptedImg1), []), title(['Image + Noise and Mild Turbulence with K = ', num2str(K1)]);
    subplot(133), imshow(uint8(corruptedImg2), []), title(['Image + Noise Severe Turbulence with K = ', num2str(K2)]);

    figure,
    subplot(231), imshow(uint8(corruptedImg1), []), title(['Image with Mild Turbulence and K = ', num2str(K1)]);
    subplot(233), imshow(uint8(restoredInvFilt1), []), title('Restored Image Using Inverse Filter');
    subplot(234), imshow(uint8(restoredImg1), []), title(['Restored Image & Applying Butterworth LPF with D0 = ', num2str(D1)]);
    subplot(235), imshow(uint8(restoredImg2), []), title(['Restored Image & Applying Butterworth LPF with D0 = ', num2str(D2)]);
    subplot(236), imshow(uint8(restoredImg3), []), title(['Restored Image & Applying Butterworth LPF with D0 = ', num2str(D3)]);

    figure,
    subplot(231), imshow(uint8(corruptedImg2), []), title(['Image with Mild Turbulence and K = ', num2str(K2)]);
    subplot(233), imshow(uint8(restoredInvFilt2), []), title('Restored Image Using Inverse Filter');
    subplot(234), imshow(uint8(restoredImg4), []), title(['Restored Image & Applying Butterworth LPF with D0 = ', num2str(D4)]);
    subplot(235), imshow(uint8(restoredImg5), []), title(['Restored Image & Applying Butterworth LPF with D0 = ', num2str(D5)]);
    subplot(236), imshow(uint8(restoredImg6), []), title(['Restored Image & Applying Butterworth LPF with D0 = ', num2str(D6)]);
end

% Call the main function
imageRestoration();
