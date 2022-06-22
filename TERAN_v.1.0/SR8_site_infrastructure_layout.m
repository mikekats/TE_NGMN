%**************************************************************************
% Part 0: Define and initialize struct (allocate memory) 
%**************************************************************************
site_infrastructure = define_site_infrastructure_struct(temp_actual_sites);
   
%**************************************************************************
% Part 1: Create sites - general information (site IDs, types, location, development year)
%**************************************************************************

% site_ID 
temp_site_ID = genvarname(repmat({'s'}, 1, temp_actual_sites), 's');

% site_type
temp_owned_tower = repmat({inputs_technology.site_types(1).name},1,ceil(temp_actual_sites*inputs_technology.site_types(1).share));
temp_owned_rooftop = repmat({inputs_technology.site_types(2).name},1,floor(temp_actual_sites*inputs_technology.site_types(2).share));
temp_rent_tower = repmat({inputs_technology.site_types(3).name},1,ceil(temp_actual_sites*inputs_technology.site_types(3).share));
temp_rent_rooftop = repmat({inputs_technology.site_types(4).name},1,floor(temp_actual_sites*inputs_technology.site_types(4).share));
temp_shared_rent_tower = repmat({inputs_technology.site_types(5).name},1,ceil(temp_actual_sites*inputs_technology.site_types(5).share));
temp_shared_rent_rooftop = repmat({inputs_technology.site_types(6).name},1,floor(temp_actual_sites*inputs_technology.site_types(6).share));
temp_site_types = [temp_owned_tower temp_owned_rooftop temp_rent_tower temp_rent_rooftop temp_shared_rent_tower temp_shared_rent_rooftop]; 
temp_site_types = temp_site_types(randperm(numel(temp_site_types)));

% site location
% shuffle the sites_position and convert to cells
temp_sites_position = temp_sites_position(randperm(temp_actual_sites),:);
temp_long = num2cell(temp_sites_position(:,1));
temp_lat = num2cell(temp_sites_position(:,2));

% site development year
temp_newest_site_development_year = inputs_technology.site_types.newest_site_development_year;
temp_oldest_site_development_year = inputs_technology.site_types.oldest_site_development_year;
temp_site_development_year = randi([temp_oldest_site_development_year, temp_newest_site_development_year],temp_actual_sites,1);
temp_site_development_year = num2cell(temp_site_development_year);

[site_infrastructure(:).site_ID] = temp_site_ID{:};
[site_infrastructure(:).site_type] = temp_site_types{:};
[site_infrastructure(:).longitude] = temp_long{:};
[site_infrastructure(:).latitude] = temp_lat{:};
[site_infrastructure(:).development_year] = temp_site_development_year{:};

clear temp_owned_tower temp_owned_rooftop temp_rent_tower temp_rent_rooftop temp_shared_rent_tower temp_shared_rent_rooftop ...
    temp_site_ID temp_site_types temp_long temp_lat temp_newest_site_development_year temp_oldest_site_development_year temp_site_development_year;

%**************************************************************************
% Part 2: Create randomly multi-RAN sites in site_infrastructure structure
%**************************************************************************
% Assumption: EUTRAN_CA configurations are not co-located to each other.
% Assumption: EUTRAN_s configurations are not co-located to each other.
% Assumption: UTRAN 2100 configurations are not co-located to each other
% Assumption: UTRAN 900 configurations are not co-located to each other
% Assumption: GERAN 900 configurations are not co-located to each other
% Assumption: GERAN 900 refarming configurations are not co-located to each other
% Assumption: GERAN 1800 configurations are not co-located to each other
% Assumption: EUTRAN_CA with 900, 1800 and 2100 MHz should not be co-located with UTRAN and GERAN at these bands
% Assumption: EUTRAN_s at 900, 1800 and 2100 MHz should not be co-located with UTRAN and GERAN at these bands
% Assumption: UTRAN 900 and GERAN 900 refarming are always site-colocated

%*************EUTRAN_CA: Allocate the eNodeB_CA cells to the sites*********
temp_RAN = 'EUTRAN_CA';
temp_sector = 'sector';
temp_site_ID_prefix = 'Eca';
temp_iter = 1:length(inputs_technology.(temp_RAN));

% Find the potential sites
temp_potential_sites = randperm(length(site_infrastructure)); 

