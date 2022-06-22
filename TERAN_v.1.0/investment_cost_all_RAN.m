function investment_cost = investment_cost_all_RAN(sites,LR_network_cost)                              
%investment_cost_all_RAN Summary of this function goes here
%   Detailed explanation goes here

% Define and initialize struct (allocate memory) 
 [investment_cost]= temp_create_struct(sites);   


% RAN: site_development    
investment_cost.RAN_site_development = sum_of_technologies('RAN','site_development');

% RAN: site_equipment    
investment_cost.RAN_site_equipment = sum_of_technologies('RAN','site_equipment');

% RAN: basestations 
investment_cost.RAN_basestations = sum_of_technologies('RAN','basestations');

% RAN: controllers
investment_cost.RAN_controllers = sum_of_technologies('RAN','controllers');

% RAN: owned_transmission_lines
investment_cost.RAN_owned_transmission_lines = sum_of_technologies('RAN','owned_transmission_lines');

% RAN: other_tangible_fixed_asset  
investment_cost.RAN_other_tangible_fixed_asset = sum_of_technologies('RAN','other_tangible_fixed_asset');

% RAN_to_core: owned_transmission_lines
investment_cost.RANtoCORE_owned_transmission_lines = sum_of_technologies('RANtoCORE','owned_transmission_lines');

% RAN_to_core: other_tangible_fixed_asset
investment_cost.RANtoCORE_other_tangible_fixed_asset = sum_of_technologies('RANtoCORE','other_tangible_fixed_asset');

% core: PSnetwork_elements
investment_cost.CORE_PSnetwork_elements = sum_of_technologies('CORE','PSnetwork_elements');

% core: common_network_elements 
investment_cost.CORE_common_network_elements = sum_of_technologies('CORE','common_network_elements');

% core: owned_transmission_lines
investment_cost.CORE_owned_transmission_lines = sum_of_technologies('CORE','owned_transmission_lines');

% core: other_tangible_fixed_asset
investment_cost.CORE_other_tangible_fixed_asset = sum_of_technologies('CORE','other_tangible_fixed_asset');

% non_network_tangible_fixed_assets
investment_cost.non_network_tangible_fixed_assets = sum_of_technologies('non_network','tangible_fixed_assets');

% non_network_intangible_fixed_assets
investment_cost.non_network_intangible_fixed_assets= sum_of_technologies('non_network','intangible_fixed_assets');

      
    %**************************************************************************
    % Nested function
    %**************************************************************************
    
    function [investment_cost]= temp_create_struct(sites)     
    
    
       investment_cost = struct(...
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
        
        temp_sum =  cellfun(@(x) sum(x(:)),{LR_network_cost.EUTRAN_s.investment_cost_cell.(group).(parameter)})  +...        
                    cellfun(@(x) sum(x(:)),{LR_network_cost.EUTRAN_CA.investment_cost_cell.(group).(parameter)})  +...       
                    cellfun(@(x) sum(x(:)),{LR_network_cost.UTRAN_2100.investment_cost_cell.(group).(parameter)})  +...        
                    cellfun(@(x) sum(x(:)),{LR_network_cost.UTRAN_900.investment_cost_cell.(group).(parameter)})  +...
                    cellfun(@(x) sum(x(:)),{LR_network_cost.GERAN_900.investment_cost_cell.(group).(parameter)})  +...        
                    cellfun(@(x) sum(x(:)),{LR_network_cost.GERAN_1800.investment_cost_cell.(group).(parameter)});
                
    end



end

