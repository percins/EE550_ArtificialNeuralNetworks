%% 1 Creating the sample patterns
number9=[1 -1 -1 -1 -1 -1 -1 1; 
         1 -1 1 1 1 1 -1 1; 
         1 -1 1 1 1 1 -1 1; 
         1 -1 1 1 1 1 -1 1; 
         1 -1 -1 -1 -1 -1 -1 1; 
         1 1 1 1 1 1 -1 1; 
         1 1 1 1 1 1 -1 1; 
         1 -1 -1 -1 -1 -1 -1 1];
number7=[1 -1 -1 -1 -1 -1 1 1; 
         1 1 1 1 1 -1 1 1; 
         1 1 1 1 1 -1 1 1; 
         1 1 1 1 1 -1 1 1; 
         1 1 1 -1 -1 -1 -1 1; 
         1 1 1 1 1 -1 1 1; 
         1 1 1 1 1 -1 1 1; 
         1 1 1 1 1 -1 1 1];
number4=[1 1 1 1 1 -1 -1 1; 
         1 1 1 1 -1 -1 -1 1; 
         1 1 1 -1 -1 1 -1 1; 
         1 1 -1 -1 1 1 -1 1; 
         1 -1 -1 1 1 1 -1 1; 
         -1 -1 -1 -1 -1 -1 -1 -1; 
         1 1 1 1 1 1 -1 1; 
         1 1 1 1 1 1 -1 1];
number1=[1 1 1 1 -1 1 1 1; 
         1 1 1 -1 -1 1 1 1; 
         1 1 -1 1 -1 1 1 1; 
         1 1 1 1 -1 1 1 1; 
         1 1 1 1 -1 1 1 1; 
         1 1 1 1 -1 1 1 1; 
         1 1 1 1 -1 1 1 1; 
         1 1 -1 -1 -1 -1 -1 1];
%% 2 Convert each number to a 64-element vector
n1=reshape(number1,64,1);
n4=reshape(number4,64,1);
n7=reshape(number7,64,1);
n9=reshape(number9,64,1);
%% 3 Creating the weight matrix
w=zeros(64,64);
for j=1:64
    for i=1:64
        if(i==j)
            continue
        else
            w1=n1(j)*n1(i);
            w4=n4(j)*n4(i);
            w7=n7(j)*n7(i);
            w9=n9(j)*n9(i);
        end
        w(j,i)=w1+w4+w7+w9;  
    end
end
%% 4 Generating the noisy image and converting into noisy binary image
std=0.7;
noise=std*randn(8,8)+0;
im_in=sign(number9+noise);
in=reshape(im_in,64,1);
%% Starting the iterations
ynew=((w*in)>=0)*2-1;
ymemory=zeros(64,1);
count=1;
%adding the images in each iteration in an array in order to plot later
toshow=[reshape(ynew,8,8)];
while(sum((ynew-ymemory).^2)~=0)
    ymemory=ynew;
    ynew=((w*ymemory)>=0)*2-1;
    if (sum((ynew-ymemory).^2)~=0)
        %adding the images in each iteration in an array in order to plot later
        toshow=[toshow reshape(ynew,8,8)];
    end
    count=count+1;
end
figure(1)
title('Original image');
imshow(im_in);
figure(2)
title('Original image and the images after the iterations');
imshow([im_in,toshow]);
