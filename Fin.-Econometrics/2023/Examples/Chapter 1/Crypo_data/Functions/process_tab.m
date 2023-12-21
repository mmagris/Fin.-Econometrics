function[tab] = process_tab(tab,tick_size)
tab.dp  = round([nan;diff(tab.Price)],3);

tab.A = tab.dp ~=0;
indx    = tab.dp<0;
tab.D(indx,:) = -1*ones(sum(indx),1);
indx    = tab.dp>0;
tab.D(indx,:) = +1*ones(sum(indx),1);
tab.S = abs(tab.dp./tick_size);
tab.V  = [nan;diff(tab.Volume)];
tab.A1 = [nan;tab.A(1:end-1)];
tab.D1 = [nan;tab.D(1:end-1)];
tab.S1 = [nan;tab.S(1:end-1)];
tab.V1  = [nan;tab.V(1:end-1)];
tab(1:2,:) = [];
end