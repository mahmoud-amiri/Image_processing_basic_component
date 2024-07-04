function [ScaledImg] = Scaling(InputImg)

MinOfInputImg = min(min(InputImg));
ScaledImg = InputImg - MinOfInputImg ;
Max = max(max(ScaledImg));
ScaledImg = ScaledImg * ( 255 / Max );

end