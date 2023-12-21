clear
clc


f = load('C:\Users\Martin\Desktop\FinEc_Examples\Yahoo\Data\CAPM_p.mat');
p = f.p;
tr = timerange('1-Jan-2015','14-Nov-2023');

p = p(tr,:);
tmp = varfun(@(t) diff(log(t)),p);
tmp(:,end) = [];

r = synchronize(tmp,p(:,end));
r.Properties.VariableNames = p.Properties.VariableNames;
r.IRX = r.IRX/100/365;
r(end,:) = [];

%%

Data = r{:,:};
Assets = f.Tickers;

[NumSamples, NumSeries] = size(Data);
NumAssets = NumSeries - 2;

StartDate = r.Time(1);
EndDate = r.Time(end);

fprintf(1,'Separate regressions with ');
fprintf(1,'daily total return data from %s to %s ...\n', ...
    datestr(StartDate,1),datestr(EndDate,1));
fprintf(1,'  %4s %-20s %-20s %-20s\n','','Alpha','Beta','Sigma');
fprintf(1,'  ---- -------------------- ');
fprintf(1,'-------------------- --------------------\n');

for i = 1:NumAssets
% Set up separate asset data and design matrices
  TestData = zeros(NumSamples,1);
  TestDesign = zeros(NumSamples,2);

  TestData(:) = Data(:,i) - Data(:,end);
  TestDesign(:,1) = 1.0;
  TestDesign(:,2) = Data(:,end-1) - Data(:,end);

% Estimate CAPM for each asset separately
  [Param, Covar] = ecmmvnrmle(TestData, TestDesign);

 % Estimate ideal standard errors for covariance parameters
  [StdParam, StdCovar] = ecmmvnrstd(TestData, TestDesign, ... 
      Covar, 'fisher');

% Estimate sample standard errors for model parameters
  StdParam = ecmmvnrstd(TestData, TestDesign, Covar, 'hessian');

% Set up results for output
  Alpha = Param(1);
  Beta = Param(2);
  Sigma = sqrt(Covar);

  StdAlpha = StdParam(1);
  StdBeta = StdParam(2);
  StdSigma = sqrt(StdCovar);

% Display estimates
  fprintf('  %4s %9.4f (%8.4f) %9.4f (%8.4f) %9.4f (%8.4f)\n', ...
     Assets{i},Alpha(1),abs(Alpha(1)/StdAlpha(1)), ...
     Beta(1),abs(Beta(1)/StdBeta(1)),Sigma(1),StdSigma(1));
 
 BB(1,i) = Beta;
 BB(2,i) = Alpha;
end

%%

plot(TestDesign(:,2),TestData,'.')
xlabel('z_m')
ylabel('z_i')
refline(BB(1,end),BB(2,end))
title(['$z_m$ vs $z_i$ for ', Assets{i}],'Interpreter','latex')

%%

lm = fitlm(BB(1,:)',nanmean(Data(:,1:end-2))','Intercept',true);

vpa(nanmean(Data(:,end)),7)
vpa(nanmean(Data(:,end-1)-Data(:,end)),7)


plot(lm)
title('$R_i$ vs $\beta_i$','Interpreter','latex')
ylabel('$R_i$','Interpreter','latex')
xlabel('$\beta_i$','Interpreter','latex')


%%


