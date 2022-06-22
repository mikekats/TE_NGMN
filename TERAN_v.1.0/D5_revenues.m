% Past Annual Revenues (TR)

% Actual Market Annual Revenues for data services
TR_3G = 12 .* (inputs_demand_parameters.quantity(1:5)./(1+inputs_market_industry.service.ULtoDLratio)).* inputs_demand_parameters.determinants_of_demand.price(1:5);
TR_4G = 12 .* (inputs_demand_parameters.quantity(6:10)./(1+inputs_market_industry.service.ULtoDLratio)) .* inputs_demand_parameters.determinants_of_demand.price(6:10);

% MNO Annual Revenues for data services
TR_3G_mno = 12 .* (operator_quantity(1:5)./(1+inputs_market_industry.service.ULtoDLratio)) .* inputs_demand_parameters.determinants_of_demand.price(1:5);
TR_4G_mno = 12 .* (operator_quantity(6:10)./(1+inputs_market_industry.service.ULtoDLratio)) .* inputs_demand_parameters.determinants_of_demand.price(6:10);

% MNO Annual Revenues for data services in the region
TR_3G_mno_region = 12 .* (operator_quantity_region(1:5)./(1+inputs_market_industry.service.ULtoDLratio)) .* inputs_demand_parameters.determinants_of_demand.price(1:5);
TR_4G_mno_region = 12 .* (operator_quantity_region(6:10)./(1+inputs_market_industry.service.ULtoDLratio)) .* inputs_demand_parameters.determinants_of_demand.price(6:10);


% Forecast Annual Revenues (TR)

TR_h_2020 = 12 .* (exp(QlogG_h_2017_2020)./(1+inputs_market_industry.service.ULtoDLratio)) .* exp(PlogG_h_2017_2020);
TR_m_2020 = 12 .* (exp(QlogG_m_2017_2020)./(1+inputs_market_industry.service.ULtoDLratio)) .* exp(PlogG_m_2017_2020);
TR_l_2020 = 12 .* (exp(QlogG_l_2017_2020)./(1+inputs_market_industry.service.ULtoDLratio)) .* exp(PlogG_l_2017_2020);


market_demand_revenues.annual_revenue = [TR_3G TR_4G];
market_demand_revenues.annual_revenue_mno_region = [TR_3G_mno_region TR_4G_mno_region];
market_demand_revenues.annual_revenue_high = TR_h_2020;
market_demand_revenues.annual_revenue_medium = TR_m_2020;
market_demand_revenues.annual_revenue_low = TR_l_2020;