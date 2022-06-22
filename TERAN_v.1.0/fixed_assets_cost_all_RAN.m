function temp_struct = fixed_assets_cost_all_RAN(sites,network_cost)                              
%fixed_assets_cost_all_RAN Summary of this function goes here
%   Detailed explanation goes here

% Define and initialize struct (allocate memory) 
 [fixed_asset_cost,fixed_asset_depreciation,fixed_asset_value,...
                spectrum_cost,spectrum_amortization,spectrum_value]= temp_create_struct(sites);   


% RAN: site_development    
fixed_asset_cost.RAN_site_development = sum_of_technologies('RAN','site_development');
fixed_asset_depreciation.RAN_site_development  = sum_of_technologies('RAN_dep','site_development');
fixed_asset_value.RAN_site_development  =  sum_of_technologies('RAN_value','site_development');

% RAN: site_equipment    
fixed_asset_cost.RAN_site_equipment = sum_of_technologies('RAN','site_equipment');
fixed_asset_depreciation.RAN_site_equipment  = sum_of_technologies('RAN_dep','site_equipment');
fixed_asset_value.RAN_site_equipment  = sum_of_technologies('RAN_value','site_equipment');

% RAN: basestations 
fixed_asset_cost.RAN_basestations = sum_of_technologies('RAN','basestations');
fixed_asset_depreciation.RAN_basestations  = sum_of_technologies('RAN_dep','basestations');
fixed_asset_value.RAN_basestations  = sum_of_technologies('RAN_value','basestations');

% RAN: controllers
fixed_asset_cost.RAN_controllers = sum_of_technologies('RAN','controllers');
fixed_asset_depreciation.RAN_controllers  = sum_of_technologies('RAN_dep','controllers');
fixed_asset_value.RAN_controllers  = sum_of_technologies('RAN_value','controllers');

% RAN: owned_transmission_lines
fixed_asset_cost.RAN_owned_transmission_lines = sum_of_technologies('RAN','owned_transmission_lines');
fixed_asset_depreciation.RAN_owned_transmission_lines  = sum_of_technologies('RAN_dep','owned_transmission_lines');
fixed_asset_value.RAN_owned_transmission_lines  =  sum_of_technologies('RAN_value','owned_transmission_lines');

% RAN: other_tangible_fixed_asset  
fixed_asset_cost.RAN_other_tangible_fixed_asset = sum_of_technologies('RAN','other_tangible_fixed_asset');
fixed_asset_depreciation.RAN_other_tangible_fixed_asset  = sum_of_technologies('RAN_dep','other_tangible_fixed_asset');
fixed_asset_value.RAN_other_tangible_fixed_asset  =  sum_of_technologies('RAN_value','other_tangible_fixed_asset');

% RAN_to_core: owned_transmission_lines
fixed_asset_cost.RANtoCORE_owned_transmission_lines = sum_of_technologies('RANtoCORE','owned_transmission_lines');
fixed_asset_depreciation.RANtoCORE_owned_transmission_lines  = sum_of_technologies('RANtoCORE_dep','owned_transmission_lines');
fixed_asset_value.RANtoCORE_owned_transmission_lines  =  sum_of_technologies('RANtoCORE_value','owned_transmission_lines');

% RAN_to_core: other_tangible_fixed_asset
fixed_asset_cost.RANtoCORE_other_tangible_fixed_asset = sum_of_technologies('RANtoCORE','other_tangible_fixed_asset');
fixed_asset_depreciation.RANtoCORE_other_tangible_fixed_asset  = sum_of_technologies('RANtoCORE_dep','other_tangible_fixed_asset');
fixed_asset_value.RANtoCORE_other_tangible_fixed_asset  =  sum_of_technologies('RANtoCORE_value','other_tangible_fixed_asset');

% core: PSnetwork_elements
fixed_asset_cost.CORE_PSnetwork_elements = sum_of_technologies('CORE','PSnetwork_elements');
fixed_asset_depreciation.CORE_PSnetwork_elements  = sum_of_technologies('CORE_dep','PSnetwork_elements');
fixed_asset_value.CORE_PSnetwork_elements  =  sum_of_technologies('CORE_value','PSnetwork_elements');

