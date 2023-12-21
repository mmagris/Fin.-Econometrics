
clear
clc
load('C:\Users\Martin\Desktop\FinEc_Examples\HAR\VolData.mat')

t = Vol.DJI.r;

%% just put today's volatility

for i = 23:1363

M(i,4) = mean(t(i-22:i-1));

end

%% Fill yesteday's volatility
M = nan(1363,4)

for i = 1:1363

M(i,1) = t(i);

end

%% Fill weekly volatility

for i = 6:1363

M(i,3) = mean(t(i-5:i-1));

end

%% Fill monthly volatility

for i = 23:1363

M(i,4) = mean(t(i-22:i-1));

end

%% Done with a single loop

M = nan(1363,4)

for i = 23:1363

M(i,1) = t(i);
M(i,2) = t(i-1);
M(i,3) = mean(t(i-5:i-1));
M(i,4) = mean(t(i-22:i-1));

end

%% Remove the first 22 rows where there are NaNs

M(1:22,:)=[]

%% 

y = M(:,1); %dep. variable
X = M(:,2:4); % Design matrix (without col of ones)

lm = fitlm(X,y) %fit model

%%

plot(lm.Residuals.Raw) %plot residuals

%%


llm = fitlm(log(X),log(y)) %fit model in the logs

mean(llm.Residuals.Raw)
 %plot residuals