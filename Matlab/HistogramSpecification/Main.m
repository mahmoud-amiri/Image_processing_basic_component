function histogram_matching
    clear all;
    close all;
    clc;

    % Main
    inputImage = imread('Fig0323(a)(mars_moon_phobos).tif');
    [rows, cols] = size(inputImage);

    %% Calculate Cumulative Histogram of Input Image s=T(r)
    inputImageHist = imhist(inputImage) / (rows * cols);
    cumHistInputImage = calculate_cumulative_histogram(inputImageHist);

    %% Create Specified Histogram
    specifiedHist = create_specified_histogram();

    %% Load Data Of Specified Histogram (.fig)
    figure, open('SpecifiedHist.fig'), title('Specified Histogram');
    data = get(gca, 'Children'); 
    specifiedHistIntensity = get(data, 'YData');

    %% Calculate Cumulative Histogram of Specified s=G(z)
    specifiedHistProb = specifiedHistIntensity / sum(specifiedHistIntensity(:));
    cumHistSpecified = calculate_cumulative_histogram(specifiedHistProb);

    %% Histogram Matching Method
    matchedValues = match_histograms(cumHistInputImage, cumHistSpecified);

    %% Output Image
    outputImage = create_output_image(inputImage, matchedValues, rows, cols);

    %% Calculate Cumulative Histogram of Output Image 
    outputImageHist = imhist(outputImage) / (rows * cols);
    cumHistOutputImage = calculate_cumulative_histogram(outputImageHist);

    %% Subplotting
    plot_results(inputImage, cumHistSpecified, outputImage, cumHistOutputImage);
end

function cumHist = calculate_cumulative_histogram(hist)
    cumHist = zeros(1, 256);
    cumHist(1) = hist(1);
    for i = 2:256
        cumHist(i) = cumHist(i - 1) + hist(i);
    end
end

function specifiedHist = create_specified_histogram()
    x = 0:1:255;
    specifiedHist = (((7 * (10^4)) / 8) * x) .* (0 <= x & x < 8) + ...
                    (((-6.2 * (10^4)) / 10) * (x - 8) + 7 * (10^4)) .* (8 <= x & x < 18) + ...
                    (((-0.8 * (10^4)) / (190 - 18)) * (x - 18) + 0.8 * (10^4)) .* (18 <= x & x < 190) + ...
                    (((0.725 * (10^4)) / 18) * (x - 190)) .* (190 <= x & x < 208) + ...
                    (((-0.725 * (10^4)) / (255 - 208)) * (x - 208) + 0.725 * (10^4)) .* (208 <= x & x < 255);
end

function matchedValues = match_histograms(cumHistInput, cumHistSpecified)
    cumHistInput = round(255 * cumHistInput);
    cumHistSpecified = round(255 * cumHistSpecified);
    matchedValues = zeros(1, 256);
    diffVec = zeros(1, 256);

    for i = 1:256
        threshold = 255;
        for j = 256:-1:1
            diffVec(j) = cumHistInput(i) - cumHistSpecified(j);
            if abs(diffVec(j)) <= threshold
                threshold = abs(diffVec(j));
                matchedValues(i) = j;
            end
        end     
    end
end

function outputImage = create_output_image(inputImage, matchedValues, rows, cols)
    outputImage = zeros(rows, cols);
    for i = 1:rows
        for j = 1:cols
            outputImage(i, j) = matchedValues((inputImage(i, j) + 1));
        end
    end
end

function plot_results(inputImage, cumHistSpecified, outputImage, cumHistOutput)
    t = 0:255;
    figure;
    subplot(2, 3, 1), imshow(inputImage); title('Input Image');
    subplot(2, 3, 4), imhist(inputImage); title('Histogram of Input Image');
    subplot(2, 3, 5), stem(t, cumHistSpecified, 'Marker', 'none'); xlim([0, 255]); title('Cumulative of Specified Histogram');
    subplot(2, 3, 3), imshow(uint8(outputImage)); title('Output Image');
    subplot(2, 3, 6), imhist(uint8(outputImage)); title('Histogram of Output Image');
end
