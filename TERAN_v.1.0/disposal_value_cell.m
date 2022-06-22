function temp_struct_disposal = disposal_value_cell(sites,...
                                                    site_infrastructure,...
                                                    network_cost,...
                                                    network_information,...
                                                    temp_sites_to_remove_equip,...
                                                    inputs_finance,...
                                                    temp_future_year,...
                                                    temp_RAN,...
                                                    temp_RAN_spectrum,...
                                                    temp_sector,...
                                                    temp_RAN_spectrum_remove)
%disposal_value_cells Summary of this function goes here
%   Detailed explanation goes here


%Define and initialize struct (allocate memory) 
[RAN, RANtoCORE, CORE, non_network] = temp_create_struct_disposal_value(sites);

for i = 1:sites
    
    if network_information.(temp_RAN_spectrum).cells_per_site(i) ~= 0 
        
        temp_sectors_per_site = network_information.(temp_RAN_spectrum).cells_per_site(i);
      
        for s=1:temp_sectors_per_site

            if ismember(i,temp_sites_to_remove_equip) && strcmp(temp_RAN_spectrum_remove,temp_RAN_spectrum) % This site/sector is an investment site
                
                % RAN: site_development      
            	RAN(i).site_development(s) = calculate_disposal_value(network_cost.(temp_RAN_spectrum).fixed_asset_cost_cell.RAN(i).site_development(s),...
                                                                      inputs_finance.economic_asset_life.buildings_and_constructions,...
                                                                      site_infrastructure(i).development_year);                                             
                % RAN: site_equipment        
                RAN(i).site_equipment(s) = calculate_disposal_value(network_cost.(temp_RAN_spectrum).fixed_asset_cost_cell.RAN(i).site_equipment(s),...
                                                                    inputs_finance.economic_asset_life.buildings_and_constructions,...
                                                                    site_infrastructure(i).development_year);     

                % RAN: basestations 
                RAN(i).basestations(s) = calculate_disposal_value(network_cost.(temp_RAN_spectrum).fixed_asset_cost_cell.RAN(i).basestations(s),...
                                                                  inputs_finance.economic_asset_life.telecom_networks,...
                                                                  site_infrastructure(i).(temp_RAN).(temp_sector)(s).development_year); 

                % RAN: controllers
                RAN(i).controllers(s) = calculate_disposal_value(network_cost.(temp_RAN_spectrum).fixed_asset_cost_cell.RAN(i).controllers(s),...
                                                                 inputs_finance.economic_asset_life.telecom_networks,...
                                                                 site_infrastructure(i).development_year); 

                % RAN: owned_transmission_lines
                RAN(i).owned_transmission_lines(s) = calculate_disposal_value(network_cost.(temp_RAN_spectrum).fixed_asset_cost_cell.RAN(i).owned_transmission_lines(s),...
                                                                              inputs_finance.economic_asset_life.telecom_networks,...
                                                                              site_infrastructure(i).development_year); 
                            
                % RAN: other_tangible_fixed_asset   
                RAN(i).other_tangible_fixed_asset(s) = calculate_disposal_value(network_cost.(temp_RAN_spectrum).fixed_asset_cost_cell.RAN(i).other_tangible_fixed_asset(s),...
                                                                                inputs_finance.economic_asset_life.equipment_for_network_and_exchanges,...
                                                                                site_infrastructure(i).development_year); 


                % RAN_to_core: owned_transmission_lines                                                      
                RANtoCORE(i).owned_transmission_lines(s) = calculate_disposal_value(network_cost.(temp_RAN_spectrum).fixed_asset_cost_cell.RANtoCORE(i).owned_transmission_lines(s),...
                                                                                    inputs_finance.economic_asset_life.telecom_networks,...
                                                                                    site_infrastructure(i).development_year); 

                % RAN_to_core: other_tangible_fixed_asset
                RANtoCORE(i).other_tangible_fixed_asset(s) = calculate_disposal_value(network_cost.(temp_RAN_spectrum).fixed_asset_cost_cell.RANtoCORE(i).other_tangible_fixed_asset(s),...
                                                                                      inputs_finance.economic_asset_life.equipment_for_network_and_exchanges,...
                                                                                      site_infrastructure(i).development_year); 

                % core: PSnetwork_elements
                CORE(i).PSnetwork_elements(s) = calculate_disposal_value(network_cost.(temp_RAN_spectrum).fixed_asset_cost_cell.CORE(i).PSnetwork_elements(s),...
                                                                         inputs_finance.economic_asset_life.exchanges_and_concentrators,...
                                                                         site_infrastructure(i).(temp_RAN).(temp_sector)(s).development_year);
    
                % core: common_network_elements 
                CORE(i).common_network_elements(s)  = calculate_disposal_value(network_cost.(temp_RAN_spectrum).fixed_asset_cost_cell.CORE(i).common_network_elements(s),...
                                                                               inputs_finance.economic_asset_life.telecom_networks,...
                                                                               site_infrastructure(i).development_year);   

                % core: owned_transmission_lines
                CORE(i).owned_transmission_lines(s) = calculate_disposal_value(network_cost.(temp_RAN_spectrum).fixed_asset_cost_cell.CORE(i).owned_transmission_lines(s),...
                                                                               inputs_finance.economic_asset_life.telecom_networks,...
                                                                               site_infrastructure(i).development_year);   

                % core: other_tangible_fixed_asset
                CORE(i).other_tangible_fixed_asset(s) = calculate_disposal_value(network_cost.(temp_RAN_spectrum).fixed_asset_cost_cell.CORE(i).other_tangible_fixed_asset(s),...
                                                                                 inputs_finance.economic_asset_life.equipment_for_network_and_exchanges,...
                                                                                 site_infrastructure(i).development_year); 

                % non_network_tangible_fixed_assets
                non_network(i).tangible_fixed_assets(s) = calculate_disposal_value(network_cost.(temp_RAN_spectrum).fixed_asset_cost_cell.non_network(i).tangible_fixed_assets(s),...
                                                                                   inputs_finance.economic_asset_life.other_machinery_or_equipment,...
                                                                                   site_infrastructure(i).development_year); 

                % non_network_intangible_fixed_assets
                non_network(i).intangible_fixed_assets(s) = calculate_disposal_value(network_cost.(temp_RAN_spectrum).fixed_asset_cost_cell.non_network(i).intangible_fixed_assets(s),...
                                                                                     inputs_finance.economic_asset_life.other,...
                                                                                     site_infrastructure(i).development_year);    
                
            else
                RAN(i).site_development(s)=0;      
                RAN(i).site_equipment(s) = 0;
                RAN(i).basestations(s) = 0;
                RAN(i).controllers(s) = 0;
                RAN(i).owned_transmission_lines(s) = 0; 
                RAN(i).other_tangible_fixed_asset(s) = 0;                                                     
                RANtoCORE(i).owned_transmission_lines(s) = 0;
                RANtoCORE(i).other_tangible_fixed_asset(s) = 0;
                CORE(i).PSnetwork_elements(s) = 0;
                CORE(i).common_network_elements(s) = 0;    
                CORE(i).owned_transmission_lines(s) = 0;
                CORE(i).other_tangible_fixed_asset(s) = 0;
                non_network(i).tangible_fixed_assets(s) = 0;
                non_network(i).intangible_fixed_assets(s) = 0; 
            end

                                                               
        end
  
    end
    
