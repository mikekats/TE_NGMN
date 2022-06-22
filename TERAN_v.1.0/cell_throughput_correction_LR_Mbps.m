function LR_site_infrastructure = cell_throughput_correction_LR_Mbps(LR_site_infrastructure,...
                                                                     network_information,...
                                                                     network_throughput_progression,...
                                                                     traffic_growth_sval,...
                                                                     temp_sites_to_remove_equip,...
                                                                     temp_investment_sites,...
                                                                     temp_covering_non_investment_sites,...
                                                                     LR_network_information_growth_snapshot,...
                                                                     max_traffic)
%cell_throughput_correction_LR_Mbps Summary of this function goes here
%   Detailed explanation goes here


% - b. the investment_sites carry the total traffic of unistalled technologies 

%*********************************UTRAN************************************
temp_RAN_spectrum = 'UTRAN_2100'; 

t = network_information.(temp_RAN_spectrum).throughput_Mbps_per_cell(:,temp_sites_to_remove_equip) + ...
    network_throughput_progression.(temp_RAN_spectrum)(:,temp_sites_to_remove_equip,traffic_growth_sval);


for j = 1 : length(temp_sites_to_remove_equip)
    % ensure that a removed cell is covered from another cell
    traffic = zeros(size(t(:,j)));
    if network_information.EUTRAN_CA.cells_per_site(temp_sites_to_remove_equip(j))== network_information.(temp_RAN_spectrum).cells_per_site(temp_sites_to_remove_equip(j))
        traffic = t(:,j);
    else
        t2x = sum(t(:,j))/network_information.EUTRAN_CA.cells_per_site(temp_sites_to_remove_equip(j));
        traffic(1:network_information.EUTRAN_CA.cells_per_site(temp_sites_to_remove_equip(j)),j) = t2x;
    end
    % Make corrections to LR_site_infrastructure for throughput
    for sector_num = 1:length(LR_site_infrastructure(temp_sites_to_remove_equip(j)).EUTRAN_CA.sector)

        LR_site_infrastructure(temp_sites_to_remove_equip(j)).EUTRAN_CA.sector(sector_num).cell_throughput_Mbps = ...
                    LR_site_infrastructure(temp_sites_to_remove_equip(j)).EUTRAN_CA.sector(sector_num).cell_throughput_Mbps + ...
                    traffic(sector_num);
    end 
                    
end


% - c. the investment_sites carry the exceeded traffic of colocated technologies
% 1.Find the sites per technology which need investments and
% colocated with the actual investment sites
% 2.change their traffic to max (either safe or techlimit depending on the
% available capasity on investmnet sites)
% 3.Take the exceeded traffic to investment sites/cells 

%*****************************EUTRAN_single********************************
temp_RAN = 'EUTRAN_s'; 
temp_RAN_spectrum = 'EUTRAN_s';
temp_sector = 'sector';

LR_site_infrastructure = colocated_site_traffic(LR_site_infrastructure, temp_RAN, temp_RAN_spectrum, temp_sector);

%*********************************UTRAN************************************
% UTRAN_2100
% The UTRAN_2100 collocated to investment sites is removed (see b.)

% UTRAN_900
temp_RAN = 'UTRAN'; 
temp_RAN_spectrum = 'UTRAN_900';
temp_sector = 'sector900';

LR_site_infrastructure = colocated_site_traffic(LR_site_infrastructure, temp_RAN, temp_RAN_spectrum, temp_sector);
                               
%*********************************GERAN************************************
% GERAN_900
temp_RAN = 'GERAN'; 
temp_RAN_spectrum = 'GERAN_900';
temp_sector = 'sector900';

LR_site_infrastructure = colocated_site_traffic(LR_site_infrastructure, temp_RAN, temp_RAN_spectrum, temp_sector);

% GERAN_1800
temp_RAN = 'GERAN'; 
temp_RAN_spectrum = 'GERAN_1800';
temp_sector = 'sector1800';

