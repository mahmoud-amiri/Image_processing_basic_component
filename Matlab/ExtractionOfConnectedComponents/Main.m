function connected_component_extraction
    close all
    clear all
    clc;

    %***** Extraction of Connected Component *****%

    %% Inputs
    inputImage = im2bw(imread('Test.tif'));
    tempImage = inputImage;
    [rows, cols] = size(inputImage);
    labelImage = zeros(rows, cols);

    %% Structure Element
    se = strel('square', 3);

    %% Morphological Operation
    numComponents = 0;
    points = find(tempImage == 1);

    while ~isempty(points)
        numComponents = numComponents + 1;
        point = points(1);

        x = zeros(rows, cols);
        x(point) = 1;

        y = tempImage & imdilate(x, se, 'same');

        while ~isequal(x, y)
            x = y;
            y = tempImage & imdilate(x, se);
        end

        positions = find(y == 1);
        tempImage(positions) = 0;
        labelImage(positions) = numComponents;

        points = find(tempImage == 1);
    end

    %% Plotting
    plotConnectedComponents(labelImage, numComponents, inputImage);
end

function plotConnectedComponents(labelImage, numComponents, inputImage)
    figure;
    k = 1;
    for i = 1:numComponents
        subplot(ceil((numComponents + 1) / 3), ceil((numComponents + 1) / 3), k);
        imshow(labelImage == i);
        title(['Connected Component ', num2str(k)]);
        k = k + 1;
    end
    subplot(ceil((numComponents + 1) / 3), ceil((numComponents + 1) / 3), k);
    imshow(inputImage);
    title('Main Image');
end
