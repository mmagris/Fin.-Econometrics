clc
clear
wd = 'C:\Users\Martin\Desktop\FinEc_Examples\Crypo_data';
cd(wd)
addpath(genpath(wd))


%%
clc
Type = 'Trades';

% tickers = {'BTC','ETH','ADA','XLM','LTC'};
tickers = {'BTC'}

tickers = cellfun(@(c) [c 'USDT'], tickers,'UniformOutput',0);

date_from   = datetime(2023,10,01);
date_to     = datetime(2023,10,03);
days        = date_from:date_to;

remove_files = true;
i = 0;

%%
clc

fprintf('------ Working on %s ------\n',Type)
t_all = tic;

for Day = days
    i=i+1;
    
    for curr_ticker = 1:numel(tickers)
        t_Day_ticker = tic;
        ticker = tickers{curr_ticker};
        
        [url,date_str_read,tmp_path_zip,tmp_path_csv,tmp_path_mat] = make_strings(Day,ticker,Type);
        
        try
            
            websave(tmp_path_zip,url);
            u = unzip(tmp_path_zip,fullfile('Temp',Type));
            tab = readtable(tmp_path_csv);
            
            switch Type
                case 'Trades'
                    t = datetime(tab.Var5,'ConvertFrom','epochtime','TicksPerSecond',1e3,'Format','dd-MMM-yyyy HH:mm:ss.SSS');
                    tt = tab(:,[2 3 6]);
                    tt.Properties.VariableNames = {'Price','Volume','IsBuyer'};
                    tt.IsBuyer = strcmp('True',tab.Var6);
                case 'Prices'
                    t = datetime(tab.Var1,'ConvertFrom','epochtime','TicksPerSecond',1e3,'Format','dd-MMM-yyyy HH:mm');
                    tt = tab(:,[5 6 9]);
                    tt.Properties.VariableNames = {'Price','Volume','Trades'};
            end
            
            tt = table2timetable(tt,'RowTimes',t);
            save(tmp_path_mat,'tt')
            
            if remove_files
                delete(tmp_path_zip)
                delete(tmp_path_csv)
            end
            
            fprintf('%s. Day %.3i/%.3i (%s) %s, done. Self: %.2f sec., Total: %.2f min.\n',...
                Type,i,numel(days),ticker, date_str_read, toc(t_Day_ticker), toc(t_all)/60)
            
        catch
            
            fprintf('WARNING. %s, ticker: %s. Problem on day %s.\n',Type,ticker,date_str_read)
            if dir(tmp_path_zip).bytes <10
                fprintf('WARNING. %s, ticker: %s. Files is empty %s.\n',Type,ticker,date_str_read)
            end
            
        end
        
    end
    
    
end


%%

