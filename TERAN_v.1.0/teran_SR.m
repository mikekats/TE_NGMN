%**************************************************************************
% Short-Run cost model
%**************************************************************************

read_flag = 1; 
write_flag = 1;

SR1_inputs_market_industry;
SR2_inputs_technology_spectrum;
SR3_inputs_costs;
SR4_inputs_finance;

if ~read_flag
    SR5_supply_cell;
    SR6_demand_cell;
    SR7_site_infrastructure_positions;
    SR8_site_infrastructure_layout;
    
    if write_flag
        io_write_site_infrastructure_to_file(site_infrastructure);
    end
    
else
    site_infrastructure = io_read_site_infrastructure_from_file('cells_EUTRAN_s.txt', 'cells_EUTRAN_CA.txt', 'cells_UTRAN.txt', 'cells_GERAN.txt');
end

SR9_network_information;
SR10_assets_value;
SR11_operating_costs;

clear read_flag write_flag load_flag