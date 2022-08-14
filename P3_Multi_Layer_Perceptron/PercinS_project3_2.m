format long
f= @(x) sin(x)+2*cos(x);
inputs=rand(60,1)*2*pi;
imin=min(inputs);
imax=max(inputs);
inputs=(inputs-imin)./(imax-imin);
outputs=f(inputs);
omin=min(outputs);
omax=max(outputs);
outputs=(outputs-omin)./(omax-omin);
 
ws1 = rand(2,2);
ws2 = rand(3,2);
ws3 = rand(3,1);  
lrate=0.7; 
epoch=0;
errplot=[];
errp=37; 
while (errp>0.1) 
    outcheck=zeros(length(inputs),1);   
    ws1memory=ws1; 
    ws2memory=ws2;
    ws3memory=ws3;
    for sample=1:length(inputs)
        input=[1;inputs(sample)]; 
        output=outputs(sample);
        s_2=(ws1)'*input;
        o_2=1./(1+exp(-s_2));
        s_3=(ws2')*[1; o_2];
        o_3=1./(1+exp(-s_3));
        s_4=(ws3')*[1; o_3];
        o_4=1./(1+exp(-s_4));
        outcheck(sample)=o_4;
        err=(output-o_4);
        %del-delta values
        del4=err*o_4*(1-o_4);
        delta3=lrate*del4*[1;o_3];
        del3=del4*ws3.*[1;o_3].*(ones(3,1)-[1;o_3]);
        delta2=lrate*[1;o_2]*(del3(2:3)');
        del2(1,1)=0;
        del2(2,1)=(del3(2)*ws2(2,1)+del3(3)*ws2(2,2))*o_2(1)*(1-o_2(1));
        del2(3,1)=(del3(2)*ws2(3,1)+del3(3)*ws2(3,2))*o_2(2)*(1-o_2(2));
        delta1=lrate*input*(del2(2:3)');

        ws1=ws1+delta1;
        ws2=ws2+delta2;
        ws3=ws3+delta3;
    end
    conv=sum((ws1-ws1memory).^2,'all')+sum((ws2-ws2memory).^2,'all')+sum((ws3-ws3memory).^2,'all');
    errp=0.5*sum((outputs-outcheck).^2,'all');
    errplot=[errplot errp];
    epoch=epoch+1;
end
figure(1)
plot(1:epoch,errplot);

figure(2)
hold on;
plot(inputs(1:24),outputs(1:24),'ro');
plot(inputs(1:24),outcheck(1:24),'bx');
hold off;
