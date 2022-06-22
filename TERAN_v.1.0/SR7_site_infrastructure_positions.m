%**************************************************************************
% Generate site positions
%**************************************************************************

%**********Find the initial bassestation positions for EUTRAN_single*******

temp_EUTRAN_s_bs_initial_position = basestations_initial_position(inputs_market_industry.demographics.land_Area_km2,...
                                                                 [inputs_technology.EUTRAN_s(:).cell_range_km],...
                                                                 [inputs_technology.EUTRAN_s(:).basestations]);

%**********Find the initial bassestation positions for EUTRAN_CA***********

temp_EUTRAN_CA_bs_initial_position = basestations_initial_position(inputs_market_industry.demographics.land_Area_km2,...
                                                                  [inputs_technology.EUTRAN_CA(:).cell_range_km],...
                                                                  [inputs_technology.EUTRAN_CA(:).basestations]);

%************Find the initial bassestation positions for UTRAN*************

temp_UTRAN_bs_initial_position = basestations_initial_position(inputs_market_industry.demographics.land_Area_km2,...
                                                              [inputs_technology.UTRAN(:).cell_range_km],...
                                                              [inputs_technology.UTRAN(:).basestations]);

%************Find the initial bassestation positions for GERAN*************

temp_GERAN_bs_initial_position = basestations_initial_position(inputs_market_industry.demographics.land_Area_km2,...
                                                              [inputs_technology.GERAN(:).cell_range_km],...
                                                              [inputs_technology.GERAN(:).basestations]);

%**************************************************************************                       
% Find the actual sites positions by grouping the initial sites based on 
% the nearest neighbor (clusters' center) 

% all the initial sites
temp_all_bs_initial_position = [temp_EUTRAN_s_bs_initial_position;
                                temp_EUTRAN_CA_bs_initial_position;
                                temp_UTRAN_bs_initial_position;
                                temp_GERAN_bs_initial_position];
                                
temp_actual_sites = number_of_sites(length(temp_all_bs_initial_position),...
                                    length(temp_EUTRAN_s_bs_initial_position),...
                                    length(temp_EUTRAN_CA_bs_initial_position),...
                                    inputs_technology);
   
% find the site locations
% matlab with statistics toolbox should use its own function 
% the loop ensure that the coordinations of the sites are unique (kmeans gave once a double coordinate)
temp_sites_position = [0 0];
%k=0;
while size(unique([temp_sites_position(:,1), temp_sites_position(:,2)],'rows','stable'),1) ~= temp_actual_sites
    [~,temp_sites_position] = kmeans(temp_all_bs_initial_position,temp_actual_sites,'EmptyAction','singleton');
    %size(unique([temp_sites_position(:,1), temp_sites_position(:,2)],'rows','stable'),1)
    %k=k+1
end

clear temp_EUTRAN_s_bs_initial_position temp_EUTRAN_CA_bs_initial_position temp_UTRAN_bs_initial_position temp_GERAN_bs_initial_position...
       temp_all_bs_initial_position k;