% electrons possible position in x direction: 1,2,...,WIRE_LENGTH
% mat col number
WIRE_LENGTH = 500;
% electrons possible position in y direction: 1,2,...,WIRE_WIDTH
% mat row number
WIRE_WIDTH = 100;

% each row: start_x,end_x,resistance
% first row describes the wire resistance info
RESISTANCE_INFO = [0,0,0.01;
                   100,150,0.2;
                   200,300,0.4;
                   400,450,0.5];

ELECTRONS_NUM = 100;

FIELD_FACTOR = 1;
FIELD_DIRECTION = [-5,0];


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


field_static = FIELD_DIRECTION;
field_dynamic = zeros(ELECTRONS_NUM, 2);


while true
    for e = 1:ELECTRONS_NUM
        diff = electrons_pos([1:e-1,e+1:end],:) - electrons_pos(e,:);
        % TODO temporarily ignore all zero row vectors in diff
        diff(all(diff==0,2),:) = [];
        distance = sqrt(sum(diff.^2, 2));
        field_dynamic(e,:) = sum(diff./(distance.^3), 1);

    end
    field = round(field_static + FIELD_FACTOR * field_dynamic);
    electrons_vel = electrons_vel - field;

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

    imagesc(resistance_map);
    colormap(flipud(pink));
    caxis('manual');
    hold on;
    plot(electrons_pos(:,1), electrons_pos(:,2), '.');
    q = quiver(electrons_pos(:,1),electrons_pos(:,2), ...
        field(:,1),field(:,2));
    q.AutoScale = 0;
    axis([1,WIRE_LENGTH,1,WIRE_WIDTH]);
    axis equal;
    hold off;

    pause(0.05)
end
