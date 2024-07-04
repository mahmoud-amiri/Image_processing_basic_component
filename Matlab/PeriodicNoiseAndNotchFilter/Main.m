close all
clear all
clc;

%% Inputs

prompt = {'Digonal of Noise Ring :','Additive Noise Angle :','Noise Ratio :','D0 :','Butterworth Degree :'};
dlg_title = 'Input';
num_lines = 1;
def = {'160','pi/4','20000','10','4'};
answer = inputdlg(prompt,dlg_title,num_lines,def);
R = str2double(answer{1});
Theta = str2num(answer{2});
K = str2double(answer{3});
D0 = str2double(answer{4});
ButtOrder = str2double(answer{5});

InputImg = imread( 'cameraman.tif' );
FreqImg = fftshift( fft2( InputImg ) );
[ M N ] = size( InputImg );

%% 8-Points Noise Model In Frequency

r = R / 2; 
Noise = zeros( M , N ); 
a = floor( M / 2 + 1 ); b = floor( N / 2 + 1 );
c = floor( r * cos( Theta ) ); d = floor( r * sin( Theta ) );
n1 = a + r ; n2 = b + r; n3 = a - r; n4 = b - r;
n5 = a + c ; n6 = b + d ;
n7 = a - c ; n8 = b - d  ;
Noise( n1 , b ) = 255; Noise( n3 , b ) = 255; Noise( a , n2 ) = 255; Noise( a , n4 ) = 255;
Noise( n5 , n6 ) = 255; Noise( n5 , n8 ) = 255; Noise( n7 , n6 ) = 255; Noise( n7 , n8 ) = 255;

NoisyImg = FreqImg + K * Noise;

%% Notch Filter - Band Reject

[ H11 H12 H13 ] = NotchFilter( D0 , r , 0 , M , N , ButtOrder );
[ H21 H22 H23 ] = NotchFilter( D0 , 0 , r , M , N , ButtOrder );
[ H31 H32 H33 ] = NotchFilter( D0 , c , d , M , N , ButtOrder );
[ H41 H42 H43 ] = NotchFilter( D0 , -c , d , M , N , ButtOrder );
H1 = H11 .* H21 .* H31 .* H41;
H2 = H12 .* H22 .* H32 .* H42;
H3 = H13 .* H23 .* H33 .* H43;
figure, imshow(H1);
Output1 = H1 .* NoisyImg ;
Output2 = H2 .* NoisyImg ;
Output3 = H3 .* NoisyImg ;

OutputImg1 = real( ifft2( ifftshift( Output1 ) ) );
OutputImg2 = real( ifft2( ifftshift( Output2 ) ) );
OutputImg3 = real( ifft2( ifftshift( Output3 ) ) );

%% Plotting

figure,imshow( abs( NoisyImg) , []);title('Image + Periodic Noise in Frequency Domain');

figure,
subplot(221),imshow( uint8( real( ifft2( ifftshift( NoisyImg ) ) ) ) , [] );title('Noisy Image ( Periodic Noise )');
subplot(222),imshow( uint8( OutputImg1 ) , [] );title(['Apply Gaussian Notch Filter with D0 = ',num2str(D0)]);
subplot(223),imshow( uint8( OutputImg2 ) , [] );title(['Apply Butterworth Notch Filter with degree = ',num2str(ButtOrder),' and D0 = ',num2str(D0)]);
subplot(224),imshow( uint8( OutputImg3 ) , [] );title(['Apply Ideal Notch Filter with D0 = ',num2str(D0)]);



