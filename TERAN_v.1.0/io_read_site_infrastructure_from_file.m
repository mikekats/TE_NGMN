function [site_infrastructure] = io_read_site_infrastructure_from_file(file_EUTRAN_s, file_EUTRAN_CA, file_UTRAN, file_GERAN)
%io_read_site_infrastructure_from_file Summary of this function goes here
%   Detailed explanation goes here

%**************************************************************************
% Part 0: Read files to find:
% i)   the number of unique sites (needed for structure's memory allocation)
% ii)  the sites_ID
% iii) the number of sectors per site
%**************************************************************************
        
temp_sites_and_sectors_info_EUTRAN_CA = get_sites_and_sectors_info(file_EUTRAN_CA);
temp_sites_EUTRAN_CA = temp_sites_and_sectors_info_EUTRAN_CA{1};
temp_sector_numbering_EUTRAN_CA = temp_sites_and_sectors_info_EUTRAN_CA{2};
%temp_sectors_per_site_EUTRAN_CA = temp_sites_and_sectors_info_EUTRAN_CA{3};
temp_less_sectored_sites_EUTRAN_CA  = temp_sites_and_sectors_info_EUTRAN_CA{4};

temp_sites_and_sectors_info_EUTRAN_s = get_sites_and_sectors_info(file_EUTRAN_s);
temp_sites_EUTRAN_s = temp_sites_and_sectors_info_EUTRAN_s{1};
temp_sector_numbering_EUTRAN_s = temp_sites_and_sectors_info_EUTRAN_s{2};
%temp_sectors_per_site_EUTRAN_s = temp_sites_and_sectors_info_EUTRAN_s{3};
temp_less_sectored_sites_EUTRAN_s  = temp_sites_and_sectors_info_EUTRAN_s{4};

temp_sites_and_sectors_info_UTRAN = get_sites_and_sectors_info(file_UTRAN);
temp_sites_UTRAN = temp_sites_and_sectors_info_UTRAN{1};
temp_sector_numbering_UTRAN = temp_sites_and_sectors_info_UTRAN{2};
%temp_sectors_per_site_UTRAN = temp_sites_and_sectors_info_UTRAN{3};
temp_less_sectored_sites_UTRAN  = temp_sites_and_sectors_info_UTRAN{4};

temp_sites_and_sectors_info_GERAN = get_sites_and_sectors_info(file_GERAN);
temp_sites_GERAN = temp_sites_and_sectors_info_GERAN{1};
temp_sector_numbering_GERAN = temp_sites_and_sectors_info_GERAN{2};
%temp_sectors_per_site_GERAN = temp_sites_and_sectors_info_GERAN{3};
temp_less_sectored_sites_GERAN  = temp_sites_and_sectors_info_GERAN{4};

temp_all_unique_sites =  [unique(temp_sites_EUTRAN_CA,'stable'); 
                          unique(temp_sites_EUTRAN_s,'stable');
                          unique(temp_sites_UTRAN,'stable');
                          unique(temp_sites_GERAN,'stable')];
            
temp_all_unique_sites = unique(temp_all_unique_sites,'stable');                      
temp_number_of_sites = length(temp_all_unique_sites);


%**************************************************************************
% Part 1: Define and initialize struct (allocate memory) 
%**************************************************************************

site_infrastructure = define_site_infrastructure_struct(temp_number_of_sites);

%**************************************************************************
% Part 2: Read files and assign the information to site_infrastructure
%**************************************************************************

assign_to_site_infrastructure(file_EUTRAN_CA, temp_all_unique_sites, temp_sector_numbering_EUTRAN_CA, temp_less_sectored_sites_EUTRAN_CA, 'EUTRAN_CA', 'sector');
assign_to_site_infrastructure(file_EUTRAN_s, temp_all_unique_sites, temp_sector_numbering_EUTRAN_s, temp_less_sectored_sites_EUTRAN_s, 'EUTRAN_s', 'sector');
assign_to_site_infrastructure(file_UTRAN, temp_all_unique_sites, temp_sector_numbering_UTRAN, temp_less_sectored_sites_UTRAN, 'UTRAN', {'sector900' 'sector1800' 'sector2100'});
assign_to_site_infrastructure(file_GERAN, temp_all_unique_sites, temp_sector_numbering_GERAN, temp_less_sectored_sites_GERAN, 'GERAN', {'sector900' 'sector1800' 'sector2100'});

