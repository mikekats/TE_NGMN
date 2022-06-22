%**************************************************************************
% Long-Run cost model 
%**************************************************************************

% Scenario: Macro evolution
% LTE Carrier aggregation. 
% target: 100% area coverage
% 'EUTRAN@2600+2100+1800, LTE-A, R13, CA, 20+20+20 MHz, 256 QAM, 4x4 MIMO, 1380 Mbps'
  
while 1    

    while 1
        if ~ishandle(hMainFigure);break;end;
        waitfor(findobj(hMainFigure,'Tag','push_button_in_slider'),'visible','off')
        
        if ~ishandle(hMainFigure);break;end;        
        LR_network_information_growth_snapshot.traffic_growth_snapshot_index = getappdata(0,'traffic_growth_snapshot_index');
        
        hwb = waitbar(1, 'Calculating future network costs ...');      
        LR7_sites_to_invest_due_to_traffic;
        LR8_investments_scenario;
        LR9_network_information;
        LR10_investments_cost;
        LR11_assets_value;
        LR12_operating_costs; 
        LR_D_marginal;
        setappdata(hMainFigure, 'LR_network_information_growth_snapshot', LR_network_information_growth_snapshot);
        setappdata(hMainFigure, 'LR_site_infrastructure', LR_site_infrastructure);
        setappdata(hMainFigure, 'LR_network_information', LR_network_information);
        setappdata(hMainFigure, 'LR_network_cost', LR_network_cost);
        setappdata(hMainFigure, 'LR_network_energy', LR_network_energy);       
        setappdata(hMainFigure, 'LR_inputs_market_industry', LR_inputs_market_industry); 
        setappdata(hMainFigure, 'LR_inputs_finance', LR_inputs_finance); 
        setappdata(hMainFigure, 'LR_inputs_technology', LR_inputs_technology); 
        setappdata(hMainFigure, 'market_demand_revenues', market_demand_revenues); 
        close(hwb);
        
        set(findobj(hMainFigure,'Tag','panel_LR_in_slider'),'visible','on');
        break
     
    end
    
    if ~ishandle(hMainFigure);break;end;
    waitfor(findobj(hMainFigure,'Tag','push_button_in_slider'),'visible','on')
    clear LR_network_information_growth_snapshot LR_site_infrastructure LR_network_information LR_network_cost LR_network_energy;
      
end

clear hMainFigure hwb;
