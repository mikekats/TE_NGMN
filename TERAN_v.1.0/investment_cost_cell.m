function temp_struct_investments = investment_cost_cell (sites,...
                                                        investment_cost,... 
                                                        site_infrastructure,...
                                                        LR_site_infrastructure,...
                                                        LR_network_information,...
                                                        temp_investment_sites,...
                                                        inputs_technology,...
                                                        LR_inputs_technology,...
                                                        LR_inputs_costs,...
                                                        temp_RAN,...
                                                        temp_RAN_spectrum,...
                                                        temp_sector,...
                                                        temp_RAN_spectrum_investment)
%investment_cost_cells Summary of this function goes here
%   Detailed explanation goes here


%Define and initialize struct (allocate memory) 
[RAN, RANtoCORE, CORE, non_network] = temp_create_struct_investment_cost(sites);

for i = 1:sites
    
    if LR_network_information.(temp_RAN_spectrum).cells_per_site(i) ~= 0 
        
        temp_sectors_per_site = LR_network_information.(temp_RAN_spectrum).cells_per_site(i);
      
        for s=1:temp_sectors_per_site

            if ismember(i,temp_investment_sites) && strcmp(temp_RAN_spectrum_investment,temp_RAN_spectrum) % This site/sector is an investment site
                
                % RAN: site_development      
                RAN(i).site_development(s) = LR_inputs_costs.investment.intangible_fixed_assets.development_cost_site_upgrade /...
                                                 LR_network_information.all_RAN.cells_per_site(i);

                % RAN: site_equipment        
                RAN(i).site_equipment(s) = 0;

                % RAN: basestations 
                RAN(i).basestations(s) = investment_cost / LR_inputs_technology.extra.default_sector_number;

                % RAN: controllers
                RAN(i).controllers(s) = 0;

                % RAN: owned_transmission_lines
                RAN(i).owned_transmission_lines(s) = 0;        

                % RAN: other_tangible_fixed_asset   
                RAN(i).other_tangible_fixed_asset(s) = 0;

                % RAN_to_core: owned_transmission_lines                                                      
                temp_owned_transmission_lines = site_infrastructure(i).transmission.owned_transmission_lines * ...
                                                site_infrastructure(i).(temp_RAN).(temp_sector)(s).cell_capacity_Mbps * ...
                                                (1+inputs_technology.extra.transmission_overhead);

                LR_temp_owned_transmission_lines = LR_site_infrastructure(i).transmission.owned_transmission_lines * ...
                                                   LR_site_infrastructure(i).(temp_RAN).(temp_sector)(s).cell_capacity_Mbps * ...
                                                   (1+LR_inputs_technology.extra.transmission_overhead);

                RANtoCORE(i).owned_transmission_lines(s) = max(0,(LR_temp_owned_transmission_lines-temp_owned_transmission_lines)) * ...
                                                     LR_inputs_costs.investment.RAN_to_core.owned_transmission_line;

                % RAN_to_core: other_tangible_fixed_asset
                RANtoCORE(i).other_tangible_fixed_asset(s) = 0;

                % core: PSnetwork_elements
                CORE(i).PSnetwork_elements(s) = 0;  

                % core: common_network_elements 
                CORE(i).common_network_elements(s) = 0;    

                % core: owned_transmission_lines
                CORE(i).owned_transmission_lines(s) = 0;

                % core: other_tangible_fixed_asset
                CORE(i).other_tangible_fixed_asset(s) = 0;

                % non_network_tangible_fixed_assets
                non_network(i).tangible_fixed_assets(s) = 0;

                % non_network_intangible_fixed_assets
                non_network(i).intangible_fixed_assets(s) = 0;         
            else
                RAN(i).site_development(s) = 0;      
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

temp_struct_investments.RAN = RAN;
temp_struct_investments.RANtoCORE = RANtoCORE;
temp_struct_investments.CORE = CORE;
temp_struct_investments.non_network = non_network;                  

    %**************************************************************************
    % Nested functions
    %**************************************************************************
           
    
    function [RAN, RANtoCORE, CORE, non_network] = temp_create_struct_investment_cost(sites)  
       
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

end
