function c_eff = getc_eff(sol, xpos)
% Obtain effection cation density at position determined by XPOS
par = sol.par;
% Get currents
[~,J] = dfana.calcJ(sol);
% Get field
[F,~] = dfana.calcF(sol);

% Find point position of xpos
ppos = find(sol.x <= xpos);
ppos = ppos(end);

c_eff = abs((J.c(:,ppos))./(par.e*par.mucat(par.active_layer)*F(:,ppos)));

figure(401)
plot(sol.t, c_eff)
xlabel('Time [s]')
ylabel('c eff [cm-3]')
ylim([0, 2*par.Ncat(par.active_layer)])
xlim([0, 0.2])

figure(402)
plot(sol.t, J.c(:,ppos))
xlabel('Time [s]')
ylabel('Jcation [Acm-2]')
xlim([0, 0.2])

figure(403)
plot(sol.t, F(:,ppos))
xlabel('Time [s]')
ylabel('Field [Vcm-1]')
xlim([0, 0.2])

end