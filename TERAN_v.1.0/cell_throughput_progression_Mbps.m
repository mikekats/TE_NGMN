function temp_traffic_incremental_increase_per_site = cell_throughput_progression_Mbps(temp_mobile_data_traffic_increace,...
                                                                                       throughput_Mbps_per_cell,...
                                                                                       allRAN_throughput_Mbps_per_site)
%cell_throughput_progression_Mbps Summary of this function goes here
%   Detailed explanation goes here


% Assumption: The traffic in a cell increases proportional to the current throughput  
% Traffic proportion per cell
temp_traffic_increase_ratio_per_cell = throughput_Mbps_per_cell /...
                                       sum(allRAN_throughput_Mbps_per_site);
                                   
                                  
% Traffic increace per cell   
temp_cells_throughout_progression3d = repmat(temp_traffic_increase_ratio_per_cell,[1 1 length(temp_mobile_data_traffic_increace)]);
temp_mobile_data_traffic_increace3d = reshape(temp_mobile_data_traffic_increace,1,1,length(temp_mobile_data_traffic_increace));
temp_traffic_incremental_increase_per_site =  bsxfun(@times,temp_cells_throughout_progression3d,temp_mobile_data_traffic_increace3d);

end

