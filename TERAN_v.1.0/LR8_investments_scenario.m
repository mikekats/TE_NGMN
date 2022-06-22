%**************************************************************************
% Part 0: Scenario Definition
%**************************************************************************
% LTE-A Pro (Gigabit LTE) 
% 100% coverage for 'EUTRAN@2600+2100+1800, LTE-A, R13, CA, 20+20+20 MHz, 256 QAM, 4x4 MIMO, 1380 Mbps'
% Upgrade the EUTRAN_CA sites
% (EUTRAN_CA coverage is measured for the longest cell range i.e., 1800MHz))
% Assumpion 1: The traffic of colocated technologies on investmnet_sites will be
% carried by the investmnents
% Assumption 2: The traffic of the non_investment_sites which are overlapped by the
% investment_sites is carried by the investments
% Assumption 3: The traffic of the non_investmnent_sites which are not
% overlapped by investments_sites will require other investments (e.g.
% UTRAN, not in this scenario)
%*****************************EUTRAN_single********************************
% EUTRAN_s infrastructure remains the same
% EUTRAN_s exists to cover 2.6 GHz holes of EUTRAN_CA with 2.6 GHz carrier
%********************************EUTRAN_CA*********************************
% EUTRAN_CA changes:
% EUTRAN_CA CA#1 and CA#6 change to CA#7
% CA#1: EUTRAN@2600+1800, LTE-A, R11, CA, 20+20 MHz, 64 QAM, 2x2 MIMO, 344 Mbps
% CA#6: EUTRAN@2600+2100+1800, LTE-A, R13, CA, 20+20+20 MHz, 256 QAM, 2x2 MIMO, 690 Mbps
% CA#7: EUTRAN@2600+2100+1800, LTE-A, R13, CA, 20+20+20 MHz, 256 QAM, 4x4 MIMO, 1380 Mbps
%*********************************UTRAN************************************
% UTRAN_2100 changes: 
% When CA#7 is installed UTRAN_2100 is shut down because the 2100 band is
% now used by EUTRAN_CA
% UTRAN_2100 exists to some sites to cover 2.1 GHz holes 
% Find sites/cells with EUTRAN_CA at 2100MHz in which UTRAN_2100 exists
% UTRAN_900 remain the same
%**********************************GERAN***********************************   
% GERAN remains the same
%**************************************************************************


%**************************************************************************
% Part 1: Find the most critical sites:
% - All the potential sites to invest according to the scenario
% - Compare with the sites which need investment for the specified traffic growth
%   - investment_sites = need investment and belong to potential sites to invest
%   - no_investment_sites_affected_by_investments = they are inside the range of investment_sites and the investmne site can carry their traffic
%   - no_investment_sites =  scenario cannot solve their traffic problem  
%**************************************************************************

% Find all the potential sites to invest according to the scenario
% EUTRAN_CA changes: EUTRAN_CA CA#1 and CA#6 change to CA#7
% CA#1: EUTRAN@2600+1800, LTE-A, R11, CA, 20+20 MHz, 64 QAM, 2x2 MIMO, 344 Mbps
% CA#6: EUTRAN@2600+2100+1800, LTE-A, R13, CA, 20+20+20 MHz, 256 QAM, 2x2 MIMO, 690 Mbps
% CA#7: EUTRAN@2600+2100+1800, LTE-A, R13, CA, 20+20+20 MHz, 256 QAM, 4x4 MIMO, 1380 Mbps

temp_RAN = 'EUTRAN_CA';
temp_RAN_spectrum = 'EUTRAN_CA';
temp_configs_inputs = {inputs_technology.(temp_RAN).configuration};
temp_investment_config_from_1 = temp_configs_inputs{1};
temp_investment_config_from_2 = temp_configs_inputs{6};

% Find the potential sites to invest from CA#1 to CA#7
temp_sites_with_EUTRAN_CA_1 = find(cellfun(@(x) strcmp(x,temp_investment_config_from_1), network_information.(temp_RAN_spectrum).configuration_per_site));
% Find the potential sites to invest from CA#6 to CA#7
temp_sites_with_EUTRAN_CA_6 = find(cellfun(@(x) strcmp(x,temp_investment_config_from_2), network_information.(temp_RAN_spectrum).configuration_per_site));
% Find the potential sites to invest 
temp_potential_sites_to_invest = unique([temp_sites_with_EUTRAN_CA_1,temp_sites_with_EUTRAN_CA_6]);

% - Find the investment_sites
% Based on traffic growth and the potential sites to invest: 
temp_investment_sites = intersect(LR_network_information_growth_snapshot.all_RAN.sites_to_invest,temp_potential_sites_to_invest);
 
