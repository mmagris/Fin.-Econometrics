
clear;  clc;



Y = rand([100 1]);
Y_var=sum(Y);
r=zeros(90,1);
X0=randn([100,1]);
r_ad=zeros(90,1);

% for j = 1:15

X = X0;
for i=10:100
 
 XX=randn([100 1]);
 X=[X XX];
 beta_hat= (inv(X'*X))*X'*Y;
 Y_hat=X*beta_hat;
 
 lm = fitlm(X,Y,'Intercept',true);
 r2 = lm.Rsquared.Ordinary;
 r2a = lm.Rsquared.Adjusted;
 fprintf('R2: %.3f, R2adj: %.3f.\n',r2,r2a)
 r(i-9) = lm.Rsquared.Ordinary;
 r_ad(i-9) = lm.Rsquared.Adjusted;
 plot(r_ad,'b')
 pause(0.01)
end

hold on

% end