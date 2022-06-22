function temp_actual_sites = number_of_sites(temp_all_bs,EUTRAN_s_bs,EUTRAN_CA_bs,inputs_technology)
%number_of_sites Summary of this function goes here
%   Detailed explanation goes here

    % the number of actual sites (clusters' center): 
    
    % Assumption 1: use of site-to-basestations ratio to determine the number of multi-RAN sites
    temp_actual_sites1 = ceil((temp_all_bs)*inputs_technology.extra.sites_to_basestations_ratio);
    
    % Assumption 2: the number of sites cannot be smaller than the max number of
    %               basestations of each RAN
    temp_actual_sites2 = max ([ max([inputs_technology.EUTRAN_s(:).basestations])...
                                max([inputs_technology.EUTRAN_CA(:).basestations])...
                                max([inputs_technology.UTRAN(:).basestations])...
                                max([inputs_technology.GERAN(:).basestations])]);
                            
    % Assumption 3: EUTRAN_s and EUTRAN_CA are never site co-located
    temp_actual_sites3 = EUTRAN_s_bs + EUTRAN_CA_bs;

    temp_actual_sites = max([temp_actual_sites1 temp_actual_sites2 temp_actual_sites3]);

end

