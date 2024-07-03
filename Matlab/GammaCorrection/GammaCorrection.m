function gamma_correction
    close all
    clear all
    clc;

    %***** Gamma Correction *****%

    %% Inputs
    choice = menu('Choose', 'Washed Out Image', 'Dark Image');

    if choice == 1
        method = 'Washed Out Image';
        prompt = {'Enter Gamma', 'Enter C'};
        dlg_title = 'Enter Info';
        num_lines = 1;
        def = {'3', '1'};
        answer = inputdlg(prompt, dlg_title, num_lines, def);
        gammaValue = str2double(answer{1});
        cValue = str2double(answer{2});
        inputImage = imread('G1.jpg');
    elseif choice == 2
        method = 'Dark Image';
        prompt = {'Enter Gamma', 'Enter C'};
        dlg_title = 'Enter Info';
        num_lines = 1;
        def = {'0.4', '1'};
        answer = inputdlg(prompt, dlg_title, num_lines, def);
        gammaValue = str2double(answer{1});
        cValue = str2double(answer{2});
        inputImage = imread('G2.jpg');
    end

    % Convert input image to double
    inputImage = double(inputImage) / 255;

    % Perform gamma correction
    correctedImage = performGammaCorrection(inputImage, gammaValue, cValue);

    % Plotting
    plotResults(method, inputImage, correctedImage, gammaValue, cValue);
end

function correctedImage = performGammaCorrection(inputImage, gammaValue, cValue)
    [rows, cols] = size(inputImage);
    correctedImage = zeros(rows, cols);

    for i = 1:rows
        for j = 1:cols
            correctedImage(i, j) = cValue * (inputImage(i, j) .^ gammaValue);
        end
    end
end

function plotResults(method, inputImage, correctedImage, gammaValue, cValue)
    if strcmp(method, 'Washed Out Image')
        subplot(2, 2, 1), imshow(inputImage); title('Washed Out Image');
        subplot(2, 2, 2), imshow(correctedImage); title(['Corrected Image with Gamma = ', num2str(gammaValue), ' and C = ', num2str(cValue)]);
        subplot(2, 2, 3), imhist(inputImage); title('Histogram of Washed Out Image');
        subplot(2, 2, 4), imhist(correctedImage); title('Histogram of Corrected Image');
    elseif strcmp(method, 'Dark Image')
        subplot(2, 2, 1), imshow(inputImage); title('Dark Image');
        subplot(2, 2, 2), imshow(correctedImage); title(['Corrected Image with Gamma = ', num2str(gammaValue), ' and C = ', num2str(cValue)]);
        subplot(2, 2, 3), imhist(inputImage); title('Histogram of Dark Image');
        subplot(2, 2, 4), imhist(correctedImage); title('Histogram of Corrected Image');
    end
end
