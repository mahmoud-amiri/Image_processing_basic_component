function region_filling
    close all
    clear all
    clc;

    %***** Region Filling *****%

    %% Inputs
    inputImage = im2double(imread('RF.tif'));
    [rows, cols] = size(inputImage);

    % Using Cursor for Specifying Starting Points
    figure,
    imshow(inputImage); title('Please Specify Points Which Must Be Filled Then Press Enter');
    [x, y] = ginput;
    x = round(x); y = round(y);
    numPoints = size(x, 1);
    close all;

    %% Region Filling
    outputImage = inputImage;

    for k = 1:numPoints
        filledRegion = fillRegion(x(k), y(k), rows, cols, inputImage);
        outputImage = outputImage + filledRegion;
    end

    %% Plotting
    figure,
    subplot(121), imshow(inputImage); title('Main Image');
    subplot(122), imshow(outputImage); title([num2str(numPoints), ' Region(s) is/are Filled']);
end

function filledRegion = fillRegion(x, y, rows, cols, inputImage)
    % Structure Element
    se = strel('diamond', 1);

    % Region Filling Operation
    filledRegion = zeros(rows, cols);
    filledRegion(y, x) = 1;
    previousRegion = zeros(rows, cols);

    while sum(previousRegion(:)) ~= sum(filledRegion(:))
        previousRegion = filledRegion;
        filledRegion = imdilate(filledRegion, se, 'same');
        filledRegion = filledRegion .* (~inputImage);
    end
end
