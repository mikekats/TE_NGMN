function [temp_struct,temp_struct_energy_MWh]  = operating_cost_all_RAN(sites,network_cost,network_energy)                              
%operating_cost_all_RAN Summary of this function goes here
%   Detailed explanation goes here

% Define and initialize struct (allocate memory) 
[temp_struct,energy_RAN,energy_CORE]  = temp_create_struct(sites); 


% cost_of_good_sold: RAN_site_rental
temp_struct.cogs_RAN_site_rental = sum_of_technologies('cost_of_good_sold','RAN_site_rental');

% cost_of_good_sold: RAN_network_operation_maintenance  
temp_struct.cogs_RAN_network_operation_maintenance = sum_of_technologies('cost_of_good_sold','RAN_network_operation_maintenance');

% cost_of_good_sold: RAN energy_consumption 
temp_struct.cogs_RAN_fixed_energy_consumption = sum_of_technologies('cost_of_good_sold','RAN_fixed_energy_consumption');
temp_struct.cogs_RAN_current_variable_energy_consumption = sum_of_technologies('cost_of_good_sold','RAN_current_variable_energy_consumption');
temp_struct.cogs_RAN_variable_energy_consumption = sum_cell_of_technologies('cost_of_good_sold','RAN_variable_energy_consumption');

% cost_of_good_sold: RAN_leased_transmission_lines  
temp_struct.cogs_RAN_leased_transmission_lines = sum_of_technologies('cost_of_good_sold','RAN_leased_transmission_lines');

% cost_of_good_sold: RAN_personnel 
temp_struct.cogs_RAN_personnel = sum_of_technologies('cost_of_good_sold','RAN_personnel');

% cost_of_good_sold: RAN_other 
temp_struct.cogs_RAN_other = sum_of_technologies('cost_of_good_sold','RAN_other');

% cost_of_good_sold: RANtoCORE_leased_transmission_lines  
temp_struct.cogs_RANtoCORE_leased_transmission_lines = sum_of_technologies('cost_of_good_sold','RANtoCORE_leased_transmission_lines');

% cost_of_good_sold: RANtoCORE_other
temp_struct.cogs_RANtoCORE_other = sum_of_technologies('cost_of_good_sold','RANtoCORE_other');

% cost_of_good_sold: RANtoCORE_network_operation_maintenance   
temp_struct.cogs_RANtoCORE_network_operation_maintenance = sum_of_technologies('cost_of_good_sold','RANtoCORE_network_operation_maintenance');

% cost_of_good_sold: core energy_consumption 
temp_struct.cogs_CORE_fixed_energy_consumption = sum_of_technologies('cost_of_good_sold','CORE_fixed_energy_consumption');
temp_struct.cogs_CORE_current_variable_energy_consumption = sum_of_technologies('cost_of_good_sold','CORE_current_variable_energy_consumption');
temp_struct.cogs_CORE_variable_energy_consumption = sum_cell_of_technologies('cost_of_good_sold','CORE_variable_energy_consumption');

% cost_of_good_sold: CORE_personnel
temp_struct.cogs_CORE_personnel = sum_of_technologies('cost_of_good_sold','CORE_personnel');

% cost_of_good_sold: CORE_other 
temp_struct.cogs_CORE_other = sum_of_technologies('cost_of_good_sold','CORE_other');

% cost_of_good_sold: CORE_network_operation_maintenance          
temp_struct.cogs_CORE_network_operation_maintenance = sum_of_technologies('cost_of_good_sold','CORE_network_operation_maintenance');

% operating expenses: interconnection_and_other_fees
temp_struct.opex_interconnection_and_other_fees = sum_of_technologies('operating_expenses','interconnection_and_other_fees');

% Non-network operating expenses: selling_general_and_administrative
temp_struct.opex_selling_general_and_administrative = sum_of_technologies('operating_expenses','selling_general_and_administrative');

% energy_MWh: RAN energy_consumption 
energy_RAN.fixed_energy_consumption_MWh = sum_energy_of_technologies('energy_RAN','fixed_energy_consumption_MWh');
energy_RAN.current_variable_energy_consumption_MWh = sum_energy_of_technologies('energy_RAN','current_variable_energy_consumption_MWh');
energy_RAN.variable_energy_consumption_MWh = sum_cell_energy_of_technologies('energy_RAN','variable_energy_consumption_MWh');

