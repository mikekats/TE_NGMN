function distributed_sites = distribute_RAN_to_sites(inputs_technology, site_infrastructure, temp_RAN, temp_sector, temp_site_ID_prefix, iter, temp_potential_sites)
%distribute_RAN_to_sites Summary of this function goes here
%   Detailed explanation goes here

RAN_sites = cell(1,length(inputs_technology.(temp_RAN)));

    for RANconfig = iter

        s = ceil((1:inputs_technology.(temp_RAN)(RANconfig).cells)/3);
        c = mod(1:inputs_technology.(temp_RAN)(RANconfig).cells,3);
        c(c==0)=3;

        if isempty(s)
            continue
        end
       
        P = temp_potential_sites; 
        P = setdiff(P,cell2mat(RAN_sites));  %RAN configurations are not co-located to each other.
        P = P(randperm(length(P)));

        for n = 1:inputs_technology.(temp_RAN)(RANconfig).cells
            site_infrastructure(P(s(n))).(temp_RAN).(temp_sector)(c(n)).cell_ID = [temp_site_ID_prefix num2str(inputs_technology.(temp_RAN)(RANconfig).cellgroupID) '#' num2str(n)]; 
            site_infrastructure(P(s(n))).(temp_RAN).(temp_sector)(c(n)).configuration = inputs_technology.(temp_RAN)(RANconfig).configuration;
            site_infrastructure(P(s(n))).(temp_RAN).(temp_sector)(c(n)).band = inputs_technology.(temp_RAN)(RANconfig).bands;
            site_infrastructure(P(s(n))).(temp_RAN).(temp_sector)(c(n)).BW = inputs_technology.(temp_RAN)(RANconfig).BW;
            site_infrastructure(P(s(n))).(temp_RAN).(temp_sector)(c(n)).cell_range_km = inputs_technology.(temp_RAN)(RANconfig).cell_range_km;
            site_infrastructure(P(s(n))).(temp_RAN).(temp_sector)(c(n)).cell_direction_az = inputs_technology.extra.antDir(c(n));
            site_infrastructure(P(s(n))).(temp_RAN).(temp_sector)(c(n)).cell_capacity_Mbps = inputs_technology.(temp_RAN)(RANconfig).cell_capacity_Mbps;
            site_infrastructure(P(s(n))).(temp_RAN).(temp_sector)(c(n)).cell_throughput_Mbps = inputs_technology.(temp_RAN)(RANconfig).cell_throughput_Mbps(n);
            site_infrastructure(P(s(n))).(temp_RAN).(temp_sector)(c(n)).development_year = inputs_technology.(temp_RAN)(RANconfig).development_year;
            site_infrastructure(P(s(n))).configurations = [site_infrastructure(P(s(n))).configurations ; {inputs_technology.(temp_RAN)(RANconfig).configuration}];
            site_infrastructure(P(s(n))).cell_directions = [site_infrastructure(P(s(n))).cell_directions ; {inputs_technology.extra.antDir(c(n))}];
        end 
        if c(end)~=3 
            %remove the empty sectors
            site_infrastructure(P(s(n))).(temp_RAN).(temp_sector)(c(end)+1:end) = [];
        end 

        RAN_sites{RANconfig} =  unique(P(s));
    end

    distributed_sites{1} = RAN_sites;
    distributed_sites{2} = site_infrastructure;
end