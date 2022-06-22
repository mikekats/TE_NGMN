function [temp_struct_operating_cost, temp_struct_energy] = operating_cost_cells(sites,... 
                                                                                site_infrastructure,...
                                                                                network_information,...
                                                                                inputs_technology,...
                                                                                inputs_costs,...
                                                                                temp_RAN,...
                                                                                temp_RAN_spectrum,...
                                                                                temp_sector)
%operating_cost_cells Summary of this function goes here
%   Detailed explanation goes here


%Define and initialize struct (allocate memory) 
[cost_of_good_sold, energy_RAN, energy_CORE, operating_expenses] = temp_create_struct_operating_cost(sites);


for i = 1:sites
    
    temp_site_rent = find_site_rent(site_infrastructure(i).site_type);
    
    if network_information.(temp_RAN_spectrum).cells_per_site(i) ~= 0 
        
        temp_sectors_per_site = network_information.(temp_RAN_spectrum).cells_per_site(i);

        for s=1:temp_sectors_per_site

                                                                               
        % cost_of_good_sold: RAN_site_rental      
            cost_of_good_sold(i).RAN_site_rental(s) = temp_site_rent *12 / network_information.all_RAN.cells_per_site(i);
            
            
        % cost_of_good_sold: RAN_leased_transmission_lines
            switch temp_RAN
                case {'UTRAN','GERAN'}
                    cost_of_good_sold(i).RAN_leased_transmission_lines(s) = site_infrastructure(i).transmission.leased_transmission_lines * ...
                                                                             site_infrastructure(i).(temp_RAN).(temp_sector)(s).cell_capacity_Mbps * ...
                                                                             (1+inputs_technology.extra.transmission_overhead) * ...
                                                                             inputs_costs.operating_cost.cost_of_good_sold.RAN_leased_transmission_lines_Mbps;
                otherwise
                    cost_of_good_sold(i).RAN_leased_transmission_lines(s) = 0;
            end   
            
                                               
        % cost_of_good_sold: RAN_personnel
            cost_of_good_sold(i).RAN_personnel(s) = inputs_technology.extra.RAN_labor *...
                                                    inputs_costs.operating_cost.cost_of_good_sold.personnel_mon*12 /...
                                                    sites  /...
                                                    network_information.all_RAN.cells_per_site(i);   
         
        % energy_MWh: RAN energy_consumption   
            temp_throughput_share =  site_infrastructure(i).(temp_RAN).(temp_sector)(s).cell_throughput_Mbps/network_information.all_RAN.total_throughput_Mbps;
            temp_throughput_over_any_traffic = network_information.all_RAN.mobile_data_traffic_from_zero_Mbps*temp_throughput_share; 
            temp_loadfactor_over_any_traffic = temp_throughput_over_any_traffic/site_infrastructure(i).(temp_RAN).(temp_sector)(s).cell_capacity_Mbps;                 
            temp_loadfactor_current_traffic = site_infrastructure(i).(temp_RAN).(temp_sector)(s).cell_throughput_Mbps/site_infrastructure(i).(temp_RAN).(temp_sector)(s).cell_capacity_Mbps;
            
            [temp_max_power_basestation, temp_share_of_max_power_in_idle_mode_basestation] = find_cell_power_parameters();
                
            [temp_energy_fixed,temp_energy_variable,temp_current_energy_variable] = energy_consumption_cell(temp_loadfactor_over_any_traffic,...
                                                                                                            temp_loadfactor_current_traffic,...
                                                                                                            temp_max_power_basestation,....
                                                                                                            temp_share_of_max_power_in_idle_mode_basestation,...
                                                                                                            temp_sectors_per_site);                                                                                                                                                     
            switch temp_RAN
                case {'UTRAN','GERAN'}
                    energy_RAN(i).fixed_energy_consumption_MWh(s) = temp_energy_fixed *...
                                                                        (1+inputs_technology.extra.RAN_controllers_energy_consumption_parameter);
                    
                    energy_RAN(i).variable_energy_consumption_MWh{s} = temp_energy_variable *...
                                                                       (1+inputs_technology.extra.RAN_controllers_energy_consumption_parameter);
                    
                    energy_RAN(i).current_variable_energy_consumption_MWh(s) = temp_current_energy_variable *...
                                                                               (1+inputs_technology.extra.RAN_controllers_energy_consumption_parameter);
                    
                otherwise
                    energy_RAN(i).fixed_energy_consumption_MWh(s) = temp_energy_fixed;
                    energy_RAN(i).variable_energy_consumption_MWh{s} = temp_energy_variable;
                    energy_RAN(i).current_variable_energy_consumption_MWh(s) = temp_current_energy_variable;
            end 
            
        % cost_of_good_sold: RAN energy_consumption 
            
            cost_of_good_sold(i).RAN_fixed_energy_consumption(s) = energy_RAN(i).fixed_energy_consumption_MWh(s) *...
                                                                   inputs_costs.operating_cost.cost_of_good_sold.energy_MWh;
            cost_of_good_sold(i).RAN_variable_energy_consumption{s} = energy_RAN(i).variable_energy_consumption_MWh{s} *...
                                                                    inputs_costs.operating_cost.cost_of_good_sold.energy_MWh;
            cost_of_good_sold(i).RAN_current_variable_energy_consumption(s) = energy_RAN(i).current_variable_energy_consumption_MWh(s) *...
                                                                               inputs_costs.operating_cost.cost_of_good_sold.energy_MWh;
                    
                                                                           
        % cost_of_good_sold: RAN_other  
            temp_cost_of_good_RAN = (cost_of_good_sold(i).RAN_site_rental(s) +...
                                     cost_of_good_sold(i).RAN_leased_transmission_lines(s)  +...
                                     cost_of_good_sold(i).RAN_personnel(s) +...
                                     cost_of_good_sold(i).RAN_fixed_energy_consumption(s) +...
                                     cost_of_good_sold(i).RAN_current_variable_energy_consumption(s)) / ...
                                    (1-(inputs_costs.operating_cost.cost_of_good_sold.RAN_other+inputs_costs.operating_cost.cost_of_good_sold.RAN_network_operation_maintenance));
            
            cost_of_good_sold(i).RAN_other(s) = temp_cost_of_good_RAN * inputs_costs.operating_cost.cost_of_good_sold.RAN_other;

        % cost_of_good_sold: RAN_network_operation_maintenance       
            cost_of_good_sold(i).RAN_network_operation_maintenance(s) = temp_cost_of_good_RAN * inputs_costs.operating_cost.cost_of_good_sold.RAN_network_operation_maintenance;                                                              
        
        
        % cost_of_good_sold: RANtoCORE_leased_transmission_lines
            cost_of_good_sold(i).RANtoCORE_leased_transmission_lines(s) = site_infrastructure(i).transmission.leased_transmission_lines * ...
                                                                       site_infrastructure(i).(temp_RAN).(temp_sector)(s).cell_capacity_Mbps *...
                                                                       (1+inputs_technology.extra.transmission_overhead) * ...
                                                                       inputs_costs.operating_cost.cost_of_good_sold.RANtoCORE_leased_transmission_lines_Mbps;

                                                                         
        % cost_of_good_sold: RANtoCORE_other
            temp_cost_of_good_RANtoCORE = (cost_of_good_sold(i).RANtoCORE_leased_transmission_lines(s)) / ...
                                (1-(inputs_costs.operating_cost.cost_of_good_sold.RANtoCORE_other+inputs_costs.operating_cost.cost_of_good_sold.RANtoCORE_network_operation_maintenance));

            cost_of_good_sold(i).RANtoCORE_other(s) = temp_cost_of_good_RANtoCORE * inputs_costs.operating_cost.cost_of_good_sold.RANtoCORE_other;

        % cost_of_good_sold: RANtoCORE_network_operation_maintenance
     
            cost_of_good_sold(i).RANtoCORE_network_operation_maintenance(s) = temp_cost_of_good_RANtoCORE *...
                                                                            inputs_costs.operating_cost.cost_of_good_sold.RANtoCORE_network_operation_maintenance;                                                              
        
        
                                                                                                                                  
        % energy_MWh: core energy_consumption 
            
            energy_CORE(i).fixed_energy_consumption_MWh(s) = energy_RAN(i).fixed_energy_consumption_MWh(s) *...
                                                                 inputs_technology.extra.core_energy_consumption_parameter;
            energy_CORE(i).variable_energy_consumption_MWh{s} = energy_RAN(i).variable_energy_consumption_MWh{s} * ...
                                                                    inputs_technology.extra.core_energy_consumption_parameter;           
            energy_CORE(i).current_variable_energy_consumption_MWh(s) = energy_RAN(i).current_variable_energy_consumption_MWh(s) * ...
                                                                            inputs_technology.extra.core_energy_consumption_parameter; 
        
        % cost_of_good_sold: core energy_consumption   
       
            cost_of_good_sold(i).CORE_fixed_energy_consumption(s) = energy_CORE(i).fixed_energy_consumption_MWh(s) *...
                                                                    inputs_costs.operating_cost.cost_of_good_sold.energy_MWh;
            cost_of_good_sold(i).CORE_variable_energy_consumption{s} = energy_CORE(i).variable_energy_consumption_MWh{s} *...
                                                                       inputs_costs.operating_cost.cost_of_good_sold.energy_MWh;
            cost_of_good_sold(i).CORE_current_variable_energy_consumption(s) = energy_CORE(i).current_variable_energy_consumption_MWh(s) *...
                                                                               inputs_costs.operating_cost.cost_of_good_sold.energy_MWh;
             
                                                                           
        % cost_of_good_sold: CORE_personnel
            cost_of_good_sold(i).CORE_personnel(s) = inputs_technology.extra.CORE_labor *...
                                                    inputs_costs.operating_cost.cost_of_good_sold.personnel_mon*12 /...
                                                    sites  /...
                                                    network_information.all_RAN.cells_per_site(i); 
                                                
        % cost_of_good_sold: CORE_other  
            temp_cost_of_good_CORE = (cost_of_good_sold(i).CORE_fixed_energy_consumption(s) +...
                                      cost_of_good_sold(i).CORE_current_variable_energy_consumption(s) +...
                                      cost_of_good_sold(i).CORE_personnel(s)) / ...
                                 (1-(inputs_costs.operating_cost.cost_of_good_sold.CORE_other+inputs_costs.operating_cost.cost_of_good_sold.CORE_network_operation_maintenance));
            
            cost_of_good_sold(i).CORE_other(s) = temp_cost_of_good_CORE * inputs_costs.operating_cost.cost_of_good_sold.CORE_other;
    
        % cost_of_good_sold: CORE_network_operation_maintenance          
             cost_of_good_sold(i).CORE_network_operation_maintenance(s) = temp_cost_of_good_CORE *...
                                                                            inputs_costs.operating_cost.cost_of_good_sold.CORE_network_operation_maintenance;                                                              
        
        

        % operating expenses: interconnection_and_other_fees
            temp_operating_cost = cost_of_good_sold(i).RAN_site_rental(s) +...
                                  cost_of_good_sold(i).RAN_leased_transmission_lines(s)  +...
                                  cost_of_good_sold(i).RAN_personnel(s) +...
                                  cost_of_good_sold(i).RAN_fixed_energy_consumption(s) +...
                                  cost_of_good_sold(i).RAN_current_variable_energy_consumption(s) +...
                                  cost_of_good_sold(i).RAN_other(s) +...
                                  cost_of_good_sold(i).RAN_network_operation_maintenance(s) +...
                                  cost_of_good_sold(i).RANtoCORE_leased_transmission_lines(s) +...
                                  cost_of_good_sold(i).RANtoCORE_other(s) +...
                                  cost_of_good_sold(i).RANtoCORE_network_operation_maintenance(s) +...
                                  cost_of_good_sold(i).CORE_personnel(s) +...
                                  cost_of_good_sold(i).CORE_other(s) +...
                                  cost_of_good_sold(i).CORE_network_operation_maintenance(s) +...
                                  cost_of_good_sold(i).CORE_fixed_energy_consumption(s) +...
                                  cost_of_good_sold(i).CORE_current_variable_energy_consumption(s);
                                                     
            operating_expenses(i).interconnection_and_other_fees(s) = temp_operating_cost * inputs_costs.operating_cost.interconnection_and_other_fees;
                
        % Non-network operating expenses: selling_general_and_administrative
            operating_expenses(i).selling_general_and_administrative(s) = temp_operating_cost * inputs_costs.operating_cost.selling_general_and_administrative.other;
            
        end
  
    end
    
