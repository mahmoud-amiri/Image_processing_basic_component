function [ZeroPadR Mnew Nnew ] = ZeroPad(r,InputImg,M,N)

    ZeroPad = zeros( M , N + r );
    ZeroPad( 1 : M , r + 1 : N + r ) = InputImg;
    [ Mnew Nnew ] = size( ZeroPad );
    ZeroPadR = ZeroPad;
    
end