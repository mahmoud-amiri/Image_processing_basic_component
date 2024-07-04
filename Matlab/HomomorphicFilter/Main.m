close all
clear 
clc;
%% Inputs

InputImg = imread('HF1.tif');
[ M N ] = size( InputImg );
LogInImg = log( im2double( InputImg ) + 1 );
[ LogInImgR ] = ZeroPad( LogInImg , M , N );

%% Homomorphic Filtering

[H] = HomFil( 2 , 0.25 , 1 , 80 , M , N );
FT = fft2( LogInImgR );
Output = H .* FT ;
OutputImg = real( ifft2( Output ) );
OutputImg = exp( OutputImg ) - 1 ;
OutputImg = OutputImg( 1 : M , 1 : N ) ;
[OutputImg] = Scaling( OutputImg );

%% Plotting

figure,
subplot(121),imshow( InputImg );title('Main Image');
subplot(122),imshow( uint8( OutputImg ) );title('Apply Homomorphic Filter');



