%choosing long format to use more precision
format long
%loading the data set
optdigits=load('optdigits.tes');

%seperating classes
class0=[];
class1=[];
class2=[];
class3=[];
class4=[];
class5=[];
class6=[];
class7=[];
class8=[];
class9=[];
%normalizing the inputs,outputs and separating them according to their
%classes
for i=1:size(optdigits,1)
    a=optdigits(i,65);
    i_opt=optdigits(i,1:64);
    imin=min(i_opt);
    imax=max(i_opt);
    toadd=(i_opt-imin)./(imax-imin);
    if(a==0)
      class0=[class0; toadd 0];
    elseif(a==1)
      class1=[class1; toadd 1/9];
    elseif(a==2)
      class2=[class2; toadd 2/9];
    elseif(a==3)
      class3=[class3; toadd 3/9];
    elseif(a==4)
      class4=[class4; toadd 4/9];
    elseif(a==5)
      class5=[class5; toadd 5/9];
    elseif(a==6)
      class6=[class6; toadd 6/9];
    elseif(a==7)
      class7=[class7; toadd 7/9];
    elseif(a==8)
      class8=[class8; toadd 8/9];
    elseif(a==9)
      class9=[class9; toadd 1];
    end
end
%choosing 100 samples from each class
sample=[class0(50:149,:);class1(50:149,:);class2(50:149,:);class3(50:149,:);
        class4(50:149,:); class5(50:149,:);class6(50:149,:);class7(50:149,:);
        class8(50:149,:);class9(50:149,:)];
%initializing random matrices
ws1=rand(65,16);
ws2=rand(17,1);
%learning rate
lrate=0.6;
epoch=0;
%array to store previous total error values
errplot=[];
%arbitrary errp for the loop
%errp is normally defined as the total error
errp=2;
while(errp>0.1)  
    %saving resultant outputs and weight matrix values
    outcheck=zeros(1000,1); 
    ws1memory=ws1; 
    ws2memory=ws2;
    %looping over the samples
    for s=1:1000
        %adding bias input to input vectır
        input=[1;sample(s,1:64)'];
        output=sample(s,65);
        %for the second layer
        s_2=(ws1)'*input;
        o_2=1./(1+exp(-s_2));
        %for the output layer
        s_3=((ws2')*[1; o_2]);
        o_3=1./(1+exp(-s_3));
        outcheck(s)=o_3;
        %the error
        err=(output-o_3);
        %del values
        del3=err*o_3*(1-o_3); 
        del2=del3*ws2.*[1;o_2].*(ones(17,1)-[1;o_2]);
        %update rule at output 
        delta2=lrate*del3*[1;o_2];
        %update rule at hidden layer
        delta1=lrate*input*(del2(2:17)');
        %updating weight matrices
        ws1=ws1+delta1;
        ws2=ws2+delta2;   
    end
    %checking the convergence of the weight matrices
    conv=sum((ws1-ws1memory).^2,'all')+sum((ws2-ws2memory).^2,'all');
    %calculating total error
    errp=0.5*sum((sample(:,65)-outcheck).^2,'all');
    errplot=[errplot errp];
    epoch=epoch+1;
end
%plotting the epoch vs error
figure(1);
title('Total Error vs the Number of Epochs');
xlabel('Number of Epochs');
ylabel('Total Error');
plot(1:epoch,errplot);

%checking for the test samples
result=zeros(200,1);
testset=[class0(20:39,:);class1(20:39,:);class2(20:39,:);class3(20:39,:);
        class4(20:39,:); class5(20:39,:);class6(20:39,:);class7(20:39,:);
        class8(20:39,:);class9(20:39,:)];
for s=1:200
        input=[1;testset(s,1:64)'];
        s2=(ws1)'*input;
        o2=1./(1+exp(-s2));
        s3=((ws2')*[1; o2]);
        out=1./(1+exp(-s3));
        result(s)=round(out*9);
end
T = table(round(testset(:,65).*9),result(:),'VariableNames',{'Desired Output','Predicted Output'})
figure(2)
hold on;
plot(1:200,round(testset(:,65).*9),'ro');
plot(1:200,result(:),'bx');
hold off;