function [x,y]=RandomInsideSphere(r)
for i=1:3
    x(i)=randsample(r*9000,1)/10000; %Randomply genereate three different value within the range o to the radius which has been put as an input
end

while(sqrt(sum(x.^2))>=r)            % If the initial distance from the center [0 0 0] is outside the sphere, re initialize another sample. 
    for i=1:3                        %Keep on doing this till the condistion is meet
        x(i)=randsample(r*9000,1)/10000;
    end
end
y=sqrt(sum(x.^2));
end