% - Find the no_investment_sites and no_investment_sites_affected_by_investments
% The no_investment_sites which are inside the range of investment_sites
% are no_investment_sites_affected_by_investments
% (in toolbox of matlab, the built-in function rangesearch could be used  & improvements in algorithm are needed)
temp_no_investment_sites = setdiff(LR_network_information_growth_snapshot.all_RAN.sites_to_invest,temp_potential_sites_to_invest);
temp_no_investment_sites_affected_by_investments = [];

if ~isempty(temp_no_investment_sites)

    %site coordinates 
    temp_investment_sites_site_coord =  [site_infrastructure(temp_investment_sites).longitude; site_infrastructure(temp_investment_sites).latitude]' ;         
    temp_no_investment_sites_site_coord =  [site_infrastructure(temp_no_investment_sites).longitude; site_infrastructure(temp_no_investment_sites).latitude]' ;  
    
    temp_covering_non_investment_sites = cell(1,length(temp_investment_sites));
    for i=1:length(temp_investment_sites)       

        range = site_infrastructure(temp_investment_sites(i)).(temp_RAN).sector(1).cell_range_km *1000 *1.5;
        idx = rangesearch(temp_investment_sites_site_coord(i,:),...
                          range,...
                          temp_no_investment_sites_site_coord);

        temp_covering_non_investment_sites(i) = {temp_no_investment_sites(idx)};
    %     t=0:0.02:2*pi;
    %     x=temp_investment_sites_site_coord(i,1)+range*cos(t);
    %     y=temp_investment_sites_site_coord(i,2)+range*sin(t);
    %     figure;
    %     plot(temp_no_investment_sites_site_coord(:,1),temp_no_investment_sites_site_coord(:,2),'b.',...
    %         temp_investment_sites_site_coord(i,1),temp_investment_sites_site_coord(i,2),'r.',...
    %         temp_no_investment_sites_site_coord(idx,1),temp_no_investment_sites_site_coord(idx,2),'g.',...
    %         x,y,'r:')
    %     axis([-1500 1500 -1500 1500] )        
    end
    
    temp_no_investment_sites_affected_by_investments = unique(cell2mat(temp_covering_non_investment_sites)); 
    temp_no_investment_sites = setdiff(temp_no_investment_sites,temp_no_investment_sites_affected_by_investments); 
end


%**************************************************************************
% Part 2: Make the investments to the site infrastructure
% Changes on infrastructure
%**************************************************************************
% Copy existing infrastructure to the future one (allocate memory) 
LR_site_infrastructure = site_infrastructure; 

% Install equipment
%********************************EUTRAN_CA*********************************
temp_RAN = 'EUTRAN_CA';
temp_RAN_spectrum = 'EUTRAN_CA';
temp_sector = 'sector';
temp_cell_ID_prefix = 'Eca';
temp_investment_config_from_1 = temp_configs_inputs{1};
temp_investment_config_from_2 = temp_configs_inputs{6};
temp_investment_config = temp_configs_inputs{7};
temp_RANconfig = find(strcmp(temp_investment_config, {LR_inputs_technology.(temp_RAN).configuration}));

% throughput capabilities of new cells
temp_investment_cell_max_techlimit_throughput_Mbps_in_BH = LR_inputs_technology.EUTRAN_CA(temp_RANconfig).cell_capacity_Mbps; 
temp_investment_cell_max_techlimit_throughput = temp_investment_cell_max_techlimit_throughput_Mbps_in_BH/LR_inputs_market_industry.service.BHratio/24;
temp_investment_cell_max_safe_throughput_Mbps_in_BH = temp_investment_cell_max_techlimit_throughput_Mbps_in_BH * (1-LR_inputs_technology.extra.caproom); 
temp_investment_cell_max_safe_throughput = temp_investment_cell_max_safe_throughput_Mbps_in_BH/LR_inputs_market_industry.service.BHratio/24;


LR_site_infrastructure = invest_to_sites(LR_inputs_technology,...
                                         site_infrastructure,...
                                         LR_site_infrastructure,...
                                         network_information,...
                                         temp_RAN,...
                                         temp_RAN_spectrum,...
                                         temp_sector,...
                                         temp_cell_ID_prefix,...
                                         temp_RANconfig,...
                                         temp_investment_sites,...
                                         network_throughput_progression.(temp_RAN_spectrum)(:,:,LR_network_information_growth_snapshot.traffic_growth_snapshot_index),...
                                         LR_inputs_finance.current_year); 
                                   
