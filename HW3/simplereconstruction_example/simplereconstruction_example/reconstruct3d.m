function reconpts = reconstruct3d(leftray,rightray,Rlr,tlr,Twl)
NN = size(leftray,2)
for i = 1:NN,
% triangulate in coordinate frame of left camera
% wrt_left = triangulate_midpoint(leftray(:,i),rightray(:,i),Rlr,tlr);
 wrt_left = triangulate_dlt(leftray(:,i),rightray(:,i),Rlr,tlr);
% convert to world coordinates
three_d_point = Twl*[wrt_left; 1];
reconpts(i,:) = three_d_point';
end;