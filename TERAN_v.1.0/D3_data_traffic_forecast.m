%****************Mobile data traffic growth forecast**********************
% using datafit software we got the coefficients for:
% Exponential (best Rsquare) (medium)
a1 = 283489.251285675;
b1 = 0.577419440604293;
X0 = 1:0.01:10;
Y0 = a1*exp(b1*X0);
T0 = 2006 + X0;

X1 = 10:0.01:14;
Y1 = a1*exp(b1*X1);
T1 = 2006 + X1;
CAGR1 = (Y1(end)/inputs_demand_parameters.quantity(end))^(1/(T1(end)-T0(end)))-1;

% Geometric -exponential (high)
a2 = 1301928.84075009;
b2 = 0.184796843078914;
X2 = 10:0.01:14;
Y2 = a2*X2.^(b2*X2);
T2 = 2006 + X2;
CAGR2 = (Y2(end)/inputs_demand_parameters.quantity(end))^(1/(T2(end)-T0(end)))-1;

% Power (low)
a3 = 960.661642513998;
b3 = 4.97228078681757;
X3 = 10:0.01:14;
Y3 = a3*X3.^b3;
T3 = 2006 + X3;
CAGR3 = (Y3(end)/inputs_demand_parameters.quantity(end))^(1/(T3(end)-T0(end)))-1;

market_demand_revenues.traffic_fit.Y = Y0;
market_demand_revenues.traffic_fit.T = T0;
market_demand_revenues.traffic_forecast_exponential.Y = Y1;
market_demand_revenues.traffic_forecast_exponential.T = T1;
market_demand_revenues.traffic_forecast_exponential.CAGR = CAGR1;
market_demand_revenues.traffic_forecast_geometric.Y = Y2;
market_demand_revenues.traffic_forecast_geometric.T = T2;
market_demand_revenues.traffic_forecast_geometric.CAGR = CAGR2;
market_demand_revenues.traffic_forecast_power.Y = Y3;
market_demand_revenues.traffic_forecast_power.T = T3;
market_demand_revenues.traffic_forecast_power.CAGR = CAGR3;



       