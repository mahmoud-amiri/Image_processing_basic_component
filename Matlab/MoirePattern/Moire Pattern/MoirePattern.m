close all
clear all
clc;

%***** Generate Moire Pattern *****%

% Main function
function generateMoirePattern()
    % Generate images
    [image1, image2] = generateImages();

    % Display original images
    figure, imshow(image1);
    figure, imshow(image2);

    % Rotate images
    rotatedImage1 = rotateImage(image1, 45);
    rotatedImage2 = rotateImage(image2, 45);

    % Display rotated images
    figure, imshow(uint8(rotatedImage1));
    figure, imshow(uint8(rotatedImage2));

    % Combine original and rotated images
    combinedImage1 = combineImages(rotatedImage1, image1);
    combinedImage2 = combineImages(rotatedImage2, image2);

    % Display combined images
    figure, imshow(uint8(combinedImage1));
    figure, imshow(uint8(combinedImage2));
end

% Function to generate the images
function [image1, image2] = generateImages()
    image1 = zeros(400, 401);
    image2 = zeros(401, 401);
    
    for i = 1 : 10 : 401
        if mod(i, 2) ~= 0
            image1(:, i) = 255 * ones(400, 1);
        end
    end
    
    for i = 1 : 8 : 401
        for j = 1 : 8 : 401 
            if mod(i + j, 2) == 0 
                image2(i, j) = 255;
            end
        end
    end
end

% Function to rotate an image
function rotatedImage = rotateImage(image, angle)
    rotatedImage = imrotate(image, angle, 'bilinear', 'crop');
end

% Function to combine original and rotated images
function combinedImage = combineImages(rotatedImage, originalImage)
    combinedImage = rotatedImage + originalImage;
end

% Call the main function
generateMoirePattern();