% core: common_network_elements 
fixed_asset_cost.CORE_common_network_elements = sum_of_technologies('CORE','common_network_elements');
fixed_asset_depreciation.CORE_common_network_elements  = sum_of_technologies('CORE_dep','common_network_elements');
fixed_asset_value.CORE_common_network_elements  =  sum_of_technologies('CORE_value','common_network_elements');

% core: owned_transmission_lines
fixed_asset_cost.CORE_owned_transmission_lines = sum_of_technologies('CORE','owned_transmission_lines');
fixed_asset_depreciation.CORE_owned_transmission_lines  = sum_of_technologies('CORE_dep','owned_transmission_lines');
fixed_asset_value.CORE_owned_transmission_lines  =  sum_of_technologies('CORE_value','owned_transmission_lines');

% core: other_tangible_fixed_asset
fixed_asset_cost.CORE_other_tangible_fixed_asset = sum_of_technologies('CORE','other_tangible_fixed_asset');
fixed_asset_depreciation.CORE_other_tangible_fixed_asset  = sum_of_technologies('CORE_dep','other_tangible_fixed_asset');
fixed_asset_value.CORE_other_tangible_fixed_asset  =  sum_of_technologies('CORE_value','other_tangible_fixed_asset');

% non_network_tangible_fixed_assets
fixed_asset_cost.non_network_tangible_fixed_assets = sum_of_technologies('non_network','tangible_fixed_assets');
fixed_asset_depreciation.non_network_tangible_fixed_assets  = sum_of_technologies('non_network_dep','tangible_fixed_assets');
fixed_asset_value.non_network_tangible_fixed_assets  =  sum_of_technologies('non_network_value','tangible_fixed_assets');

% non_network_intangible_fixed_assets
fixed_asset_cost.non_network_intangible_fixed_assets= sum_of_technologies('non_network','intangible_fixed_assets');
fixed_asset_depreciation.non_network_intangible_fixed_assets  = sum_of_technologies('non_network_dep','intangible_fixed_assets');
fixed_asset_value.non_network_intangible_fixed_assets  =  sum_of_technologies('non_network_value','intangible_fixed_assets');

% spectrum
spectrum_cost.allocation = sum_of_technologies('spectrum','allocation');
spectrum_amortization.amortization = sum_of_technologies('spectrum_amort','amortization');
spectrum_value.value =  sum_of_technologies('spectrum_value','value');


temp_struct.fixed_asset_cost = fixed_asset_cost;
temp_struct.fixed_asset_depreciation = fixed_asset_depreciation;
temp_struct.fixed_asset_value = fixed_asset_value;
temp_struct.spectrum_cost = spectrum_cost;
temp_struct.spectrum_amortization = spectrum_amortization;
temp_struct.spectrum_value = spectrum_value;


      
    %**************************************************************************
    % Nested function
    %**************************************************************************
    
    function [fixed_asset_cost,fixed_asset_depreciation,fixed_asset_value,...
                spectrum_cost,spectrum_amortization,spectrum_value]= temp_create_struct(sites)     
    
    
       fixed_asset_cost = struct(...
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

       fixed_asset_depreciation = struct(...
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

       fixed_asset_value = struct(...
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

        spectrum_cost = struct('allocation',zeros(1,sites));   
        spectrum_amortization = struct('amortization',zeros(1,sites));
        spectrum_value = struct('value',zeros(1,sites));
   
    
    end

                                
    function temp_sum = sum_of_technologies(group,parameter)
        
        temp_sum =  cellfun(@(x) sum(x(:)),{network_cost.EUTRAN_s.fixed_asset_cost_cell.(group).(parameter)})  +...        
                    cellfun(@(x) sum(x(:)),{network_cost.EUTRAN_CA.fixed_asset_cost_cell.(group).(parameter)})  +...       
                    cellfun(@(x) sum(x(:)),{network_cost.UTRAN_2100.fixed_asset_cost_cell.(group).(parameter)})  +...        
                    cellfun(@(x) sum(x(:)),{network_cost.UTRAN_900.fixed_asset_cost_cell.(group).(parameter)})  +...
                    cellfun(@(x) sum(x(:)),{network_cost.GERAN_900.fixed_asset_cost_cell.(group).(parameter)})  +...        
                    cellfun(@(x) sum(x(:)),{network_cost.GERAN_1800.fixed_asset_cost_cell.(group).(parameter)});
                
    end



end

