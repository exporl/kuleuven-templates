%%
% Vangjush Komini


close all
clear all
clc
%%
addpath FIELD_II_combined %add path to the toolbox

%%
eval('field_init(0)','1;')%Ensuring that field II has been called properly

%%
% DEFINITION OF THE 2D ARRAY PARAMETERS
Freq_Center=2.5e6;              %Central frequency of the tranducer [Hz]
Freq_Sampling=50e6;              %Sampling frequency [Hz]
SpeedOfSound=1540;              %Speed of sound [m/s]
Lambda=SpeedOfSound/Freq_Center;% Wavelength [m]
Heigth=0.3124/1000;             % Height of the tranducer crystal [m]
Width= 0.3125/1000;             % Width of element [m]
kerf_x=0;                       % Gap between tranducers along x direction [m]
kerf_y=0;                       % Gap between tranducers along x direction [m]
nr_ele_x=32;                    % Number of elementrs along x direction
nr_ele_y=32;                    % Number of elementrs along y direction


%%
% DEFINITION OF THE FOCAL POINT IN THE SPACE
%Arbitrary direction
% This angels needs to be changed for differet types of focusing
theta1=75/2; % Azimuth angle   [rad] 
phi1=75/2;   % Elevation angle [rad]

theta=pi/180*theta1; % Azimuth angle   [rad] 
phi=pi/180*phi1;   % Elevation angle [rad]
r=60e-3;           % Focal distance  [m]

%%
% ROTATION MATRIX FOR THE BEAM PROFILE
Point=[0,0,r]';                                                             % Spherical coordinate of the point (which will be rotated)
Rotate_y=[cos(-theta) 0 -sin(-theta);0 1 0;sin(-theta) 0 cos(-theta)];      % Rotation matrix along y direction
Rotate_x=[1 0 0;0 cos(phi) sin(phi);0 -sin(phi) cos(phi)];                  % Rotation matrix along x direction
Total_Rotation_Matrix=Rotate_x*Rotate_y;                                    % Rotation matrix for both directions
Rotate_Point=Total_Rotation_Matrix*Point;                                   % Rotated point


%%
% EXTRACTION OF THE SPHERICAL COORDINATE OF THE ROTATED POINT
Azimuth=Rotate_Point(1);                        % Azimuth angle
Elevation=Rotate_Point(1);                      % Elevation angle
Depth_focus=Rotate_Point(2);                    % Focal depth


Focus_point=[Azimuth Elevation Depth_focus];    % Initial focus coordinates [m]
Array_Size=nr_ele_x*Width;                       % Lenthg of an array [m]

%%
% GENERATION OF THE TRANSMIT APERTURE

% We could either choose the fully wired system of the partially wired
% array
% Enable=ones(nr_ele_x,nr_ele_y);                                                                     % Fully wired system
Enable=zeros(nr_ele_x,nr_ele_y);                                                                      % Fully wired system
for k=1:4:nr_ele_x
    for l=1:nr_ele_y
        Enable(k,l)=1;                                                                                % Wire only 1 after 3 consecutive elements
    end
end
figure
imagesc(Enable)
figure
Emit_Aperture=xdc_2d_array(nr_ele_x,nr_ele_y,Width,Heigth,kerf_x,kerf_y,Enable,1,1,Focus_point);

%%
% SET THE IMPULSE RESPONSE AND EXCITATION OF THE TRANSMIT APERTURE
BandWidth=0.6;                                             % Bandwidth of the pulse [Hz]
Time=-2/Freq_Center:1/Freq_Sampling:2/Freq_Center;         % Time spam of the pulse
Impulse=gauspuls(Time,Freq_Center,BandWidth);              % Impulse created

set_sampling(Freq_Sampling);                               % Set the sampling frequency of the system
xdc_impulse(Emit_Aperture,Impulse);                        % Setting the impulse response of an aperture

