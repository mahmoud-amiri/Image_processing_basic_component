function adaptive_median_filtering
    close all
    clear all
    clc;

    %% Inputs
    prompt = {'Enter Maximum Kernel Dimensions :', 'Enter Salt & Pepper Noise Density :', 'Enter Median Kernel Dimensions :'};
    dlg_title = 'Input';
    num_lines = 1;
    def = {'15', '0.01', '7'};
    answer = inputdlg(prompt, dlg_title, num_lines, def);
    maxKernelDim = str2double(answer{1});
    noiseDensity = str2double(answer{2});
    medianKernelDim = str2double(answer{3});
    inputImage = imread('SP.tif');
    [rows, cols] = size(inputImage);
    outputImage = zeros(rows, cols);

    %% Add Noise
    paddingSize = floor(maxKernelDim / 2);
    noisyImage = imnoise(inputImage, 'salt & pepper', noiseDensity);
    replicatedImage = replicatePadding(noisyImage, paddingSize, rows, cols);

    %% Adaptive Median Filtering
    outputImage = adaptiveMedianFilter(replicatedImage, rows, cols, maxKernelDim, paddingSize);

    %% Median Filtering
    medianOutputImage = medianFilter(noisyImage, medianKernelDim, rows, cols);

    %% Plotting
    plotResults(noisyImage, outputImage, medianOutputImage, maxKernelDim, medianKernelDim);
end

function outputImage = adaptiveMedianFilter(replicatedImage, rows, cols, maxKernelDim, paddingSize)
    outputImage = zeros(rows, cols);

    for i = (maxKernelDim - paddingSize):(rows + paddingSize)
        for j = (maxKernelDim - paddingSize):(cols + paddingSize)
            kernelDim = 3;
            
            while (kernelDim <= maxKernelDim)
                r = floor(kernelDim / 2);
                if kernelDim == maxKernelDim
                    outputImage(i - paddingSize, j - paddingSize) = medianValue;
                    break
                end
                localRegion = replicatedImage(i - r:i + r, j - r:j + r);
                medianValue = median(localRegion(:));
                maxValue = max(localRegion(:));
                minValue = min(localRegion(:));
                A1 = medianValue - minValue;
                A2 = medianValue - maxValue;
                B1 = localRegion(r + 1, r + 1) - minValue;
                B2 = localRegion(r + 1, r + 1) - maxValue;
                
                if (A1 > 0) && (A2 < 0)
                    if (B1 > 0) && (B2 < 0)
                        outputImage(i - paddingSize, j - paddingSize) = localRegion(r + 1, r + 1);
                    else
                        outputImage(i - paddingSize, j - paddingSize) = medianValue;
                    end
                    break
                else
                    kernelDim = kernelDim + 2;
                end
            end
        end
    end
end

function outputImage = medianFilter(noisyImage, medianKernelDim, rows, cols)
    paddingSize = floor(medianKernelDim / 2);
    replicatedImage = replicatePadding(noisyImage, paddingSize, rows, cols);
    outputImage = zeros(rows, cols);

    for i = (medianKernelDim - paddingSize):(rows + paddingSize)
        for j = (medianKernelDim - paddingSize):(cols + paddingSize)
            localRegion = replicatedImage(i - paddingSize:i + paddingSize, j - paddingSize:j + paddingSize);
            outputImage(i - paddingSize, j - paddingSize) = median(localRegion(:));
        end
    end
end

function paddedImage = replicatePadding(inputImage, paddingSize, rows, cols)
    paddedImage = zeros(rows + 2 * paddingSize, cols + 2 * paddingSize);
    paddedImage(paddingSize + 1:rows + paddingSize, paddingSize + 1:cols + paddingSize) = inputImage;
end

function plotResults(noisyImage, adaptiveOutputImage, medianOutputImage, maxKernelDim, medianKernelDim)
    figure,
    subplot(131), imshow(noisyImage); title('Corrupted Image by Salt & Pepper Noise');
    subplot(132), imshow(uint8(adaptiveOutputImage)); title(['Result of Applying Adaptive Median Filter with Dmax = ', num2str(maxKernelDim)]);
    subplot(133), imshow(uint8(medianOutputImage)); title(['Result of Applying Median Filter with Kernel Dimensions = ', num2str(medianKernelDim)]);
end

function medianVal = median(localRegion)
    sortedValues = sort(localRegion(:));
    medianVal = sortedValues(floor(numel(sortedValues) / 2) + 1);
end
