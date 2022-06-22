% calculations for all RANs per configuration:
% number of cells in the region (cells) - function
% number of 3-sectored basestations (basestations)
% typical cell capacity, cell data rate (cell_capacity_Mbps) - function

% calculations only for EUTRAN_CA per configuration:
% cell ranges for each EUTRAN_CA configuration (inputs_technology.EUTRAN_CA.cell_ranges_km)
% max cell range for each EUTRAN_CA configuration (inputs_technology.EUTRAN_CA.cell_max_km)
% number of carriers for each EUTRAN_CA configuration (inputs_technology.EUTRAN_CA.carriers)
% bands for each EUTRAN_CA configuration (inputs_technology.EUTRAN_CA.bands)
% BW for each EUTRAN_CA configuration (inputs_technology.EUTRAN_CA.BW)
% number of non-aggregated cells in the region (cells_non_aggregated)
% territory coverage for all carriers inside a aggregated cell (territory_coverage_all_carriers)
    
%*****************************EUTRAN_single********************************
temp_cells = ... % number of cells in the region (cells)
             number_of_cells(inputs_market_industry.demographics.land_Area_km2,...
                            [inputs_technology.EUTRAN_s.territory_coverage],...
                            [inputs_technology.EUTRAN_s.cell_range_km]);

[inputs_technology.EUTRAN_s(:).cells] = temp_cells{:}; 
clear temp_cells;

temp_basestations = num2cell(ceil([inputs_technology.EUTRAN_s(:).cells]/inputs_technology.extra.default_sector_number));
[inputs_technology.EUTRAN_s(:).basestations] = temp_basestations{:};
clear temp_basestations;

temp_cell_capacity = ... % typical cell capacity, cell data rate (cell_capacity_Mbps)
                      cell_capacity_Mbps([inputs_technology.EUTRAN_s.BW],...
                                         [inputs_technology.EUTRAN_s.typical_BW_efficiency_bps_per_Hz]);

[inputs_technology.EUTRAN_s(:).cell_capacity_Mbps] = temp_cell_capacity{:}; 
clear temp_cell_capacity; 

%********************************EUTRAN_CA*********************************
temp_CAconfig = {inputs_technology.EUTRAN_CA(:).CA_config};
temp_EUTRAN_s_cellranges = repmat(num2cell([inputs_technology.EUTRAN_s(:).cell_range_km],2),1,length(inputs_technology.EUTRAN_CA));
temp_CA_ranges = cellfun(@(x,y) x.*y, temp_CAconfig,temp_EUTRAN_s_cellranges, 'UniformOutput',false);
temp_EUTRAN_s_bands = repmat(num2cell([inputs_technology.EUTRAN_s(:).bands],2),1,length(inputs_technology.EUTRAN_CA));
temp_CA_bands = cellfun(@(x,y) x.*y, temp_CAconfig,temp_EUTRAN_s_bands, 'UniformOutput',false);
temp_EUTRAN_s_BW = repmat(num2cell([inputs_technology.EUTRAN_s(:).BW],2),1,length(inputs_technology.EUTRAN_CA));
temp_CA_BW = cellfun(@(x,y) x.*y, temp_CAconfig,temp_EUTRAN_s_BW, 'UniformOutput',false);
temp_EUTRAN_s_cell_capacity = repmat(num2cell([inputs_technology.EUTRAN_s(:).cell_capacity_Mbps],2),1,length(inputs_technology.EUTRAN_CA));
temp_CA_cell_capacity = cellfun(@(x,y) x.*y, temp_CAconfig,temp_EUTRAN_s_cell_capacity, 'UniformOutput',false);
temp_CA_max_ranges = cell(1,length(inputs_technology.EUTRAN_CA));
temp_carriers = cell(1,length(inputs_technology.EUTRAN_CA));
for i = 1:length(inputs_technology.EUTRAN_CA)
    temp_CA_ranges{i}(temp_CA_ranges{i}==0) = [];   % cell ranges for each EUTRAN_CA configuration (inputs_technology.EUTRAN_CA.cell_ranges_km)
    temp_CA_max_ranges{i} = max(temp_CA_ranges{i}); % max cell range for each EUTRAN_CA configuration (inputs_technology.EUTRAN_CA.cell_max_km)
    temp_carriers{i} = length(temp_CA_ranges{i});   % number of carriers for each EUTRAN_CA configuration (inputs_technology.EUTRAN_CA.carriers)
    temp_CA_bands{i}(temp_CA_bands{i}==0) = [];     % bands for each EUTRAN_CA configuration (inputs_technology.EUTRAN_CA.bands)
    temp_CA_BW{i}(temp_CA_BW{i}==0) = [];           % BW for each EUTRAN_CA configuration (inputs_technology.EUTRAN_CA.BW)
    temp_CA_cell_capacity{i} = sum(temp_CA_cell_capacity{i}); % cell capacity for each EUTRAN_CA configuration (inputs_technology.EUTRAN_CA.cell_capacity_Mbps)
