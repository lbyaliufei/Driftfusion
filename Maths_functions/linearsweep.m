function f = linearsweep(coeff, t)
% coeff = [Vstart, V1, V2, tmax, Nperiods]
% t is an input time

if t < tmax/4
    f = (coeff(2)-coeff(1))*t/(coeff(4)/4);
elseif t >= tmax/4 && t < 3*tmax/4
    f = (coeff(3)-coeff(2))*t/(coeff(4)/2);
elseif t >= 3*tmax/4
    f = (coeff(4)-coeff(3))*t/(coeff(4)/4);
end

end

