%% Roll's model on BTC data
load("20231001_BTCUSDT.mat")

dp = diff(tt.Price);
autocorr(dp) % Indeed first-order autocov is negative
% But look carefully, also higher-order autocov are... we expect the roll
% model not to work so well

C = cov(dp(1:end-1),dp(2:end));
gamma_1 = C(1,2); % from vcov matrix
gamma_1 = mean(dp(1:end-1).*dp(2:end)); % direct
c = sqrt(-gamma_1); % This cost indeed appears to be quite huge

%% Vol-Signature plot

dt_list = sort([1/120,1/60,2/60,3/60,5/60,0.5,1:1:20,25:5:115,120:15:300]);

clear V

V = zeros(numel(dt_list),1);

for i = 1:numel(dt_list)

dt = dt_list(i);
rT = retime(tt,'regular','previous','TimeStep',minutes(dt));

r = diff(log(rT.Price));

V(i) = sqrt(nansum(r.^2))*252;

end

plot(dt_list,V,'.-')
grid
xlabel('Minutes')
ylabel('Annualized Volatility (%)')
title('Volatility signature plot BTC/USD 1-Oct-2023')

%%