LR_site_infrastructure = colocated_site_traffic(LR_site_infrastructure, temp_RAN, temp_RAN_spectrum, temp_sector);

% - d. the investment_sites carry the exceeded traffic of no_investment_sites_affected_by_investments
% 1.Find the sites per technology which need investments and
% are neighboors with the actual investment sites
% 2.change their traffic to max (either safe or techlimit depending on the
% available capasity on investmnet sites)
% 3.Take the exceeded traffic to investment sites/cells 

%*****************************EUTRAN_single********************************
temp_RAN = 'EUTRAN_s'; 
temp_RAN_spectrum = 'EUTRAN_s';
temp_sector = 'sector';

LR_site_infrastructure = neighbor_site_traffic(LR_site_infrastructure, temp_RAN, temp_RAN_spectrum, temp_sector);

%*********************************UTRAN************************************
% UTRAN_2100
% The UTRAN_2100 collocated to investment sites is removed (see b.)

% UTRAN_900
temp_RAN = 'UTRAN'; 
temp_RAN_spectrum = 'UTRAN_900';
temp_sector = 'sector900';

LR_site_infrastructure = neighbor_site_traffic(LR_site_infrastructure, temp_RAN, temp_RAN_spectrum, temp_sector);
                               
%*********************************GERAN************************************
% GERAN_900
temp_RAN = 'GERAN'; 
temp_RAN_spectrum = 'GERAN_900';
temp_sector = 'sector900';

LR_site_infrastructure = neighbor_site_traffic(LR_site_infrastructure, temp_RAN, temp_RAN_spectrum, temp_sector);

% GERAN_1800
temp_RAN = 'GERAN'; 
temp_RAN_spectrum = 'GERAN_1800';
temp_sector = 'sector1800';

LR_site_infrastructure = neighbor_site_traffic(LR_site_infrastructure, temp_RAN, temp_RAN_spectrum, temp_sector);


