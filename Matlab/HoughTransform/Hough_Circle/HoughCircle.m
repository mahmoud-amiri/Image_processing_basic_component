function detect_circles_hough_transform
    close all
    clear all
    clc;

    %***** Detecting Circles Using Hough Transform *****%

    %% Inputs
    inputImage = rgb2gray(imread('coins.png'));
    [rows, cols] = size(inputImage);

    %% Edge Detection Using Sobel's Algorithm
    edgeImage = edge(inputImage, 'sobel');

    %% Hough Transform Parameters
    radius1 = 28; 
    radius2 = 36;

    %% Plotting Main and Edge Images
    figure;
    subplot(221), imshow(inputImage); title('Main Image');
    subplot(222), imshow(edgeImage); title('Finding Edges Using Sobel');

    %% Hough Transform for Circle Detection
    detectCircles(inputImage, edgeImage, radius1, rows, cols, 'r');
    detectCircles(inputImage, edgeImage, radius2, rows, cols, 'g', 3);

end

function detectCircles(inputImage, edgeImage, radius, rows, cols, color, maxCircles)
    if nargin < 7
        maxCircles = 1;
    end
    
    accumulator = zeros(rows, cols);
    
    for i = 1:rows
        for j = 1:cols
            if edgeImage(i, j) ~= 0
                for theta = 0:359
                    radTheta = deg2rad(theta);
                    p1 = floor(i - radius * cos(radTheta));
                    p2 = floor(j - radius * sin(radTheta));
                    if p1 <= rows && p1 >= 1 && p2 <= cols && p2 >= 1
                        accumulator(p1, p2) = accumulator(p1, p2) + 1;
                    end
                end
            end
        end
    end
    
    subplotIndex = (4 * abs(radius - 28) + 3 * abs(radius - 36)) / abs(28 - 36);
    subplot(2, 2, subplotIndex), imshow(accumulator, []); title(['Hough circle ---> radius=', num2str(radius)]);
    
    for k = 1:maxCircles
        [maxRowValues, maxColIndices] = max(accumulator);
        [~, maxColIndex] = max(maxRowValues);
        rowIndex = maxColIndices(maxColIndex);
        accumulator(rowIndex, maxColIndex) = 0;
        rectangle('Position', [maxColIndex - radius, rowIndex - radius, 2 * radius, 2 * radius], 'Curvature', [1, 1], 'EdgeColor', color);
    end
end
