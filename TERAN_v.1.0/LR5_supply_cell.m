%same as SR5_supply_cell

%*****************************EUTRAN_single********************************
temp_cells = ... % number of cells in the region (cells)
             number_of_cells(LR_inputs_market_industry.demographics.land_Area_km2,...
                            [LR_inputs_technology.EUTRAN_s.territory_coverage],...
                            [LR_inputs_technology.EUTRAN_s.cell_range_km]);

[LR_inputs_technology.EUTRAN_s(:).cells] = temp_cells{:}; 
clear temp_cells;

temp_basestations = num2cell(ceil([LR_inputs_technology.EUTRAN_s(:).cells]/3));
[LR_inputs_technology.EUTRAN_s(:).basestations] = temp_basestations{:};
clear temp_basestations;

temp_cell_capacity = ... % typical cell capacity, cell data rate (cell_capacity_Mbps)
                      cell_capacity_Mbps([LR_inputs_technology.EUTRAN_s.BW],...
                                         [LR_inputs_technology.EUTRAN_s.typical_BW_efficiency_bps_per_Hz]);

[LR_inputs_technology.EUTRAN_s(:).cell_capacity_Mbps] = temp_cell_capacity{:}; 
clear temp_cell_capacity; 

%********************************EUTRAN_CA*********************************
temp_CAconfig = {LR_inputs_technology.EUTRAN_CA(:).CA_config};
temp_EUTRAN_s_cellranges = repmat(num2cell([LR_inputs_technology.EUTRAN_s(:).cell_range_km],2),1,length(LR_inputs_technology.EUTRAN_CA));
temp_CA_ranges = cellfun(@(x,y) x.*y, temp_CAconfig,temp_EUTRAN_s_cellranges, 'UniformOutput',false);
temp_EUTRAN_s_bands = repmat(num2cell([LR_inputs_technology.EUTRAN_s(:).bands],2),1,length(LR_inputs_technology.EUTRAN_CA));
temp_CA_bands = cellfun(@(x,y) x.*y, temp_CAconfig,temp_EUTRAN_s_bands, 'UniformOutput',false);
temp_EUTRAN_s_BW = repmat(num2cell([LR_inputs_technology.EUTRAN_s(:).BW],2),1,length(LR_inputs_technology.EUTRAN_CA));
temp_CA_BW = cellfun(@(x,y) x.*y, temp_CAconfig,temp_EUTRAN_s_BW, 'UniformOutput',false);
temp_EUTRAN_s_cell_capacity = repmat(num2cell([LR_inputs_technology.EUTRAN_s(:).cell_capacity_Mbps],2),1,length(LR_inputs_technology.EUTRAN_CA));
temp_CA_cell_capacity = cellfun(@(x,y) x.*y, temp_CAconfig,temp_EUTRAN_s_cell_capacity, 'UniformOutput',false);
temp_CA_max_ranges = cell(1,length(LR_inputs_technology.EUTRAN_CA));
temp_carriers = cell(1,length(LR_inputs_technology.EUTRAN_CA));
for i = 1:length(LR_inputs_technology.EUTRAN_CA)
    temp_CA_ranges{i}(temp_CA_ranges{i}==0) = [];   % cell ranges for each EUTRAN_CA configuration (LR_inputs_technology.EUTRAN_CA.cell_ranges_km)
    temp_CA_max_ranges{i} = max(temp_CA_ranges{i}); % max cell range for each EUTRAN_CA configuration (LR_inputs_technology.EUTRAN_CA.cell_max_km)
    temp_carriers{i} = length(temp_CA_ranges{i});   % number of carriers for each EUTRAN_CA configuration (LR_inputs_technology.EUTRAN_CA.carriers)
    temp_CA_bands{i}(temp_CA_bands{i}==0) = [];     % bands for each EUTRAN_CA configuration (LR_inputs_technology.EUTRAN_CA.bands)
    temp_CA_BW{i}(temp_CA_BW{i}==0) = [];           % BW for each EUTRAN_CA configuration (LR_inputs_technology.EUTRAN_CA.BW)
    temp_CA_cell_capacity{i} = sum(temp_CA_cell_capacity{i}); % cell capacity for each EUTRAN_CA configuration (LR_inputs_technology.EUTRAN_CA.cell_capacity_Mbps)