% Distribute the EUTRAN_CA cells to potetnial sites
temp_distributed_sites = distribute_RAN_to_sites(inputs_technology, site_infrastructure, temp_RAN, temp_sector, temp_site_ID_prefix, temp_iter, temp_potential_sites);
EUTRAN_CA_sites = temp_distributed_sites{1};
site_infrastructure = temp_distributed_sites{2};

% Empty the unused site_infrastructure.EUTRAN_CA structs
non_EUTRAN_CA_sites = setdiff(1:length(site_infrastructure),cell2mat(EUTRAN_CA_sites));
for i=1:length(non_EUTRAN_CA_sites)
    site_infrastructure(non_EUTRAN_CA_sites(i)).(temp_RAN) = [];
end

clear temp_RAN temp_sector temp_site_ID_prefix temp_iter temp_potential_sites temp_distributed_sites non_EUTRAN_CA_sites i

%*************EUTRAN_s: Allocate the eNodeB_s cells to the sites***********
temp_RAN ='EUTRAN_s';
temp_sector = 'sector';
temp_site_ID_prefix = 'Es';
temp_iter = 1:length(inputs_technology.(temp_RAN));

% Find the potential sites
% Assumption: EUTRAN_CA and EUTRAN_s configurations are not co-located.
temp_potential_sites = randperm(length(site_infrastructure)); 
temp_potential_sites = setdiff(temp_potential_sites,cell2mat(EUTRAN_CA_sites));

% Distribute the EUTRAN_s cells to potential sites 
temp_distributed_sites = distribute_RAN_to_sites(inputs_technology, site_infrastructure, temp_RAN, temp_sector, temp_site_ID_prefix, temp_iter, temp_potential_sites);
EUTRAN_s_sites = temp_distributed_sites{1};
site_infrastructure = temp_distributed_sites{2};

% Empty the unused site_infrastructure.EUTRAN_s structs
non_EUTRAN_s_sites = setdiff(1:length(site_infrastructure),cell2mat(EUTRAN_s_sites));
for i=1:length(non_EUTRAN_s_sites)
    site_infrastructure(non_EUTRAN_s_sites(i)).(temp_RAN) = [];
end

clear temp_RAN temp_sector temp_site_ID_prefix temp_iter temp_potential_sites temp_distributed_sites non_EUTRAN_s_sites i

%**************UTRAN: Allocate the NodeB_s cells to the sites**************
% UTRAN 2100
temp_RAN ='UTRAN';
temp_sector = 'sector2100';
temp_site_ID_prefix = 'U';
temp_band = 2.1;
temp_iter = [inputs_technology.(temp_RAN)([inputs_technology.(temp_RAN).bands]==temp_band).cellgroupID];

% Find the potential sites
% Assumption: EUTRAN_CA with 900, 1800 and 2100 MHz should not be co-located with UTRAN and GERAN at these bands
% Assumption: EUTRAN_s at 900, 1800 and 2100 MHz should not be co-located with UTRAN and GERAN at these bands
EUTRAN_CA_2100_sites = cell(1,length(inputs_technology.EUTRAN_CA));
for i = 1:length(inputs_technology.EUTRAN_CA)
        if ismember(temp_band,[inputs_technology.EUTRAN_CA(i).bands])
            EUTRAN_CA_2100_sites{i}  = EUTRAN_CA_sites{i} ;
        end 
end
EUTRAN_CA_2100_sites = cell2mat(EUTRAN_CA_2100_sites);
EUTRAN_s_2100_sites_index = [inputs_technology.EUTRAN_s.bands]==temp_band;
EUTRAN_s_2100_sites = cell2mat(EUTRAN_s_sites(EUTRAN_s_2100_sites_index));
temp_potential_sites = randperm(length(site_infrastructure)); 
temp_potential_sites = setdiff(temp_potential_sites,EUTRAN_CA_2100_sites);
temp_potential_sites = setdiff(temp_potential_sites,EUTRAN_s_2100_sites);

% Distribute the UTRAN2100 cells to potetnial sites  
temp_distributed_sites = distribute_RAN_to_sites(inputs_technology, site_infrastructure, temp_RAN, temp_sector, temp_site_ID_prefix, temp_iter, temp_potential_sites);
UTRAN2100_sites = temp_distributed_sites{1};
site_infrastructure = temp_distributed_sites{2};

