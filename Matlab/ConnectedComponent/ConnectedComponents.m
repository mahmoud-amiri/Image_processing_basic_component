function connected_components
    close all;
    clear all;
    clc;

    % Global variables
    global inputImage stack stackPtr label visitedMatrix

    % Read and preprocess the image
    inputImage = im2bw(imread('1.tif'), 0.5);
    [rows, cols] = size(inputImage);
    visitedMatrix = zeros(rows, cols, 2);
    stack = zeros(1, 2 * rows * cols);
    stackPtr = 0;
    label = 1;

    % Main loop to find connected components
    for i = 1:rows
        for j = 1:cols
            if inputImage(i, j) == 1 && visitedMatrix(i, j, 2) == 0
                visitedMatrix(i, j, 1) = label;
                visitedMatrix(i, j, 2) = 1;
                push(i);
                push(j);
                find_region(i, j);
                label = label + 1;
            end
        end
    end

    numComponents = label - 1;
    display_components(numComponents, rows, cols);
end

function find_region(i, j)
    global inputImage stack stackPtr label visitedMatrix

    [rows, cols] = size(inputImage);

    while stackPtr ~= 0
        j = pop();
        i = pop();
        for k = -1:1
            for l = -1:1
                if is_valid_pixel(i + k, j + l, rows, cols) && inputImage(i + k, j + l) == 1 && visitedMatrix(i + k, j + l, 2) == 0
                    visitedMatrix(i + k, j + l, 1) = label;
                    visitedMatrix(i + k, j + l, 2) = 1;
                    push(i + k);
                    push(j + l);
                end
            end
        end
    end
end

function isValid = is_valid_pixel(i, j, rows, cols)
    isValid = (i > 0 && i <= rows && j > 0 && j <= cols);
end

function stackTop = pop()
    global stack stackPtr
    stackTop = stack(stackPtr);
    stackPtr = stackPtr - 1;
end

function push(value)
    global stack stackPtr
    stackPtr = stackPtr + 1;
    stack(stackPtr) = value;
end

function display_components(numComponents, rows, cols)
    global visitedMatrix inputImage
    k = 1;
    figure;
    for i = 1:numComponents
        subplot(ceil(numComponents / 3), 3, k);
        imshow(visitedMatrix(:, :, 1) == i);
        title(['Connected Component ', num2str(k)]);
        k = k + 1;
    end
    subplot(ceil(numComponents / 3), 3, k);
    imshow(inputImage);
    title('Main Image');
end
