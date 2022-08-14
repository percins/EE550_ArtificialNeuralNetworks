%% EE550 PROJECT 1
%% 1 Generating data points
x=rand(15,1)*9+1;
%% 2 Adding the Gaussian noise and plotting
noise=0.15*randn(15,1)+0;
theta=[1.15; 0.5; 1.12];
y=[ones(1,15); (x.'); (x.^2).'].'*theta+noise;
figure(1)
hold on;
title('Generated Data Set')
plot(x,y,'r+')
xlabel('X values')
ylabel('Y values')
hold off;
%% 3 Models
%Model 1
phi1=[ones(1,15)].';
n=1;
pv1=50*ones(1,n);
P01=diag(pv1);
w01=zeros(n,1);
for t=1:15
   P1=P01-(P01*(phi1(t,:).')*phi1(t,:)*P01)/(1+phi1(t,:)*P01*(phi1(t,:).'));
   K1=P1*(phi1(t,:).');
   err1=y(t)-phi1(t,:)*w01;
   w1=w01+K1*err1;
   w01=w1;
   P01=P1;
end
y1=phi1*w1;

%Model 2
phi2=[ones(1,15); (x.')].';
n=2;
pv2=50*ones(1,n);
P02=diag(pv2);
w02=zeros(n,1);
for t=1:15
   P2=P02-(P02*(phi2(t,:).')*phi2(t,:)*P02)/(1+phi2(t,:)*P02*(phi2(t,:).'));
   K2=P2*(phi2(t,:).');
   err2=y(t)-phi2(t,:)*w02;
   w2=w02+K2*err2;
   w02=w2;
   P02=P2;
end
y2=phi2*w2;

%Model 3
phi3=[ones(1,15); (x.'); (x.^2).'].';
n=3;
pv3=50*ones(1,n);
P03=diag(pv3);
w03=zeros(n,1);
for t=1:15
   P3=P03-(P03*(phi3(t,:).')*phi3(t,:)*P03)/(1+phi3(t,:)*P03*(phi3(t,:).'));
   K3=P3*(phi3(t,:).');
   err3=y(t)-phi3(t,:)*w03;
   w3=w03+K3*err3;
   w03=w3;
   P03=P3;
end
y3=phi3*w3;

%Model 4
phi4=[ones(1,15); (x.'); (x.^2).'; (x.^3).'].';
n=4;
pv4=50*ones(1,n);
P04=diag(pv4);
w04=zeros(n,1);
for t=1:15
   P4=P04-(P04*(phi4(t,:).')*phi4(t,:)*P04)/(1+phi4(t,:)*P04*(phi4(t,:).'));
   K4=P4*(phi4(t,:).');
   err4=y(t)-phi4(t,:)*w04;
   w4=w04+K4*err4;
   w04=w4;
   P04=P4;
end
y4=phi4*w4;

%% 4 RLS Error
err1=sum((y-y1).^2);
err2=sum((y-y2).^2);
err3=sum((y-y3).^2);
err4=sum((y-y4).^2);
%% 5 Plotting
figure(2)
hold on;
title('Model 1 - Actual Data Set')
plot(x,y,'r+')
plot(x,y1,'bo');
legend('Actual','Estimated')
xlabel('X values')
ylabel('Y values')
hold off;

figure(3)
hold on;
title('Model 2 - Actual Data Set')
plot(x,y,'r+')
plot(x,y2,'k-');
legend('Actual','Estimated')
xlabel('X values')
ylabel('Y values')
hold off;

figure(4)
hold on;
title('Model 3 - Actual Data Set')
plot(x,y,'r+')
plot(x,y3,'go');
legend('Actual','Estimated')
xlabel('X values')
ylabel('Y values')
hold off;

figure(5)
hold on;
title('Model 4 - Actual Data Set')
plot(x,y,'r+')
plot(x,y4,'kp');
legend('Actual','Estimated')
xlabel('X values')
ylabel('Y values')
hold off;
%% 6 Estimated Parameters and RLS Errors
models = {'Model 1';'Model 2';'Model 3';'Model 4'};
param={num2str(w1.');num2str(w2.');num2str(w3.');num2str(w4.')};
RLS=[err1;err2;err3;err4];
T = table(models,param,RLS,'VariableNames',{'Models','Estimated Parameters (theta(1) theta(2) ... theta(n))','RLS Errors'})