%Sezen Perçin - 2018401000
%Winner Takes All Network

%% 1 Creating the data points using the spherical coordinates
%region 1
theta=pi/6+rand(30,1)*(pi/6);
phi=pi/6+rand(30,1)*(pi/6);
r=1;
p1=[(r.*sin(theta).*cos(phi)) (r.*sin(theta).*sin(phi)) r.*cos(theta)];

%region 2
phi=10*pi/6+rand(30,1)*(pi/6);
theta=4*pi/6+rand(30,1)*(pi/6);
p2=[(r.*sin(theta).*cos(phi)) (r.*sin(theta).*sin(phi)) r.*cos(theta)];
%region 3
phi=4*pi/6+rand(30,1)*(pi/6);
theta=4*pi/6+rand(30,1)*(pi/6);
p3=[(r.*sin(theta).*cos(phi)) (r.*sin(theta).*sin(phi)) r.*cos(theta)];

%% 2 Plotting the sample vectors
figure(1)
scatter3(p1(:,1),p1(:,2),p1(:,3),'or');
hold on
title('Sample Set')
scatter3(p2(:,1),p2(:,2),p2(:,3),'og');
scatter3(p3(:,1),p3(:,2),p3(:,3),'ob');
legend('Region 1','Region 2','Region 3');
hold off;

%% 3 Initializing the weights:
%This Is a Secure Case For the Winning Operation
% w1=[1/sqrt(2);0;1/sqrt(2)];
% w2=[0;-1/sqrt(2);-1/sqrt(2)];
% w3=[-1/sqrt(2);1/sqrt(2);0];
% %constructing the weight matrix
% w=[w1 w2 w3];

%Randomly intitializing the weight vectors
phi=rand(1,1)*(2*pi);
theta=rand(1,1)*(pi);
w1=[(r.*sin(theta).*cos(phi)); (r.*sin(theta).*sin(phi)); r.*cos(theta)];
phi=rand(1,1)*(2*pi);
theta=rand(1,1)*(pi);
w2=[(r.*sin(theta).*cos(phi)); (r.*sin(theta).*sin(phi)); r.*cos(theta)];
phi=rand(1,1)*(2*pi);
theta=rand(1,1)*(pi);
w3=[(r.*sin(theta).*cos(phi)); (r.*sin(theta).*sin(phi)); r.*cos(theta)];
% constructing the weight matrix
w=[w1 w2 w3];

%% 4 Implementation
figure(2)
scatter3(p1(:,1),p1(:,2),p1(:,3),'or');
hold on
title('Trajectory Plot');
scatter3(p2(:,1),p2(:,2),p2(:,3),'og');
scatter3(p3(:,1),p3(:,2),p3(:,3),'ob');
plot3(w1(1),w1(2),w1(3),'kx')
plot3(w2(1),w2(2),w2(3),'mx')
plot3(w3(1),w3(2),w3(3),'cx')

%forming training set
trainset=[p1(1:27,:); p2(1:27,:); p3(1:27,:)];
%forming test set
testset=[p1(28:30,:); p2(28:30,:); p3(28:30,:)];
%shuffling the set for efficiency
trainset=trainset(randperm(size(trainset,1)),:);

%learning rate
lrate=0.5;
%looping over the training set
for mu=1:27
    %calculating the output
    y=w'*trainset(mu,:)';
    %finding the max value
    maxofy=max(y);
    %finding the winner unit
    winner=find(y==maxofy);
    %output of the system
    outputtrain=(y==maxofy);
    %calculating the delta using the update rule
    delta=lrate*[trainset(mu,:)'-w(:,winner)];
    %preparing to plot the change
    toplot=[w(:,winner)'; (w(:,winner)+delta)'];
    %plotting the trajectories
    if winner==1
        plot3(toplot(:,1),toplot(:,2),toplot(:,3),'k-');
    elseif winner==2
        plot3(toplot(:,1),toplot(:,2),toplot(:,3),'m-');
    elseif winner==3
        plot3(toplot(:,1),toplot(:,2),toplot(:,3),'c-');
    end
    %updating the weights
    w(:,winner)=w(:,winner)+delta;
    
end
hold off;



%Trying the test set
class=zeros(9:1);
outputtest=[];
%looping over the test set
for i=1:9
   %calculating the output
   ytest=w'*testset(i,:)';
   %classifying the region
   class(i)= find(ytest==max(ytest));
   %recording the system output and the region information
   outputtest=[outputtest  [(ytest==max(ytest)); class(i)]];
end