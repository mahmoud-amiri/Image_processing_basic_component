function Intensity_Slicing()
    close all
    clear all
    clc;

    %% Inputs
    num_slices = get_number_of_slices();

    input_image = imread('IS.tif');
    [rows, cols] = size(input_image);

    %% Intensity Slicing
    output_image = perform_intensity_slicing(input_image, num_slices, rows, cols);

    %% Plotting
    plot_images(input_image, output_image, num_slices);
end

function num_slices = get_number_of_slices()
    prompt = {'Number Of Slices'};
    dlg_title = 'Input';
    num_lines = 1;
    default_answer = {'8'};
    answer = inputdlg(prompt, dlg_title, num_lines, default_answer);
    num_slices = str2double(answer{1});
end

function output_image = perform_intensity_slicing(input_image, num_slices, rows, cols)
    output_image = zeros(rows, cols, 3);
    intensity_step = max(max(input_image)) / num_slices;

    colors = get_colors(num_slices);

    for i = 1:rows
        for j = 1:cols
            for k = 1:num_slices
                if ((k - 1) * intensity_step <= input_image(i, j) && input_image(i, j) < k * intensity_step)
                    if k == 1
                        output_image(i, j, :) = 0;
                    elseif k == num_slices
                        output_image(i, j, :) = 1;
                    else
                        output_image(i, j, :) = colors(k - 1, :) / 255;
                    end
                    break;
                end
            end
        end
    end
end

function colors = get_colors(num_slices)
    % Define or generate colors for each slice
    colors = [
        255, 0, 0;
        0, 255, 0;
        0, 0, 255;
        255, 255, 0;
        255, 0, 255;
        0, 255, 255;
    ];
    if num_slices > size(colors, 1)
        % If more slices are needed, generate additional colors
        colors = [colors; randi([0, 255], num_slices - size(colors, 1), 3)];
    end
end

function plot_images(input_image, output_image, num_slices)
    figure;
    subplot(1, 2, 1), imshow(input_image), title('Original Image');
    subplot(1, 2, 2), imshow(output_image), title(['Image Divided into ', num2str(num_slices), ' Slices']);
end
