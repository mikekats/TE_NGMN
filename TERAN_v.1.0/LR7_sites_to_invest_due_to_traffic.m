%**************************************************************************
% Part 1: Traffic growth and time
%**************************************************************************

%LR_network_information_growth_snapshot.traffic_growth_snapshot_index = ...
%traffic_growth_snapshot_index; % take from GUI

%traffic_growth_time = 'lowSc' 'mediumSc' 'highSc'
LR_network_information_growth_snapshot.traffic_growth_snapshot_time = ...
    convert_trafficGrowth_to_time(network_throughput_progression.all_RAN.growth(LR_network_information_growth_snapshot.traffic_growth_snapshot_index),...
                                  inputs_demand_parameters.future_market_share_mno,...
                                  market_demand_revenues.inverse_demand_forecast_annual_equilibria,...
                                  market_demand_revenues.operator_region_data_weight_factor,...
                                  network_information.all_RAN.total_throughput_Mbps,...
                                  inputs_market_industry.service.ULtoDLratio);

% Manually chosen: for medium traffic growth scenario
% in future user should choose among traffic growth scenario options
LR_inputs_finance.current_year = str2double(LR_network_information_growth_snapshot.traffic_growth_snapshot_time{2});
if isnan(LR_inputs_finance.current_year)
    LR_inputs_finance.current_year = 2021;
end

%**************************************************************************
% Part 2: Find: - the investment trigger per cell and 
%               - the sites/cells to invest
%**************************************************************************
%*****************************EUTRAN_single********************************
inv_trigger_per_cell = (network_information.EUTRAN_s.throughput_Mbps_per_cell + ...
                   network_throughput_progression.EUTRAN_s(:,:,LR_network_information_growth_snapshot.traffic_growth_snapshot_index)) ./...
                   network_information.EUTRAN_s.max_safe_throughput_Mbps_per_cell;
inv_trigger_per_cell(isnan(inv_trigger_per_cell)) = 0;

[row,col] = find(inv_trigger_per_cell > 1);
site_and_its_cell_to_invest = [col,row];
sites_to_invest = unique(col)';


LR_network_information_growth_snapshot.EUTRAN_s.inv_trigger_per_cell = inv_trigger_per_cell;
LR_network_information_growth_snapshot.EUTRAN_s.sites_to_invest = sites_to_invest;
LR_network_information_growth_snapshot.EUTRAN_s.site_cell_to_invest = site_and_its_cell_to_invest;

%*****************************EUTRAN_CA************************************
inv_trigger_per_cell = (network_information.EUTRAN_CA.throughput_Mbps_per_cell + ...
                 network_throughput_progression.EUTRAN_CA(:,:,LR_network_information_growth_snapshot.traffic_growth_snapshot_index)) ./...
                 network_information.EUTRAN_CA.max_safe_throughput_Mbps_per_cell;
inv_trigger_per_cell(isnan(inv_trigger_per_cell)) = 0;

[row,col] = find(inv_trigger_per_cell > 1);
site_and_its_cell_to_invest = [col,row];
sites_to_invest = unique(col)';

LR_network_information_growth_snapshot.EUTRAN_CA.inv_trigger_per_cell = inv_trigger_per_cell;
LR_network_information_growth_snapshot.EUTRAN_CA.sites_to_invest = sites_to_invest;
LR_network_information_growth_snapshot.EUTRAN_CA.site_cell_to_invest = site_and_its_cell_to_invest;

%*****************************UTRAN***************************************
inv_trigger_per_cell = (network_information.UTRAN_2100.throughput_Mbps_per_cell + ...
                 network_throughput_progression.UTRAN_2100(:,:,LR_network_information_growth_snapshot.traffic_growth_snapshot_index)) ./...
                 network_information.UTRAN_2100.max_safe_throughput_Mbps_per_cell;
inv_trigger_per_cell(isnan(inv_trigger_per_cell)) = 0;

[row,col] = find(inv_trigger_per_cell > 1);
site_and_its_cell_to_invest = [col,row];
sites_to_invest = unique(col)';

LR_network_information_growth_snapshot.UTRAN_2100.inv_trigger_per_cell = inv_trigger_per_cell;
LR_network_information_growth_snapshot.UTRAN_2100.sites_to_invest = sites_to_invest;
LR_network_information_growth_snapshot.UTRAN_2100.site_cell_to_invest = site_and_its_cell_to_invest;


