close all;
clear;
clc;

%% Inputs
prompt = {'Enter Kernel Dimensions:', 'Enter Trimmed Value:'};
dlg_title = 'Input';
num_lines = 1;
default_vals = {'3', '4'};
answer = inputdlg(prompt, dlg_title, num_lines, default_vals);
kernel_dim = str2double(answer{1});
trim_val = str2double(answer{2});
input_img = imread('SP.tif');
[img_rows, img_cols] = size(input_img);

%% Parameters
half_kernel = floor(kernel_dim / 2);
padded_img = replicate_padding(half_kernel, input_img, img_rows, img_cols);

output_img = zeros(img_rows, img_cols);

%% Filtering
for i = (kernel_dim - half_kernel):(img_rows + half_kernel)
    for j = (kernel_dim - half_kernel):(img_cols + half_kernel)
        local_region = padded_img(i - half_kernel:i + half_kernel, j - half_kernel:j + half_kernel);
        sorted_vec = sort_local_region(local_region, kernel_dim);
        if mod(trim_val, 2) == 0
            output_img(i - half_kernel, j - half_kernel) = (1 / ((kernel_dim * kernel_dim) - trim_val)) * sum(sum(sorted_vec((trim_val / 2) + 1:(kernel_dim * kernel_dim) - (trim_val / 2))));
        else
            output_img(i - half_kernel, j - half_kernel) = (1 / ((kernel_dim * kernel_dim) - trim_val)) * sum(sum(sorted_vec(floor(trim_val / 2) + 1:(kernel_dim * kernel_dim) - floor(trim_val / 2) - 1)));
        end
    end
end

%% Display
subplot(121), imshow(input_img); title('Corrupted Image By Salt & Pepper Noise');
subplot(122), imshow(uint8(output_img)); title('Applying Alpha-Trimmed Mean Filter');

%% Functions
function padded_img = replicate_padding(pad_size, img, img_rows, img_cols)
    padded_img = zeros(img_rows + 2 * pad_size, img_cols + 2 * pad_size);
    padded_img(pad_size + 1:img_rows + pad_size, pad_size + 1:img_cols + pad_size) = img;
    temp = padded_img;
    for i = 1:pad_size
        padded_img(:, i) = temp(:, pad_size + 1);
        padded_img(:, img_cols + pad_size + i) = temp(:, img_cols + pad_size);
        padded_img(i, :) = temp(pad_size + 1, :);
        padded_img(img_rows + pad_size + i, :) = temp(img_rows + pad_size, :);
    end
end

function sorted_vec = sort_local_region(local_region, kernel_dim)
    local_vec = reshape(local_region', 1, []);
    sorted_vec = zeros(1, kernel_dim * kernel_dim);
    for j = 1:kernel_dim * kernel_dim
        for i = 1:kernel_dim * kernel_dim - 1
            if local_vec(i) > local_vec(i + 1)
                temp = local_vec(i + 1);
                local_vec(i + 1) = local_vec(i);
                local_vec(i) = temp;
            end
        end
        if isequal(sorted_vec, local_vec)
            break;
        end
        sorted_vec = local_vec;
    end
end
