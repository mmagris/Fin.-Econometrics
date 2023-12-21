
%% Moments of the Student-t

clc

v = 9; % degrees of freedom >4

[0,v/(v-2),0,6/(v-4)+3] % Theoretical

mu      = integral(@(x) x.^1.*tpdf(x,v),-Inf,+Inf);
sig2    = integral(@(x) (x-0).^2.*tpdf(x,v),-Inf,+Inf);
sig     = sqrt(sig2);
s       = integral(@(x) (x-0).^3.*tpdf(x,v),-Inf,+Inf)/sig^3;
k       = integral(@(x) (x-0).^4.*tpdf(x,v),-Inf,+Inf)/sig^4;

[mu,sig2,s,k] % Computed

%% Heavy taildness example for the Student-t

clc

v = 9
q = -3.5;

in = integral(@(x) normpdf(x,0,sqrt(v/(v-2))),-Inf,q);
it = integral(@(x) tpdf(x,v),-Inf,q);

fprintf('Normal Pr(X <= %.2f) = %.3f%% \n', -3.5, in*100)
fprintf('Student Pr(X <= %.2f) = %.3f%% \n', -3.5, it*100)

xp = linspace(-5,5,1000);
ty = tpdf(xp,v);
ny = normpdf(xp,0,sqrt(v/(v-2)));

plot(xp,ty)
hold on
plot(xp,ny,'--')
hold off