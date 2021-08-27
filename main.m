WIRE_LENGTH = 500;  % x axis boundary
WIRE_WIDTH = 50;  % y axis boundary
WIRE_RESISTANCE = 0.1

RESISTOR_RANGE = [200,300];
RESISTOR_RESISTANCE = 0.6;

ELECTRONS_NUM = 100;

FIELD_FACTOR = 1;
FIELD_DIRECTION = [-1,0];


time_frame = 0;

electrons_pos = zeros(ELECTRONS_NUM, 2);
electrons_pos(:,1) = randi([0,WIRE_LENGTH], ELECTRONS_NUM, 1)  % x coordinates
electrons_pos(:,2) = randi([0,WIRE_WIDTH], ELECTRONS_NUM, 2)  % y coordinates

electrons_vel = zeros(ELECTRONS_NUM, 2);

resistance_map = WIRE_RESISTANCE*ones()

field_static = FIELD_FACTOR * FIELD_DIRECTION;

while true
	electrons_vel = electrons_vel + field_static;

	electrons_vel[rand(ELECTRONS_NUM,1)<=,:] = 0

	electrons_pos = electrons_pos + electrons_vel;
	% the wire surfase is a doughnut
end
