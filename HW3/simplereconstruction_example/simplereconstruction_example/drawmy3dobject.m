function drawmy3dobject(pts);
xx = pts(:,1);
yy = pts(:,2);
zz = pts(:,3);

% draw object as seen by right camera
line([xx(1) xx(2)], [yy(1) yy(2)], [zz(1) zz(2)]);
line([xx(2) xx(3)], [yy(2) yy(3)], [zz(2) zz(3)]);
line([xx(3) xx(4)], [yy(3) yy(4)], [zz(3) zz(4)]);
line([xx(4) xx(1)], [yy(4) yy(1)], [zz(4) zz(1)]);
line([xx(5) xx(6)], [yy(5) yy(6)], [zz(5) zz(6)]);
line([xx(6) xx(7)], [yy(6) yy(7)], [zz(6) zz(7)]);
line([xx(7) xx(8)], [yy(7) yy(8)], [zz(7) zz(8)]);
line([xx(8) xx(5)], [yy(8) yy(5)], [zz(8) zz(5)]);


line([xx(1) xx(5)], [yy(1) yy(5)], [zz(1) zz(5)]);
line([xx(2) xx(6)], [yy(2) yy(6)], [zz(2) zz(6)]);
line([xx(3) xx(7)], [yy(3) yy(7)], [zz(3) zz(7)]);
line([xx(4) xx(8)], [yy(4) yy(8)], [zz(4) zz(8)]);