function temp_struct = extract_network_information_all_RAN(network_information,...
                                                           site_infrastructure,...
                                                           site_types,...
                                                           population,...
                                                           mobile_penetration,...
                                                           market_share,...
                                                           proportion_of_data_subs)
                                      
                                
%extract_network_information_all_RAN Summary of this function goes here
%   Detailed explanation goes here

% Define and initialize struct (allocate memory) 
temp_struct = temp_create_struct(length(site_infrastructure)); 


% configurations
temp_struct.configurations = concat_technologies('configurations');

% configuration_per_site
temp_struct.configuration_per_site = concat_technologies('configuration_per_site');

% bands_per_site
temp_struct.bands_per_site = concat_technologies('bands_per_site');

% BWs_per_site
temp_struct.BWs_per_site = concat_technologies('BWs_per_site');

% cells_per_site
temp_struct.cells_per_site =  sum_of_technologies('cells_per_site');

% cells
temp_struct.cells = sum(temp_struct.cells_per_site);

% basestations_per_site
temp_struct.basestations_per_site =  sum_of_technologies('basestations_per_site');

% basestations
temp_struct.basestations = sum(temp_struct.basestations_per_site);

% sites and types
temp_struct.sites = length(site_infrastructure);
count_site_equipment_type();

% data_subs and data_subs_per_site
[temp_data_users, temp_data_users_in_site] = find_data_users_in_site();
temp_struct.data_subs = temp_data_users; 
temp_struct.avrg_site_data_subs = temp_data_users_in_site;

% capacity_Mbps_per_site
temp_struct.capacity_Mbps_per_site =  sum_of_technologies('capacity_Mbps_per_site');

% total_capacity_Mbps
temp_struct.total_capacity_Mbps = sum(temp_struct.capacity_Mbps_per_site);

% avrg_cell_capacity_Mbps
temp_struct.avrg_cell_capacity_Mbps =  temp_struct.total_capacity_Mbps/temp_struct.cells;

% throughput_Mbps_per_site
temp_struct.throughput_Mbps_per_site =  sum_of_technologies('throughput_Mbps_per_site');

% throughput_Mbps_in_BH_per_site
temp_struct.throughput_Mbps_in_BH_per_site =  sum_of_technologies('throughput_Mbps_in_BH_per_site');

% max_safe_throughput_Mbps_per_site
temp_struct.max_safe_throughput_Mbps_per_site =  sum_of_technologies('max_safe_throughput_Mbps_per_site');

% max_safe_throughput_Mbps_in_BH_per_site
temp_struct.max_safe_throughput_Mbps_in_BH_per_site =  sum_of_technologies('max_safe_throughput_Mbps_in_BH_per_site');

% max_techlimit_throughput_Mbps_per_site
temp_struct.max_techlimit_throughput_Mbps_per_site =  sum_of_technologies('max_techlimit_throughput_Mbps_per_site');

% max_techlimit_throughput_Mbps_in_BH_per_site
temp_struct.max_techlimit_throughput_Mbps_in_BH_per_site =  sum_of_technologies('max_techlimit_throughput_Mbps_in_BH_per_site');

% total_throughput_Mbps
temp_struct.total_throughput_Mbps =  sum(temp_struct.throughput_Mbps_per_site);

% throughput_Mbps_in_BH
temp_struct.total_throughput_Mbps_in_BH =  sum(temp_struct.throughput_Mbps_in_BH_per_site);

% max_safe_throughput_Mbps
temp_struct.total_max_safe_throughput_Mbps =  sum(temp_struct.max_safe_throughput_Mbps_per_site);

% max_safe_throughput_Mbps_in_BH
temp_struct.total_max_safe_throughput_Mbps_in_BH =  sum(temp_struct.max_safe_throughput_Mbps_in_BH_per_site);

% max_techlimit_throughput_Mbps
temp_struct.total_max_techlimit_throughput_Mbps =  sum(temp_struct.max_techlimit_throughput_Mbps_per_site);

% max_techlimit_throughput_Mbps_in_BH
temp_struct.total_max_techlimit_throughput_Mbps_in_BH =  sum(temp_struct.max_techlimit_throughput_Mbps_in_BH_per_site);

% avrg_cell_throughput_Mbps
temp_struct.avrg_cell_throughput_Mbps =  temp_struct.total_throughput_Mbps/temp_struct.cells;

% avrg_cell_throughput_Mbps_in_BH
temp_struct.avrg_cell_throughput_Mbps_in_BH =  temp_struct.total_throughput_Mbps_in_BH/temp_struct.cells;

% avrg_cell_max_safe_throughput_Mbps
temp_struct.avrg_cell_max_safe_throughput_Mbps =  temp_struct.total_max_safe_throughput_Mbps/temp_struct.cells;

% current_load_per_site
temp_struct.current_load_per_site = temp_struct.throughput_Mbps_per_site ./ temp_struct.capacity_Mbps_per_site;

% current_load_per_site_in_BH
temp_struct.current_load_per_site_in_BH = temp_struct.throughput_Mbps_in_BH_per_site ./ temp_struct.capacity_Mbps_per_site; 

% avrg_cell_load
temp_struct.avrg_cell_load = temp_struct.avrg_cell_throughput_Mbps/temp_struct.avrg_cell_capacity_Mbps;

