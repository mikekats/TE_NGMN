function LR_site_infrastructure = cell_throughput_LR_Mbps(sites,...
                                                          LR_site_infrastructure,...
                                                          site_infrastructure,...
                                                          temp_RAN,...
                                                          temp_sector,...
                                                          throughput_progression) 
%cell_throughput_LR_Mbps Summary of this function goes here
%   Detailed explanation goes here


for i = 1:sites
    
    if isfield(LR_site_infrastructure(i).(temp_RAN), temp_sector)      
   
        for s=1:length(LR_site_infrastructure(i).(temp_RAN).(temp_sector))

                LR_site_infrastructure(i).(temp_RAN).(temp_sector)(s).cell_throughput_Mbps = ...
                            site_infrastructure(i).(temp_RAN).(temp_sector)(s).cell_throughput_Mbps + ...
                            throughput_progression(s,i);
                                                            
        end
  
    end
    
end


end

