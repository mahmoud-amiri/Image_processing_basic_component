function color_edge_detection
    close all
    clear all
    clc;

    %**** Color Edge Detection *****%

    %% Inputs
    img = imread('lenna.tif');

    B = im2double(img(:, :, 3));
    G = im2double(img(:, :, 2));
    R = im2double(img(:, :, 1));

    [rows, cols] = size(B);

    %% Gradient Computation
    [F, RGB] = computeGradient(R, G, B, rows, cols);

    %% Plotting
    plotResults(F, RGB);
end

function [F, RGB] = computeGradient(R, G, B, rows, cols)
    [GxB, GyB] = imgradientxy(B);
    [GxG, GyG] = imgradientxy(G);
    [GxR, GyR] = imgradientxy(R);

    gxx = GxB .* GxB + GxG .* GxG + GxR .* GxR;
    gyy = GyB .* GyB + GyG .* GyG + GyR .* GyR;
    gxy = GxB .* GyB + GxG .* GyG + GxR .* GyR;

    X = (2 .* gxy ./ (gxx - gyy + 10^-10)) .* pi / 180;
    Theta = (0.5 .* atan(X)) .* pi / 180;

    Y = (gxx + gyy + 2 .* gxy .* sin(2 .* Theta) + (gxx - gyy) .* cos(2 .* Theta));
    F = sqrt(0.5 .* Y);

    RGB = GxB + GyB + GxG + GyG + GxR + GyR;
end

function plotResults(F, RGB)
    figure,
    subplot(121), imshow(abs(F), []); title('Edge Detection Using Di Zenzo Relations, 1986');
    subplot(122), imshow(uint8(RGB), []); title('Edge Detection Using R, G, and B Components');
end
