function traffic_growth_time = convert_trafficGrowth_to_time(growth,...
                                                         future_market_share_mno,...
                                                         annual_equilibria,...
                                                         data_weight_factor,...
                                                         total_throughput_Mbps,...
                                                         ULtoDLratio)
%convert_trafficGrowth_to_time Summary of this function goes here
%   Detailed explanation goes here


% Annual Traffic growth based on forecast in D3 (for one operator)
% Convert the traffic growth to time to see when investmest should be taken
annual_growth_lowSc = (annual_equilibria.lowSc_quantity .* ...
                       future_market_share_mno.* data_weight_factor) /...
                       ((total_throughput_Mbps*60*60*24*30/8/1024)*(1+ULtoDLratio));

annual_growth_mediumSc = (annual_equilibria.mediumSc_quantity .* ...
                          future_market_share_mno.* data_weight_factor) /...
                          ((total_throughput_Mbps*60*60*24*30/8/1024)*(1+ULtoDLratio)); 

annual_growth_highSc = (annual_equilibria.highSc_quantity .* ...
                        future_market_share_mno.* data_weight_factor) /...
                        ((total_throughput_Mbps*60*60*24*30/8/1024)*(1+ULtoDLratio));

forecast_years = annual_equilibria.years;

temp_data = [annual_growth_lowSc;
             annual_growth_mediumSc;
             annual_growth_highSc];

% time (year) 
traffic_growth_time = cell(1,size(temp_data,1));
for i = 1:size(temp_data,1)
    temp_time = find(growth > temp_data(i,:));
    if isempty(temp_time)
        traffic_growth_time{i} = num2str(forecast_years(1));
    else
        if temp_time(end) == length(forecast_years)
            traffic_growth_time{i} = 'beyond 2020';
        else
            traffic_growth_time{i} = num2str(forecast_years(temp_time(end))+1);
        end
    end
end

end

