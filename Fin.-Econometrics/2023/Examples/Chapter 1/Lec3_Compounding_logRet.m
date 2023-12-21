
%% Example Compouding interest

C = 1; %initial capital
r = 0.1; %Annual net rate
% close all


f_list = [1,2];% Number of periods
n = numel(f_list);

P_final = zeros(n,4);
P_final(:,1) = f_list;
P_final(:,2) = C;


for i = 1:n

    f = f_list(i);
    x = linspace(0,1,f+1);
    clear p
    p = [C,C*(1+r/f).^(1:f)];
    P_final(i,3) = p(end);

    hold on
    plot(x,p,'.-')
end

hold off
grid
box on

lbl = arrayfun(@(i) ['Frequency: 1/' num2str(i)],f_list,'UniformOutput',0);

legend(lbl,'Location','southeast')
xlabel('Fraction of the year')
ylabel('Wealth')

P_final(:,4) = P_final(:,3)./P_final(:,2)-1;
P_final(end+1,:) = [Inf,C(1),C(1)*exp(r),exp(r)-1];

% Summary table
tab = array2table(P_final,'VariableNames',{'Num Periods','Initial','Final','Net Retrun'});

clearvars -except tab

%% Example distrubtion e^X with X normal

x = normrnd(0,1,10000,1);
subplot(2,1,1)
histogram(x,'NumBins',50)
subplot(2,1,2)
histogram(exp(x),'NumBins',50)

%% r \approx R

clc

% Generate small R (net)
R = -0.15;

% Get the respective r (logret)
r = log(1+R);

subplot(2,1,1)
p = histogram(R,'NumBins',50);
title('R')

subplot(2,1,2)
histogram(r,'NumBins',50)
title('r')

[R,r,abs((R-r)/R)]*100


%% Logret-Netret approximation

x = -1:0.01:3;
plot(x,[x;log(1+x)])
xlabel('R')
ylabel('r')
legend({'$r=R$','$r = \log(1+R)$'},'Interpreter','latex')
grid

%% Compute logreturns and net returns
clear
clc

load("AAPL.mat") %load data
p = str.AAPL.Close; %Take apple Closing prices

% Compute logreturns
lr = diff(log(p));

% Compute net retuns
t = p(2:end);
y = p(1:end-1);

% Put t and y next to each other and have a look
z = [t,y];
% z is a matrix that contains for each row today's price and yesterday's
% price: compare it with the entries in p

% To copute net returs you need to "(t-y)/y"
nr = (t-y)./y;

% or t/y-1"

nr2 = t./y-1;

plot(nr,lr,'.')
xlabel('Net returns')
ylabel('Log returns')
refline(1,0)
grid
% Compared with the diagonal, logrets are always below it, except at zero netret,
% that is logret <= netret





