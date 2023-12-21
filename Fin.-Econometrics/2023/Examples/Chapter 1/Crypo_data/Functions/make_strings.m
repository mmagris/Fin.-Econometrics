function[url,date_str_read,tmp_path_zip,tmp_path_csv,tmp_path_mat] = make_strings(Day,ticker,Type)

switch Type
    
    case 'Trades'
        link    = 'https://data.binance.vision/data/spot/daily/trades';
        f_file  = @(ticker,date_str_read) [ticker '-trades-' date_str_read];
        f_url   = @(link,ticker,file) [link '/' ticker '/' file '.zip'];
    case 'Prices'
        link = 'https://data.binance.vision/data/spot/daily/klines/';
        f_file  =@(ticker,date_str_read) [ticker '-1m-' date_str_read];
        f_url   =@(link,ticker,file)[link ticker '/1m/' file '.zip'];
end

date_str_save = datestr(Day,'yyyymmdd');
date_str_read = datestr(Day,'yyyy-mm-dd');

file = f_file(ticker,date_str_read);
url = f_url(link,ticker,file);

tmp_path_zip = fullfile('Temp',Type,[file '.zip']);
tmp_path_csv = fullfile('Temp',Type,[file '.csv']);
tmp_path_mat = fullfile(Type,[date_str_save '_' ticker '.mat']);

end