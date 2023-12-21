%% Isomean Example

clear
clc

rp = 2.07;
x = linspace(0,2.5,2.5);
y = 0.99*rp-2.05*x;


plot(x,y)
hold on
refline(-1,1)
hold off

ylabel('$w_2$','Interpreter','latex')
xlabel('$w_1$','Interpreter','latex')
ylim([0 2.5])
xlim([0 2.5])
grid

legend({'Isomean','Budget constraint'})
title(['Isomean for portoflio return at ' num2str(rp,'%.2f%%')])

%% MVP

w1 = 0:0.01:1;
v = 48.20*w1.^2 + 34.25*(1-w1).^2 +2*w1.*(1-w1)*(-2.65);

tab = array2table([w1',v'],'VariableNames',{'w1','PortfolioVar'}); %tablulated results
tab

[~,indx] = min(v); %MVP index in w1
[w1(indx),(1-w1(indx))] %MVP weights

% Exact solution
w_1 = (34.25-(-2.65))/(48.20+34.25-2*(-2.65));
W_2 = 1-w_1;

%% Sig-E-space

fm = @(w) w*2.07 + (1-w)*1.01;
c = -0 ;%-2.65; % Show what changes;
fv = @(w) sqrt(48.20*w.^2 + 34.25*(1-w).^2 +2*w.*(1-w)*c);

I = [-5,5];% show what changes with with leverage

w = I(1) + rand(50,1)*(I(2)-I(1)); 
plot(fv(w),fm(w),'.')
hold on
plot(48.20^0.5,2.07,'xr')
plot(34.25^0.5,1.01,'xb')
hold off
grid
ylim([0,3])
xlim([4,9])
ylabel('Expected portfolio return')
xlabel('Portfolio variance')


%MVP
w1 = (34.25-c)/(34.25+48.20-2*c);
w2 = 1-w1;

hold on
plot(fv(w1),fm(w1),'xr')
hold off

xlim([0 10])
%%

% rng(1)
clc

r1 = 2.07;
r2 = 0.21;
r3 = 1.01;

s11 = 48.20;
s22 = 16.34;
s33 = 34.25;

s12 = 7.82;
s13 = -2.65;
s23 = 0.99;

S = [[s11,s12,s13];[s12,s22,s23];[s13,s23,s33]];
[s,C] = cov2corr(S)

w = rand(50000,3);
w = w./sum(w,2);

fm = @(w1,w2,w3) w1*r1+w2*r2+w3*r3;
fv = @(w1,w2,w3) sqrt(w1.^2*s11 + w2.^2*s22 + w3.^2*s33 +2*w1.*w2*s12 + 2*w1.*w3*s13 + 2*w2.*w3*s23);

M = fm(w(:,1),w(:,2),w(:,3));
V = fv(w(:,1),w(:,2),w(:,3));

plot(V,M,'.')
hold on
plot(sqrt([s11,s22,s33]),[r1,r2,r3],'or')
hold off


%%
clc
syms x y
f1 = 2*(s11+s33-2*s13)*x +(2*s33+2*s12-2*s13-2*s23)*y +(-2*s33+2*s13) == 0;
f2 = (2*s33+2*s12-2*s13-2*s23)*x + 2*(s22+s33-2*s23)*y +(-2*s33+2*s23) == 0;

sol = solve([f1,f2],[x y]);
w1 = double(sol.x);
w2 = double(sol.y);
w3 = double(1-w1-w2);

[w1,w2,w3] % MVP weights

mvp = fv(w1,w2,w3) % MVP variance

hold on
plot(mvp,fm(w1,w2,w3),'sqb')
hold off

%% Sig-E-space bis


rho = 0
c = rho*0.20*0.40;
% c = ;%-2.65; % Show what changes;

fm = @(w) w*0.05 + (1-w)*0.15;
fv = @(w) sqrt(0.20^2*w.^2 + 0.40^2*(1-w).^2 +2*w.*(1-w)*c);

I = [0,1]

w = I(1) + rand(500,1)*(I(2)-I(1)); 
plot(fv(w),fm(w),'.')
ylabel('Expected portfolio return')
xlabel('Portfolio variance')


hold on
plot(fv(2/3),fm(2/3),'xr')
hold off

xlim([0 0.5])
ylim([0 0.2])

%% Example 7.2 - find the weights for a portfolio p whose expected return is 1.5%

clear
clc

ep = 1.5; %Target expected return

e = [2.07;0.21;1.10]; %Expected retunrs
S = [[48.20,7.82,-2.65];[7.82,16.34,0.99];[-2.65,0.99,34.25]]; %Cov matrix
u = ones(3,1);
iS = inv(S);


A = u'*iS*e;
B = e'*iS*e;
C = u'*iS*u;
D = B*C-A^2;

g = 1/D*(B*iS*u-A*iS*e);
h = 1/D*(C*iS*e-A*iS*u);

% Portfolio weights
wp = g+h*ep;

wp'*e; %Portfolio expected return == ep

s2p = wp'*S*wp; %Portfolio variance
sp = sqrt(s2p); %Portfolio std



%% Example 7.3 - Recompute the weights for a portfolio q whose expected return is 2%

ep = 1.8;
wq = g+h*ep;
sq = sqrt(wq'*S*wq);

hold on
plot(sq,wq'*e,'xr')
hold off


%% Example 7.4 - Same as Example 7.2 + Rf = 0.18%

ep = 1.5;
rf = 0.18;

H = B-2*rf*A+rf^2*C;
wp = iS*(e-rf*u)*(ep-rf)/H;

sp = sqrt(wp'*S*wp);

%% Example 7.5

z = iS*(e-rf*u);
w = z./sum(z) % == iS*(e-rf*u)/(A-rf*C)

er = w'*e; % Ptf. expected retunr
sqrt(w'*S*w) % Ptf. std.

%% Example 7.6 weights for a ptf. whose exp. ret is 1.5%
syms x
sol = double(solve( 1.5 == x*er+(1-x)*rf,x));
w_rf = 1-sol;

sol*w % weighs for the risky assets

%% Example A7.1

C = u'*iS*u
w_mvp = 1/C*iS*u;

[A/C; w_mvp'*e] %Expected ptf return
[1/C, w_mvp'*S*w_mvp] % ptf var

%%
clear x y