end

temp_struct_operating_cost.cost_of_good_sold = cost_of_good_sold;
temp_struct_operating_cost.operating_expenses = operating_expenses;
temp_struct_energy.energy_RAN = energy_RAN;
temp_struct_energy.energy_CORE = energy_CORE;

    %**************************************************************************
    % Nested functions
    %**************************************************************************
           
    
    function [cost_of_good_sold, energy_RAN, energy_CORE, operating_expenses] = temp_create_struct_operating_cost(sites)  
       
        cost_of_good_sold(1,1:sites) = struct(...
                                            'RAN_site_rental',0,...
                                            'RAN_network_operation_maintenance',0,...
                                            'RAN_fixed_energy_consumption',0,...
                                            'RAN_current_variable_energy_consumption',0,...
                                            'RAN_variable_energy_consumption',cell(1),...
                                            'RAN_leased_transmission_lines',0,...
                                            'RAN_personnel',0,...
                                            'RAN_other',0,...
                                            'RANtoCORE_leased_transmission_lines',0,...
                                            'RANtoCORE_network_operation_maintenance',0,...
                                            'RANtoCORE_other',0,...
                                            'CORE_fixed_energy_consumption',0,...
                                            'CORE_current_variable_energy_consumption',0,...
                                            'CORE_variable_energy_consumption',cell(1),...
                                            'CORE_network_operation_maintenance',0,...
                                            'CORE_personnel',0,...
                                            'CORE_other',0);
     
        energy_RAN(1,1:sites) = struct(...
                                            'fixed_energy_consumption_MWh',0,...
                                            'variable_energy_consumption_MWh',cell(1),...
                                            'current_variable_energy_consumption_MWh',0);
      
        energy_CORE(1,1:sites) = struct(...
                                            'fixed_energy_consumption_MWh',0,...
                                            'variable_energy_consumption_MWh',cell(1),...
                                            'current_variable_energy_consumption_MWh',0);
                                        
        operating_expenses(1,1:sites) = struct(...
                                            'interconnection_and_other_fees',0,...
                                            'selling_general_and_administrative',0);
    end


    function temp_site_rent = find_site_rent(site_type)
        
        switch site_type
            case inputs_technology.site_types(1).name
                temp_site_rent = 0;
            case inputs_technology.site_types(2).name
                temp_site_rent = 0;
            case inputs_technology.site_types(3).name
                temp_site_rent = inputs_costs.operating_cost.cost_of_good_sold.site_rental_tower_mon;
            case inputs_technology.site_types(4).name
                temp_site_rent = inputs_costs.operating_cost.cost_of_good_sold.site_rental_rooftop_mon;
            case inputs_technology.site_types(5).name
                temp_site_rent = inputs_costs.operating_cost.cost_of_good_sold.site_rental_shared_tower_mon;
            case inputs_technology.site_types(6).name
                temp_site_rent = inputs_costs.operating_cost.cost_of_good_sold.site_rental_shared_rooftop_mon;
        end  
        
    end


    function [temp_max_power_basestation, temp_share_of_max_power_in_idle_mode_basestation] = find_cell_power_parameters()
         
        temp_max_power_basestation_cell_array = {inputs_technology.(temp_RAN).max_power_basestation};
        temp_share_of_max_power_cell_array = {inputs_technology.(temp_RAN).share_of_max_power_in_idle_mode_basestation};

        temp_index_cell_array = find(strcmp({inputs_technology.(temp_RAN).configuration},site_infrastructure(i).(temp_RAN).(temp_sector)(s).configuration));
        
        temp_max_power_basestation = temp_max_power_basestation_cell_array{temp_index_cell_array};
        temp_share_of_max_power_in_idle_mode_basestation = temp_share_of_max_power_cell_array{temp_index_cell_array};  
        
    end


    function [temp_energy_fixed,temp_energy_variable, temp_current_energy_variable] = energy_consumption_cell(temp_loadfactor_over_any_traffic, temp_loadfactor_current_traffic, temp_max_power_basestation, temp_share_of_max_power_in_idle_mode_basestation,temp_sectors_per_site) 
        
        temp_cell_maximum_power = (temp_max_power_basestation/inputs_technology.extra.default_sector_number)*temp_sectors_per_site;
        temp_power_fixed = temp_cell_maximum_power*temp_share_of_max_power_in_idle_mode_basestation;

        temp_power_variable =  (temp_cell_maximum_power-temp_power_fixed).*temp_loadfactor_over_any_traffic;
        temp_current_power_variable = (temp_cell_maximum_power-temp_power_fixed)*temp_loadfactor_current_traffic;
        
        temp_energy_fixed = temp_power_fixed*24*30*12/1000/1000;
        temp_energy_variable = temp_power_variable*24*30*12/1000/1000;
        temp_current_energy_variable = temp_current_power_variable*24*30*12/1000/1000;
    end

end

