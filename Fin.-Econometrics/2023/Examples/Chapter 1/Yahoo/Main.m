
clear
clc
mkdir('Data')

% List of stocks: DJI, SP100, or make your own in StockList
DJI = {'AAPL','AMGN','AXP','BA','CAT','CRM','CSCO','CVX','DIS','HAL','GS','HD',...
'HON','IBM','INTC','JNJ','JPM','KO','MCD','MMM','MRK','MSFT','NKE','PG','TRV',...
'UNH','V','VZ','WBA','WMT'};
% DOW (available only from 2019),
% replaced with HAL (that was replace by DOW but still exists)


SP100 = {'AAPL','ABBV','ABT','ACN','ADBE','AIG','AMD','AMGN','AMT','AMZN','AVGO','AXP','BA','BAC','BK','BKNG',...
'BLK','BMY','BRK-B','C','CAT','CHTR','CL','CMCSA','COF','COP','COST','CRM','CSCO','CVS','CVX','DHR',...
'DIS','HAL','DUK','EMR','EXC','F','FDX','GD','GE','GILD','GM','GOOG','GOOGL','GS','HD','HON',...
'IBM','INTC','JNJ','JPM','KHC','KO','LIN','LLY','LMT','LOW','MA','MCD','MDLZ','MDT','MET','META',...
'MMM','MO','MRK','MS','MSFT','NEE','NFLX','NKE','NVDA','ORCL','PEP','PFE','PG','PM','PYPL','QCOM',...
'RTX','SBUX','SCHW','SO','SPG','T','TGT','TMO','TMUS','TSLA','TXN','UNH','UNP','UPS','USB','V',...
'VZ','WBA','WFC','WMT','XOM'};

StockList = {'AAPL'};

%%


Tickers = StockList;  % List of stock to download
lbl = 'AAPL';   % Label to use for the saved files

date_start  = '1-Jan-2016';
date_end    = datetime('today');


% Download data in a struct
for i = 1:min(numel(Tickers),500)
    

    s = Tickers{i};
    
    data = getMarketDataViaYahoo(s, datestr(datetime(date_start)-days(5)), date_end, '1d');
    data = table2timetable(data);

    data.Rcc = [nan;diff(log(data.AdjClose))]*100;

    tr = timerange(date_start,date_end,'closed');
    data = data(tr,:);
    
    fprintf('Stock %03i/%03i: %s.\n',i,numel(Tickers),s)

    str.(strrep(s,"-","")) = data;

end

Tickers = fieldnames(str);
save(['Data\' lbl '.mat'],'str','Tickers')

% Retimed data on common dates;
d = structfun(@(s) s.Date,str,'uni',0);
c = struct2cell(d);
ud = unique(cat(1,c{:}));
z = structfun(@(s) retime(s,ud),str,'uni',0);
r = structfun(@(s) s.Rcc,z,'UniformOutput',0);
r = struct2table(r);

% Close-to-close Returns' timetable
r = table2timetable(r,"RowTimes",ud);

save(['Data\' lbl '_ret.mat'],'r','Tickers')

%%

function data = getMarketDataViaYahoo(symbol, startdate, enddate, interval)

    if(nargin() == 1)
        startdate = posixtime(datetime('1-Jan-2018'));
        enddate = posixtime(datetime()); % now
        interval = '1d';
    elseif (nargin() == 2)
        startdate = posixtime(datetime(startdate));
        enddate = posixtime(datetime()); % now
        interval = '1d';
    elseif (nargin() == 3)
        startdate = posixtime(datetime(startdate));
        enddate = posixtime(datetime(enddate));        
        interval = '1d';
    elseif(nargin() == 4)
        startdate = posixtime(datetime(startdate));
        enddate = posixtime(datetime(enddate));
    else
        error('At least one parameter is required. Specify ticker symbol.');
        data = [];
        return;
    end
    
    % Send a request for data
    % Construct an URL for the specific data
    uri = matlab.net.URI(['https://query1.finance.yahoo.com/v7/finance/download/', upper(symbol)],...
        'period1',  num2str(int64(startdate), '%.10g'),...
        'period2',  num2str(int64(enddate), '%.10g'),...
        'interval', interval,...
        'events',   'history',...
        'frequency', interval,...
        'guccounter', 1,...
        'includeAdjustedClose', 'true');  
    
    options = weboptions('ContentType','table', 'UserAgent', 'Mozilla/5.0');
    try
        data = rmmissing(webread(uri.EncodedURI, options));
    catch ME
        data = [];
        warning(['Identifier: ', ME.identifier, 'Message: ', ME.message])
    end 
end