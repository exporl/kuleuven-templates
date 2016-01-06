function [B]=RotateDipole(A,x,y,z)

Rotate_y=[cos(-y) 0 -sin(-y);0 1 0;sin(-y) 0 cos(-y)];      % Rotation matrix along y direction
Rotate_x=[1 0 0;0 cos(x) sin(x);0 -sin(x) cos(x)];          % Rotation matrix along x direction
Rotate_z=[0 cos(z) -sin(z);sin(z) cos(z) 0;0 0  1];         % Rotation matrix along x direction
Total_Rotation_Matrix=Rotate_x*Rotate_y*Rotate_z;           % Rotation matrix for all directions
B=Total_Rotation_Matrix*A;                                  % Rotated point


end