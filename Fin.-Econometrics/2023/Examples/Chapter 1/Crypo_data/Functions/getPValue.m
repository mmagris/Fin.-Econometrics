function testPValue = getPValue(CVTable,numObs,testStat)
    
sampSizes = [10 15 20 25 30 40 50 75 100 150 200 300 500 1000 10000];
sigLevels = [0.001 (0.005:0.005:0.10) (0.125:0.025:0.20) ...
                   (0.80:0.025:0.875) (0.90:0.005:0.995) 0.999];

% P-values are estimated using two successive 1D interpolations:
%
% 1. Find all critical values associated with the sample size.
% 2. Find the cumulative probability associated with the test statistic.

CVTableRow = interp2(sigLevels,sampSizes,CVTable(1:end-1,:),sigLevels,numObs,'linear');

if isnan(CVTableRow) % numObs > maxT

    CVTableRow = CVTable(end-1,:); % Use row for maxT
    
end

% Left-tailed test
    
if testStat <= CVTableRow(1)

    testPValue = sigLevels(1);

elseif testStat >= CVTableRow(end)

    testPValue = sigLevels(end);

else

    testPValue = interp1(CVTableRow,sigLevels,testStat,'linear');

end

end % GETPVALUE