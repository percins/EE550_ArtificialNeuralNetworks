%% Question 1
inputs=[0 0 1 1; 0 1 0 1]; 
outputs=[0; 1; 1; 0]; 
nlayer=3;
ws1 = rand(3,2);
ws2 = rand(3,1);
epoch=0;
errplot=[];
lrate=0.6;
errp=1;
while(errp>0.001)   
    outcheck=zeros(length(inputs),1);
    ws1memory=ws1; 
    ws2memory=ws2; 
    for sample=1:length(inputs)
        input=[1;inputs(:,sample)];
        output=outputs(sample);
        s_2=(ws1)'*input;
        o_2=1./(1+exp(-s_2));
        s_3=(ws2')*[1; o_2];
        o_3=1./(1+exp(-s_3));
        outcheck(sample)=o_3;
        err=(output-o_3);
        %del values
        del3=err*o_3*(1-o_3); 
        del2=del3*ws2.*[1;o_2].*(ones(3,1)-[1;o_2]);
        %update rule at output 
        delta2=lrate*del3*[1;o_2];
        %update rule at hidden layer
        delta1=lrate*input*(del2(2:3)');
        ws1=ws1+delta1;
        ws2=ws2+delta2;         
    end
    conv=sum((ws1-ws1memory).^2,'all')+sum((ws2-ws2memory).^2,'all');
    errp=0.5*sum((outputs-outcheck).^2,'all');
    errplot=[errplot errp];
    epoch=epoch+1;
end

figure(1)
plot(1:epoch,errplot);
T = table(inputs(1,:)',inputs(2,:)',outputs, outcheck,'VariableNames',{'input1','input2','desired output','predicted output'})