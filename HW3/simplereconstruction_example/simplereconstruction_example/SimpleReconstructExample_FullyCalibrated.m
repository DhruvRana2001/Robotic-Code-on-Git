{\rtf1\ansi\ansicpg1252\cocoartf2636
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 \
% Demonstration of 3D Reconstruction Using a Simple Polygonal Object\
% intrinsic param\
K = [-100 0 200 ;\
    0 -100 200 ;\
    0 0 1];\
\
% extrinsic camera parameters\
Mextleft = [ 0.707 0.707 0 -3 ;-0.707 0.707 0 -0.5; 0 0  1 3];\
Mextright = [ 0.866 -0.5 0 -3 ;0.5 0.866 0 -0.5; 0 0 1 3];\
\
pts = [ 2 0 0 ;\
  3 0 0;\
  3 1 0;\
  2 1 0;\
  2 0 1 ;\
  3 0 1;\
  3 1 1;\
  2 1 1;\
  2.5 0.5 2];\
%for i = 1:9,\
 %   pts(i,:) = rand(1,3);\
%end;\
     \
%pts = [ 0 0 0 ; 0 1 0; 1 1 0; -1 1 0;1 0 1 ;1 0 1;1 1 1;1 1 1;1.5 0.5 2];\
\
NN = 9;\
pix = zeros(NN,3);\
for i = 1:NN,\
    pixels = K*Mextleft * [pts(i,1) pts(i,2) pts(i,3) 1]';\
    leftpix(i,:) = pixels./pixels(3);\
    pixels = K*Mextright * [pts(i,1) pts(i,2) pts(i,3) 1]';\
    rightpix(i,:) = pixels./pixels(3);\
end\
    \
% rightpix and leftpix are the list of corresponding points (attainable by\
% ginput also\
\
figure(1);clf;\
drawmyobject(leftpix); title('Left Image');\
figure(2);clf;\
drawmyobject(rightpix); title('Right Image');\
\
\
%% From pixels to rays \
\
rightray = inv(K)*[rightpix(:,1) rightpix(:,2) rightpix(:,3)]';\
leftray = inv(K)*[leftpix(:,1) leftpix(:,2) leftpix(:,3)]';\
\
\
%% STEREO RECONSTRUCTION  With known camera matrices\
\
Trw = [Mextright ; 0 0 0 1];\
Tlw = [Mextleft; 0 0 0 1];\
Twr = inv(Trw); % can be done using transpose\
Twl = inv(Tlw); % can be done using transpose\
\
Tlr = Tlw*Twr;\
% Rotation from right to left coordinate frame \
Rlr = Tlr(1:3,1:3);\
    % translation\
tlr = Tlr(1:3,4);\
\
reconpts = reconstruct3d(leftray,rightray,Rlr,tlr,Twl);\
\
figure(3);clf;view(3)\
drawmy3dobject(pts(:,1:3));title('Original 3D Points');\
\
figure(4);clf;view(3)\
drawmy3dobject(reconpts(:,1:3));title('Euclidian Reconstruction');\
\
\
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%}