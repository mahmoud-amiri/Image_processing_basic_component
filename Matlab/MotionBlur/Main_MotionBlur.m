function motion_blur_restoration
    close all
    clear all
    clc;

    %% Inputs
    prompt = {'a', 'b', 'T', 'Mean', 'Variance', 'K'};
    dlg_title = 'Input';
    num_lines = 1;
    def = {'0.09', '0.09', '1', '0', '[ 0.5 0.01 0.0005 ]', '0.005'};
    answer = inputdlg(prompt, dlg_title, num_lines, def);
    a = str2double(answer{1});
    b = str2double(answer{2});
    T = str2double(answer{3});
    meanVal = str2double(answer{4});
    varVec = str2num(answer{5});
    K = str2double(answer{6});

    inputImage = imread('MB.tif');
    [rows, cols] = size(inputImage);

    %% Motion Blur and Butterworth LPF Filter
    [H] = fftshift(applyMotionBlur(T, a, b, rows, cols));
    absH = abs(H);
    conjH = conj(H);

    figure,

    for i = 1:length(varVec)
        noisyImage = imnoise(inputImage, 'gaussian', meanVal, varVec(i));
        imFFT = fft2(noisyImage);

        %% Corrupted Image
        corruptedFreq = H .* imFFT;
        corruptedImage = real(ifft2(corruptedFreq));

        %% Restoration - Using Inverse Filter
        finvFilt = corruptedFreq ./ H;
        restoredInvFilt = real(ifft2(finvFilt));

        %% Restoration Using Wiener Filter and MSE
        estimatedF = (corruptedFreq .* conjH) ./ (absH .* absH + K);
        restoredWNR = real(ifft2(estimatedF));

        subplot(3, 3, i), imshow(uint8(corruptedImage), []); title('Corrupted Image');
        subplot(3, 3, i + 3), imshow(uint8(restoredInvFilt), []); title('Restored Image Using Inverse Filter');
        subplot(3, 3, i + 6), imshow(uint8(restoredWNR), []); title('Restored Image Using Wiener Filter');
    end

end

function [buttF] = buttLPF(rows, cols, n, D0)
    buttF = zeros(rows, cols);
    for i = 1:rows
        for j = 1:cols
            D = sqrt((i - floor(rows / 2) - 1)^2 + (j - floor(cols / 2) - 1)^2);
            D = (D / D0) ^ (2 * n);
            buttF(i, j) = 1 / (1 + D);
        end
    end
end

function [H] = applyMotionBlur(T, a, b, rows, cols)
    H = zeros(rows, cols);
    for i = 1:rows
        for j = 1:cols
            D = (a * (i - floor(rows / 2) - 1) + b * (j - floor(cols / 2) - 1));
            H(i, j) = T * sinc(D) * exp(-1i * D);
        end
    end
end
