function [temp_bs_initial_position] = basestations_initial_position(Land_Area,R,basestations_number)

R = R(basestations_number>0)*1000; % meters
basestations_number = basestations_number(basestations_number>0);
x = [];
y = [];

area = sqrt(Land_Area)/2*[-1 1 -1 1]*1000; % meters
xmin = area(1);
xmax = area(2);
ymin = area(3);
ymax = area(4);

for i = 1:length(R)

    xNeg = 0:-1.5*R(i):xmin+R(i)/2; 
    xPos = 1.5*R(i):1.5*R(i):xmax-3*R(i)/4; 
    xlist = [fliplr(xNeg) xPos];

    yNeg = 0:-(3*sqrt(3)/4)*R(i):ymin+(sqrt(3)/2)*R(i)/2; 
    yPos = (3*sqrt(3)/4)*R(i):(3*sqrt(3)/4)*R(i):ymax-(sqrt(3)/2)*R(i)/2;
    ylist = [fliplr(yNeg) yPos];

    center_x = repmat(xlist,length(ylist),1);
    center_y = repmat(ylist,length(xlist),1)';
    
    [row, col]=find(center_x+center_y==0);
    center_x(row+1:2:end,:) = center_x(row+1:2:end,:)+0.75*R(i); % Shift every second row for positive y
    center_x(row-1:-2:1,:) = center_x(row-1:-2:1,:)+0.75*R(i); % Shift every second row for negative y
      
    f = find(xmin >= center_x(:) <= xmax); % find only the centers which are inside the defined area
    center_x = center_x(f); 
    center_y = center_y(f);
    
    f = find(ymin >= center_y(:) <= ymax); % find only the centers which are inside the defined area
    center_x = center_x(f); 
    center_y = center_y(f);
    
    % Remove basestations 
    remove_basestations = length(center_x) - basestations_number(i);

    if remove_basestations > 0;
         % first remove randomly cells from region borders
         A = [find(center_x>=xmax-3*R(i)/4)' find(center_x<=xmin+R(i)/2)'];
         B = [find(center_y>=ymax-sqrt(3)*R(i)/4)' find(center_y<=ymin+sqrt(3)*R(i)/4)'];
         C = union(A,B);
         index = randperm(length(C));

        if length(C)>=remove_basestations
            center_x(C(index(1:remove_basestations))) = [];
            center_y(C(index(1:remove_basestations))) = [];
        else
            center_x(C(index)) = [];
            center_y(C(index)) = [];
        end

        %then remove randomly from the region
        indices = randperm(length(center_x));
        indices = indices(1:basestations_number(i));
        center_x = center_x(indices);
        center_y = center_y(indices);
    end
    
    x = [x;center_x];
    y = [y;center_y];
end

temp_bs_initial_position = [x, y];

end