% avrg_cell_load_in_BH
temp_struct.avrg_cell_load_in_BH = temp_struct.avrg_cell_throughput_Mbps_in_BH/temp_struct.avrg_cell_capacity_Mbps;   
   
% mobile_data_traffic_from_zero_Mbps (define data traffic resolution for x-axis)
temp_struct.mobile_data_traffic_from_zero_Mbps = temp_define_traffic_resolution(temp_struct.total_max_techlimit_throughput_Mbps);

    %**************************************************************************
    % Nested function
    %**************************************************************************
  
        function temp_struct = temp_create_struct(sites)     
        temp_struct = struct(...
                            'configurations','',...
                            'configuration_per_site',{cell(1,sites)},...
                            'bands_per_site',{cell(1,sites)},...
                            'BWs_per_site',{cell(1,sites)},...
                            'cells_per_site',zeros(1,sites),...
                            'cells',0,...
                            'basestations_per_site',zeros(1,sites),...
                            'basestations',0,...
                            'TRx_per_BTS',zeros(1,sites),...
                            'TRx',0,...
                            'sites',0,...
                            'sites_owned_towers',0,...
                            'sites_owned_rooftops',0,...
                            'sites_rent_towers',0,...
                            'sites_rent_rooftops',0,...
                            'sites_shared_rent_towers',0,...
                            'sites_shared_rent_rooftops',0,...
                            'data_subs',0,...
                            'avrg_site_data_subs',zeros(1,sites),...
                            'capacity_Mbps_per_site',zeros(1,sites),...
                            'total_capacity_Mbps',0,...
                            'avrg_cell_capacity_Mbps',0,...
                            'throughput_Mbps_per_site',zeros(1,sites),...
                            'throughput_Mbps_in_BH_per_site',zeros(1,sites),...
                            'max_safe_throughput_Mbps_per_site',zeros(1,sites),...
                            'max_safe_throughput_Mbps_in_BH_per_site',zeros(1,sites),...
                            'max_techlimit_throughput_Mbps_per_site',zeros(1,sites),...
                            'max_techlimit_throughput_Mbps_in_BH_per_site',zeros(1,sites),...
                            'total_throughput_Mbps',0,...
                            'total_throughput_Mbps_in_BH',0,...
                            'total_max_safe_throughput_Mbps',0,...
                            'total_max_safe_throughput_Mbps_in_BH',0,...
                            'total_max_techlimit_throughput_Mbps',0,...
                            'total_max_techlimit_throughput_Mbps_in_BH',0,...
                            'avrg_cell_throughput_Mbps',0,...
                            'avrg_cell_throughput_Mbps_in_BH',0,...
                            'avrg_cell_max_safe_throughput_Mbps',0,...
                            'current_load_per_site',zeros(1,sites),...
                            'current_load_per_site_in_BH',zeros(1,sites),...
                            'avrg_cell_load',0,...
                            'avrg_cell_load_in_BH',0,...
                            'mobile_data_traffic_from_zero_Mbps',0);
        end

                                
    function temp_sum = sum_of_technologies(parameter)
        temp_sum =  network_information.EUTRAN_s.(parameter) +...
                    network_information.EUTRAN_CA.(parameter) +...
                    network_information.UTRAN_2100.(parameter) +...
                    network_information.UTRAN_900.(parameter) +...
                    network_information.GERAN_900.(parameter) + ...
                    network_information.GERAN_1800.(parameter);
    end


    function temp_concat = concat_technologies(parameter)
        temp_concat =  [network_information.EUTRAN_s.(parameter);
                        network_information.EUTRAN_CA.(parameter);
                        network_information.UTRAN_2100.(parameter);
                        network_information.UTRAN_900.(parameter);
                        network_information.GERAN_900.(parameter);
                        network_information.GERAN_1800.(parameter)];
                                                
    end

    function count_site_equipment_type()
    
        for i = 1: length(site_infrastructure)
            switch site_infrastructure(i).site_type
                case site_types(1).name
                    temp_struct.sites_owned_towers = temp_struct.sites_owned_towers + 1;
                case site_types(2).name
                    temp_struct.sites_owned_rooftops =  temp_struct.sites_owned_rooftops + 1;
                case site_types(3).name
                    temp_struct.sites_rent_towers = temp_struct.sites_rent_towers + 1;
                case site_types(4).name
                    temp_struct.sites_rent_rooftops =  temp_struct.sites_rent_rooftops + 1;
                case site_types(5).name
                    temp_struct.sites_shared_rent_towers = temp_struct.sites_shared_rent_towers +1;
                case site_types(6).name
                    temp_struct.sites_shared_rent_rooftops = temp_struct.sites_shared_rent_rooftops + 1;
            end  
        end
        
    end

   
    function [temp_data_users, temp_data_users_in_site] = find_data_users_in_site()
        % assumption: average number of data users in the site
        temp_data_users = population * ...
            mobile_penetration *...
            market_share * ...
            proportion_of_data_subs;
        
        temp_data_users_in_site = temp_data_users / length(site_infrastructure);
    end

    function temp_mobile_data_traffic = temp_define_traffic_resolution(mobile_data_traffic_end)
        
        temp_startloop = 0;
        temp_endloop = mobile_data_traffic_end; 
        temp_step =10;
        
        temp_mobile_data_traffic = temp_startloop:temp_step:temp_endloop; 

    end

end