% energy_MWh: core energy_consumption 
energy_CORE.fixed_energy_consumption_MWh = sum_energy_of_technologies('energy_CORE','fixed_energy_consumption_MWh');
energy_CORE.current_variable_energy_consumption_MWh = sum_energy_of_technologies('energy_CORE','current_variable_energy_consumption_MWh');
energy_CORE.variable_energy_consumption_MWh = sum_cell_energy_of_technologies('energy_CORE','variable_energy_consumption_MWh');

temp_struct_energy_MWh.energy_RAN = energy_RAN;
temp_struct_energy_MWh.energy_CORE = energy_CORE;

    %**************************************************************************
    % Nested function
    %**************************************************************************
    
    function [temp_struct,energy_RAN,energy_CORE] = temp_create_struct(sites)     

    temp_struct = struct(...
                        'cogs_RAN_site_rental',zeros(1,sites),...
                        'cogs_RAN_network_operation_maintenance',zeros(1,sites),...
                        'cogs_RAN_fixed_energy_consumption',zeros(1,sites),...
                        'cogs_RAN_current_variable_energy_consumption',zeros(1,sites),...
                        'cogs_RAN_variable_energy_consumption',{cell(1,sites)},...
                        'cogs_RAN_leased_transmission_lines',zeros(1,sites),...
                        'cogs_RAN_personnel',zeros(1,sites),...
                        'cogs_RAN_other',zeros(1,sites),...
                        'cogs_RANtoCORE_leased_transmission_lines',zeros(1,sites),...
                        'cogs_RANtoCORE_network_operation_maintenance',zeros(1,sites),...
                        'cogs_RANtoCORE_other',zeros(1,sites),...
                        'cogs_CORE_fixed_energy_consumption',zeros(1,sites),...
                        'cogs_CORE_current_variable_energy_consumption',zeros(1,sites),...
                        'cogs_CORE_variable_energy_consumption',{cell(1,sites)},...
                        'cogs_CORE_network_operation_maintenance',{cell(1,sites)},...
                        'cogs_CORE_personnel',zeros(1,sites),...
                        'cogs_CORE_other',zeros(1,sites),...
                        'opex_interconnection_and_other_fees',zeros(1,sites),...
                        'opex_selling_general_and_administrative',zeros(1,sites));
   
    
   energy_RAN = struct(...
                        'fixed_energy_consumption_MWh',zeros(1,sites),...
                        'variable_energy_consumption_MWh',{cell(1,sites)},...
                        'current_variable_energy_consumption_MWh',zeros(1,sites)); 
   
   energy_CORE = struct(...
                        'fixed_energy_consumption_MWh',zeros(1,sites),...
                        'variable_energy_consumption_MWh',{cell(1,sites)},...
                        'current_variable_energy_consumption_MWh',zeros(1,sites));    
    end

                                
    function temp_sum = sum_of_technologies(group,parameter)
        
        temp_sum =  cellfun(@(x) sum(x(:)),{network_cost.EUTRAN_s.operating_cost_cell.(group).(parameter)})  +...        
                    cellfun(@(x) sum(x(:)),{network_cost.EUTRAN_CA.operating_cost_cell.(group).(parameter)})  +...       
                    cellfun(@(x) sum(x(:)),{network_cost.UTRAN_2100.operating_cost_cell.(group).(parameter)})  +...        
                    cellfun(@(x) sum(x(:)),{network_cost.UTRAN_900.operating_cost_cell.(group).(parameter)})  +...
                    cellfun(@(x) sum(x(:)),{network_cost.GERAN_900.operating_cost_cell.(group).(parameter)})  +...        
                    cellfun(@(x) sum(x(:)),{network_cost.GERAN_1800.operating_cost_cell.(group).(parameter)});
                
    end

    function temp_sum_cell = sum_cell_of_technologies(group,parameter)  % cell is the data type here
        
        temp_sum_cell1 = cellfun(@(x) sum(cell2mat(x(:)),1),{network_cost.EUTRAN_s.operating_cost_cell.(group).(parameter)},'UniformOutput',0);      
        temp_sum_cell2 = cellfun(@(x) sum(cell2mat(x(:)),1),{network_cost.EUTRAN_CA.operating_cost_cell.(group).(parameter)},'UniformOutput',0);      
        temp_sum_cell3 = cellfun(@(x) sum(cell2mat(x(:)),1),{network_cost.UTRAN_2100.operating_cost_cell.(group).(parameter)},'UniformOutput',0);      
        temp_sum_cell4 = cellfun(@(x) sum(cell2mat(x(:)),1),{network_cost.UTRAN_900.operating_cost_cell.(group).(parameter)},'UniformOutput',0);
        temp_sum_cell5 = cellfun(@(x) sum(cell2mat(x(:)),1),{network_cost.GERAN_900.operating_cost_cell.(group).(parameter)},'UniformOutput',0);       
        temp_sum_cell6 = cellfun(@(x) sum(cell2mat(x(:)),1),{network_cost.GERAN_1800.operating_cost_cell.(group).(parameter)},'UniformOutput',0);

                                    
        temp_sum_cell1(cellfun(@isempty,temp_sum_cell1))={0};
        temp_sum_cell2(cellfun(@isempty,temp_sum_cell2))={0};
        temp_sum_cell3(cellfun(@isempty,temp_sum_cell3))={0};
        temp_sum_cell4(cellfun(@isempty,temp_sum_cell4))={0};
        temp_sum_cell5(cellfun(@isempty,temp_sum_cell5))={0};
        temp_sum_cell6(cellfun(@isempty,temp_sum_cell6))={0};
        
        temp_sum_cell =  cellfun(@(x1,x2,x3,x4,x5,x6) x1(:)'+x2(:)'+x3(:)'+x4(:)'+x5(:)'+x6(:)',...
                                temp_sum_cell1,temp_sum_cell2,temp_sum_cell3,temp_sum_cell4,temp_sum_cell5,temp_sum_cell6,...
                                'UniformOutput',0);
        
    end

    function temp_sum_energy = sum_energy_of_technologies(group,parameter)
        
        temp_sum_energy =  cellfun(@(x) sum(x(:)),{network_energy.EUTRAN_s.(group).(parameter)})  +...        
                    cellfun(@(x) sum(x(:)),{network_energy.EUTRAN_CA.(group).(parameter)})  +...       
                    cellfun(@(x) sum(x(:)),{network_energy.UTRAN_2100.(group).(parameter)})  +...        
                    cellfun(@(x) sum(x(:)),{network_energy.UTRAN_900.(group).(parameter)})  +...
                    cellfun(@(x) sum(x(:)),{network_energy.GERAN_900.(group).(parameter)})  +...        
                    cellfun(@(x) sum(x(:)),{network_energy.GERAN_1800.(group).(parameter)});
                
    end

    function temp_sum_cell_energy = sum_cell_energy_of_technologies(group,parameter)
        
        temp_sum_cell1 = cellfun(@(x) sum(cell2mat(x(:)),1),{network_energy.EUTRAN_s.(group).(parameter)},'UniformOutput',0);      
        temp_sum_cell2 = cellfun(@(x) sum(cell2mat(x(:)),1),{network_energy.EUTRAN_CA.(group).(parameter)},'UniformOutput',0);      
        temp_sum_cell3 = cellfun(@(x) sum(cell2mat(x(:)),1),{network_energy.UTRAN_2100.(group).(parameter)},'UniformOutput',0);      
        temp_sum_cell4 = cellfun(@(x) sum(cell2mat(x(:)),1),{network_energy.UTRAN_900.(group).(parameter)},'UniformOutput',0);
        temp_sum_cell5 = cellfun(@(x) sum(cell2mat(x(:)),1),{network_energy.GERAN_900.(group).(parameter)},'UniformOutput',0);       
        temp_sum_cell6 = cellfun(@(x) sum(cell2mat(x(:)),1),{network_energy.GERAN_1800.(group).(parameter)},'UniformOutput',0);

                                    
        temp_sum_cell1(cellfun(@isempty,temp_sum_cell1))={0};
        temp_sum_cell2(cellfun(@isempty,temp_sum_cell2))={0};
        temp_sum_cell3(cellfun(@isempty,temp_sum_cell3))={0};
        temp_sum_cell4(cellfun(@isempty,temp_sum_cell4))={0};
        temp_sum_cell5(cellfun(@isempty,temp_sum_cell5))={0};
        temp_sum_cell6(cellfun(@isempty,temp_sum_cell6))={0};
        
        temp_sum_cell_energy =  cellfun(@(x1,x2,x3,x4,x5,x6) x1(:)'+x2(:)'+x3(:)'+x4(:)'+x5(:)'+x6(:)',...
                                temp_sum_cell1,temp_sum_cell2,temp_sum_cell3,temp_sum_cell4,temp_sum_cell5,temp_sum_cell6,...
                                'UniformOutput',0);
        
    end

end

