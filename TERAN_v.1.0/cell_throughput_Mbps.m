function [temp_cells_throughout] = cell_throughput_Mbps(cell_capacity_Mbps, caproom, traffic_distribution_among_sites, BHratio, cells, len)
%cell_throughtput_Mbps distributes traffic to cells
%   Detailed explanation goes here
% Bottom up approach: from the cell capacity to the total traffic volume
% Assumption: The network has been built to serve the current traffic level
% plus some extra traffic room (caproom) during busy hour.
% Thus, the cell capacity (minus the caproom), taking into account traffic characteristics (busy hour, traffic disctibution among sites),
% is the demanded traffic, i.e., cell thoughtput

temp_avrgcellthroughput_DL_Mbps = ...                                  % average throughput per RAN configuration cell in DL Mbps 
                                (((cell_capacity_Mbps).*...            % typical cell capacity in DL Mbps 
                                (1-caproom))*...                       % typical cell capacity in DL Mbps with caproom = maximum cell throughtput in DL Mbps with caproon (incl., BH, TrD)
                                traffic_distribution_among_sites)/...  % average throughput in DL Mbps with caproom (incl., BH)
                                BHratio/24;                            % average throughput in DL Mbps with caproom

temp_maxcellthroughput_DL_Mbps = ...                                   % average throughput per RAN configuration cell in DL Mbps 
                                cell_capacity_Mbps./...                % typical cell capacity in DL Mbps = maximum cell throughtput in DL Mbps in BH
                                BHratio/24;                            % max throughput in DL Mbps 

temp_max_operational_cellthroughput_DL_Mbps = ...                      % average throughput per RAN configuration cell in DL Mbps 
                                            cell_capacity_Mbps.*...    % typical cell capacity in DL Mbps = maximum cell throughtput in DL Mbps in BH
                                            (1-caproom)./...           % maximum cell throughtput in DL Mbps in BH with the caproom 
                                            BHratio/24;                % max throughput in DL Mbps  with the caproom
                            
% However, the traffic is spacially distributed among sites (or cells). 
% For example: We know that, 15% of sites carry 50% of demanded raffic (traffic_distribution_among_sites=0.3).
% The share of sites with high load is (traffic_distribution_among_sites * 0.5 = 15%)
% The share of sites with low load is (1 - (traffic_distribution_among_sites * 0.5) = 75%)
temp_highload_cells = ceil(cells*(traffic_distribution_among_sites* 0.5));
temp_lowload_cells = floor(cells*(1 - (traffic_distribution_among_sites* 0.5)));
temp_AvrgCell_highload_cells_DL_Mbps = (0.5 * temp_avrgcellthroughput_DL_Mbps) ./ (traffic_distribution_among_sites* 0.5);  % this is the max temp_max_operational_cellthroughput_DL_Mbps
temp_AvrgCell_lowload_cells_DL_Mbps = (0.5 * temp_avrgcellthroughput_DL_Mbps) ./ (1 - (traffic_distribution_among_sites* 0.5));

% Generate cell traffic per configuration
% The traffic in a cell follows an exponential distribution
% mean value for the exponential distribution rate parameter
temp_hl_lmd = 1./temp_AvrgCell_highload_cells_DL_Mbps;
temp_hl_lmd(isinf(temp_hl_lmd))=0;
temp_ll_lmd = 1./temp_AvrgCell_lowload_cells_DL_Mbps;
temp_ll_lmd(isinf(temp_ll_lmd))=0;

% While loop, because the sum of randomly distributed traffic to cells (temp_RANconfig_capacity_random) 
% cannot be higher than the maximum traffic that the network can carry taking into account
% traffic characteristics (temp_RANconfig_capacity)
% In other words, the throughput cannot be higher than temp_maxcellthroughput_DL_Mbps
temp_cells_throughout = cell(1,len);
for i = 1:len
    temp_lmd = [ones(1,temp_highload_cells(i))*temp_hl_lmd(i) ones(1,temp_lowload_cells(i))*temp_ll_lmd(i)];
    temp_lmd = temp_lmd(randperm(length(temp_lmd)));
   
    temp_cells_throughout{i} = temp_maxcellthroughput_DL_Mbps(i) +1;
    while max(temp_cells_throughout{i}) > temp_maxcellthroughput_DL_Mbps(i)
        temp_cells_throughout{i} = (-log(rand(length(temp_lmd),1))')./temp_lmd;
    end
    
%     temp_RANconfig_capacity = temp_avrgcellthroughput_DL_Mbps(i)*cells(i)*(1+caproom);  
%     temp_RANconfig_capacity_random = temp_RANconfig_capacity + 1;
%     while temp_RANconfig_capacity < temp_RANconfig_capacity_random
%         temp_lmd = [ones(1,temp_highload_cells(i))*temp_hl_lmd(i) ones(1,temp_lowload_cells(i))*temp_ll_lmd(i)];
%         temp_lmd = temp_lmd(randperm(length(temp_lmd)));
%         temp_cells_throughout{i} = (-log(rand(length(temp_lmd),1))')./temp_lmd;
%         temp_RANconfig_capacity_random = sum([temp_cells_throughout{i}]);
%     end  

end

end

% Complete assumption:
% CUrrent network is built to carry current traffic with a capacity room
% (caproom) in BH and traffic distribution statement as following.."15/ of
% sites carry 50% of traffic"