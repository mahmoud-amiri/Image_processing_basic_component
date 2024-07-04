function [gaussianNotchFilter, butterworthNotchFilter, idealNotchFilter] = NotchFilter(cutoffFrequency, notchCenterU, notchCenterV, rows, cols, butterworthOrder)
 
    for row = 1 : rows
        for col = 1 : cols
            
            distance1 = sqrt((row - floor(rows / 2) - 1 - notchCenterU)^2 + (col - floor(cols / 2) - 1 - notchCenterV)^2);
            distance2 = sqrt((row - floor(rows / 2) - 1 + notchCenterU)^2 + (col - floor(cols / 2) - 1 + notchCenterV)^2);
            
            productDistances = (distance1 * distance2) / (cutoffFrequency * cutoffFrequency);
            gaussianNotchFilter(row, col) = 1 - exp(-0.5 * productDistances);
            butterworthNotchFilter(row, col) = 1 / (1 + (productDistances) ^ (-butterworthOrder));
            
            if distance1 >  cutoffFrequency && distance2 > cutoffFrequency
                idealNotchFilter(row, col) = 1;
            else
                idealNotchFilter(row, col) = 0;
            end
            
        end
    end
    
end
