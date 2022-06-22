%**************************************************************************
% Part 1: Investment costs (Installed/upgraded equipment)
%**************************************************************************

temp_RAN_spectrum_investment = 'EUTRAN_CA';

% Cost-level 1: Investment per cell (per site per technology)
%*****************************EUTRAN_single********************************
LR_network_cost.EUTRAN_s.investment_cost_cell = investment_cost_cell(length(LR_site_infrastructure),...
                                                                  LR_inputs_costs.investment.RAN.basestation_eNodeB_CA_upgrade,...
                                                                  site_infrastructure,...
                                                                  LR_site_infrastructure,...
                                                                  LR_network_information,...
                                                                  LR_network_information_growth_snapshot.critical_sites.investment_sites,...
                                                                  inputs_technology,...
                                                                  LR_inputs_technology,...
                                                                  LR_inputs_costs,...
                                                                  'EUTRAN_s',...
                                                                  'EUTRAN_s',...
                                                                  'sector',...
                                                                  temp_RAN_spectrum_investment);
                                                    
%********************************EUTRAN_CA*********************************
LR_network_cost.EUTRAN_CA.investment_cost_cell = investment_cost_cell(length(LR_site_infrastructure),...
                                                                   LR_inputs_costs.investment.RAN.basestation_eNodeB_CA_upgrade,...
                                                                   site_infrastructure,...
                                                                   LR_site_infrastructure,...
                                                                   LR_network_information,...
                                                                   LR_network_information_growth_snapshot.critical_sites.investment_sites,...
                                                                   inputs_technology,...
                                                                   LR_inputs_technology,...
                                                                   LR_inputs_costs,...
                                                                   'EUTRAN_CA',...
                                                                   'EUTRAN_CA',...
                                                                   'sector',...
                                                                   temp_RAN_spectrum_investment);

%*********************************UTRAN************************************
LR_network_cost.UTRAN_2100.investment_cost_cell = investment_cost_cell(length(LR_site_infrastructure),...
                                                                    LR_inputs_costs.investment.RAN.basestation_eNodeB_CA_upgrade,...
                                                                    site_infrastructure,...
                                                                    LR_site_infrastructure,...
                                                                    LR_network_information,...
                                                                    LR_network_information_growth_snapshot.critical_sites.investment_sites,...
                                                                    inputs_technology,...
                                                                    LR_inputs_technology,...
                                                                    LR_inputs_costs,...
                                                                   'UTRAN',...
                                                                   'UTRAN_2100',...
                                                                   'sector2100',...
                                                                    temp_RAN_spectrum_investment); 

LR_network_cost.UTRAN_900.investment_cost_cell = investment_cost_cell(length(LR_site_infrastructure),...
                                                                    LR_inputs_costs.investment.RAN.basestation_eNodeB_CA_upgrade,...
                                                                    site_infrastructure,...
                                                                    LR_site_infrastructure,...
                                                                    LR_network_information,...
                                                                    LR_network_information_growth_snapshot.critical_sites.investment_sites,...
                                                                    inputs_technology,...
                                                                    LR_inputs_technology,...
                                                                    LR_inputs_costs,...
                                                                    'UTRAN',...
                                                                    'UTRAN_900',...
                                                                    'sector900',...
                                                                    temp_RAN_spectrum_investment); 

%**********************************GERAN***********************************   
LR_network_cost.GERAN_900.investment_cost_cell = investment_cost_cell(length(LR_site_infrastructure),...
                                                                    LR_inputs_costs.investment.RAN.basestation_eNodeB_CA_upgrade,...
                                                                    site_infrastructure,...
                                                                    LR_site_infrastructure,...
                                                                    LR_network_information,...
                                                                    LR_network_information_growth_snapshot.critical_sites.investment_sites,...
                                                                    inputs_technology,...
                                                                    LR_inputs_technology,...
                                                                    LR_inputs_costs,...
                                                                    'GERAN',...
                                                                    'GERAN_900',...
                                                                    'sector900',...
                                                                    temp_RAN_spectrum_investment); 

LR_network_cost.GERAN_1800.investment_cost_cell =  investment_cost_cell(length(LR_site_infrastructure),...
                                                                    LR_inputs_costs.investment.RAN.basestation_eNodeB_CA_upgrade,...
                                                                    site_infrastructure,...
                                                                    LR_site_infrastructure,...
                                                                    LR_network_information,...
                                                                    LR_network_information_growth_snapshot.critical_sites.investment_sites,...
                                                                    inputs_technology,...
                                                                    LR_inputs_technology,...
                                                                    LR_inputs_costs,...
                                                                    'GERAN',...
                                                                    'GERAN_1800',...
                                                                    'sector1800',...
                                                                    temp_RAN_spectrum_investment);
                                                                                                                                                                                                                
