function[RT] = Reftime_fun(Ta,Tb)
imax = numel(Ta)+numel(Tb);

t = nan(imax,1);
Cond = true;
i = 1;
t(i,1) = max(Ta(i),Tb(i));


while Cond == true
    i = i+1;
    indx_a = find(Ta>t(i-1),1);
    indx_b = find(Tb>t(i-1),1);
    Cond = ~isempty(indx_a) && ~isempty(indx_b);
    if Cond
        t(i,1) = max(Ta(indx_a),Tb(indx_b));
        if mod(i,2000) == 0
            %fprintf('Refresh time: %06.i (%s). \n',i)
        end
    end

end


RT = datetime(t(1:i-1,:),'ConvertFrom','datenum');

end