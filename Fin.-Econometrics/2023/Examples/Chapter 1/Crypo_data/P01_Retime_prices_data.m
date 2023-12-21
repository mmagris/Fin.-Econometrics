
% Takes the Price table and retimes it at a given sampling frequency

clc
clear
wd = 'C:\Users\Martin\Desktop\Crypo_data';
cd(wd)
addpath(genpath(wd))

load(fullfile('Timetables/Prices/Prices'));

r = struct;
all_tickers = fieldnames(data);

Ts = [duration(0,0,0):duration(0,5,0):duration(23,59,0)]';
for j = 1:numel(all_tickers)
    
    ticker = all_tickers{j};
    s = data.(ticker);
    
    s.Day = dateshift(s.Time,'start','day');
    s.Day.Format = 'yyyy-MM-dd';
    uD = unique(s.Day);
    
    nD = numel(uD);
    
    allT = cell(nD,1);
    for i = 1:nD
        
        allT{i} = uD(i) + Ts;
    end
    
    allT = vertcat(allT{:});
    allT.Format = 'yyyy-MM-dd HH:mm';
    
    s = retime(s,allT,'previous');
    r.(ticker) = s(:,[1:3]);
    
end

D = s.Day;
p = struct2table(structfun(@(s) s.Price,r,'uni',0));
p = table2timetable(p,'RowTimes',allT);

save(fullfile('Timetables/Prices/','Prices_retime.mat'),'r','p')

%%




%%

