function[pd] = slice_data(p,r,w)


n = size(p,1);

nw = floor(n/w);
clear pd

v = struct2table(structfun(@(s) s.Price,r,'uni',0));
tr = struct2table(structfun(@(s) s.Price,r,'uni',0));

for i = 0:(nw)
    first   = i*w+1;
    last    = min(n,(i+1)*w);
    pd(i+1).Epoch     = i+1;
    pd(i+1).Time      = p.Time(first:last);
    pd(i+1).Price     = timetable2table(p(first:last,:));
    pd(i+1).Volume    = v(first:last,:);
    pd(i+1).Trades    = tr(first:last,:);
end

if isempty(pd(i+1).Time)
   pd(i+1) = []; 
end

end
