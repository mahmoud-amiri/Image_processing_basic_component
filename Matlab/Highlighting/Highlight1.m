function [HighLightImg1]=Highlight1(InputImg,i,j)
%[M N]=size(InputImg);
%HighLightImg1=zeros(M,N);
if (InputImg(i,j) < 100) || (InputImg(i,j) >150);
    HighLightImg1(i,j)=70;
else
    HighLightImg1(i,j)=230;
end
%HighLightImg1;