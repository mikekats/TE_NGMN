% Techno-economics of Radio Access Networks
% version: 1
% date: August-November 2017
% developer: Michail Katsigiannis

clear;
clc;

teran_SR; % Short-Run cost model
teran_D;  % Demand model
teran_LR_initial; % Long-Run cost model initialization

hMainFigure = teranGUI(inputs_market_industry, inputs_technology, inputs_costs, inputs_finance,...
                    site_infrastructure, network_information, network_cost, network_energy, network_throughput_progression,...
                    inputs_demand_parameters,market_demand_revenues);

teran_LR; % Long-Run cost model   