% Remove the unused site_infrastructure.UTRAN.sector2100 structs
P = randperm(length(site_infrastructure));
P = setdiff(P,cell2mat(UTRAN2100_sites));
for i=1:length(P)
    if isfield(site_infrastructure(P(i)).(temp_RAN), temp_sector)
        site_infrastructure(P(i)).(temp_RAN) = rmfield(site_infrastructure(P(i)).(temp_RAN),temp_sector);
    end
end

clear temp_RAN temp_sector temp_site_ID_prefix temp_band temp_iter EUTRAN_s_2100_sites_index temp_potential_sites temp_distributed_sites P i

% UTRAN 900
temp_RAN ='UTRAN';
temp_sector = 'sector900';
temp_site_ID_prefix = 'U';
temp_band = 0.9;
temp_iter = [inputs_technology.(temp_RAN)([inputs_technology.(temp_RAN).bands]==temp_band).cellgroupID];

% Find the potential sites
% Assumption: EUTRAN_CA with 900, 1800 and 2100 MHz should not be co-located with UTRAN and GERAN at these bands
% Assumption: EUTRAN_s at 900, 1800 and 2100 MHz should not be co-located with UTRAN and GERAN at these bands
EUTRAN_CA_900_sites = cell(1,length(inputs_technology.EUTRAN_CA));
for i = 1:length(inputs_technology.EUTRAN_CA)
        if ismember(temp_band,[inputs_technology.EUTRAN_CA(i).bands])
            EUTRAN_CA_900_sites{i}  = EUTRAN_CA_sites{i} ;
        end 
end
EUTRAN_CA_900_sites = cell2mat(EUTRAN_CA_900_sites);
EUTRAN_s_900_sites_index = [inputs_technology.EUTRAN_s.bands]==temp_band;
EUTRAN_s_900_sites = cell2mat(EUTRAN_s_sites(EUTRAN_s_900_sites_index));
temp_potential_sites = randperm(length(site_infrastructure)); 
temp_potential_sites = setdiff(temp_potential_sites,EUTRAN_CA_900_sites);
temp_potential_sites = setdiff(temp_potential_sites,EUTRAN_s_900_sites);

% Distribute the UTRAN900 cells to potetnial sites  
temp_distributed_sites = distribute_RAN_to_sites(inputs_technology, site_infrastructure, temp_RAN, temp_sector, temp_site_ID_prefix, temp_iter, temp_potential_sites);
UTRAN900_sites = temp_distributed_sites{1};
site_infrastructure = temp_distributed_sites{2};

% Remove the unused site_infrastructure.UTRAN.sector900 structs
P = randperm(length(site_infrastructure));
P = setdiff(P,cell2mat(UTRAN900_sites));
for i=1:length(P)
    if isfield(site_infrastructure(P(i)).(temp_RAN), temp_sector)
        site_infrastructure(P(i)).(temp_RAN) = rmfield(site_infrastructure(P(i)).(temp_RAN),temp_sector);
    end
end

% Empty the unused site_infrastructure.UTRAN structs
non_UTRAN_sites = setdiff(1:length(site_infrastructure),union(cell2mat(UTRAN2100_sites),cell2mat(UTRAN900_sites)));
for i=1:length(non_UTRAN_sites)
    site_infrastructure(non_UTRAN_sites(i)).(temp_RAN) = [];
end

clear temp_RAN temp_sector temp_site_ID_prefix temp_band temp_iter EUTRAN_s_900_sites_index temp_potential_sites  temp_distributed_sites P non_UTRAN_sites i

%*****************GERAN: Allocate the BTS cells to the sites***************
% GERAN 900
temp_RAN ='GERAN';
temp_sector = 'sector900';
temp_site_ID_prefix = 'G';
temp_band = 0.9;

temp_iter1 = [inputs_technology.(temp_RAN)([inputs_technology.(temp_RAN).bands]==temp_band).cellgroupID];
temp_iter2 = zeros(1,length(inputs_technology.(temp_RAN)));
for i = 1:length(inputs_technology.(temp_RAN))
    if isempty(strfind(inputs_technology.(temp_RAN)(i).configuration,'refarming'))
       temp_iter2(i) = inputs_technology.(temp_RAN)(i).cellgroupID;
    else
       temp_iter2(i) = 0;
    end
    temp_iter2(temp_iter2==0) = [];
end
temp_iter = intersect(temp_iter1,temp_iter2);