% Uninstall equipment
%*********************************UTRAN************************************
temp_RAN ='UTRAN';
temp_RAN_spectrum = 'UTRAN_2100';
temp_sector = 'sector2100';
temp_remove_config = network_information.UTRAN_2100.configurations;

temp_potential_sites_to_remove_equip = find(cellfun(@(x) strcmp(x,temp_remove_config), network_information.(temp_RAN_spectrum).configuration_per_site));
temp_sites_to_remove_equip = intersect(temp_investment_sites,temp_potential_sites_to_remove_equip);


% Remove the LR_site_infrastructure.UTRAN.sector2100 structs
for i=1:length(temp_sites_to_remove_equip)
    if isfield(LR_site_infrastructure(temp_sites_to_remove_equip(i)).(temp_RAN), temp_sector)
        LR_site_infrastructure(temp_sites_to_remove_equip(i)).(temp_RAN) = rmfield(LR_site_infrastructure(temp_sites_to_remove_equip(i)).(temp_RAN),temp_sector);
    end
end

% Empty the unused LR_site_infrastructure.UTRAN structs
temp_sites_with_UTRAN_2100 = setdiff(find(network_information.UTRAN_2100.cells_per_site~=0),temp_sites_to_remove_equip);
temp_sites_with_UTRAN_900 = find(network_information.UTRAN_900.cells_per_site~=0);
temp_sites_with_UTRAN = unique([temp_sites_with_UTRAN_2100 temp_sites_with_UTRAN_900]);
temp_sites_without_UTRAN = setdiff(1:length(LR_site_infrastructure),temp_sites_with_UTRAN);

for i=1:length(temp_sites_without_UTRAN)
    LR_site_infrastructure(temp_sites_without_UTRAN(i)).(temp_RAN) = [];
end



%**************************************************************************
% Part 2: Make changes to the site infrastructure
%         Changes on throughputs after investments
%         Consider for each RAN:
% - a. traffic growth 
% - b. the investment_sites carry the total traffic of unistalled technologies 
% - c. the investment_sites carry the exceeded traffic of colocated technologies
% - d. the investment_sites carry the exceeded traffic of no_investment_sites_affected_by_investments
%**************************************************************************


% - a. only traffic growth 
%*****************************EUTRAN_single********************************
temp_RAN = 'EUTRAN_s';
temp_RAN_spectrum = 'EUTRAN_s'; 
temp_sector = 'sector';

% Allocate the new throughput to LR_site_infrastructure
LR_site_infrastructure = cell_throughput_LR_Mbps(length(LR_site_infrastructure),...
                                                 LR_site_infrastructure,...
                                                 site_infrastructure,...
                                                 temp_RAN,...
                                                 temp_sector,...
                                                 network_throughput_progression.(temp_RAN_spectrum)(:,:,LR_network_information_growth_snapshot.traffic_growth_snapshot_index));

%********************************EUTRAN_CA*********************************
temp_RAN = 'EUTRAN_CA';
temp_RAN_spectrum = 'EUTRAN_CA'; 
temp_sector = 'sector';

% Allocate the new throughput to LR_site_infrastructure
LR_site_infrastructure = cell_throughput_LR_Mbps(length(LR_site_infrastructure),...
                                                 LR_site_infrastructure,...
                                                 site_infrastructure,...
                                                 temp_RAN,...
                                                 temp_sector,...
                                                 network_throughput_progression.(temp_RAN_spectrum)(:,:,LR_network_information_growth_snapshot.traffic_growth_snapshot_index));
                                             
%*********************************UTRAN************************************
temp_RAN = 'UTRAN';
temp_RAN_spectrum = 'UTRAN_2100'; 
temp_sector = 'sector2100';

% Allocate the new throughput to LR_site_infrastructure
LR_site_infrastructure = cell_throughput_LR_Mbps(length(LR_site_infrastructure),...
                                                 LR_site_infrastructure,...
                                                 site_infrastructure,...
                                                 temp_RAN,...
                                                 temp_sector,...
                                                 network_throughput_progression.(temp_RAN_spectrum)(:,:,LR_network_information_growth_snapshot.traffic_growth_snapshot_index));                                             
                                             
temp_RAN = 'UTRAN';
temp_RAN_spectrum = 'UTRAN_900'; 
temp_sector = 'sector900';

% Allocate the new throughput to LR_site_infrastructure
LR_site_infrastructure = cell_throughput_LR_Mbps(length(LR_site_infrastructure),...
                                                 LR_site_infrastructure,...
                                                 site_infrastructure,...
                                                 temp_RAN,...
                                                 temp_sector,...
                                                 network_throughput_progression.(temp_RAN_spectrum)(:,:,LR_network_information_growth_snapshot.traffic_growth_snapshot_index));  
                                             
