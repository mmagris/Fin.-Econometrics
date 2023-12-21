clc
clear
wd = 'C:\Users\Martin\Desktop\Crypo_data';
cd(wd)
addpath(genpath(wd))

%% Creates a struct containing the data for the different sticker for a single day

a = load('Trades\20231001_ADAUSDT.mat');
b = load('Trades\20231001_BTCUSDT.mat');

data = struct();
data.ADA = a.tt;
data.DOT = b.tt;
save(fullfile('GroupedTrades/Trades_ADA_ETH_1d.mat'),'data')

%% Create a struct containing the data for the different sticker for a certain time period

clear
clc

from    = datetime('2021-Dec-01');
to      = datetime('2021-Dec-10');

da = dir(fullfile("Trades",'*ADA*'));
db = dir(fullfile("Trades",'*ETH*'));

days_a = cellfun(@(c) c(1:8),{da.name},'uni',0);
days_a = cellfun(@(c) datetime(str2double(c),'ConvertFrom','yyyymmdd'),days_a)';

days_b = cellfun(@(c) c(1:8),{db.name},'uni',0);
days_b = cellfun(@(c) datetime(str2double(c),'ConvertFrom','yyyymmdd'),days_b)';

da = da(days_a>=from & days_a <= to,:);
db = db(days_b>=from & days_b <= to,:);

if numel(da)~=numel(db)
    warning('Different number of days.')
end

clear from to days_a days_b

n = numel(da);
v = cell(n,2);

for i = 1:n
    sa = load(fullfile(da(i).folder,da(i).name),'-mat','tt');
    v{i,1} = sa.tt;
    sa = load(fullfile(db(i).folder,db(i).name),'-mat','tt');
    v{i,2} = sa.tt;
end

va = vertcat(v(:,1));
ta = vertcat(va{:});

vb = vertcat(v(:,2));
tb = vertcat(vb{:});

clear from to days_a days_b v va vb sa i n

data = struct();
data.ADA = ta;
data.DOT = tb;
save(fullfile('GroupedTrades/Trades_ADA_ETH_10d.mat'),'data')
