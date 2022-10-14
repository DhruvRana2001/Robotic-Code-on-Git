function drawmyobject(pix);
xx = pix(:,1);
yy = pix(:,2);


% draw object as seen by right camera
line([xx(1) xx(2)], [yy(1) yy(2)]);
line([xx(2) xx(3)], [yy(2) yy(3)]);
line([xx(3) xx(4)], [yy(3) yy(4)]);
line([xx(4) xx(1)], [yy(4) yy(1)]);
line([xx(5) xx(6)], [yy(5) yy(6)]);
line([xx(6) xx(7)], [yy(6) yy(7)]);
line([xx(7) xx(8)], [yy(7) yy(8)]);
line([xx(8) xx(5)], [yy(8) yy(5)]);

line([xx(1) xx(5)], [yy(1) yy(5)]);
line([xx(2) xx(6)], [yy(2) yy(6)]);
line([xx(3) xx(7)], [yy(3) yy(7)]);
line([xx(4) xx(8)], [yy(4) yy(8)]);