% Find the potential sites
% Assumption: EUTRAN_CA with 900, 1800 and 2100 MHz should not be co-located with UTRAN and GERAN at these bands
% Assumption: EUTRAN_s at 900, 1800 and 2100 MHz should not be co-located with UTRAN and GERAN at these bands
EUTRAN_CA_900_sites = cell(1,length(inputs_technology.EUTRAN_CA));
for i = 1:length(inputs_technology.EUTRAN_CA)
        if ismember(temp_band,[inputs_technology.EUTRAN_CA(i).bands])
            EUTRAN_CA_900_sites{i}  = EUTRAN_CA_sites{i} ;
        end 
end
EUTRAN_CA_900_sites = cell2mat(EUTRAN_CA_900_sites);
EUTRAN_s_900_sites_index = [inputs_technology.EUTRAN_s.bands]==temp_band;
EUTRAN_s_900_sites = cell2mat(EUTRAN_s_sites(EUTRAN_s_900_sites_index));
UTRAN900_sites_index = [inputs_technology.UTRAN.bands]==temp_band;
UTRAN900_sites = cell2mat(UTRAN900_sites(UTRAN900_sites_index));
temp_potential_sites = randperm(length(site_infrastructure)); 
temp_potential_sites = setdiff(temp_potential_sites,EUTRAN_CA_900_sites);
temp_potential_sites = setdiff(temp_potential_sites,EUTRAN_s_900_sites);
temp_potential_sites = setdiff(temp_potential_sites,UTRAN900_sites);

% Distribute the GERAN900 cells to potetnial sites  
temp_distributed_sites = distribute_RAN_to_sites(inputs_technology, site_infrastructure, temp_RAN, temp_sector, temp_site_ID_prefix, temp_iter, temp_potential_sites);
GERAN900_sites = temp_distributed_sites{1};
site_infrastructure = temp_distributed_sites{2};

clear temp_RAN temp_sector temp_site_ID_prefix temp_band temp_iter1 temp_iter2 temp_iter EUTRAN_s_900_sites_index ...
    UTRAN900_sites_index temp_potential_sites temp_distributed_sites i

% GERAN 900 refaming
temp_RAN ='GERAN';
temp_sector = 'sector900';
temp_site_ID_prefix = 'G';
temp_band = 0.9;

temp_iter1 = [inputs_technology.(temp_RAN)([inputs_technology.(temp_RAN).bands]==temp_band).cellgroupID];
temp_iter2 = zeros(1,length(inputs_technology.(temp_RAN)));
for i = 1:length(inputs_technology.(temp_RAN))
    if ~isempty(strfind(inputs_technology.(temp_RAN)(i).configuration,'refarming'))
       temp_iter2(i) = inputs_technology.(temp_RAN)(i).cellgroupID;
    else
       temp_iter2(i) = 0;
    end
    temp_iter2(temp_iter2==0) = [];
end
temp_iter = intersect(temp_iter1,temp_iter2);

% Find the potential sites
% Assumption: UTRAN 900 and GERAN 900 refarming are always site-colocated
temp_potential_sites = UTRAN900_sites;

% Distribute the GERAN900 cells to potetnial sites  
temp_distributed_sites = distribute_RAN_to_sites(inputs_technology, site_infrastructure, temp_RAN, temp_sector, temp_site_ID_prefix, temp_iter, temp_potential_sites);
GERAN900_refarming_sites = temp_distributed_sites{1};
site_infrastructure = temp_distributed_sites{2};

% Remove the unused site_infrastructure.GERAN.sector900 structs
P = randperm(length(site_infrastructure));
P = setdiff(P,union(cell2mat(GERAN900_sites),cell2mat(GERAN900_refarming_sites)));
for i=1:length(P)
    if isfield(site_infrastructure(P(i)).(temp_RAN), temp_sector)
        site_infrastructure(P(i)).(temp_RAN) = rmfield(site_infrastructure(P(i)).(temp_RAN),temp_sector);
    end
end

clear temp_RAN temp_sector temp_site_ID_prefix temp_band temp_iter1 temp_iter2 temp_iter temp_potential_sites temp_distributed_sites P i

% GERAN 1800
temp_RAN ='GERAN';
temp_sector = 'sector1800';
temp_site_ID_prefix = 'G';
temp_band = 1.8;
temp_iter = [inputs_technology.(temp_RAN)([inputs_technology.(temp_RAN).bands]==temp_band).cellgroupID];