%**************************************************************************
% Nested function
%**************************************************************************

    function LR_site_infrastructure =  colocated_site_traffic(LR_site_infrastructure, temp_RAN, temp_RAN_spectrum, temp_sector)
        % (temp_RAN_spectrum) sites which require investments
        s2 = LR_network_information_growth_snapshot.(temp_RAN_spectrum).site_cell_to_invest;
        if isempty(s2)
            s2 = [0 0];
        end
        % (temp_RAN_spectrum) sites which require investments on the investments site
        s1_logical = ismember(s2(:,1),temp_investment_sites);
        s = s2(s1_logical,:);

        t_safe = zeros(1,size(s,1));
        t_techlimit = zeros(1,size(s,1));   
        reserved_traffic_safe = zeros(1,size(s,1));
        reserved_traffic_techlimit = zeros(1,size(s,1));
        for i = 1 : size(s,1)

            % change the future throughput to the maximum safe throughput or maximum techlimit throughput
            t_safe(i) = network_information.(temp_RAN_spectrum).max_safe_throughput_Mbps_per_cell(s(i,2),s(i,1));
            t_techlimit(i) = network_information.(temp_RAN_spectrum).max_techlimit_throughput_Mbps_per_cell(s(i,2),s(i,1));

            % reserve the exceed throughput for the investment cell
            reserved_traffic_safe(i) = ...          
                network_throughput_progression.(temp_RAN_spectrum)(s(i,2),s(i,1),traffic_growth_sval)+...
                network_information.(temp_RAN_spectrum).throughput_Mbps_per_cell(s(i,2),s(i,1))-...
                t_safe(i);      
            reserved_traffic_techlimit(i) = ...          
                network_throughput_progression.(temp_RAN_spectrum)(s(i,2),s(i,1),traffic_growth_sval)+...
                network_information.(temp_RAN_spectrum).throughput_Mbps_per_cell(s(i,2),s(i,1))-...
                t_techlimit(i);
            if reserved_traffic_techlimit(i)<0
                % sometimes the cells have axcedd the safe throughput limit
                % but still the techlimit has not been reached
                reserved_traffic_techlimit(i) = reserved_traffic_safe(i);
                t_techlimit(i) = t_safe(i);
            end

            % ensure that a removed cell is covered from another cell
            if network_information.EUTRAN_CA.cells_per_site(s(i,1)) < s(i,2)
                reserved_traffic_safe(i) = reserved_traffic_safe(i) / network_information.EUTRAN_CA.cells_per_site(s(i,1));
                reserved_traffic_techlimit(i) = reserved_traffic_techlimit(i) / network_information.EUTRAN_CA.cells_per_site(s(i,1));
                    % Make corrections to LR_site_infrastructure.EUTRAN_CA for throughput
                    for sec=1:length(LR_site_infrastructure(s(i,1)).EUTRAN_CA.sector)

                        traffic_safe = LR_site_infrastructure(s(i,1)).EUTRAN_CA.sector(sec).cell_throughput_Mbps + ...
                                    reserved_traffic_safe(i);
                        traffic_techlimit = LR_site_infrastructure(s(i,1)).EUTRAN_CA.sector(sec).cell_throughput_Mbps + ...
                                    reserved_traffic_safe(i);

                        if  traffic_safe < max_traffic      
                            LR_site_infrastructure(s(i,1)).EUTRAN_CA.sector(sec).cell_throughput_Mbps = traffic_safe;
                            LR_site_infrastructure(s(i,1)).(temp_RAN).(temp_sector)(s(i,2)).cell_throughput_Mbps = t_safe(i);
                        else
                            LR_site_infrastructure(s(i,1)).EUTRAN_CA.sector(sec).cell_throughput_Mbps = traffic_techlimit; %the max capabilities might exceeded
                            LR_site_infrastructure(s(i,1)).(temp_RAN).(temp_sector)(s(i,2)).cell_throughput_Mbps = t_techlimit(i);
                        end        

                    end 
            else
                 % Make corrections to LR_site_infrastructure.EUTRAN_CA for throughput
                traffic_safe = LR_site_infrastructure(s(i,1)).EUTRAN_CA.sector(s(i,2)).cell_throughput_Mbps + ...
                            reserved_traffic_safe(i);
                traffic_techlimit = LR_site_infrastructure(s(i,1)).EUTRAN_CA.sector(s(i,2)).cell_throughput_Mbps + ...
                            reserved_traffic_techlimit(i);

                if  traffic_safe < max_traffic      
                    LR_site_infrastructure(s(i,1)).EUTRAN_CA.sector(s(i,2)).cell_throughput_Mbps = traffic_safe;
                    LR_site_infrastructure(s(i,1)).(temp_RAN).(temp_sector)(s(i,2)).cell_throughput_Mbps = t_safe(i);
                else
                    LR_site_infrastructure(s(i,1)).EUTRAN_CA.sector(s(i,2)).cell_throughput_Mbps = traffic_techlimit;
                    LR_site_infrastructure(s(i,1)).(temp_RAN).(temp_sector)(s(i,2)).cell_throughput_Mbps = t_techlimit(i);
                end
            end

        end
    end



    function LR_site_infrastructure = neighbor_site_traffic(LR_site_infrastructure, temp_RAN, temp_RAN_spectrum, temp_sector)
        % (temp_RAN_spectrum) sites which require investments
        s2 = LR_network_information_growth_snapshot.(temp_RAN_spectrum).site_cell_to_invest;
        if isempty(s2)
            s2 = [0 0];
        end
        % (temp_RAN_spectrum) sites which require investments and are affected by neighbor investment sites
        s1_logical = ismember(s2(:,1),unique(cell2mat(temp_covering_non_investment_sites)));
        s = s2(s1_logical,:);

        t_safe = zeros(1,size(s,1));
        t_techlimit = zeros(1,size(s,1));   
        reserved_traffic_safe = zeros(1,size(s,1));
        reserved_traffic_techlimit = zeros(1,size(s,1));
        reserved_traffic_to_new_site = cell(1,size(s,1));
        for i = 1 : size(s,1)

            % change the future throughput to the maximum safe throughput or maximum techlimit throughput
            t_safe(i) = network_information.(temp_RAN_spectrum).max_safe_throughput_Mbps_per_cell(s(i,2),s(i,1));
            t_techlimit(i) = network_information.(temp_RAN_spectrum).max_techlimit_throughput_Mbps_per_cell(s(i,2),s(i,1));

            % reserve the exceed throughput for the investment cell
            reserved_traffic_safe(i) = ...          
                network_throughput_progression.(temp_RAN_spectrum)(s(i,2),s(i,1),traffic_growth_sval)+...
                network_information.(temp_RAN_spectrum).throughput_Mbps_per_cell(s(i,2),s(i,1))-...
                t_safe(i);      
            reserved_traffic_techlimit(i) = ...          
                network_throughput_progression.(temp_RAN_spectrum)(s(i,2),s(i,1),traffic_growth_sval)+...
                network_information.(temp_RAN_spectrum).throughput_Mbps_per_cell(s(i,2),s(i,1))-...
                t_techlimit(i);
            if reserved_traffic_techlimit(i)<0
                % sometimes the cells have axcedd the safe throughput limit
                % but still the techlimit has not been reached
                reserved_traffic_techlimit(i) = reserved_traffic_safe(i);
                t_techlimit(i) = t_safe(i);
            end

            % The reserved traffic will be carried by the corresponding site in temp_covering_non_investment_sites
            ind = cellfun(@(x) any(ismember(x,s(i,1))),temp_covering_non_investment_sites,'UniformOutput', false);
            reserved_traffic_to_new_site(i) = {temp_investment_sites(cell2mat(ind))};
            reserved_traffic_to_new_site_aux = reserved_traffic_to_new_site{i}; 
            
            % Assumption: the reserved traffic is shared to all the cells of the all
            % investment/neighbor sites. Improvements are needed to find the
            % direction of the cell which cover the problematic site                           
            reserved_traffic_safe(i) = reserved_traffic_safe(i)/sum(network_information.EUTRAN_CA.cells_per_site(reserved_traffic_to_new_site{i}));
            reserved_traffic_techlimit(i) = reserved_traffic_techlimit(i)/sum(network_information.EUTRAN_CA.cells_per_site(reserved_traffic_to_new_site{i}));
                 
            % Make corrections to LR_site_infrastructure.EUTRAN_CA for throughput
            for k = 1 : length(reserved_traffic_to_new_site_aux)
                
                for sec=1:length(LR_site_infrastructure(reserved_traffic_to_new_site_aux(k)).EUTRAN_CA.sector)

                    traffic_safe = LR_site_infrastructure(reserved_traffic_to_new_site_aux(k)).EUTRAN_CA.sector(sec).cell_throughput_Mbps + ...
                                reserved_traffic_safe(i);
                    traffic_techlimit = LR_site_infrastructure(reserved_traffic_to_new_site_aux(k)).EUTRAN_CA.sector(sec).cell_throughput_Mbps + ...
                                reserved_traffic_safe(i);

                    if  traffic_safe < max_traffic      
                        LR_site_infrastructure(reserved_traffic_to_new_site_aux(k)).EUTRAN_CA.sector(sec).cell_throughput_Mbps = traffic_safe;
                        LR_site_infrastructure(s(i,1)).(temp_RAN).(temp_sector)(s(i,2)).cell_throughput_Mbps = t_safe(i);
                    else
                        LR_site_infrastructure(reserved_traffic_to_new_site_aux(k)).EUTRAN_CA.sector(sec).cell_throughput_Mbps = traffic_techlimit; %the max capabilities might exceeded
                        LR_site_infrastructure(s(i,1)).(temp_RAN).(temp_sector)(s(i,2)).cell_throughput_Mbps = t_techlimit(i);
                    end        

                end 
                
            end

        end
        
             
    end
% !!
% The network investment might not be capable to satisfy the new traffic
% This traffic is "lost"
% the netwrok cost should be calculated for max traffic in these sites 
% LR_network_information will shed some light on this
end

