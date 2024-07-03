function [ZeroPadR Mnew Nnew ] = ZeroPad(r,InputImg,M,N)

    ZeroPad = zeros( M + 2 * r , N + 2 * r );
    ZeroPad( r + 1 : M + r , r + 1 : N + r ) = InputImg;
    [ Mnew Nnew ] = size( ZeroPad );
    ZeroPadR = ZeroPad;
    
end