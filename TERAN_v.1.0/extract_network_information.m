function temp_struct = extract_network_information(site_infrastructure, BHratio, caproom, temp_RAN, temp_sector)
%extract_network_information Summary of this function goes here
%   Detailed explanation goes here           
            
temp_cells = 0;
temp_basestations = 0;
temp_RANconfiguration = cell(1,length(site_infrastructure));
%Define and initialize struct (allocate memory) 
temp_struct = temp_create_struct(length(site_infrastructure)); 

for i = 1: length(site_infrastructure)
    
    if isfield(site_infrastructure(i).(temp_RAN), temp_sector)       
        temp_basestations = temp_basestations + 1;
        
        % basestations_per_site
        temp_struct.basestations_per_site(i) = temp_struct.basestations_per_site(i) + 1; 
        
        for s=1:length(site_infrastructure(i).(temp_RAN).(temp_sector))
            temp_cells = temp_cells + 1;
            
            % configuration 
            temp_RANconfiguration{i} = unique([temp_RANconfiguration{i}; {site_infrastructure(i).(temp_RAN).(temp_sector)(s).configuration}]);  
            % bands_per_site
            temp_struct.bands_per_site{i} = [temp_struct.bands_per_site{i}; site_infrastructure(i).(temp_RAN).(temp_sector)(s).band];
            % BWs_per_site
            temp_struct.BWs_per_site{i} = [temp_struct.BWs_per_site{i}; site_infrastructure(i).(temp_RAN).(temp_sector)(s).BW];  
            % cells_per_site
            temp_struct.cells_per_site(i) = temp_struct.cells_per_site(i) + 1;        
            % capacity_Mbps_per_cell
            temp_struct.capacity_Mbps_per_cell(s,i) = site_infrastructure(i).(temp_RAN).(temp_sector)(s).cell_capacity_Mbps;     
            % capacity_Mbps_per_site
            temp_struct.capacity_Mbps_per_site(i) = temp_struct.capacity_Mbps_per_site(i) + site_infrastructure(i).(temp_RAN).(temp_sector)(s).cell_capacity_Mbps; 
            % throughput_Mbps_per_cell
            temp_struct.throughput_Mbps_per_cell(s,i) = site_infrastructure(i).(temp_RAN).(temp_sector)(s).cell_throughput_Mbps;         
            % throughput_Mbps_per_site
            temp_struct.throughput_Mbps_per_site(i) = temp_struct.throughput_Mbps_per_site(i) + site_infrastructure(i).(temp_RAN).(temp_sector)(s).cell_throughput_Mbps;             
           
        end
        
    else
        temp_RANconfiguration{i} = [];
        temp_struct.cells_per_site(i) = 0;
        temp_struct.basestations_per_site(i) = 0;
        temp_struct.capacity_Mbps_per_site(i) = 0;
        temp_struct.throughput_Mbps_per_site(i) = 0;
        temp_struct.capacity_Mbps_per_cell(:,i) = 0;
        temp_struct.throughput_Mbps_per_cell(:,i) = 0;
    
    end
          
end

% configuration
temp_struct.configurations = unique([temp_RANconfiguration{:}])';

% configuration_per_site
temp_struct.configuration_per_site = {temp_RANconfiguration{:}};

% cells
temp_struct.cells = temp_cells;

% basestations
temp_struct.basestations = temp_basestations;

% total_capacity_Mbps  
temp_struct.total_capacity_Mbps = sum(temp_struct.capacity_Mbps_per_site(:));

% avrg_cell_capacity_Mbps
temp_struct.avrg_cell_capacity_Mbps = temp_struct.total_capacity_Mbps/temp_struct.cells;
  
% throughput_Mbps_in_BH_per_site  
temp_struct.throughput_Mbps_in_BH_per_site = temp_struct.throughput_Mbps_per_site .* 24 * BHratio;

% max_safe_throughput_Mbps_per_cell
temp_struct.max_safe_throughput_Mbps_per_cell = temp_struct.capacity_Mbps_per_cell .* (1-caproom) ./ BHratio / 24;

% max_safe_throughput_Mbps_per_site  
temp_struct.max_safe_throughput_Mbps_per_site = temp_struct.capacity_Mbps_per_site .* (1-caproom) ./ BHratio / 24;

% max_safe_throughput_Mbps_in_BH_per_site  
temp_struct.max_safe_throughput_Mbps_in_BH_per_site = temp_struct.capacity_Mbps_per_site .* (1-caproom);

% max_techlimit_throughput_Mbps_per_cell
temp_struct.max_techlimit_throughput_Mbps_per_cell = temp_struct.capacity_Mbps_per_cell  ./ BHratio / 24;

% max_techlimit_throughput_Mbps_per_site  
temp_struct.max_techlimit_throughput_Mbps_per_site = temp_struct.capacity_Mbps_per_site ./ BHratio / 24;

