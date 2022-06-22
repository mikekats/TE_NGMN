%***********Market and Individual Demand of mobile data traffic (Estimation)*************    

%**************************************************************************
% Part 1: Market Demand - Simple regression
% If we believe that price alone determines demand, it would be plausible to
% describe the demand for the product by drawing a straight line which "fit"
% the points Qlog Plog. The function P represent the inverse demand for the mobile data traffic 
% only if no important factors other than price affect demand. 
%**************************************************************************

% fitting the quantity - price  points
Qlog = log(inputs_demand_parameters.quantity);
Plog = log(inputs_demand_parameters.determinants_of_demand.price);
[p, r] = polyfit(Qlog,Plog,1);
alfa = p(1);
beta = p(2);

% Estimated inverse demand function (only price P influences the demand)
Plog_est = alfa*Qlog + beta;

% Calculate Rsquare
%Rsquare = 1 - r.normr^2 / norm(Plog_est-mean(Plog_est))^2;      


%**************************************************************************
% Part 2: Market Demand - Multiple regression
% More determinants of demand: the user experienced/expected data rate factor. 
% Note that this factor (G) has increased once during the study, suggesting that the demand
% curve has shifted. Thus demand curves d1 and d2 give a more likely description of demand.
%**************************************************************************

% fitting the quantity - price  points with multiple regression
QlogG = log(inputs_demand_parameters.quantity)';
GlogG = log(inputs_demand_parameters.determinants_of_demand.experienced_user_data_rate_factor)';
PlogG = log(inputs_demand_parameters.determinants_of_demand.price)';
coeffG = [QlogG GlogG ones(size(QlogG))]\PlogG;
alfaG = coeffG(1, 1);
betaG = coeffG(2, 1);
gamaG = coeffG(3, 1);

% Estimated inverse demand function (price P and experienced user data rate factor G influence the demand)
% 3G Era (2007-2011): PlogG_est(1:5)
% 4G Era (2012-2016): PlogG_est(6:10)
PlogG_est = alfaG * QlogG + betaG * GlogG + gamaG;