inv_trigger_per_cell = (network_information.UTRAN_900.throughput_Mbps_per_cell + ...
                 network_throughput_progression.UTRAN_900(:,:,LR_network_information_growth_snapshot.traffic_growth_snapshot_index)) ./...
                 network_information.UTRAN_900.max_safe_throughput_Mbps_per_cell;
inv_trigger_per_cell(isnan(inv_trigger_per_cell)) = 0;

[row,col] = find(inv_trigger_per_cell > 1);
site_and_its_cell_to_invest = [col,row];
sites_to_invest = unique(col)';

LR_network_information_growth_snapshot.UTRAN_900.inv_trigger_per_cell = inv_trigger_per_cell;
LR_network_information_growth_snapshot.UTRAN_900.sites_to_invest = sites_to_invest;
LR_network_information_growth_snapshot.UTRAN_900.site_cell_to_invest = site_and_its_cell_to_invest;

%*****************************GERAN***************************************
inv_trigger_per_cell = (network_information.GERAN_900.throughput_Mbps_per_cell + ...
                 network_throughput_progression.GERAN_900(:,:,LR_network_information_growth_snapshot.traffic_growth_snapshot_index)) ./...
                 network_information.GERAN_900.max_safe_throughput_Mbps_per_cell;
inv_trigger_per_cell(isnan(inv_trigger_per_cell)) = 0;

[row,col] = find(inv_trigger_per_cell > 1);
site_and_its_cell_to_invest = [col,row];
sites_to_invest = unique(col)';

LR_network_information_growth_snapshot.GERAN_900.inv_trigger_per_cell = inv_trigger_per_cell;
LR_network_information_growth_snapshot.GERAN_900.sites_to_invest = sites_to_invest;
LR_network_information_growth_snapshot.GERAN_900.site_cell_to_invest = site_and_its_cell_to_invest;


inv_trigger_per_cell = (network_information.GERAN_1800.throughput_Mbps_per_cell + ...
                 network_throughput_progression.GERAN_1800(:,:,LR_network_information_growth_snapshot.traffic_growth_snapshot_index)) ./...
                 network_information.GERAN_1800.max_safe_throughput_Mbps_per_cell;
inv_trigger_per_cell(isnan(inv_trigger_per_cell)) = 0;

[row,col] = find(inv_trigger_per_cell > 1);
site_and_its_cell_to_invest = [col,row];
sites_to_invest = unique(col)';

LR_network_information_growth_snapshot.GERAN_1800.inv_trigger_per_cell = inv_trigger_per_cell;
LR_network_information_growth_snapshot.GERAN_1800.sites_to_invest = sites_to_invest;
LR_network_information_growth_snapshot.GERAN_1800.site_cell_to_invest = site_and_its_cell_to_invest;

%*****************************all_RAN ***************************************                                          
% Combine the sites from the above findings
temp_sites_to_invest_per_technology = {LR_network_information_growth_snapshot.EUTRAN_s.sites_to_invest,...
                                       LR_network_information_growth_snapshot.EUTRAN_CA.sites_to_invest,...
                                       LR_network_information_growth_snapshot.UTRAN_2100.sites_to_invest,...
                                       LR_network_information_growth_snapshot.UTRAN_900.sites_to_invest,...
                                       LR_network_information_growth_snapshot.GERAN_900.sites_to_invest,...
                                       LR_network_information_growth_snapshot.GERAN_1800.sites_to_invest}; 

sites_to_invest = unique(cat(2, temp_sites_to_invest_per_technology{:}));
LR_network_information_growth_snapshot.all_RAN.sites_to_invest = sites_to_invest;

% site level 
inv_trigger_per_site = (network_information.all_RAN.throughput_Mbps_per_site + ...
                   network_throughput_progression.all_RAN.per_site(:,:,LR_network_information_growth_snapshot.traffic_growth_snapshot_index)) ./...
                   network_information.all_RAN.max_safe_throughput_Mbps_per_site;
inv_trigger_per_site(isnan(inv_trigger_per_site)) = 0;

[~,col] = find(inv_trigger_per_site > 1);
sites_to_invest = unique(col)';

LR_network_information_growth_snapshot.all_RAN.growth_per_site = inv_trigger_per_site;
%(gives wrong estimation because all the cells traffic is integrated)
LR_network_information_growth_snapshot.all_RAN.sites_to_invest_site_level = sites_to_invest;


clear col row growth_per_site site_and_its_cell_to_invest sites_to_invest temp_sites_to_invest_per_technology inv_trigger_per_cell inv_trigger_per_site;
