function [] = io_write_site_infrastructure_to_file(site_infrastructure)
%io_write_site_infrastructure_to_file Summary of this function goes here
%   Detailed explanation goes here

    header_cell_format = '%s %10s %10s %10s %10s %10s %10s %10s %10s %10s %10s %10s %10s %10s %10s %10s %10s %10s %10s %10s %10s %10s %10s %10s %10s %10s %10s %10s %10s %10s %10s\r\n';
    
%********************* write file for eNodeBs_s_cells *************************%

    EUTRAN_s_FileID = fopen('cells_EUTRAN_s.txt', 'w');
    fprintf(EUTRAN_s_FileID, header_cell_format, 'number','|','site_ID','|','site_type','|','longitude','|','latitude','|','site_deployment_year','|',...
                    'cell_ID','|','configuration','|','band','|','BW','|','cell_range_km','|','cell_direction_az','|','cell_capacity_Mbps','|','cell_throughput_Mbps','|','cell_deployment_year','|','owned_transmission');
    write_cells_fprintf(EUTRAN_s_FileID,'EUTRAN_s','sector')   

%********************* write file for eNodeBs_CA_cells ************************%

    EUTRAN_CA_FileID = fopen('cells_EUTRAN_CA.txt', 'w');
    fprintf(EUTRAN_CA_FileID, header_cell_format, 'number','|','site_ID','|','site_type','|','longitude','|','latitude','|','site_deployment_year','|',...
                    'cell_ID','|','configuration','|','band','|','BW','|','cell_range_km','|','cell_direction_az','|','cell_capacity_Mbps','|','cell_throughput_Mbps','|','cell_deployment_year','|','owned_transmission');
    write_cells_fprintf(EUTRAN_CA_FileID,'EUTRAN_CA','sector')
    
%********************* write file for NodeBs_cells*****************************%

    UTRAN_FileID = fopen('cells_UTRAN.txt', 'w');
    fprintf(UTRAN_FileID, header_cell_format, 'number','|','site_ID','|','site_type','|','longitude','|','latitude','|','site_deployment_year','|',...
                    'cell_ID','|','configuration','|','band','|','BW','|','cell_range_km','|','cell_direction_az','|','cell_capacity_Mbps','|','cell_throughput_Mbps','|','cell_deployment_year','|','owned_transmission');
    write_cells_fprintf(UTRAN_FileID,'UTRAN','sector2100')
    
    UTRAN_FileID = fopen('cells_UTRAN.txt', 'a');
    write_cells_fprintf(UTRAN_FileID,'UTRAN','sector900')
    
%********************* write file for BTS_cells********************************%

    GERAN_FileID = fopen('cells_GERAN.txt', 'w');
    fprintf(GERAN_FileID, header_cell_format, 'number','|','site_ID','|','site_type','|','longitude','|','latitude','|','site_deployment_year','|',...
                    'cell_ID','|','configuration','|','band','|','BW','|','cell_range_km','|','cell_direction_az','|','cell_capacity_Mbps','|','cell_throughput_Mbps','|','cell_deployment_year','|','owned_transmission');    
    write_cells_fprintf(GERAN_FileID,'GERAN','sector900')
    
    GERAN_FileID = fopen('cells_GERAN.txt', 'a');
    write_cells_fprintf(GERAN_FileID,'GERAN','sector1800')

%**************************************************************************
% Nested functions
%**************************************************************************
%******************** nested function for writing the file ********************%
   
    function write_cells_fprintf(FileID,temp_RAN,temp_sector)
        
        number_of_site = 0;

        for i = 1:length(site_infrastructure)  
            if ~isempty(site_infrastructure(i).(temp_RAN))
                if isfield(site_infrastructure(i).(temp_RAN),temp_sector) 
                    number_of_site = number_of_site+1;
                    for j = 1:length(site_infrastructure(i).(temp_RAN).(temp_sector))
                        fprintf(FileID, '%.0f\t\t', number_of_site);
                        fprintf(FileID, '%s\t\t', '|');
                        fprintf(FileID, '%s\t\t', site_infrastructure(i).site_ID);
                        fprintf(FileID, '%s\t\t', '|');
                        fprintf(FileID, '%s\t\t', site_infrastructure(i).site_type);
                        fprintf(FileID, '%s\t\t', '|');
                        fprintf(FileID, '%.5f\t\t', site_infrastructure(i).longitude);
                        fprintf(FileID, '%s\t\t', '|');
                        fprintf(FileID, '%.5f\t\t', site_infrastructure(i).latitude);
                        fprintf(FileID, '%s\t\t', '|');
                        fprintf(FileID, '%.0f\t\t', site_infrastructure(i).development_year);
                        fprintf(FileID, '%s\t\t', '|');
                        fprintf(FileID, '%s\t\t', site_infrastructure(i).(temp_RAN).(temp_sector)(j).cell_ID);
                        fprintf(FileID, '%s\t\t', '|');
                        fprintf(FileID, '%s\t\t', site_infrastructure(i).(temp_RAN).(temp_sector)(j).configuration);
                        fprintf(FileID, '%s\t\t', '|');
                        fprintf(FileID, '%.1f\t\t', site_infrastructure(i).(temp_RAN).(temp_sector)(j).band); 
                        fprintf(FileID, '%s\t\t', '|');
                        fprintf(FileID, '%.3f\t\t', site_infrastructure(i).(temp_RAN).(temp_sector)(j).BW); 
                        fprintf(FileID, '%s\t\t', '|');
                        fprintf(FileID, '%.3f\t\t', site_infrastructure(i).(temp_RAN).(temp_sector)(j).cell_range_km);
                        fprintf(FileID, '%s\t\t', '|');
                        fprintf(FileID, '%.3f\t\t', site_infrastructure(i).(temp_RAN).(temp_sector)(j).cell_direction_az);
                        fprintf(FileID, '%s\t\t', '|');
                        fprintf(FileID, '%.15f\t\t', site_infrastructure(i).(temp_RAN).(temp_sector)(j).cell_capacity_Mbps);
                        fprintf(FileID, '%s\t\t', '|');
                        fprintf(FileID, '%.15f\t\t', site_infrastructure(i).(temp_RAN).(temp_sector)(j).cell_throughput_Mbps);
                        fprintf(FileID, '%s\t\t', '|');
                        fprintf(FileID, '%.0f\t\t', site_infrastructure(i).(temp_RAN).(temp_sector)(j).development_year);
                        fprintf(FileID, '%s\t\t', '|');
                        fprintf(FileID, '%.0f\r\n', site_infrastructure(i).transmission.owned_transmission_lines);
                    end
                end
            end       

        end

        fclose(FileID);
    end
    
end                                      