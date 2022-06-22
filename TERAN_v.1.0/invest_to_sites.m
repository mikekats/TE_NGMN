function LR_site_infrastructure = invest_to_sites(  LR_inputs_technology,...
                                                    site_infrastructure,...
                                                    LR_site_infrastructure,...
                                                    network_information,...
                                                    temp_RAN,...
                                                    temp_RAN_spectrum,...
                                                    temp_sector,...
                                                    temp_cell_ID_prefix,...
                                                    temp_RANconfig,...
                                                    temp_sites_to_invest,...
                                                    throughput_progression,...
                                                    time)
%invest_to_sites Summary of this function goes here
%   Detailed explanation goes here



                                   
    for i = 1:length(temp_sites_to_invest)
          
        temp_sectors_per_site = network_information.(temp_RAN_spectrum).cells_per_site(temp_sites_to_invest(i));

%       LR_site_infrastructure(temp_sites_to_invest(i)).site_ID = 
%       LR_site_infrastructure(temp_sites_to_invest(i)).site_type = 
%       LR_site_infrastructure(temp_sites_to_invest(i)).longitude = 
%       LR_site_infrastructure(temp_sites_to_invest(i)).latitude = 
%       LR_site_infrastructure(temp_sites_to_invest(i)).development_year = 
%       LR_site_infrastructure(temp_sites_to_invest(i)).transmission.owned_transmission_lines = 
%       LR_site_infrastructure(temp_sites_to_invest(i)).transmission.leased_transmission_lines = 

        for temp_sector_num=1:temp_sectors_per_site

            cellIDstr = site_infrastructure(temp_sites_to_invest(i)).(temp_RAN).(temp_sector)(temp_sector_num).cell_ID;
            LR_site_infrastructure(temp_sites_to_invest(i)).(temp_RAN).(temp_sector)(temp_sector_num).cell_ID = strrep(cellIDstr,strtok(cellIDstr,'#'),[temp_cell_ID_prefix num2str(LR_inputs_technology.(temp_RAN)(temp_RANconfig).cellgroupID)]);
            LR_site_infrastructure(temp_sites_to_invest(i)).(temp_RAN).(temp_sector)(temp_sector_num).configuration =  LR_inputs_technology.(temp_RAN)(temp_RANconfig).configuration;            
            LR_site_infrastructure(temp_sites_to_invest(i)).(temp_RAN).(temp_sector)(temp_sector_num).band = LR_inputs_technology.(temp_RAN)(temp_RANconfig).bands;
            LR_site_infrastructure(temp_sites_to_invest(i)).(temp_RAN).(temp_sector)(temp_sector_num).BW = LR_inputs_technology.(temp_RAN)(temp_RANconfig).BW;
            LR_site_infrastructure(temp_sites_to_invest(i)).(temp_RAN).(temp_sector)(temp_sector_num).cell_range_km = LR_inputs_technology.(temp_RAN)(temp_RANconfig).cell_range_km;
            LR_site_infrastructure(temp_sites_to_invest(i)).(temp_RAN).(temp_sector)(temp_sector_num).cell_capacity_Mbps = LR_inputs_technology.(temp_RAN)(temp_RANconfig).cell_capacity_Mbps;                     
            LR_site_infrastructure(temp_sites_to_invest(i)).(temp_RAN).(temp_sector)(temp_sector_num).development_year = time; 
            LR_site_infrastructure(temp_sites_to_invest(i)).(temp_RAN).(temp_sector)(temp_sector_num).cell_throughput_Mbps = ...
                site_infrastructure(temp_sites_to_invest(i)).(temp_RAN).(temp_sector)(temp_sector_num).cell_throughput_Mbps + ...
                throughput_progression(temp_sector_num,temp_sites_to_invest(i));
              
        end  
        
    end 

end
