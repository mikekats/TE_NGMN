%*****************************Demand forecast*****************************
% Demand in 2017-2019: Shifting the demand curve
% 4G pro Era (2017-2019): PlogG_pro

% experienced user data rates factor for 4G pro
GlogG_pro = log(inputs_demand_parameters.determinants_of_demand.future_experienced_user_data_rate_factor(1:3));
QlogG_pro = log([inputs_demand_parameters.quantity market_demand_revenues.traffic_forecast_geometric.Y*1.5]); % the high mobile data trafic forecast scenario 

% Forecasted inverse demand function (price P and experienced user data rate factor G influence the demand)
PlogG_pro = alfaG * QlogG_pro + betaG * GlogG_pro(1) + gamaG;


% Demand in 2020: Shifting the demand curve
% 5G Era (2020-): PlogG_2020

% experienced user data rates factor for the first phase of 5G deployment
GlogG_2020 = log(inputs_demand_parameters.determinants_of_demand.future_experienced_user_data_rate_factor(4));
QlogG_2020 = log([inputs_demand_parameters.quantity market_demand_revenues.traffic_forecast_geometric.Y*1.5]); % the high mobile data trafic forecast scenario 

% Forecasted inverse demand function (price P and experienced user data rate factor G influence the demand)
PlogG_2020 = alfaG * QlogG_2020 + betaG * GlogG_2020 + gamaG;


% Equilibria based on traffic growth scenario 
% Generation factor 
Glog_2017_2020 = log(inputs_demand_parameters.determinants_of_demand.future_experienced_user_data_rate_factor);
% Quantities  
QlogG_h_2017_2020 = log(market_demand_revenues.traffic_forecast_geometric.Y(101:100:401)); % the high mobile data trafic forecast scenario 
QlogG_m_2017_2020 = log(market_demand_revenues.traffic_forecast_exponential.Y(101:100:401)); % the medium mobile data trafic forecast scenario 
QlogG_l_2017_2020 = log(market_demand_revenues.traffic_forecast_power.Y(101:100:401)); % the low mobile data trafic forecast scenario 
% Prices 
PlogG_h_2017_2020 = alfaG * QlogG_h_2017_2020 + betaG * Glog_2017_2020 + gamaG;
PlogG_m_2017_2020 = alfaG * QlogG_m_2017_2020 + betaG * Glog_2017_2020 + gamaG;
PlogG_l_2017_2020 = alfaG * QlogG_l_2017_2020 + betaG * Glog_2017_2020 + gamaG;

% Potential market equilibria in 2020
Qlog_h_2020 = QlogG_h_2017_2020(end);
Plog_h_2020 = PlogG_h_2017_2020(end);
Qlog_m_2020 = QlogG_m_2017_2020(end);
Plog_m_2020 = PlogG_m_2017_2020(end);
Qlog_l_2020 = QlogG_l_2017_2020(end);
Plog_l_2020 = PlogG_l_2017_2020(end);

market_demand_revenues.inverse_demand_forecast_annual_equilibria.mediumSc_quantity = exp(QlogG_m_2017_2020);
market_demand_revenues.inverse_demand_forecast_annual_equilibria.mediumSc_price = exp(PlogG_m_2017_2020);
market_demand_revenues.inverse_demand_forecast_annual_equilibria.lowSc_quantity = exp(QlogG_l_2017_2020);
market_demand_revenues.inverse_demand_forecast_annual_equilibria.lowSc_price = exp(PlogG_l_2017_2020);
market_demand_revenues.inverse_demand_forecast_annual_equilibria.highSc_quantity = exp(QlogG_h_2017_2020);
market_demand_revenues.inverse_demand_forecast_annual_equilibria.highSc_price = exp(PlogG_l_2017_2020);
market_demand_revenues.inverse_demand_forecast_annual_equilibria.years = market_demand_revenues.traffic_forecast_geometric.T(101:100:401);

market_demand_revenues.inverse_demand_forecast4Gpro.quantity_log_pro = QlogG_pro;
market_demand_revenues.inverse_demand_forecast4Gpro.price_log_pro = PlogG_pro;
market_demand_revenues.inverse_demand_forecast4Gpro.alfa_pro = alfaG;
market_demand_revenues.inverse_demand_forecast4Gpro.beta_pro = betaG;
market_demand_revenues.inverse_demand_forecast4Gpro.gama_pro = gamaG;
market_demand_revenues.inverse_demand_forecast4Gpro.price_elasticity_of_demand_pro = 1/alfaG;
market_demand_revenues.inverse_demand_forecast2020.quantity_log_2020 = QlogG_2020;
market_demand_revenues.inverse_demand_forecast2020.price_log_2020 = PlogG_2020;
market_demand_revenues.inverse_demand_forecast2020.alfa_2020 = alfaG;
market_demand_revenues.inverse_demand_forecast2020.beta_2020 = betaG;
market_demand_revenues.inverse_demand_forecast2020.gama_2020 = gamaG;
market_demand_revenues.inverse_demand_forecast2020.price_elasticity_of_demand_2020 = 1/alfaG;
market_demand_revenues.inverse_demand_forecast2020.highSc_quantity_log_2020 = Qlog_h_2020;
market_demand_revenues.inverse_demand_forecast2020.highSc_price_log_2020 = Plog_h_2020;
market_demand_revenues.inverse_demand_forecast2020.mediumSc_quantity_log_2020 = Qlog_m_2020;
market_demand_revenues.inverse_demand_forecast2020.mediumSc_price_log_2020 = Plog_m_2020;
market_demand_revenues.inverse_demand_forecast2020.lowSc_quantity_log_2020 = Qlog_l_2020;
market_demand_revenues.inverse_demand_forecast2020.lowSc_price_log_2020 = Plog_l_2020;

