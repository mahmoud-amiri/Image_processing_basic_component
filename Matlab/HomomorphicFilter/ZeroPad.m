function [OutputImg] = ZeroPad(InputImg,P,R)

    [ M N ] = size(InputImg);
 
    ZeroPad = zeros( M + P - 1 , N + R - 1 );
    ZeroPad( 1 : M , 1 : N ) = InputImg;
    OutputImg = ZeroPad;
    
end