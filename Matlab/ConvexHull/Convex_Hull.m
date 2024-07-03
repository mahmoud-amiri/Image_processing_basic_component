function convex_hull_extraction
    close all
    clear all
    clc;

    %***** Convex Hull *****%

    %% Inputs
    inputImage = ~imread('TC.tif');
    [rows, cols] = size(inputImage);

    %% Find Upper and Lower Limitations of Image
    colSum = sum(inputImage); rowSum = sum(inputImage, 2);

    tempCol = find(colSum ~= 0); tempRow = find(rowSum ~= 0);

    lowerCol = tempCol(1); upperCol = tempCol(end);
    lowerRow = tempRow(1); upperRow = tempRow(end);

    %% Structure Elements
    B = zeros(3, 3, 4);
    B(:, :, 1) = [1 0 0; 1 -1 0; 1 0 0];
    B(:, :, 2) = rot90(B(:, :, 1), 3);
    B(:, :, 3) = fliplr(B(:, :, 1));
    B(:, :, 4) = flipud(B(:, :, 2));

    %% Convex Hull Operation
    DLim = zeros(rows, cols, 4);
    D = zeros(rows, cols, 4);

    for i = 1:4
        DLim(:, :, i) = convexHullLimited(inputImage, i, B, rows, cols, lowerRow, upperRow, lowerCol, upperCol);
        D(:, :, i) = convexHull(inputImage, i, B, rows, cols);
    end

    CLim = DLim(:, :, 1) | DLim(:, :, 2) | DLim(:, :, 3) | DLim(:, :, 4);
    C = D(:, :, 1) | D(:, :, 2) | D(:, :, 3) | D(:, :, 4);

    SLim = and(~inputImage, CLim);
    S = and(~inputImage, C);

    SLim = 100 * SLim;
    S = 100 * S;

    inputImage = inputImage * 155;

    SLim = SLim + inputImage;
    S = S + inputImage;

    %% Plotting
    figure;
    subplot(131), imshow(inputImage, []); title('Main Image');
    subplot(132), imshow(S, []); title('Convex Hull of Main Image');
    subplot(133), imshow(SLim, []); title('Result of Limiting Growth of Convex Hull Algorithm');
end

function D = convexHull(inputImage, i, B, rows, cols)
    Xp = inputImage;
    b = B(:, :, i);

    while true
        X = bwhitmiss(Xp, b);

        if any(b(:, 1) ~= 0)
            X(:, 1) = 0;
        end

        if any(b(:, 3) ~= 0)
            X(:, cols) = 0;
        end

        if any(b(1, :) ~= 0)
            X(1, :) = 0;
        end

        if any(b(3, :) ~= 0)
            X(rows, :) = 0;
        end

        X = or(X, Xp);

        if isequal(X, Xp)
            D = X;
            break;
        end

        Xp = X;
    end
end

function DLim = convexHullLimited(inputImage, i, B, rows, cols, lowerRow, upperRow, lowerCol, upperCol)
    Xp = inputImage;
    b = B(:, :, i);

    while true
        XLim = bwhitmiss(Xp, b);

        for row = 1:rows
            if row < lowerRow || row > upperRow
                XLim(row, :) = 0;
            end
        end

        for col = 1:cols
            if col < lowerCol || col > upperCol
                XLim(:, col) = 0;
            end
        end

        XLim = or(XLim, Xp);

        if isequal(XLim, Xp)
            DLim = XLim;
            break;
        end

        Xp = XLim;
    end
end
