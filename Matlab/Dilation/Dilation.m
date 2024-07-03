close all
clear all
clc;

%******* Dilation *******%

%% Inputs

% InputImg = ~im2double( rgb2gray( imread( 'D.png' ) ) );
InputImg = imread( 'D1.tif' ) ;
[ M N ] = size( InputImg );

%% Structure Element - Square
   
Method = 'Square';
prompt = {'Size of Square'};
dlg_title = 'Enter Info';
num_lines = 1;
def = {'3'};
answer = inputdlg(prompt,dlg_title,num_lines,def);
W = str2double(answer{1});
r = floor( W / 2 );
[ InputImgR Mnew Nnew] = ZeroPad( r , InputImg , M , N );
MainParam = [ 'Size of Square = ',num2str(W) ];
        
%% Dilation

StrEl = [ 0 1 0 ; 1 1 1 ; 0 1 0];
    
for i = r + 1 : Mnew - r 
    for j = r + 1 : Nnew - r
        
        Local( : , : ) = InputImgR( i - r : i + r , j - r : j + r );
        Local = Local .* StrEl;
        A = sum( sum( Local ) );
            
        if A ~= 0
            OutputImg( i - r , j - r ) = 1;
        else
            OutputImg( i - r , j - r ) = 0;
        end
    
    end
end
    
% Matlab Command
    
% StrEl = strel( 'square' , W );
Out = imdilate( InputImg , StrEl , 'same' );      

%% Plotting

figure,
% subplot(131),imshow(~InputImg);title('Main Image');
% subplot(132),imshow(~OutputImg);title({['Dilated Image Using ',num2str(Method),' Structure Element'] , MainParam });
% subplot(133),imshow(~Out);title('Dilated Image Using Matlab Command and Same Str Element' );

subplot(131),imshow(InputImg);title('Main Image');
subplot(132),imshow(OutputImg);title({['Dilated Image Using ',num2str(Method),' Structure Element'] , MainParam });
subplot(133),imshow(Out);title('Dilated Image Using Matlab Command and Same Str Element' );

        
