function TRx_per_BTS = number_of_TRx(inputs_technology, site_infrastructure, temp_RAN, temp_sector)
%number_of_TRx Summary of this function goes here
%   Detailed explanation goes here

TRx_per_BTS = zeros(1,length(site_infrastructure));

for i = 1: length(site_infrastructure)

    if isfield(site_infrastructure(i).(temp_RAN), temp_sector) ~= 0
        for s=1:length(site_infrastructure(i).(temp_RAN).(temp_sector))
                TRx_per_BTS(i) =  TRx_per_BTS(i) +...
                     (site_infrastructure(i).(temp_RAN).(temp_sector)(s).BW / inputs_technology.extra.GSM_channel_MHz);               
        end
    end
        
end

TRx_per_BTS = ceil(TRx_per_BTS);

end

