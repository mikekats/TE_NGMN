% Forecast years

scenario = 'medium';
market = 'MNO_regional'; 
time = LR_network_information_growth_snapshot.traffic_growth_snapshot_time{2};
switch time
    case '2017'
        year = 'year_1';
        i=1;
    case '2018'
        year = 'year_2';
        i=2;
    case '2019'
        year = 'year_3';
        i=3;
    case '2020'
        year = 'year_4';
        i=4;
    case '2021'
        year = 'year_5';
        i=4; % 2012 is not in the arrays. So use the variables for year_4(2020). It applies on high traffi growth scenario
end
                    
MNO_region_traffic = LR_network_information.all_RAN.total_throughput_Mbps * ...
                    (1+LR_inputs_market_industry.service.ULtoDLratio)*60*60*24*30/8/1024; % regional throughput in GB/mon (UL+DL)

QlogG_m_mno_region = market_demand_revenues.inverse_demand_forecast_annual_equilibria.mediumSc_quantity(end) .*...
    inputs_demand_parameters.future_market_share_mno(end) .* market_demand_revenues.operator_region_data_weight_factor; 


market_demand_revenues.inverse_demand.(year).(market).(scenario).actual = calculate_inverse_demand(...
                                                                market_demand_revenues.inverse_demand_multiple_4G_2012_2016_mno_region.alfa,...
                                                                market_demand_revenues.inverse_demand_multiple_4G_2012_2016_mno_region.beta,...
                                                                market_demand_revenues.inverse_demand_multiple_4G_2012_2016_mno_region.gama,...
                                                                inputs_demand_parameters.determinants_of_demand.future_experienced_user_data_rate_factor(i),...
                                                                MNO_region_traffic,...
                                                                QlogG_m_mno_region(end),...
                                                                length(network_information.all_RAN.mobile_data_traffic_from_zero_Mbps));

clear MNO_region_traffic year i QlogG_m_mno_region scenario market time