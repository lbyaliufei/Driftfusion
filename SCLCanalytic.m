function [Jsclc, dJdV] = SCLCanalytic(sol, Varr)

p = sol.p;

% J in mAcm-2
Jsclc = 1000* p.e*p.mue_i*p.N0i*exp((p.IPi-p.PhiA)/(p.kB*p.T)).*Varr/p.xmax;

dJdV = gradient(Varr, Jsclc);

end
