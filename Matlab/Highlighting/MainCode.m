InputImg=imread('test.tif');
InputImg=InputImg(:,:,1);
[M N]=size(InputImg);
HighLightImg1=zeros(M,N);
HighLightImg2=zeros(M,N);
for i=1:M
    for j=1:N
        %Method One
        if InputImg(i,j) > 100 ;
           HighLightImg1(i,j)=20;
        else
            HighLightImg1(i,j)=255;
            %Method Two
         if InputImg(i,j) <  180  ;
            HighLightImg2(i,j)=255;
         else
             HighLightImg2(i,j)=InputImg(i,j);
        end
        end      
    end
end
figure,
subplot(2,2,1.5),imshow(InputImg); title('Main Image');
subplot(2,2,3),imshow(uint8(HighLightImg1)); title('HighLighted Image 1');
subplot(2,2,4), imshow(uint8(HighLightImg2)); title('HighLighted Image 2');
