function [zeroPaddedImage, newRows, newCols] = ZeroPad(paddingSize, inputImage, numRows, numCols)

    % Initialize a matrix with zeros and the required padding
    zeroPaddedImage = zeros(numRows + 2 * paddingSize, numCols + 2 * paddingSize);
    
    % Insert the input image into the center of the zero-padded matrix
    zeroPaddedImage(paddingSize + 1 : numRows + paddingSize, paddingSize + 1 : numCols + paddingSize) = inputImage;
    
    % Get the size of the new zero-padded image
    [newRows, newCols] = size(zeroPaddedImage);
    
end
