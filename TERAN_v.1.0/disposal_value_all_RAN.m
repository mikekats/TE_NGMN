function disposal_value = disposal_value_all_RAN(sites,LR_network_cost)                              
%investment_cost_all_RAN Summary of this function goes here
%   Detailed explanation goes here

% Define and initialize struct (allocate memory) 
 [disposal_value]= temp_create_struct(sites);   


% RAN: site_development    
disposal_value.RAN_site_development = sum_of_technologies('RAN','site_development');

% RAN: site_equipment    
disposal_value.RAN_site_equipment = sum_of_technologies('RAN','site_equipment');

% RAN: basestations 
disposal_value.RAN_basestations = sum_of_technologies('RAN','basestations');

% RAN: controllers
disposal_value.RAN_controllers = sum_of_technologies('RAN','controllers');

% RAN: owned_transmission_lines
disposal_value.RAN_owned_transmission_lines = sum_of_technologies('RAN','owned_transmission_lines');

% RAN: other_tangible_fixed_asset  
disposal_value.RAN_other_tangible_fixed_asset = sum_of_technologies('RAN','other_tangible_fixed_asset');

% RAN_to_core: owned_transmission_lines
disposal_value.RANtoCORE_owned_transmission_lines = sum_of_technologies('RANtoCORE','owned_transmission_lines');

% RAN_to_core: other_tangible_fixed_asset
disposal_value.RANtoCORE_other_tangible_fixed_asset = sum_of_technologies('RANtoCORE','other_tangible_fixed_asset');

% core: PSnetwork_elements
disposal_value.CORE_PSnetwork_elements = sum_of_technologies('CORE','PSnetwork_elements');

% core: common_network_elements 
disposal_value.CORE_common_network_elements = sum_of_technologies('CORE','common_network_elements');

% core: owned_transmission_lines
disposal_value.CORE_owned_transmission_lines = sum_of_technologies('CORE','owned_transmission_lines');

% core: other_tangible_fixed_asset
disposal_value.CORE_other_tangible_fixed_asset = sum_of_technologies('CORE','other_tangible_fixed_asset');

% non_network_tangible_fixed_assets
disposal_value.non_network_tangible_fixed_assets = sum_of_technologies('non_network','tangible_fixed_assets');

% non_network_intangible_fixed_assets
disposal_value.non_network_intangible_fixed_assets= sum_of_technologies('non_network','intangible_fixed_assets');

      
    %**************************************************************************
    % Nested function
    %**************************************************************************
    
    function [disposal_value]= temp_create_struct(sites)     
    
    
       disposal_value = struct(...
                                'RAN_site_development',zeros(1,sites),...
                                'RAN_site_equipment',zeros(1,sites),...
                                'RAN_basestations',zeros(1,sites),...
                                'RAN_controllers',zeros(1,sites),...
                                'RAN_owned_transmission_lines',zeros(1,sites),...
                                'RAN_other_tangible_fixed_asset',zeros(1,sites),...
                                'RANtoCORE_owned_transmission_lines',zeros(1,sites),...
                                'RANtoCORE_other_tangible_fixed_asset',zeros(1,sites),...
                                'CORE_PSnetwork_elements',zeros(1,sites),...
                                'CORE_common_network_elements',zeros(1,sites),...
                                'CORE_owned_transmission_lines',zeros(1,sites),...
                                'CORE_other_tangible_fixed_asset',zeros(1,sites),...
                                'non_network_tangible_fixed_assets',zeros(1,sites),...
                                'non_network_intangible_fixed_assets',zeros(1,sites));          
    
    end

                                
    function temp_sum = sum_of_technologies(group,parameter)
        
        temp_sum =  cellfun(@(x) sum(x(:)),{LR_network_cost.EUTRAN_s.disposal_value_cell.(group).(parameter)})  +...        
                    cellfun(@(x) sum(x(:)),{LR_network_cost.EUTRAN_CA.disposal_value_cell.(group).(parameter)})  +...       
                    cellfun(@(x) sum(x(:)),{LR_network_cost.UTRAN_2100.disposal_value_cell.(group).(parameter)})  +...        
                    cellfun(@(x) sum(x(:)),{LR_network_cost.UTRAN_900.disposal_value_cell.(group).(parameter)})  +...
                    cellfun(@(x) sum(x(:)),{LR_network_cost.GERAN_900.disposal_value_cell.(group).(parameter)})  +...        
                    cellfun(@(x) sum(x(:)),{LR_network_cost.GERAN_1800.disposal_value_cell.(group).(parameter)});
                
    end



end