Ex_Periods=1.5;                                            % Excitation period
t_ex=(0:1/Freq_Sampling:Ex_Periods/Freq_Center);           % Time duration of the pulse
Excitation=square(2*pi*Freq_Center*t_ex);                  % Excitation wave form
xdc_excitation(Emit_Aperture,Excitation);                  % Set the exitation waveform in the field II simulation
%%
% DEFINITION OF THE APODIZATION FOR THE EMIT APERTURE
Number_Of_Elements=nr_ele_y*nr_ele_x;   % Number of elecments to be used
Element_Number=1:Number_Of_Elements;    % Indexing the total number of elements

load tuckey;                            % Loading the tuckey window function

Elements_on=nnz(Enable);                % Nomber of nonzero elements
Apodization_Mask=tuckey.*Enable;        % Production of the apodization mask
Apodization_Mask(Enable==0)=[];         % Removing the zero elements from the mask

%ATTENTION TIP
%Field 2 consider all the indexes as linear array thus we have to remove
%the off crystals and reshare accordingly to the set we define te in probe
%profile

Apodization_Emit=reshape(Apodization_Mask,1,Elements_on); % Reshaping the apodization window
xdc_apodization(Emit_Aperture,0,Apodization_Emit);        % Applying the apodization to the transmit aperture

%%
% EXTRACT THE DEFAULT DELAY MAP 
%Since field II computes the delay by default for a certain focus there is
%these delay values could be extracted 

Delay_Table=xdc_get(Emit_Aperture,'focus');
Delay_Table(1)=[];
% Delay_Time_Plot=reshape(Delay_Table,32,32);
% surf(Delay_Time_Plot);

%%
% DEFINING THE MEASUREMENT POINTS
X_Start=-100/1000;   % Start position of measument points in x direction [m]
X_End=100/1000;      % End position of measument points in x direction [m]

Y_Start=-100/1000;   % Start position of measument points in y direction [m]
Y_End=100/1000;      % End position of measument points in y direction [m]

Nr_Point_X=100;      % Number of points along x direction 
Nr_Point_Y=100;      % Number of points along y direction 

Nr_x=linspace(X_Start,X_End,Nr_Point_X)';  % Generation of number fo points along x direction
Nr_y=linspace(Y_Start,Y_End,Nr_Point_Y)';  % Generation of number fo points along y direction 
Nr_z=ones(Nr_Point_X*Nr_Point_Y,1);        % Generation of number fo points along z direction 

Nr_z=Nr_z*60/1000;                         % Defing the starting point along the Z direction
[X,Y]=meshgrid(Nr_x,Nr_y);                 % Meshing 3D coordinate system 
Plane_0060=[X(:),Y(:),Nr_z];               % Creating the measurement points

%%
% ROTATION OF THE PLANE FOR THE MEASUREMENT POINTS
Plane_0060_Rotated=(Total_Rotation_Matrix*Plane_0060')';                                           % Rotation of the measurement plane
Measurement_Points=[Plane_0060_Rotated(:,1),Plane_0060_Rotated(:,2),Plane_0060_Rotated(:,3)];   % Extracing the rotated coordinate for the measurment points

%%
% Calculation of the emit pressure
[Emitted_Pressure_Field,Start_Time]=calc_hp(Emit_Aperture,Measurement_Points);

%%
%Calculation of BP
Bp=sqrt(mean(Emitted_Pressure_Field.^2));  
Bp_Matrix=reshape(Bp,Nr_Point_Y,Nr_Point_X);  % Creat the matrix of the pressure field out of the linear data
Bp_Normalized=Bp_Matrix/max(Bp_Matrix(:));    % Normalize the pressure field

%%
% Hereby ploting of the profile pressure takes place
surf(Nr_x*1000,Nr_y*1000,20*log10(Bp_Normalized))
xlabel('Azimuth [mm]');
ylabel('elevation [mm]');
zlabel('pressure [dB]');
a=sprintf('Azimuth(theta)=%d, Elevation(phi)=%d',theta1,phi1);
title(a);
shading interp
colorbar
view (0,90)
caxis ([-55 0])











