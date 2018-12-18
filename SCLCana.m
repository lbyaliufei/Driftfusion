function SCLCstats = SCLCana(solstruct, layernum)

%% Input arguments
% SOLSTRUCT = A JV solution used for the analysis
% LAYERNUM = the number of the SCLC layer e.g. in 3 layer system this would
% be 2

% Simple structure names
sol = solstruct.sol;
par = solstruct.par;
Vapp_arr = solstruct.Vapp;

%% ANALYSIS %%
% split the solution into its component parts (e.g. electrons, holes and efield)
n = sol(:,:,1);     % electrons
p = sol(:,:,2);     % holes
a = sol(:,:,3);     % mobile ions
V = sol(:,:,4);     % electric potential

%% Currents from right-hand boundary

Jn_r = par.sn_r*(n(:, end) - par.nright)*-par.e;
Jp_r = par.sp_r*(p(:, end) - par.pright)*par.e;
Jtot = Jn_r + Jp_r;

gradJV = gradient(log(Jtot), log(Vapp_arr));

% Mobility calculation based on Mott-Gurney law
mu_MG = gradient(Jtot, (Vapp_arr.^2))*(8/9)*(par.d(layernum)^3)/(par.epp(layernum)*par.epp0*par.e);

figure(200)
loglog(Vapp_arr, Jtot)
xlabel('Vapp [V]')
ylabel('J [A cm^-2]');
grid off;

% figure(201)
% plot(Vapp_arr, Jtot)
% xlabel('Vapp [V]')
% ylabel('J [A cm^-2]');
% grid off;

figure(202)
semilogx(Vapp_arr, gradJV)
xlabel('V_{app} [V]')
ylabel('d[log(J)]/[d[log(V)]')

figure(203)
semilogx(Vapp_arr, mu_MG)
xlabel('Vapp [V]')
ylabel('Calculated mobility')

SCLCstats.Vapp = Vapp_arr;
SCLCstats.J = Jtot(:,end)';
SCLCstats.gradJV = gradJV;
SCLCstats.mu_MG = mu_MG;
SCLCstats.max_gradJV = max(gradJV);

pp = find(gradJV <= max(gradJV));
pp = pp(end);
SCLCstats.mu_MG_maxgrad = mu_MG(pp);
SCLCstats.delta_mu = mu_MG - par.mue(layernum);

end