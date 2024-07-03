function aliasing_nearest_neighbor
    close all
    clear all
    clc;

    %% Aliasing by Nearest Neighbor

    % Input Image
    inputImage = imread('Aliasing2_Barbara.tif');
    avgFilter = 1/9 * ones(3,3);
    averagedImage = imfilter(inputImage, avgFilter, 'same', 'replicate');

    % Get downsample ratio from user
    prompt = {'Enter m :', 'Enter n :'};
    dlg_title = 'Enter DownSample Ratio';
    num_lines = 1;
    def = {'m', 'n'};
    answer = inputdlg(prompt, dlg_title, num_lines, def);
    m = str2double(answer{1});
    n = str2double(answer{2});

    % Perform nearest neighbor interpolation
    outputImage1 = nearestNeighbor(inputImage, m, n);
    outputImage2 = nearestNeighbor(averagedImage, m, n);

    %% Plotting
    figure,
    subplot(131), imshow(inputImage), title('Original Image');
    if m > 1 && n > 1
        subplot(132), imshow(uint8(outputImage1)), title(['UpSampled Image By Ratio = ( ', num2str(m), ' , ', num2str(n) ,' )']);
        subplot(133), imshow(uint8(outputImage2)), title(['UpSampled Image By Ratio = ( ', num2str(m), ' , ', num2str(n) ,' )']);
    elseif m < 1 && n < 1
        subplot(132), imshow(uint8(outputImage1)), title(['DownSampled Image By Ratio = ( ', num2str(m), ' , ', num2str(n) ,' )']);
        subplot(133), imshow(uint8(outputImage2)), title(['DownSampled Averaged Image By Ratio = ( ', num2str(m), ' , ', num2str(n) ,' )']);
    else
        subplot(132), imshow(uint8(outputImage1)), title(['Scaled Image By Ratio = ( ', num2str(m), ' , ', num2str(n) ,' )']);
        subplot(133), imshow(uint8(outputImage2)), title(['Scaled Averaged Image By Ratio = ( ', num2str(m), ' , ', num2str(n) ,' )']);
    end
end

function outputImage = nearestNeighbor(inputImage, m, n)
    %% Size of Output Image
    [rows, cols] = size(inputImage);
    newRows = floor(m * rows);
    newCols = floor(n * cols);
    outputImage = zeros(newRows, newCols);

    %% Nearest Neighbor Method
    for i = 1:newRows
        for j = 1:newCols
            x = i / m;
            y = j / n;
            if x < 0.5 
                x = x + 0.5;
            end
            if y < 0.5
                y = y + 0.5;
            end
            x = round(x);
            y = round(y);
            outputImage(i, j) = inputImage(x, y);        
        end
    end
end
