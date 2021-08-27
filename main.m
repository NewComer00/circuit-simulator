% electrons possible position in x direction: 1,2,...,WIRE_LENGTH
% mat col number
WIRE_LENGTH = 500;
% electrons possible position in y direction: 1,2,...,WIRE_WIDTH
% mat row number
WIRE_WIDTH = 50;

% each row: start_x,end_x,resistance
% first row describes the wire resistance info
RESISTANCE_INFO = [0,0,0.1;100,200,0.6;];

ELECTRONS_NUM = 10;

FIELD_FACTOR = 1;
FIELD_DIRECTION = [-1,0];


time_stamp = 0;

electrons_pos = zeros(ELECTRONS_NUM, 2);
% x coordinates, col subscripts, start from 1
electrons_pos(:,1) = randi([1,WIRE_LENGTH], ELECTRONS_NUM, 1);
% y coordinates, row subscripts, start from 1
electrons_pos(:,2) = randi([1,WIRE_WIDTH], ELECTRONS_NUM, 1);

electrons_vel = zeros(ELECTRONS_NUM, 2);


resistance_map = RESISTANCE_INFO(1,3) * ones(WIRE_WIDTH, WIRE_LENGTH);
for res_info = RESISTANCE_INFO(2:end,:)'
	resistance_map(:,[res_info(1):res_info(2)]) = res_info(3);
end
imagesc(resistance_map)
title("resistance_map")
pause(0.5)


field_static = FIELD_FACTOR * FIELD_DIRECTION;

while true
	electrons_vel = electrons_vel + field_static;

	% randomly set some elec velocities into 0 based on the resistance
	elecs_pos_idx = sub2ind( ...
		size(resistance_map),electrons_pos(:,2),electrons_pos(:,1));
	res_elecs_on = resistance_map(elecs_pos_idx);
	electrons_vel(rand(ELECTRONS_NUM,1)<=res_elecs_on,:) = 0;

	electrons_pos = electrons_pos + electrons_vel;

	% the wire surfase is a doughnut
	electrons_pos(:,1) = mod(electrons_pos(:,1)-1, WIRE_LENGTH) + 1;
	electrons_pos(:,2) = mod(electrons_pos(:,2)-1, WIRE_WIDTH) + 1;

	time_stamp = time_stamp + 1;
	plot(electrons_pos(:,1), electrons_pos(:,2), 'o');
	axis([0,WIRE_LENGTH,0,WIRE_WIDTH]);
	pause(0.1)
end