%**************************************************************************
% Nested functions
%**************************************************************************

    function temp_sites_and_sectors_info  = get_sites_and_sectors_info(file) 
        % 1. open file, read the site_ID column and close file
        % 2. find the site list (i.e., number of cells) in the specific RAN
        % 3. find the sector numbering index in site list
        % 4. find the number of sectors per site for the specific RAN
        % 5. find the unused sectors per site
        % Assumption: Sites might be repeated in the text file, but
        % adjacent lines with same site_ID means different sector in the
        % same site
        
        % 1. open file, read the site_ID column and band and close file
        fileID = fopen(file, 'rt');
        fgetl(fileID); %skip header line
        formatSpec =  '%*.0f %s %*s %*.5f %*.5f %*.0f %*s %*s %s %*s %*s %*.3f %*.15f %*.15f %*.0f %*.0f'; 
        data = textscan(fileID, formatSpec,'Delimiter','|');
        fclose(fileID);
       
        % 2. find the site list (i.e., number of cells) in the specific RAN
        temp_site_ID = deblank(data{:,1});
        temp_band = deblank(data{:,2});
        temp_number_of_cells = length(temp_site_ID);

        temp_site_ID_per_cell = -1;
        temp_sector_index_per_cell = zeros(1,temp_number_of_cells);
        temp_sectors = 1;
        for i = 1 : temp_number_of_cells
            if isequal(temp_site_ID{i},temp_site_ID_per_cell)
                temp_sectors = temp_sectors + 1;
            else
                temp_sectors = 1;
            end
            % 3. find the sector numbering index in site list
            temp_sector_index_per_cell(i) = temp_sectors;
            temp_site_ID_per_cell = temp_site_ID{i};
        end
        % 4. find the number of sectors per site for the specific RAN
        temp_sites_index = find(temp_sector_index_per_cell==1);
        temp_sites = temp_site_ID(temp_sites_index);
        temp_band = temp_band((temp_sites_index));
        temp_sectors_per_site = [diff(temp_sites_index) length(temp_site_ID)-temp_sites_index(end)+1];
    
        % 5. find the unused sectors per site      
        temp_less_sectored_sites{1}= temp_sites(temp_sectors_per_site~=3);
        temp_less_sectored_sites{2}= temp_band(temp_sectors_per_site~=3);
        temp_less_sectored_sites{3}= temp_sectors_per_site(temp_sectors_per_site~=3)';
              
        temp_sites_and_sectors_info{1} = temp_sites;
        temp_sites_and_sectors_info{2} = temp_sector_index_per_cell;
        temp_sites_and_sectors_info{3} = temp_sectors_per_site;
        temp_sites_and_sectors_info{4} = temp_less_sectored_sites;
    end



    function assign_to_site_infrastructure(file, site_numbering, sector_numbering, less_sectored_sites, temp_RAN, temp_sector_initial)        
        % 1. open file, skip header and initialize needed variables
        fileID = fopen(file, 'rt');
        fgetl(fileID); %skip header line  
        formatSpec =  '%.0f %s %s %.5f %.5f %.0f %s %s %s %s %s %.3f %.15f %.15f %.0f %.0f'; 
        
        i = 1;
        temp_clone_site_numbering = site_numbering;
        temp_clone_site_numbering_900 = site_numbering;
        temp_clone_site_numbering_1800 = site_numbering;
        temp_clone_site_numbering_2100 = site_numbering;
       
        % iteration for each line
        % 2. read the line
        while (1)
            line = fgetl(fileID);
            if (~ischar(line))
                break
            end
            data = textscan(line, formatSpec,'Delimiter','|');
            
            % 3. get the site_ID, give number of sector of each cell
            % (line), give a running number for the site_infrastructure
            % based on the site_ID and the global site list
            % (site_numbering), assign with zeros the used sites
            temp_site_ID = deblank(data{2});
            temp_sector_num = sector_numbering(i);
            temp_site_num = find(strcmp(site_numbering,temp_site_ID));
            temp_clone_site_numbering{temp_site_num} = 0;
            
            % 4. assign temp_sector based on the RAN and its
            % frequency, assign with zeros the used sites with specific
            % frequency
            if ~iscell(temp_sector_initial)
                temp_sector = temp_sector_initial;
            else
                temp_band = str2num(cell2mat(data{9}));
                switch temp_band
                    case 0.9
                        temp_sector = temp_sector_initial{1};
                        temp_clone_site_numbering_900{temp_site_num} = 0;
                    case 1.8
                        temp_sector = temp_sector_initial{2};
                        temp_clone_site_numbering_1800{temp_site_num} = 0;
                    case 2.1
                        temp_sector = temp_sector_initial{3};
                        temp_clone_site_numbering_2100{temp_site_num} = 0;
                end
            end
            
            % 5. assign to site infrastrcture structure
            site_infrastructure(temp_site_num).site_ID = deblank(char(data{2}));
            site_infrastructure(temp_site_num).site_type = deblank(char(data{3}));
            site_infrastructure(temp_site_num).longitude = data{4};
            site_infrastructure(temp_site_num).latitude = data{5};
            site_infrastructure(temp_site_num).development_year = data{6};
            site_infrastructure(temp_site_num).(temp_RAN).(temp_sector)(temp_sector_num).cell_ID = deblank(char(data{7}));
            site_infrastructure(temp_site_num).(temp_RAN).(temp_sector)(temp_sector_num).configuration = deblank(char(data{8}));
            site_infrastructure(temp_site_num).(temp_RAN).(temp_sector)(temp_sector_num).band = str2num(cell2mat(data{9}));
            site_infrastructure(temp_site_num).(temp_RAN).(temp_sector)(temp_sector_num).BW = str2num(cell2mat(data{10}));
            site_infrastructure(temp_site_num).(temp_RAN).(temp_sector)(temp_sector_num).cell_range_km = str2num(cell2mat(data{11}));
            site_infrastructure(temp_site_num).(temp_RAN).(temp_sector)(temp_sector_num).cell_direction_az = data{12};
            site_infrastructure(temp_site_num).(temp_RAN).(temp_sector)(temp_sector_num).cell_capacity_Mbps = data{13};
            site_infrastructure(temp_site_num).(temp_RAN).(temp_sector)(temp_sector_num).cell_throughput_Mbps = data{14};
            site_infrastructure(temp_site_num).(temp_RAN).(temp_sector)(temp_sector_num).development_year = data{15};
            site_infrastructure(temp_site_num).transmission.owned_transmission_lines = data{16};
            site_infrastructure(temp_site_num).transmission.leased_transmission_lines = double(~data{16});
            site_infrastructure(temp_site_num).configurations = [site_infrastructure(temp_site_num).configurations ; {deblank(char(data{8}))}];
            site_infrastructure(temp_site_num).cell_directions = [site_infrastructure(temp_site_num).cell_directions ; {data{12}}];
            
            % 6. remove the empty sectors from the running site
            if ~isempty(find(strcmp(less_sectored_sites{1},temp_site_ID)))
                temp_index = find(strcmp(less_sectored_sites{1},temp_site_ID));
                if strcmp(deblank(data{9}),less_sectored_sites{2}(temp_index))
                     c = less_sectored_sites{3}(find(strcmp(less_sectored_sites{1},temp_site_ID)));
                     site_infrastructure(temp_site_num).(temp_RAN).(temp_sector)(c+1:end) = [];      
                end
            end
            
            i = i + 1;
        end % end of loop
        
        % 7. close file
        fclose(fileID);
 
        % 8. Remove the unused site_infrastructure.(temp_RAN).(temp_sector) structs
        % for temp_RAN temp_sector = {'sector900' 'sector1800' 'sector2100'}
        % i.e., UTRAN and GERAN
         if iscell(temp_sector_initial)
            remove_unused_sectors_structs(temp_clone_site_numbering_900,temp_sector_initial{1})
            remove_unused_sectors_structs(temp_clone_site_numbering_1800,temp_sector_initial{2})
            remove_unused_sectors_structs(temp_clone_site_numbering_2100,temp_sector_initial{3})
         end
            
        % 9. Empty the unused site_infrastructure.(temp_RAN) structs
        for j=1:length(temp_clone_site_numbering)
            if temp_clone_site_numbering{j}== 0
                continue
            else
                site_infrastructure(j).(temp_RAN)= [];
            end
        end

        
    %**********************************************************************
    % Nested function in assign_to_site_infrastructure
    %**********************************************************************
    function remove_unused_sectors_structs(unused_site_numbering,temp_sector)
         for k=1:length(unused_site_numbering)
            if unused_site_numbering{k}== 0
                continue
            else
                if isfield(site_infrastructure(k).(temp_RAN), temp_sector)
                    site_infrastructure(k).(temp_RAN) = rmfield(site_infrastructure(k).(temp_RAN),temp_sector);
                end
            end
        end
    end
    
    
    end

end


