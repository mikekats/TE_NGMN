% Estimation Year
%*************************************************************************
year = 'year_0';
scenario = 'estimation';
market = 'total';

market_demand_revenues.inverse_demand.(year).(market).(scenario) = calculate_inverse_demand(alfaG, betaG, gamaG,...
                                                                     inputs_demand_parameters.determinants_of_demand.experienced_user_data_rate_factor(end),...
                                                                     inputs_demand_parameters.quantity(10),...
                                                                     exp(QlogG_2020(end)),...
                                                                     length(network_information.all_RAN.mobile_data_traffic_from_zero_Mbps));

market = 'MNO_regional';    

%Assuming market share equals to 2016 level                            
QlogG_2020_mno_region = exp(QlogG_2020) .* inputs_demand_parameters.future_market_share_mno(end) .* operator_region_data_weight_factor;
QlogG_2020_m_mno_region = exp(QlogG_m_2017_2020(end)) .* inputs_demand_parameters.future_market_share_mno(end) .* operator_region_data_weight_factor;

market_demand_revenues.inverse_demand.(year).(market).(scenario) = calculate_inverse_demand(alfaG_mno_region, betaG_mno_region, gamaG_mno_region,...
                                                                     inputs_demand_parameters.determinants_of_demand.experienced_user_data_rate_factor(end),...
                                                                     operator_quantity_region(10),...
                                                                     QlogG_2020_mno_region(end),...
                                                                     length(network_information.all_RAN.mobile_data_traffic_from_zero_Mbps));
                                                  
 % Forecast years
 years = market_demand_revenues.inverse_demand_forecast_annual_equilibria.years;
 years_num = {'year_1'; 'year_2'; 'year_3'; 'year_4'};
%*************************************************************************
for i = 1: length(years)
    year = years_num{i};
    scenario = 'medium';
    market = 'total';

    market_demand_revenues.inverse_demand.(year).(market).(scenario) = calculate_inverse_demand(alfaG, betaG, gamaG,...
                                                                         inputs_demand_parameters.determinants_of_demand.future_experienced_user_data_rate_factor(i),...
                                                                         exp(QlogG_m_2017_2020(i)),...
                                                                         exp(QlogG_2020(end)),...
                                                                         length(network_information.all_RAN.mobile_data_traffic_from_zero_Mbps));

    market = 'MNO_regional'; 

    %Assuming market share equals to 2016 level                            
    QlogG_2020_mno_region = exp(QlogG_2020) .* inputs_demand_parameters.future_market_share_mno(end) .* operator_region_data_weight_factor;
    QlogG_2020_m_mno_region = exp(QlogG_m_2017_2020(i)) .* inputs_demand_parameters.future_market_share_mno(i) .* operator_region_data_weight_factor;

    market_demand_revenues.inverse_demand.(year).(market).(scenario) = calculate_inverse_demand(alfaG_mno_region, betaG_mno_region, gamaG_mno_region,...
                                                                         inputs_demand_parameters.determinants_of_demand.future_experienced_user_data_rate_factor(i),...
                                                                         QlogG_2020_m_mno_region,...
                                                                         QlogG_2020_mno_region(end),...
                                                                         length(network_information.all_RAN.mobile_data_traffic_from_zero_Mbps));
end

clear alfa beta gama alfaG betaG gamaG alfaG_mno alfaG_mno_region betaG_mno betaG_mno_region gamaG_mno gamaG_mno_region  ...
    coeffG coeffG_mno coeffG_mno_region X p r CAGR1 CAGR2 CAGR3 Y0 Y1 Y2 Y3 T0 T1 T2 T3 X0 X1 X2 X3 a1 a2 a3 b1 b2 b3 ...
    operator_region_data_weight_factor operator_quantity_region operator_quantity TR_2016 TR_2016_l TR_2016_mno_region TR_2016_mno_region_l...
    TR_2020 TR_2020_l TR_2020_mno_region TR_2020_mno_region_l TR_3G TR_3G_mno TR_3G_mno_region TR_4G TR_4G_mno TR_4G_mno_region TR_h_2020 TR_m_2020 TR_l_2020...
    GlogG GlogG_2020 GlogG_mno GlogG_mno_region GlogG_pro Glog_2017_2020 MR_2016 MR_2016_l MR_2016_mno_region MR_2016_mno_region_l ...
    MR_2020 MR_2020_l MR_2020_mno_region MR_2020_mno_region_l P_2016 P_2016_l P_2016_mno_region P_2016_mno_region_l P_2020 P_2020_l ...
    P_2020_mno_region P_2020_mno_region_l Plog PlogG PlogG_2020 PlogG_est PlogG_est_mno PlogG_est_mno_region ...
    PlogG_mno PlogG_mno_region PlogG_pro Plog_est Plog_h_2020 Plog_l_2020 Plog_m_2020 Q_2016 Q_2016_l Q_2016_mno_region ...
    Q_2016_mno_region_l Q_2020 Q_2020_l Q_2020_mno_region Q_2020_mno_region_l Qlog QlogG QlogG_2020 QlogG_2020_m_mno_region QlogG_2020_mno_region ...
    QlogG_mno QlogG_mno_region QlogG_pro Qlog_h_2020 Qlog_l_2020 Qlog_m_2020 QlogG_h_2017_2020 QlogG_m_2017_2020 ...
    QlogG_l_2017_2020 PlogG_h_2017_2020 PlogG_m_2017_2020 PlogG_l_2017_2020 market scenario year years years_num