%*********************************GERAN************************************
temp_RAN = 'GERAN';
temp_RAN_spectrum = 'GERAN_900'; 
temp_sector = 'sector900';

% Allocate the new throughput to LR_site_infrastructure
LR_site_infrastructure = cell_throughput_LR_Mbps(length(LR_site_infrastructure),...
                                                 LR_site_infrastructure,...
                                                 site_infrastructure,...
                                                 temp_RAN,...
                                                 temp_sector,...
                                                 network_throughput_progression.(temp_RAN_spectrum)(:,:,LR_network_information_growth_snapshot.traffic_growth_snapshot_index));
                                             
                                             
temp_RAN = 'GERAN';
temp_RAN_spectrum = 'GERAN_1800'; 
temp_sector = 'sector1800';

% Allocate the new throughput to LR_site_infrastructure
LR_site_infrastructure = cell_throughput_LR_Mbps(length(LR_site_infrastructure),...
                                                 LR_site_infrastructure,...
                                                 site_infrastructure,...
                                                 temp_RAN,...
                                                 temp_sector,...
                                                 network_throughput_progression.(temp_RAN_spectrum)(:,:,LR_network_information_growth_snapshot.traffic_growth_snapshot_index));
                                             

% - b. the investment_sites carry the total traffic of unistalled technologies 
% - c. the investment_sites carry the exceeded traffic of colocated technologies
% - d. the investment_sites carry the exceeded traffic of no_investment_sites_affected_by_investments
LR_site_infrastructure = cell_throughput_correction_LR_Mbps(LR_site_infrastructure,...
                                                            network_information,...
                                                            network_throughput_progression,...
                                                            LR_network_information_growth_snapshot.traffic_growth_snapshot_index,...
                                                            temp_sites_to_remove_equip,...
                                                            temp_investment_sites,...
                                                            temp_covering_non_investment_sites,...
                                                            LR_network_information_growth_snapshot,...
                                                            temp_investment_cell_max_techlimit_throughput);

%**************************************************************************
% Part 3: Estimate the new territory coverage 
%**************************************************************************
%*****************************EUTRAN_single********************************
%no changes

%********************************EUTRAN_CA*********************************
temp_RAN = 'EUTRAN_CA';
LR_inputs_technology.LR.EUTRAN_CA_territory_coverage_new = [inputs_technology.(temp_RAN).territory_coverage];

temp_CAconfig = {inputs_technology.(temp_RAN)(:).CA_config};
temp_EUTRAN_s_cellranges = repmat(num2cell([inputs_technology.EUTRAN_s(:).cell_range_km],2),1,length(inputs_technology.(temp_RAN)));
temp_CA_ranges = cellfun(@(x,y) x.*y, temp_CAconfig,temp_EUTRAN_s_cellranges, 'UniformOutput',false);

% 1. CA#1: EUTRAN@2600+1800, LTE-A, R11, CA, 20+20 MHz, 64 QAM, 2x2 MIMO, 344 Mbps
temp_RANconfig = find(strcmp(temp_investment_config_from_1, {LR_inputs_technology.(temp_RAN).configuration}));
temp_sites_without_changes = setdiff(temp_sites_with_EUTRAN_CA_1,temp_investment_sites);
temp_cells_without_changes = network_information.(temp_RAN).cells_per_site(temp_sites_without_changes);
temp_total_cells_without_changes = sum(temp_cells_without_changes);
temp_CA_max_ranges = max(temp_CA_ranges{temp_RANconfig});
LR_inputs_technology.LR.EUTRAN_CA_territory_coverage_new(temp_RANconfig) = network_territory_coverage(inputs_market_industry.demographics.land_Area_km2,...
                                                                                         temp_total_cells_without_changes, ...
                                                                                         temp_CA_max_ranges);
% 2. CA#6: EUTRAN@2600+2100+1800, LTE-A, R13, CA, 20+20+20 MHz, 256 QAM, 2x2 MIMO, 690 Mbps
temp_RANconfig = find(strcmp(temp_investment_config_from_2, {LR_inputs_technology.(temp_RAN).configuration}));
temp_sites_without_changes = setdiff(temp_sites_with_EUTRAN_CA_6,temp_investment_sites);
temp_cells_without_changes = network_information.EUTRAN_CA.cells_per_site(temp_sites_without_changes);
temp_total_cells_without_changes = sum(temp_cells_without_changes);
temp_CA_max_ranges = max(temp_CA_ranges{temp_RANconfig});
LR_inputs_technology.LR.EUTRAN_CA_territory_coverage_new(temp_RANconfig) = network_territory_coverage(inputs_market_industry.demographics.land_Area_km2,...
                                                                                         temp_total_cells_without_changes, ...
                                                                                         temp_CA_max_ranges);

