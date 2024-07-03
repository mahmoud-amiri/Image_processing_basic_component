close all
clear all
clc;

%******* Moving Average *******%

%% Inputs

% InputImg = ~im2double( rgb2gray( imread( 'E.png' ) ) );
InputImg = imread( '1.tif' ) ;
[ M N ] = size( InputImg );

%% Structure Element - Square
   
prompt = {'n','b'};
dlg_title = 'Enter Info';
num_lines = 1;
def = {'20','0.5'};
answer = inputdlg(prompt,dlg_title,num_lines,def);
n = str2double(answer{1});
b = str2double(answer{2});

[ InputImgR Mnew Nnew] = ZeroPad( n - 1 , InputImg , M , N );
        
%% Moving Average

for i = 1 : Mnew
    for j = n : Nnew
        
        Local( : , : ) = InputImgR( i , j - n + 1 : j );
        Mean = mean( Local );
        T = b * Mean;
        
        if InputImgR( i , j ) >= T
            OutputImg( i , j - n + 1 ) = 1;
        else
            OutputImg( i , j - n + 1 ) = 0;
        end
        
    end
end

%% Plotting

figure,
subplot(121),imshow( InputImg );title('Text Image Corrupted by Spot Shading');
subplot(122),imshow( OutputImg );title('Corrected Image');
        
