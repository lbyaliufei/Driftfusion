par.epp10 = pc('Input_files/3_layer_test_symmetric_RC_test_epp10.csv');
par.epp20 = pc('Input_files/3_layer_test_symmetric_RC_test_epp20.csv');
par.epp30 = pc('Input_files/3_layer_test_symmetric_RC_test_epp30.csv');

soleq.epp10 = equilibrate(par.epp10);
soleq.epp20 = equilibrate(par.epp20);
soleq.epp30 = equilibrate(par.epp30);

% jumptoV(sol_ini, Vjump, tdwell, mobseti, Int, stabilise)
sol_relax.epp10 = jumptoV(soleq.epp10.ion, 20e-3, 1, 1, 0, 1);
sol_relax.epp20 = jumptoV(soleq.epp20.ion, 20e-3, 1, 1, 0, 1);
sol_relax.epp30 = jumptoV(soleq.epp30.ion, 20e-3, 1, 1, 0, 1);

al = par.epp10.active_layer;
pcum0 = par.epp10.pcum0;
pmid = pcum0(al) + round((pcum0(al+1)-pcum0(al))/2);

% Fit the decay of the cation current
Jepp10 = dfana.calcJ(sol_relax.epp10);

fit_epp10 = fit(sol_relax.epp10.t(1:180)',log(Jepp10.c(1:180, pmid)),'poly1');
figure;plot(fit_epp10,sol_relax.epp10.t,log(Jepp10.c(:,pmid)));
tau_DF_epp10 = -1/fit_epp10.p1;

Jepp20 = dfana.calcJ(sol_relax.epp20);

fit_epp20 = fit(sol_relax.epp20.t(1:180)',log(Jepp20.c(1:180, pmid)),'poly1');
figure;plot(fit_epp20,sol_relax.epp20.t,log(Jepp20.c(:,pmid)));
tau_DF_epp20 = -1/fit_epp20.p1;

Jepp30 = dfana.calcJ(sol_relax.epp30);

fit_epp30 = fit(sol_relax.epp30.t(1:180)',log(Jepp30.c(1:180, pmid)),'poly1');
figure;plot(fit_epp30,sol_relax.epp30.t,log(Jepp30.c(:,pmid)));
tau_DF_epp30 = -1/fit_epp30.p1;

% Calculate the time constants based on the two different circuit models
[tau_RC_epp10, tau_RC_dash_10, ~, ~, ~] = depletion_approx_modelX_numeric(par.epp10, 1, 0, 1, 100, 0.1, 0);
[tau_RC_epp20, tau_RC_dash_20, ~, ~, ~] = depletion_approx_modelX_numeric(par.epp20, 1, 0, 1, 100, 0.1, 0);
[tau_RC_epp30, tau_RC_dash_30, ~, ~, ~] = depletion_approx_modelX_numeric(par.epp30, 1, 0, 1, 100, 0.1, 0);