% Find the potential sites
% Assumption: EUTRAN_CA with 900, 1800 and 2100 MHz should not be co-located with UTRAN and GERAN at these bands
% Assumption: EUTRAN_s at 900, 1800 and 2100 MHz should not be co-located with UTRAN and GERAN at these bands
EUTRAN_CA_1800_sites = cell(1,length(inputs_technology.EUTRAN_CA));
for i = 1:length(inputs_technology.EUTRAN_CA)
        if ismember(temp_band,[inputs_technology.EUTRAN_CA(i).bands])
            EUTRAN_CA_1800_sites{i}  = EUTRAN_CA_sites{i} ;
        end 
end
EUTRAN_CA_1800_sites = cell2mat(EUTRAN_CA_1800_sites);
EUTRAN_s_1800_sites_index = [inputs_technology.EUTRAN_s.bands]==temp_band;
EUTRAN_s_1800_sites = cell2mat(EUTRAN_s_sites(EUTRAN_s_1800_sites_index));
temp_potential_sites = randperm(length(site_infrastructure)); 
temp_potential_sites = setdiff(temp_potential_sites,EUTRAN_CA_1800_sites);
temp_potential_sites = setdiff(temp_potential_sites,EUTRAN_s_1800_sites);

% Distribute the GERAN900 cells to potetnial sites  
temp_distributed_sites = distribute_RAN_to_sites(inputs_technology, site_infrastructure, temp_RAN, temp_sector, temp_site_ID_prefix, temp_iter, temp_potential_sites);
GERAN1800_sites = temp_distributed_sites{1};
site_infrastructure = temp_distributed_sites{2};

% Remove the unused site_infrastructure.GERAN.sector1800 structs
P = randperm(length(site_infrastructure));
P = setdiff(P,cell2mat(GERAN1800_sites));
for i=1:length(P)
    if isfield(site_infrastructure(P(i)).(temp_RAN), temp_sector)
        site_infrastructure(P(i)).(temp_RAN) = rmfield(site_infrastructure(P(i)).(temp_RAN),temp_sector);
    end
end

% Empty the unused site_infrastructure.UTRAN structs
non_GERAN_sites = setdiff(1:length(site_infrastructure),union(union(cell2mat(GERAN900_sites),cell2mat(GERAN900_refarming_sites)),cell2mat(GERAN1800_sites)));
for i=1:length(non_GERAN_sites)
    site_infrastructure(non_GERAN_sites(i)).(temp_RAN) = [];
end

clear temp_RAN temp_sector temp_site_ID_prefix temp_band temp_iter EUTRAN_s_1800_sites_index temp_potential_sites temp_distributed_sites P non_GERAN_sites i
clear EUTRAN_CA_1800_sites EUTRAN_CA_2100_sites EUTRAN_CA_900_sites EUTRAN_CA_sites...
    EUTRAN_s_1800_sites EUTRAN_s_2100_sites EUTRAN_s_900_sites EUTRAN_s_sites...
    GERAN1800_sites GERAN900_sites GERAN900_refarming_sites...
    UTRAN900_sites UTRAN2100_sites
clear temp_actual_sites temp_sites_position ;


%**************************************************************************
% Part 3: Transmission lines to sites in site_infrastructure structure
%**************************************************************************
% owned or leased tramnsmission lines in use (1=YES, 0=NO)
% set randomly which sites are equipped with their owned transmission lines 

temp_sites_with_owned_transmission = zeros(1,length(site_infrastructure)); 
temp_ix = randperm(length(site_infrastructure)); 
temp_ix = temp_ix(1:ceil(inputs_technology.extra.owned_RAN_transmission_share*length(site_infrastructure)));
temp_sites_with_owned_transmission(temp_ix) = 1;
%temp_sites_with_owned_transmission(1:ceil(inputs_technology.extra.owned_RAN_transmission_share*length(site_infrastructure))) = 1;
%temp_sites_with_owned_transmission = ones(1,length(site_infrastructure));

for i = 1:length(site_infrastructure)
    site_infrastructure(i).transmission.owned_transmission_lines = temp_sites_with_owned_transmission(i);
    site_infrastructure(i).transmission.leased_transmission_lines = double(~temp_sites_with_owned_transmission(i));
end

clear temp_ix temp_sites_with_owned_transmission i;