% Cost-level 2: Investment Cost per site                                                  
%**********************************All_RANs********************************* 
LR_network_cost.all_RAN.investment_cost  = investment_cost_all_RAN(length(LR_site_infrastructure),LR_network_cost);                 


%**************************************************************************
% Part 2: Disposal value (Unistalled equipment)
%**************************************************************************
% Gain on disposal of removed equipment

temp_RAN_spectrum_remove = 'UTRAN_2100';

% Cost-level 1: Investment per cell (per site per technology)
%*****************************EUTRAN_single********************************
LR_network_cost.EUTRAN_s.disposal_value_cell = disposal_value_cell(length(LR_site_infrastructure),...
                                                                  site_infrastructure,...
                                                                  network_cost,...
                                                                  network_information,...
                                                                  LR_network_information_growth_snapshot.critical_sites.sites_to_remove_equip,...
                                                                  inputs_finance,...
                                                                  LR_inputs_finance.current_year,...
                                                                  'EUTRAN_s',...
                                                                  'EUTRAN_s',...
                                                                  'sector',...
                                                                  temp_RAN_spectrum_remove);
      
%********************************EUTRAN_CA*********************************
LR_network_cost.EUTRAN_CA.disposal_value_cell = disposal_value_cell(length(LR_site_infrastructure),...
                                                                    site_infrastructure,...
                                                                    network_cost,...
                                                                    network_information,...
                                                                    LR_network_information_growth_snapshot.critical_sites.sites_to_remove_equip,...
                                                                    inputs_finance,...
                                                                    LR_inputs_finance.current_year,...
                                                                   'EUTRAN_CA',...
                                                                   'EUTRAN_CA',...
                                                                   'sector',...
                                                                   temp_RAN_spectrum_remove);

%*********************************UTRAN************************************
LR_network_cost.UTRAN_2100.disposal_value_cell = disposal_value_cell(length(LR_site_infrastructure),...
                                                                     site_infrastructure,...
                                                                     network_cost,...
                                                                     network_information,...
                                                                     LR_network_information_growth_snapshot.critical_sites.sites_to_remove_equip,...
                                                                     inputs_finance,...
                                                                     LR_inputs_finance.current_year,...
                                                                     'UTRAN',...
                                                                     'UTRAN_2100',...
                                                                     'sector2100',...
                                                                     temp_RAN_spectrum_remove); 

LR_network_cost.UTRAN_900.disposal_value_cell = disposal_value_cell(length(LR_site_infrastructure),...
                                                                    site_infrastructure,...
                                                                    network_cost,...
                                                                    network_information,...
                                                                    LR_network_information_growth_snapshot.critical_sites.sites_to_remove_equip,...
                                                                    inputs_finance,...
                                                                    LR_inputs_finance.current_year,...
                                                                    'UTRAN',...
                                                                    'UTRAN_900',...
                                                                    'sector900',...
                                                                    temp_RAN_spectrum_remove); 

%**********************************GERAN***********************************   
LR_network_cost.GERAN_900.disposal_value_cell = disposal_value_cell(length(LR_site_infrastructure),...
                                                                    site_infrastructure,...
                                                                    network_cost,...
                                                                	network_information,...
                                                                    LR_network_information_growth_snapshot.critical_sites.sites_to_remove_equip,...
                                                                    inputs_finance,...
                                                                    LR_inputs_finance.current_year,...
                                                                    'GERAN',...
                                                                    'GERAN_900',...
                                                                    'sector900',...
                                                                    temp_RAN_spectrum_remove); 

LR_network_cost.GERAN_1800.disposal_value_cell = disposal_value_cell(length(LR_site_infrastructure),...
                                                                    site_infrastructure,...
                                                                    network_cost,...
                                                                    network_information,...
                                                                    LR_network_information_growth_snapshot.critical_sites.sites_to_remove_equip,...
                                                                    inputs_finance,...
                                                                    LR_inputs_finance.current_year,...
                                                                    'GERAN',...
                                                                    'GERAN_1800',...
                                                                    'sector1800',...
                                                                    temp_RAN_spectrum_remove);
                                                                                                                                                                                                                
% Cost-level 2: Investment Cost per site                                                  
%**********************************All_RANs********************************* 
LR_network_cost.all_RAN.disposal_value  = disposal_value_all_RAN(length(LR_site_infrastructure),LR_network_cost);

clear temp_RAN_spectrum_investment temp_RAN_spectrum_remove;