end
[inputs_technology.EUTRAN_CA(:).carriers] = temp_carriers{:}; 
[inputs_technology.EUTRAN_CA(:).bands] = temp_CA_bands{:};
[inputs_technology.EUTRAN_CA(:).BW] = temp_CA_BW{:};
[inputs_technology.EUTRAN_CA(:).cell_ranges_km] = temp_CA_ranges{:};
[inputs_technology.EUTRAN_CA(:).cell_range_km] = temp_CA_max_ranges{:}; 
clear temp_CAconfig temp_EUTRAN_s_cellranges temp_EUTRAN_s_bands temp_EUTRAN_s_BW temp_CA_ranges temp_CA_bands temp_CA_BW temp_CA_max_ranges temp_carriers i;

temp_cells = ... % number of aggregated cells in the region (cells)
             number_of_cells(inputs_market_industry.demographics.land_Area_km2,...
                            [inputs_technology.EUTRAN_CA.territory_coverage],...
                            [inputs_technology.EUTRAN_CA.cell_range_km]);
[inputs_technology.EUTRAN_CA(:).cells] = temp_cells{:}; 
clear temp_cells;

temp_basestations = num2cell(ceil([inputs_technology.EUTRAN_CA(:).cells]/3));
[inputs_technology.EUTRAN_CA(:).basestations] = temp_basestations{:};
clear temp_basestations;

[inputs_technology.EUTRAN_CA(:).cell_capacity_Mbps] = temp_CA_cell_capacity{:}; 
clear temp_EUTRAN_s_cell_capacity temp_CA_cell_capacity;

temp_cells_non_aggregated = ... % number of single cells in the region (cells)
                [inputs_technology.EUTRAN_CA(:).carriers].*[inputs_technology.EUTRAN_CA(:).cells];   
temp_cells_non_aggregated = num2cell(temp_cells_non_aggregated);
[inputs_technology.EUTRAN_CA(:).cells_non_aggregated] = temp_cells_non_aggregated{:}; 
clear temp_cells_non_aggregated;

temp_territory = cell(1,length(inputs_technology.EUTRAN_CA));
for i = 1:length(inputs_technology.EUTRAN_CA)
    temp_territory{i} = ... % territory coverage for all carriers inside a ovelapped cell (territory_coverage_all_carriers)
                    [inputs_technology.EUTRAN_CA(i).cells].*...
                    (0.65*[inputs_technology.EUTRAN_CA(i).cell_ranges_km].^2)./...
                    inputs_market_industry.demographics.land_Area_km2;     
end

[inputs_technology.EUTRAN_CA(:).territory_coverage_all_carriers] = temp_territory{:}; 
clear temp_territory i;

%*********************************UTRAN************************************
temp_cells = ... % number of cells in the region (cells)
             number_of_cells(inputs_market_industry.demographics.land_Area_km2,...
                            [inputs_technology.UTRAN.territory_coverage],...
                            [inputs_technology.UTRAN.cell_range_km]);
[inputs_technology.UTRAN(:).cells] = temp_cells{:}; 
clear temp_cells;

temp_basestations = num2cell(ceil([inputs_technology.UTRAN(:).cells]/3));
[inputs_technology.UTRAN(:).basestations] = temp_basestations{:};
clear temp_basestations;

temp_cell_capacity = ... % typical cell capacity, cell data rate (cell_capacity_Mbps)
                      cell_capacity_Mbps([inputs_technology.UTRAN.BW],...
                                         [inputs_technology.UTRAN.typical_BW_efficiency_bps_per_Hz]);
[inputs_technology.UTRAN(:).cell_capacity_Mbps] = temp_cell_capacity{:}; 
clear temp_cell_capacity;  

%**********************************GERAN***********************************                    
temp_cells = ... % number of cells in the region (cells)
             number_of_cells(inputs_market_industry.demographics.land_Area_km2,...
                            [inputs_technology.GERAN.territory_coverage],...
                            [inputs_technology.GERAN.cell_range_km]);
[inputs_technology.GERAN(:).cells] = temp_cells{:}; 
clear temp_cells;

temp_basestations = num2cell(ceil([inputs_technology.GERAN(:).cells]/3));
[inputs_technology.GERAN(:).basestations] = temp_basestations{:};
clear temp_basestations;

temp_cell_capacity = ... % typical cell capacity, cell data rate (cell_capacity_Mbps)
                      cell_capacity_Mbps([inputs_technology.GERAN.BW],...
                                         [inputs_technology.GERAN.typical_BW_efficiency_bps_per_Hz]);
[inputs_technology.GERAN(:).cell_capacity_Mbps] = temp_cell_capacity{:}; 
clear temp_cell_capacity;  