% MAX network throughput to investigate
% The network capacity based on the scenario 
temp_end_of_investments_total_capacity_Mbps = sum([LR_inputs_technology.EUTRAN_s.cells] .* [LR_inputs_technology.EUTRAN_s.cell_capacity_Mbps]) +...
                                              sum([LR_inputs_technology.EUTRAN_CA.cells] .* [LR_inputs_technology.EUTRAN_CA.cell_capacity_Mbps]) +...
                                              sum([LR_inputs_technology.UTRAN.cells] .* [LR_inputs_technology.UTRAN.cell_capacity_Mbps]) +...
                                              sum([LR_inputs_technology.GERAN.cells] .* [LR_inputs_technology.GERAN.cell_capacity_Mbps]);

LR_max_techlimit_throughput_Mbps_in_BH = temp_end_of_investments_total_capacity_Mbps; %DL Mbps in BH
LR_max_safe_throughput_Mbps_in_BH = LR_max_techlimit_throughput_Mbps_in_BH * (1-LR_inputs_technology.extra.caproom); 
LR_max_safe_throughput_Mbps = LR_max_safe_throughput_Mbps_in_BH/LR_inputs_market_industry.service.BHratio/24;

temp_traffic_incremental_increase = LR_max_safe_throughput_Mbps - network_information.all_RAN.total_throughput_Mbps;

temp_startloop = 0;
temp_endloop = temp_traffic_incremental_increase; 
temp_step =10;
temp_mobile_data_traffic_increace = temp_startloop:temp_step:temp_endloop; 


%*****************************EUTRAN_single********************************
network_throughput_progression.EUTRAN_s = cell_throughput_progression_Mbps(temp_mobile_data_traffic_increace,...
                                                                             network_information.EUTRAN_s.throughput_Mbps_per_cell,...
                                                                             network_information.all_RAN.throughput_Mbps_per_site);


%*****************************EUTRAN_CA************************************
network_throughput_progression.EUTRAN_CA = cell_throughput_progression_Mbps(temp_mobile_data_traffic_increace,...
                                                                             network_information.EUTRAN_CA.throughput_Mbps_per_cell,...
                                                                             network_information.all_RAN.throughput_Mbps_per_site);
 
%*****************************UTRAN***************************************

network_throughput_progression.UTRAN_2100  = cell_throughput_progression_Mbps(temp_mobile_data_traffic_increace,...
                                                                             network_information.UTRAN_2100.throughput_Mbps_per_cell,...
                                                                             network_information.all_RAN.throughput_Mbps_per_site);

network_throughput_progression.UTRAN_900 = cell_throughput_progression_Mbps(temp_mobile_data_traffic_increace,...
                                                                             network_information.UTRAN_900.throughput_Mbps_per_cell,...
                                                                             network_information.all_RAN.throughput_Mbps_per_site);
                                                                            
%*****************************GERAN***************************************
network_throughput_progression.GERAN_900 = cell_throughput_progression_Mbps(temp_mobile_data_traffic_increace,...
                                                                             network_information.GERAN_900.throughput_Mbps_per_cell,...
                                                                             network_information.all_RAN.throughput_Mbps_per_site);


network_throughput_progression.GERAN_1800 = cell_throughput_progression_Mbps(temp_mobile_data_traffic_increace,...
                                                                             network_information.GERAN_1800.throughput_Mbps_per_cell,...
                                                                             network_information.all_RAN.throughput_Mbps_per_site);


%*****************************all_RAN***************************************
network_throughput_progression.all_RAN.per_site = cell_throughput_progression_Mbps(temp_mobile_data_traffic_increace,...
                                                                                                network_information.all_RAN.throughput_Mbps_per_site,...
                                                                                                network_information.all_RAN.throughput_Mbps_per_site);
    
                                   
network_throughput_progression.all_RAN.traffic_increase = temp_mobile_data_traffic_increace;
network_throughput_progression.all_RAN.growth = (network_information.all_RAN.total_throughput_Mbps +  network_throughput_progression.all_RAN.traffic_increase)/...
                                                network_information.all_RAN.total_throughput_Mbps;

clear LR_max_safe_throughput_Mbps LR_max_safe_throughput_Mbps_in_BH LR_max_techlimit_throughput_Mbps_in_BH;
clear temp_end_of_investments_total_capacity_Mbps temp_endloop temp_mobile_data_traffic_increace temp_startloop temp_step temp_traffic_incremental_increase;                            