% max_techlimit_throughput_Mbps_in_BH_per_site  
temp_struct.max_techlimit_throughput_Mbps_in_BH_per_site = temp_struct.capacity_Mbps_per_site;

% total_throughput_Mbps 
temp_struct.total_throughput_Mbps = sum(temp_struct.throughput_Mbps_per_site(:));

% total_throughput_Mbps_in_BH
temp_struct.total_throughput_Mbps_in_BH = sum(temp_struct.throughput_Mbps_in_BH_per_site(:));

% total_max_safe_throughput_Mbps
temp_struct.total_max_safe_throughput_Mbps = sum(temp_struct.max_safe_throughput_Mbps_per_site(:));

% total_max_safe_throughput_Mbps_in_BH
temp_struct.total_max_safe_throughput_Mbps_in_BH = sum(temp_struct.max_safe_throughput_Mbps_in_BH_per_site(:));

% total_max_techlimit_throughput_Mbps
temp_struct.total_max_techlimit_throughput_Mbps = sum(temp_struct.max_techlimit_throughput_Mbps_per_site(:));

% total_max_techlimit_throughput_Mbps_in_BH
temp_struct.total_max_techlimit_throughput_Mbps_in_BH = sum(temp_struct.max_techlimit_throughput_Mbps_in_BH_per_site(:));

% avrg_cell_throughput_Mbps
temp_struct.avrg_cell_throughput_Mbps = temp_struct.total_throughput_Mbps/temp_struct.cells;

% avrg_cell_throughput_Mbps_in_BH
temp_struct.avrg_cell_throughput_Mbps_in_BH =  temp_struct.total_throughput_Mbps_in_BH/temp_struct.cells;

% avrg_cell_max_safe_throughput_Mbps 
temp_struct.avrg_cell_max_safe_throughput_Mbps =  temp_struct.total_max_safe_throughput_Mbps/temp_struct.cells; 

% current_load_per_cell
temp_struct.current_load_per_cell = temp_struct.throughput_Mbps_per_cell ./ temp_struct.capacity_Mbps_per_cell;

% current_load_per_site
temp_struct.current_load_per_site = temp_struct.throughput_Mbps_per_site ./ temp_struct.capacity_Mbps_per_site;

% current_load_per_site_in_BH
temp_struct.current_load_per_site_in_BH = temp_struct.throughput_Mbps_in_BH_per_site ./ temp_struct.capacity_Mbps_per_site; 

% avrg_cell_load
temp_struct.avrg_cell_load = temp_struct.avrg_cell_throughput_Mbps/temp_struct.avrg_cell_capacity_Mbps;

% avrg_cell_load_in_BH
temp_struct.avrg_cell_load_in_BH = temp_struct.avrg_cell_throughput_Mbps_in_BH/temp_struct.avrg_cell_capacity_Mbps;            
 
                               

    function temp_struct = temp_create_struct(sites)     
        temp_struct = struct(...
                'configurations','',...
                'configuration_per_site',{cell(1,sites)},...
                'bands_per_site',{cell(1,sites)},...
                'BWs_per_site',{cell(1,sites)},...
                'cells_per_site',zeros(1,sites),...
                'cells',0,...
                'basestations_per_site',zeros(1,sites),...
                'basestations',0,...
                'capacity_Mbps_per_cell',[],...
                'capacity_Mbps_per_site',zeros(1,sites),...
                'total_capacity_Mbps',0,...
                'avrg_cell_capacity_Mbps',0,...
                'throughput_Mbps_per_cell',[],...
                'throughput_Mbps_per_site',zeros(1,sites),...   
                'throughput_Mbps_in_BH_per_site',zeros(1,sites),...
                'max_safe_throughput_Mbps_per_cell',[],...
                'max_safe_throughput_Mbps_per_site',zeros(1,sites),...
                'max_safe_throughput_Mbps_in_BH_per_site',zeros(1,sites),...
                'max_techlimit_throughput_Mbps_per_cell',[],...
                'max_techlimit_throughput_Mbps_per_site',zeros(1,sites),...
                'max_techlimit_throughput_Mbps_in_BH_per_site',zeros(1,sites),...
                'total_throughput_Mbps',0,...
                'total_throughput_Mbps_in_BH',0,...
                'total_max_safe_throughput_Mbps',0,...
                'total_max_safe_throughput_Mbps_in_BH',0,...
                'total_max_techlimit_throughput_Mbps',0,...
                'total_max_techlimit_throughput_Mbps_in_BH',0,...
                'avrg_cell_throughput_Mbps',0,...
                'avrg_cell_throughput_Mbps_in_BH',0,...
                'avrg_cell_max_safe_throughput_Mbps',0,...
                'current_load_per_cell',[],...
                'current_load_per_site',zeros(1,sites),...
                'current_load_per_site_in_BH',zeros(1,sites),...
                'avrg_cell_load',0,...
                'avrg_cell_load_in_BH',0);
    end

end

