function [OutputImg] = HomFil( GammaH , GammaL , c , D0 , M , N )

    for i = 1 : 2*M-1 
        for j = 1 : 2*N-1 
            D2 = ( i )^2 + ( j )^2;
            P = ( -c * D2 ) / ( D0 ^ 2 );
            OutputImg( i , j ) = ( GammaH - GammaL ) * ( 1 - exp(P) ) + GammaL;
        end
    end
    OutputImg = fftshift( OutputImg );
    figure, surf(OutputImg);