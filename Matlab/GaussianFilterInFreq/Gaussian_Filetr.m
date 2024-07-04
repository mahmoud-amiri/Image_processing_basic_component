function spatial_frequency_domain_processing
    clear all;
    close all;
    clc;

    %% Load Input Image
    inputImage = imread('GFilter.tif');
    padRows = 3;
    padCols = 3;
    [rows, cols] = size(inputImage);

    %********** Spatial Domain **********%
    %% Using Sobel Function
    paddedImage = zero_pad(inputImage, padRows, padCols);
    sobelImage = sobel_filter(paddedImage, 'Ver');
    scaledSobelImage = scale_image(sobelImage);

    figure,
    subplot(121), imshow(inputImage), title('Original Image');
    subplot(122), imshow(uint8(scaledSobelImage)), title('Laplacian Using Sobel');

    %********** Frequency Domain **********%
    %% Using Kernel in Spatial and Process in Frequency Domain
    prompt = {'Type Of Kernel'};
    dlg_title = 'Enter Kernel Type';
    num_lines = 1;
    def = {'Ver'};
    answer = inputdlg(prompt, dlg_title, num_lines, def);
    kernelType = answer{1};

    if strcmp(kernelType, 'Hor')
        kernel = [-1 -2 -1; 0 0 0; 1 2 1];
    elseif strcmp(kernelType, 'Ver')
        kernel = [-1 0 1; -2 0 2; -1 0 1];
    end

    paddedKernel = zero_pad(kernel, rows, cols);
    freqImage = freq_domain_transform(paddedImage);
    freqKernel = freq_domain_transform(paddedKernel);
    processedImage = freqImage .* freqKernel;

    processedImage = ifft2(processedImage);
    for i = 1:size(processedImage, 1)
        for j = 1:size(processedImage, 2)
            processedImage(i, j) = real(processedImage(i, j)) * ((-1)^(i + j));
        end
    end

    scaledProcessedImage = scale_image(processedImage);
    figure, imshow(uint8(ifftshift(scaledProcessedImage(2:end-1, 2:end-1))));
    title('Reconstructed Image Using Spatial Kernel and Processed in Frequency Domain');

    %% Using Gaussian Filter in Frequency Domain
    prompt = {'Enter Sigma1', 'Enter Sigma2', 'Enter A', 'Enter B', 'TypeOfKernel'};
    dlg_title = 'Enter Standard Deviation';
    num_lines = 1;
    def = {'60', '60', '9', '3', 'Ver'};
    answer = inputdlg(prompt, dlg_title, num_lines, def);
    sigma1 = str2double(answer{1});
    sigma2 = str2double(answer{2});
    A = str2double(answer{3});
    B = str2double(answer{4});
    typeOfKernel = answer{5};

    if strcmp(typeOfKernel, 'Ver')
        gFunc1 = gaussian_filter(A, rows, cols, sigma1, 0.5, 0.75);
        gFunc2 = gaussian_filter(B, rows, cols, sigma2, 0.5, 0.25);
    elseif strcmp(typeOfKernel, 'Hor')
        gFunc1 = gaussian_filter(A, rows, cols, sigma1, 0.25, 0.5);
        gFunc2 = gaussian_filter(B, rows, cols, sigma2, 0.75, 0.5);
    end

    gaussianFilter = gFunc1 - gFunc2;
    freqInputImage = fftshift(fft2(inputImage));
    outputImage = freqInputImage .* gaussianFilter;

    outputImage = ifft2(outputImage);
    scaledOutputImage = scale_image(outputImage);
    figure, imshow(uint8(scaledOutputImage));
    title('Reconstructed Image Using Gaussian Filter in Frequency Domain');
end

function freqImage = freq_domain_transform(inputImage)
    [rows, cols] = size(inputImage);
    centeredImage = zeros(rows, cols);
    
    for i = 1:rows
        for j = 1:cols
            centeredImage(i, j) = inputImage(i, j) * ((-1)^(i + j));
        end
    end
    
    freqImage = fft2(centeredImage);
end

function gFunc = gaussian_filter(A, rows, cols, sigma, a, b)
    gFunc = zeros(rows, cols);
    
    for i = 1:rows
        for j = 1:cols
            gFunc(i, j) = A * exp(-((i - a * rows)^2 + (j - b * cols)^2) / (2 * sigma^2));
        end
    end
end

function scaledImage = scale_image(inputImage)
    minVal = min(min(inputImage));
    scaledImage = inputImage - minVal;
    maxVal = max(max(scaledImage));
    scaledImage = scaledImage * (255 / maxVal);
end

function sobelImage = sobel_filter(inputImage, method)
    [rows, cols] = size(inputImage);
    sobelImage = zeros(rows, cols);
    
    if strcmp(method, 'Hor')
        kernel = [-1 -2 -1; 0 0 0; 1 2 1];
    elseif strcmp(method, 'Ver')
        kernel = [-1 0 1; -2 0 2; -1 0 1];
    end

    for i = 2:rows-1
        for j = 2:cols-1
            localRegion = inputImage(i-1:i+1, j-1:j+1);
            sobelImage(i-1, j-1) = sum(sum(double(localRegion) .* kernel));
        end
    end
end

function paddedImage = zero_pad(inputImage, padRows, padCols)
    [rows, cols] = size(inputImage);
    paddedImage = zeros(rows + padRows - 1, cols + padCols - 1);
    padRowOffset = floor(padRows / 2);
    padColOffset = floor(padCols / 2);
    paddedImage(padRowOffset + 1:rows + padRowOffset, padColOffset + 1:cols + padColOffset) = inputImage;
end
