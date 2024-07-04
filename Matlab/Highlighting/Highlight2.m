function [HighLightImg2]=Highlight2(InputImg,i,j)
%[M N]=size(InputImg);
%HighLightImg2=zeros(M,N);
if (InputImg(i,j) < 100) || (InputImg(i,j) >150);
    HighLightImg2(i,j)=InputImg(i,j);
else
    HighLightImg2(i,j)=230;
end
%HighLightImg2;