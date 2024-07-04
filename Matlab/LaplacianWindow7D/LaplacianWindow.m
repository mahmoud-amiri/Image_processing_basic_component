close all;
clear all;
clc;

% Main function
function laplacianFrequencyDomain()
    % Generate Laplacian in Frequency Domain
    laplacianMatrix = generateLaplacianMatrix(250, 250);

    % Display 3D Plot
    figure, surf(laplacianMatrix), title('3D Plot of Laplacian in Frequency Domain');

    % Scale and Display Image Representation
    scaledLaplacian = scaleImage(laplacianMatrix);
    figure, imshow(uint8(scaledLaplacian)), title('Image Representation of Laplacian');

    % Inverse FFT and Adjust Phase
    adjustedLaplacian = inverseFFTAndAdjustPhase(laplacianMatrix);
    figure, imshow(uint8(adjustedLaplacian));

    % Display Central Submatrix
    centralSubmatrix = adjustedLaplacian(123:129, 123:129);
    disp('Central Submatrix:');
    disp(centralSubmatrix);

    % Display My_h Matrix
    myHMatrix = generateMyHMatrix();
    disp('My_h Matrix:');
    disp(myHMatrix);
end

% Function to generate Laplacian matrix in frequency domain
function laplacianMatrix = generateLaplacianMatrix(rows, cols)
    laplacianMatrix = zeros(rows, cols);
    for i = 1:rows
        for j = 1:cols
            laplacianMatrix(i, j) = -((i - 125)^2 + (j - 125)^2);
        end
    end
end

% Function to scale image
function scaledImage = scaleImage(inputImage)
    minVal = min(min(inputImage));
    scaledImage = inputImage - minVal;
    maxVal = max(max(scaledImage));
    scaledImage = scaledImage * (255 / maxVal);
end

% Function to perform inverse FFT and adjust phase
function adjustedLaplacian = inverseFFTAndAdjustPhase(laplacianMatrix)
    invFFT = ifft2(laplacianMatrix);
    [rows, cols] = size(invFFT);
    for i = 1:rows
        for j = 1:cols
            invFFT(i, j) = real(invFFT(i, j)) * ((-1)^(i + j));
        end
    end
    adjustedLaplacian = fftshift(invFFT);
end

% Function to generate My_h matrix
function myHMatrix = generateMyHMatrix()
    myHMatrix = [0 0 0 1 0 0 0; 0 0 0 -2 0 0 0; 0 0 0 4 0 0 0; ...
        1 -2 4 -12 4 -2 1; 0 0 0 4 0 0 0; 0 0 0 -2 0 0 0; 0 0 0 1 0 0 0];
end

% Call the main function
laplacianFrequencyDomain();