end

temp_struct_disposal.RAN = RAN;
temp_struct_disposal.RANtoCORE = RANtoCORE;
temp_struct_disposal.CORE = CORE;
temp_struct_disposal.non_network = non_network;                

    %**************************************************************************
    % Nested functions
    %**************************************************************************
           
    
    function [RAN, RANtoCORE, CORE, non_network] = temp_create_struct_disposal_value(sites)  
       
        RAN(1,1:sites) = struct(...
                                'site_development',0,...
                                'site_equipment',0,...
                                'basestations',0,...
                                'controllers',0,...
                                'owned_transmission_lines',0,...
                                'other_tangible_fixed_asset',0);
        
        RANtoCORE(1,1:sites) = struct(...
                                'owned_transmission_lines',0,...
                                'other_tangible_fixed_asset',0);
                                                                        
        CORE(1,1:sites) = struct(...
                                'PSnetwork_elements',0,...
                                'common_network_elements',0,...
                                'owned_transmission_lines',0,...
                                'other_tangible_fixed_asset',0);
                            
        non_network(1,1:sites) = struct(...
                                'tangible_fixed_assets',0,...
                                'intangible_fixed_assets',0);         
                                
      
    end


    function [temp_asset_value] = calculate_disposal_value(temp_asset_cost, temp_asset_life, temp_development_year)
    % Straight line depreciation method
    % It gradually reduces the carrying value of a fixed asset over its useful life
    % Assuming zero salvage value
    
        temp_possesing_years = (temp_future_year - temp_development_year);    
        temp_depreciate_yes_or_no = temp_asset_life - temp_possesing_years;
  
        if temp_depreciate_yes_or_no > 0
            temp_depreciation_rate = 1 / temp_asset_life;
            temp_depreciation_annual = temp_asset_cost * temp_depreciation_rate; 
            temp_accumulated_depreciation = temp_depreciation_annual * temp_possesing_years;
        else
            temp_accumulated_depreciation = temp_asset_cost;
        end

        temp_asset_value = temp_asset_cost - temp_accumulated_depreciation;

    end


end








