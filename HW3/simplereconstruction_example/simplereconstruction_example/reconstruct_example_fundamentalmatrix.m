
% Demonstration of 3D Reconstruction Using a Simple Polygonal Object
% intrinsic param
K = [-100 0 200 ;
    0 -100 200 ;
    0 0 1];

% extrinsic camera parameters
Mextleft = [ 0.707 0.707 0 -3 ;-0.707 0.707 0 -0.5; 0 0  1 3];
Mextright = [ 0.866 -0.5 0 -3 ;0.5 0.866 0 -0.5; 0 0 1 3];

pts = [ 2 0 0 ;
  3 0 0;
  3 1 0;
  2 1 0;
  2 0 1 ;
  3 0 1;
  3 1 1;
  2 1 1;
  2.5 0.5 2];
%for i = 1:9,
 %   pts(i,:) = rand(1,3);
%end;
     
%pts = [ 0 0 0 ; 0 1 0; 1 1 0; -1 1 0;1 0 1 ;1 0 1;1 1 1;1 1 1;1.5 0.5 2];

NN = 9;
pix = zeros(NN,3);
for i = 1:NN,
    pixels = K*Mextleft * [pts(i,1) pts(i,2) pts(i,3) 1]';
    leftpix(i,:) = pixels./pixels(3);
    pixels = K*Mextright * [pts(i,1) pts(i,2) pts(i,3) 1]';
    rightpix(i,:) = pixels./pixels(3);
end
    
% rightpix and leftpix are the list of corresponding points (attainable by
% ginput also

figure(1);clf;
drawmyobject(leftpix); title('Left Image');
figure(2);clf;
drawmyobject(rightpix); title('Right Image');


%% From pixels to rays 

rightray = inv(K)*[rightpix(:,1) rightpix(:,2) rightpix(:,3)]';
leftray = inv(K)*[leftpix(:,1) leftpix(:,2) leftpix(:,3)]';


%% STEREO RECONSTRUCTION  With known camera matrices

Trw = [Mextright ; 0 0 0 1];
Tlw = [Mextleft; 0 0 0 1];
Twr = inv(Trw); % can be done using transpose
Twl = inv(Tlw); % can be done using transpose

Tlr = Tlw*Twr;
% Rotation from right to left coordinate frame 
Rlr = Tlr(1:3,1:3);
    % translation
tlr = Tlr(1:3,4);

reconpts = reconstruct3d(leftray,rightray,Rlr,tlr,Twl);

figure(3);clf;view(3)
drawmy3dobject(pts(:,1:3));title('Original 3D Points');

figure(4);clf;view(3)
drawmy3dobject(reconpts(:,1:3));title('Euclidian Reconstruction');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Now assume that no parameters are known and only point correspondences
% are given
% Reconstruct F from point correspondences.
% 
% Using the epipolar constraint between the point correspondences, F can be
% found


for i = 1:NN
tt=leftpix(i,:)' * rightpix(i,:); % 3 x3 matrix 
%form the matrix for Aq = 0, where q is 9x1 the elements of
A(i,:) = [tt(1,:) tt(2,:) tt(3,:)];
end;

[U,S,V] = svd(A);
lastcol = V(:,9);
F(1,1) = lastcol(1); F(1,2) = lastcol(2); F(1,3) = lastcol(3);
F(2,1) = lastcol(4); F(2,2) = lastcol(5); F(2,3) = lastcol(6);
F(3,1) = lastcol(7); F(3,2) = lastcol(8); F(3,3) = lastcol(9);

% Compare this to the built in call
%F = estimateFundamentalMatrix(rightpix(:,1:2),leftpix(:,1:2),'Method','Norm8Point');



% Get Camera Matrix From F
Ktemp = eye(3);
[U,S,V] = svd(F');
lastcol = V(:,3);
epipole = lastcol;
e1 = epipole(1);
e2 = epipole(2);
e3 = epipole(3);
ecross = [0 -e3 e2; e3 0 -e1; -e2 e1 0];
% camera matrix from F
cameramatrix = [ecross*F epipole];


% Reconstruct with triangulation
Rlr = cameramatrix(1:3,1:3);
tlr = cameramatrix(1:3,4); 

rightray_noK = [rightpix(:,1) rightpix(:,2) rightpix(:,3)]';
leftray_noK = [leftpix(:,1) leftpix(:,2) leftpix(:,3)]';
reconpts = reconstruct3d(leftray_noK,rightray_noK,Rlr,tlr,eye(4))
% Result is up to a projective transformation
figure(5);clf;view(3);
drawmy3dobject(reconpts(:,1:3));title('Reconstruction up to a Projective Transformation');
figure(6);clf;view(2);
drawmy3dobject(reconpts(:,1:3));title('Different View, Reconstruction up to a Projective Transformation');


%%%%%%%%% Find Essential Matrix
% Now assume you know K and find E.
E = K'*F*K;

% Get camera matrix from E , use standard method
W = [ 0 -1 0; 1 0 0 ; 0 0 1];
Z = [0 1 0; -1 0 0 ; 0 0 0];
[U,S,V] = svd(E); 
% four cases S1,R1 S2,R1  S1,R2  S2,R2
S1 = -U*Z*U';
S2 = U*Z*U';
R1 = U*W'*V';
R2 = U*W*V';

foundit = 0; % foundit flags that the +z reconstruction is found

%case 1
if (~foundit) 
    S = S1;R=R1;
    tlr= [ S(3,2) S(1,3) -S(1,2)]';
    reconpts = reconstruct3d(leftray,rightray,R,tlr,eye(4))
 if (min(reconpts(:,3))>0) foundit = 1;
    end
end

%case 2
if (~foundit) 
    S = S2;R=R1;
    tlr= [ S(3,2) S(1,3) -S(1,2)]';
    reconpts = reconstruct3d(leftray,rightray,R,tlr,eye(4))
    if (min(reconpts(:,3))>0) foundit = 1;
    end
end


%case 3
if (~foundit) 
    S = S1;R=R2;
    tlr= [ S(3,2) S(1,3) -S(1,2)]';
    reconpts = reconstruct3d(leftray,rightray,R,tlr,eye(4))
    if (min(reconpts(:,3))>0) foundit = 1;
    end
end


%case 4
if (~foundit) 
    S = S2;R=R2;
    tlr= [ S(3,2) S(1,3) -S(1,2)]';
    reconpts = reconstruct3d(leftray,rightray,R,tlr,eye(4))
   if (min(reconpts(:,3))>0) foundit = 1;
    end
end


figure(7);clf;view(3);
drawmy3dobject(reconpts(:,1:3));title('Reconstruction knowing only K');




