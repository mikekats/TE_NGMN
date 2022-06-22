%***************************** Inputs (new)********************************
% service/product = mobile data traffic unit (GB/month) in retail households
% Quantity, Price and experienced user data rates factor

   
inputs_demand_parameters =  struct(...   %[2007 2008 2009 2010 2011 2012 2013 2014 2015 2016]
        'market_share_mno',[0.38, 0.37, 0.38, 0.39, 0.39, 0.4, 0.4, 0.4, 0.39, 0.38],...
        'future_market_share_mno',[0.38, 0.38, 0.38, 0.38],... (2017-2020)
        'quantity',[44629.33333, 414464, 1376853.333, 2873002.667, 5250133.333, 8751616, 15253333.33, 27700736, 53534378.67 90474752],...  %GB/month
        'determinants_of_demand',struct(......
                                'price',[134.5962067, 28.55093165, 10.15455531, 6.658614143, 4.834074935, 3.791760034, 2.900094697, 1.877775586, 1.130236215, 0.756627619],...%€/GB/month
                                'experienced_user_data_rate_factor',[0.1 0.1 0.1 0.1 0.1 1 1 1 1 1],...        %Generation related parameter, 3G Era (2007-2011) and 4G Era (2012-2016)
                                'future_experienced_user_data_rate_factor',[10 10 10 100]));           %Generation related parameter, 4G pro Era (2017-2019) and 5G 1st phase Era (2020-)