% 3. CA#7: EUTRAN@2600+2100+1800, LTE-A, R13, CA, 20+20+20 MHz, 256 QAM, 4x4 MIMO, 1380 Mbps
temp_RANconfig = find(strcmp(temp_investment_config, {LR_inputs_technology.(temp_RAN).configuration}));
temp_CA_max_ranges = max(temp_CA_ranges{temp_RANconfig});
temp_cells_with_changes = network_information.EUTRAN_CA.cells_per_site(temp_investment_sites);
temp_total_cells_with_changes = sum(temp_cells_with_changes);
LR_inputs_technology.LR.EUTRAN_CA_territory_coverage_new(temp_RANconfig) = network_territory_coverage(inputs_market_industry.demographics.land_Area_km2,...
                                                                                         temp_total_cells_with_changes, ...
                                                                                         temp_CA_max_ranges);
                                                                                     
%*********************************UTRAN************************************
LR_inputs_technology.LR.UTRAN_territory_coverage_new = [inputs_technology.UTRAN.territory_coverage];

% UTRAN_2100            
temp_RAN = 'UTRAN';
temp_RANconfig = find(strcmp(temp_remove_config, {LR_inputs_technology.(temp_RAN).configuration}));
temp_sites_without_changes = setdiff(temp_potential_sites_to_remove_equip,temp_investment_sites);
temp_cells_without_changes = network_information.UTRAN_2100.cells_per_site(temp_sites_without_changes);
temp_total_cells_without_changes = sum(temp_cells_without_changes);
temp_cell_ranges = [inputs_technology.UTRAN.cell_range_km];
LR_inputs_technology.LR.UTRAN_territory_coverage_new(temp_RANconfig) = network_territory_coverage(inputs_market_industry.demographics.land_Area_km2,...
                                                                                     temp_total_cells_without_changes, ...
                                                                                     temp_cell_ranges(temp_RANconfig));
                                                                                 
%*********************************GERAN************************************
%no changes


LR_network_information_growth_snapshot.critical_sites.potential_sites_to_invest = temp_potential_sites_to_invest;
LR_network_information_growth_snapshot.critical_sites.investment_sites = temp_investment_sites;
LR_network_information_growth_snapshot.critical_sites.investment_sites_covering_other_sites_info = temp_covering_non_investment_sites;
LR_network_information_growth_snapshot.critical_sites.no_investment_sites_affected_by_investments = temp_no_investment_sites_affected_by_investments;
LR_network_information_growth_snapshot.critical_sites.no_investment_sites = temp_no_investment_sites;
LR_network_information_growth_snapshot.critical_sites.potential_sites_to_remove_equip = temp_potential_sites_to_remove_equip;
LR_network_information_growth_snapshot.critical_sites.sites_to_remove_equip = temp_sites_to_remove_equip;

clear i idx range temp_CA_max_ranges temp_CA_ranges temp_CAconfig temp_EUTRAN_s_cellranges temp_RAN temp_RAN_spectrum temp_RANconfig temp_cell_ID_prefix ...
    temp_cell_ranges temp_cells_without_changes temp_configs_inputs temp_investment_cell_max_safe_throughput temp_investment_cell_max_safe_throughput_Mbps_in_BH ...
    temp_investment_cell_max_techlimit_throughput temp_investment_cell_max_techlimit_throughput_Mbps_in_BH temp_investment_config temp_investment_config_from_1...
    temp_investment_config_from_2 temp_investment_sites_site_coord temp_no_investment_sites_site_coord temp_remove_config temp_sector ...
    temp_sites_with_EUTRAN_CA_1 temp_sites_with_EUTRAN_CA_6 temp_sites_with_UTRAN temp_sites_with_UTRAN_2100 temp_sites_with_UTRAN_900 temp_sites_without_UTRAN...
    temp_sites_without_changes temp_total_cells_without_changes;
clear temp_covering_non_investment_sites temp_investment_sites temp_no_investment_sites temp_no_investment_sites_affected_by_investments ...
    temp_potential_sites_to_invest temp_potential_sites_to_remove_equip temp_sites_to_remove_equip temp_cells_with_changes temp_total_cells_with_changes;