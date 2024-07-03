function aliasing_shrinking_nearest_neighbor
    close all
    clear all
    clc;

    %% Aliasing by Shrinking Nearest Neighbor Integer Value

    inputImage = imread('Aliasing1.tif');

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

    % Perform downsampling
    outputImage1 = shrinkAlias(inputImage, m1, n1);
    outputImage2 = shrinkAlias(inputImage, m2, n2);

    % Plotting
    figure, imshow(inputImage), title('Original Image');
    figure, imshow(uint8(outputImage1)), title(['DownSampled Image By Ratio = ( ', num2str(m1), ' , ', num2str(n1) ,' )']);
    figure, imshow(uint8(outputImage2)), title(['DownSampled Image By Ratio = ( ', num2str(m2), ' , ', num2str(n2) ,' )']);
end

function downsampledVec = downSample(factor, inputVec)
    len = length(inputVec);
    downsampledVec = inputVec(1:factor:len);
end

function outputImage = shrinkAlias(inputImage, m, n)
    assert(m == floor(m) && m >= 1 && n == floor(n) && n >= 1, 'This code requires integer values greater than or equal to 1.');

    [rows, cols] = size(inputImage);

    % Calculate new dimensions
    newRows = ceil(rows / m);
    newCols = ceil(cols / n);

    outputImage = zeros(newRows, newCols);

    %% DownSampling
    % Vertical downsampling
    k = 1;
    for i = 1:m:rows
        inputVecVer = inputImage(i, :);
        downsampledVecVer = downSample(n, inputVecVer);
        outputImage(k, 1:length(downsampledVecVer)) = downsampledVecVer;
        k = k + 1;
    end

    % Horizontal downsampling
    k = 1;
    for i = 1:n:cols
        inputVecHor = inputImage(:, i);
        downsampledVecHor = downSample(m, inputVecHor);
        outputImage(1:length(downsampledVecHor), k) = downsampledVecHor;
        k = k + 1;
    end
end