end
[LR_inputs_technology.EUTRAN_CA(:).carriers] = temp_carriers{:}; 
[LR_inputs_technology.EUTRAN_CA(:).bands] = temp_CA_bands{:};
[LR_inputs_technology.EUTRAN_CA(:).BW] = temp_CA_BW{:};
[LR_inputs_technology.EUTRAN_CA(:).cell_ranges_km] = temp_CA_ranges{:};
[LR_inputs_technology.EUTRAN_CA(:).cell_range_km] = temp_CA_max_ranges{:}; 
clear temp_CAconfig temp_EUTRAN_s_cellranges temp_EUTRAN_s_bands temp_EUTRAN_s_BW temp_CA_ranges temp_CA_bands temp_CA_BW temp_CA_max_ranges temp_carriers i;

temp_cells = ... % number of aggregated cells in the region (cells)
             number_of_cells(LR_inputs_market_industry.demographics.land_Area_km2,...
                            [LR_inputs_technology.EUTRAN_CA.territory_coverage],...
                            [LR_inputs_technology.EUTRAN_CA.cell_range_km]);
[LR_inputs_technology.EUTRAN_CA(:).cells] = temp_cells{:}; 
clear temp_cells;

temp_basestations = num2cell(ceil([LR_inputs_technology.EUTRAN_CA(:).cells]/3));
[LR_inputs_technology.EUTRAN_CA(:).basestations] = temp_basestations{:};
clear temp_basestations;

[LR_inputs_technology.EUTRAN_CA(:).cell_capacity_Mbps] = temp_CA_cell_capacity{:}; 
clear temp_EUTRAN_s_cell_capacity temp_CA_cell_capacity;

temp_cells_non_aggregated = ... % number of single cells in the region (cells)
                [LR_inputs_technology.EUTRAN_CA(:).carriers].*[LR_inputs_technology.EUTRAN_CA(:).cells];   
temp_cells_non_aggregated = num2cell(temp_cells_non_aggregated);
[LR_inputs_technology.EUTRAN_CA(:).cells_non_aggregated] = temp_cells_non_aggregated{:}; 
clear temp_cells_non_aggregated;

temp_territory = cell(1,length(LR_inputs_technology.EUTRAN_CA));
for i = 1:length(LR_inputs_technology.EUTRAN_CA)
    temp_territory{i} = ... % territory coverage for all carriers inside a ovelapped cell (territory_coverage_all_carriers)
                    [LR_inputs_technology.EUTRAN_CA(i).cells].*...
                    (0.65*[LR_inputs_technology.EUTRAN_CA(i).cell_ranges_km].^2)./...
                    LR_inputs_market_industry.demographics.land_Area_km2;     
end

[LR_inputs_technology.EUTRAN_CA(:).territory_coverage_all_carriers] = temp_territory{:}; 
clear temp_territory i;

%*********************************UTRAN************************************
temp_cells = ... % number of cells in the region (cells)
             number_of_cells(LR_inputs_market_industry.demographics.land_Area_km2,...
                            [LR_inputs_technology.UTRAN.territory_coverage],...
                            [LR_inputs_technology.UTRAN.cell_range_km]);
[LR_inputs_technology.UTRAN(:).cells] = temp_cells{:}; 
clear temp_cells;

temp_basestations = num2cell(ceil([LR_inputs_technology.UTRAN(:).cells]/3));
[LR_inputs_technology.UTRAN(:).basestations] = temp_basestations{:};
clear temp_basestations;

temp_cell_capacity = ... % typical cell capacity, cell data rate (cell_capacity_Mbps)
                      cell_capacity_Mbps([LR_inputs_technology.UTRAN.BW],...
                                         [LR_inputs_technology.UTRAN.typical_BW_efficiency_bps_per_Hz]);
[LR_inputs_technology.UTRAN(:).cell_capacity_Mbps] = temp_cell_capacity{:}; 
clear temp_cell_capacity;  

%**********************************GERAN***********************************                    
temp_cells = ... % number of cells in the region (cells)
             number_of_cells(LR_inputs_market_industry.demographics.land_Area_km2,...
                            [LR_inputs_technology.GERAN.territory_coverage],...
                            [LR_inputs_technology.GERAN.cell_range_km]);
[LR_inputs_technology.GERAN(:).cells] = temp_cells{:}; 
clear temp_cells;

temp_basestations = num2cell(ceil([LR_inputs_technology.GERAN(:).cells]/3));
[LR_inputs_technology.GERAN(:).basestations] = temp_basestations{:};
clear temp_basestations;

temp_cell_capacity = ... % typical cell capacity, cell data rate (cell_capacity_Mbps)
                      cell_capacity_Mbps([LR_inputs_technology.GERAN.BW],...
                                         [LR_inputs_technology.GERAN.typical_BW_efficiency_bps_per_Hz]);
[LR_inputs_technology.GERAN(:).cell_capacity_Mbps] = temp_cell_capacity{:}; 
clear temp_cell_capacity;  