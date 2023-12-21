clc
clear
wd = 'C:\Users\Martin\Desktop\FinEc_Examples\Crypo_data';
cd(wd)
addpath(genpath(wd))

%%

Type = 'Trades';

% Trades prouces datasets of a couple of GB. Use Prices only.

% tickers = {'BTC','ETH','BCH','LTC','TRX','XLM','XRP','ADA','DOT'};
% tickers = {'BTC','ETH','ADA','XLM','LTC'};
tickers = {'BTC'}

data = struct;
s_dir = fullfile('Timetables',Type);
t_all = tic;

for j = 1:numel(tickers)
    t_self = tic;
    
    ticker = tickers{j};
    d = dir(fullfile(Type,['*' ticker '*']));
    n = numel(d);
    
    z = cell(n,1);
    for i = 1:n
        z{i,1} = load(fullfile(d(i).folder,d(i).name));
        if mod(i,25) == 0
            fprintf('Ticker %s, File %i/%i done.\n',ticker,i,n)
        end
    end
    
    w = cellfun(@(c) timetable2table(c.tt),z,'uni',0)';
    tab = vertcat(w{:});
    tab = table2timetable(tab);
    
    switch Type
        case 'Prices'
            save(fullfile(s_dir,[Type '_' ticker '.mat']),'tab','ticker') %Saves a timetable for each ticker
        case 'Trades'
            save(fullfile(s_dir,[Type '_' ticker '.mat']),'tab','ticker','-v7.3')
    end
    
    data.(ticker) = tab;
    
    fprintf('Ticker %s (%i/%i) done. Self: %.2f sec., Total: %.2f min.\n\n',...
        ticker,j,numel(tickers), toc(t_self), toc(t_all)/60)
    
end

if strcmp(Type,'Prices')    
    save(fullfile(s_dir,[Type '.mat']),'data') %Saves a struct with the timetables for all the stocks in tickers "Prices" file
    % [p,T,tab] = make_general_tables(data);
    % save(fullfile(s_dir,[Type '.mat']),'data','p','T','tab') %Saves several timetables, retimed to common dates
end

%%

function[p,T,tab] = make_general_tables(data)
% ut: common time tickers
% p: prices on ut
% tab: all data on ut

Ti = structfun(@(s) s.Time,data,'uni',0)';
Tc = struct2cell(Ti)';
Tc = Tc{:};
T = unique(Tc);
tab = structfun(@(s) retime(s,T),data,'uni',0);
p = structfun(@(s) s.Price,tab,'uni',0);
p = struct2table(p);
p.Properties.VariableNames = fieldnames(data);
p = table2timetable(p,'RowTimes',T);
end


