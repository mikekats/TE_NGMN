function [temp_cell_capacity] = cell_capacity_Mbps(BW, typical_BW_efficiency_bps_per_Hz)
%cell_capacity_Mbps calculates the typical cell capacity per RAN configuration
%   Detailed explanation goes here

temp_cell_capacity = ... % typical cell capacity, cell data rate (cell_capacity_Mbps)
                        BW.* 1000000 .* typical_BW_efficiency_bps_per_Hz./1024/1024;
temp_cell_capacity = num2cell(temp_cell_capacity);

end

