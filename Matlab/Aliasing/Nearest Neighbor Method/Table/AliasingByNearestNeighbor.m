function aliasing_nearest_neighbor
    close all
    clear all
    clc;

    %% Aliasing by Nearest Neighbor

    % Input Image
    inputImage = imread('Aliasing1.tif');
    % inputImage = imread('Aliasing2_Barbara.tif');

    % Get downsample ratios from user
    prompt = {'Enter m1 :', 'Enter n1 :', 'Enter m2 :', 'Enter n2 :'};
    dlg_title = 'Enter Two DownSample Ratios';
    num_lines = 1;
    def = {'m1', 'n1', 'm2', 'n2'};
    answer = inputdlg(prompt, dlg_title, num_lines, def);
    m1 = str2double(answer{1});
    n1 = str2double(answer{2});
    m2 = str2double(answer{3});
    n2 = str2double(answer{4});

    % Perform nearest neighbor interpolation
    outputImage1 = nearestNeighbor(inputImage, m1, n1);
    outputImage2 = nearestNeighbor(inputImage, m2, n2);

    %% Plotting
    figure, imshow(inputImage), title('Original Image');

    % Plot the first output image
    if m1 > 1 && n1 > 1
        figure, imshow(uint8(outputImage1)), title(['UpSampled Image By Ratio = ( ', num2str(m1), ' , ', num2str(n1) ,' )']);
    elseif m1 < 1 && n1 < 1
        figure, imshow(uint8(outputImage1)), title(['DownSampled Image By Ratio = ( ', num2str(m1), ' , ', num2str(n1) ,' )']);
    else
        figure, imshow(uint8(outputImage1)), title(['Scaled Image By Ratio = ( ', num2str(m1), ' , ', num2str(n1) ,' )']);
    end

    % Plot the second output image
    if m2 > 1 && n2 > 1
        figure, imshow(uint8(outputImage2)), title(['UpSampled Image By Ratio = ( ', num2str(m2), ' , ', num2str(n2) ,' )']);
    elseif m2 < 1 && n2 < 1
        figure, imshow(uint8(outputImage2)), title(['DownSampled Image By Ratio = ( ', num2str(m2), ' , ', num2str(n2) ,' )']);
    else
        figure, imshow(uint8(outputImage2)), title(['Scaled Image By Ratio = ( ', num2str(m2), ' , ', num2str(n2) ,' )']);
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
