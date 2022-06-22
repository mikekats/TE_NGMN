function [temp_cells] = number_of_cells(land_Area_km2, territory_coverage, cell_range_km)
%number_of_cells calculates the number of cells for each RAN configuration
%   Detailed explanation goes here

temp_cells = ... % number of cells in the region (cells)
                (land_Area_km2.*territory_coverage)./...
                (0.65*cell_range_km.^2);                               
temp_cells(isnan(temp_cells)) = 0;
temp_cells = num2cell(ceil(temp_cells));

end

