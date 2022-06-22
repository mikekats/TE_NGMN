function [territory_coverage] = network_territory_coverage(land_Area_km2, cells, cell_range_km)
%number_of_cells calculates the number of cells for each RAN configuration
%   Detailed explanation goes here

territory_coverage = cells * (0.65*cell_range_km.^2) / land_Area_km2;   

end
