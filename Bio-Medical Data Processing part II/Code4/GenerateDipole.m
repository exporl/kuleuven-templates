function [R,d]=GenerateDipole(x,r)
R=zeros(x,6);                       % Initialization of the dipole data consistently to the dimesions
for i=1:x
    [y,d(i)]=RandomInsideSphere(r); % Generate randomly location coordinate of the dipole within the sphere where the radius is the smalles in the Head Modes
    for j=1:3   
        R(i,j)=y(j);                % Input data into the matrix
    end
    for j=1:3   
        x=randsample(1*1000,1)/1000;% Generate randomly the orientation of the dipole 
        R(i,j+3)=x;                 % Input data into the matrix
    end
end
end