% Calculate Rsquare
%RsquareG = 1 - sum((Plog-PlogG_est').^2)/sum((Plog-sum(Plog)/length(Plog)).^2);
%Rsquare3G = 1 - sum((Plog(1:5)-PlogG_est(1:5)').^2)/sum((Plog(1:5)-sum(Plog(1:5))/length(Plog(1:5))).^2);
%Rsquare4G = 1 - sum((Plog(6:10)-PlogG_est(6:10)').^2)/sum((Plog(6:10)-sum(Plog(6:10))/length(Plog(6:10))).^2);


%**************************************************************************
% Part 3: Individual Demand  - One mobile operator
% Based on the multiple regression
% Assumption: The market quantity is divided by operator's market share
%**************************************************************************

operator_quantity = inputs_demand_parameters.quantity .* inputs_demand_parameters.market_share_mno;

% fitting the quantity - price  points with multiple regression
% assumption: Operator as price-taker
QlogG_mno = log(operator_quantity)';
GlogG_mno = log(inputs_demand_parameters.determinants_of_demand.experienced_user_data_rate_factor)';
PlogG_mno = log(inputs_demand_parameters.determinants_of_demand.price)';
coeffG_mno = [QlogG_mno GlogG_mno ones(size(QlogG_mno))]\PlogG_mno;
alfaG_mno = coeffG_mno(1, 1);
betaG_mno = coeffG_mno(2, 1);
gamaG_mno = coeffG_mno(3, 1);

% Estimated inverse demand function (price P and experienced user data rate factor G influence the demand)
% 3G Era (2007-2011): PlogG_est_mno(1:5)
% 4G Era (2012-2016): PlogG_est_mno(6:10)
PlogG_est_mno = alfaG_mno * QlogG_mno + betaG_mno * GlogG_mno + gamaG_mno;


%**************************************************************************
% Part 4: Individual Demand - One mobile operator in specific region
% Based on the multiple regression
% Assumption1: The operator quantity is shared based on the region data
% weighting factor in 2016
% Assumption2: The region weighting factor is the same over the past years
%**************************************************************************

operator_region_data_weight_factor = (network_information.all_RAN.total_throughput_Mbps*60*60*24*30/8/1024)*...
                                        (1+inputs_market_industry.service.ULtoDLratio)/...
                                        operator_quantity(end);

operator_quantity_region = operator_quantity .* operator_region_data_weight_factor;

% fitting the quantity - price  points with multiple regression
% assumption: Operator as price-taker
QlogG_mno_region = log(operator_quantity_region)';
GlogG_mno_region = log(inputs_demand_parameters.determinants_of_demand.experienced_user_data_rate_factor)';
PlogG_mno_region = log(inputs_demand_parameters.determinants_of_demand.price)';
coeffG_mno_region = [QlogG_mno_region GlogG_mno_region ones(size(QlogG_mno_region))]\PlogG_mno_region;
alfaG_mno_region = coeffG_mno_region(1, 1);
betaG_mno_region = coeffG_mno_region(2, 1);
gamaG_mno_region = coeffG_mno_region(3, 1);

% Estimated inverse demand function (price P and experienced user data rate factor G influence the demand)
% 3G Era (2007-2011): PlogG_est_mno_region(1:5)
% 4G Era (2012-2016): PlogG_est_mno_region(6:10)
PlogG_est_mno_region = alfaG_mno_region * QlogG_mno_region + betaG_mno_region * GlogG_mno_region + gamaG_mno_region;

%**************************************************************************
% Set variable to structure
%**************************************************************************

market_demand_revenues.inverse_demand_simple_2007_2016.quantity_log = Qlog;
market_demand_revenues.inverse_demand_simple_2007_2016.price_log = Plog_est;     
                       
market_demand_revenues.inverse_demand_multiple_3G_2007_2011.quantity_log = QlogG(1:5)';
market_demand_revenues.inverse_demand_multiple_3G_2007_2011.price_log = PlogG_est(1:5)';  
market_demand_revenues.inverse_demand_multiple_4G_2012_2016.quantity_log = QlogG(6:10)';
market_demand_revenues.inverse_demand_multiple_4G_2012_2016.price_log = PlogG_est(6:10)';  
market_demand_revenues.inverse_demand_multiple_3G_2007_2011.alfa = alfaG;
market_demand_revenues.inverse_demand_multiple_3G_2007_2011.beta = betaG;
market_demand_revenues.inverse_demand_multiple_3G_2007_2011.gama = gamaG;  
market_demand_revenues.inverse_demand_multiple_4G_2012_2016.alfa = alfaG;
market_demand_revenues.inverse_demand_multiple_4G_2012_2016.beta = betaG;
market_demand_revenues.inverse_demand_multiple_4G_2012_2016.gama = gamaG;

market_demand_revenues.inverse_demand_multiple_3G_2007_2011_mno.quantity_log = QlogG_mno(1:5)';
market_demand_revenues.inverse_demand_multiple_3G_2007_2011_mno.price_log = PlogG_est_mno(1:5)';  
market_demand_revenues.inverse_demand_multiple_4G_2012_2016_mno.quantity_log = QlogG_mno(6:10)';
market_demand_revenues.inverse_demand_multiple_4G_2012_2016_mno.price_log = PlogG_est_mno(6:10)';  

market_demand_revenues.inverse_demand_multiple_3G_2007_2011_mno_region.quantity_log = QlogG_mno_region(1:5)';
market_demand_revenues.inverse_demand_multiple_3G_2007_2011_mno_region.price_log = PlogG_est_mno_region(1:5)';  
market_demand_revenues.inverse_demand_multiple_4G_2012_2016_mno_region.quantity_log = QlogG_mno_region(6:10)';
market_demand_revenues.inverse_demand_multiple_4G_2012_2016_mno_region.price_log = PlogG_est_mno_region(6:10)'; 
market_demand_revenues.inverse_demand_multiple_4G_2012_2016_mno_region.alfa = alfaG_mno_region; 
market_demand_revenues.inverse_demand_multiple_4G_2012_2016_mno_region.beta = betaG_mno_region; 
market_demand_revenues.inverse_demand_multiple_4G_2012_2016_mno_region.gama = gamaG_mno_region; 

market_demand_revenues.operator_region_data_weight_factor = operator_region_data_weight_factor;

      