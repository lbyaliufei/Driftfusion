initialise_df

%% Read in base parameters
par.epp10 = pc('Input_files/3_layer_test_symmetric_RC_test_epp10.csv');

% Change dielectric constant in the active layer
% par.epp20 = par.epp10;
% par.epp20.epp(3) = 20;
% par.epp20.dev = pc.builddev(par.epp20);
% 
% par.epp30 = par.epp10;
% par.epp30.epp(3) = 30;
% par.epp30.dev = pc.builddev(par.epp30);

%% Get equilibrium solutions
soleq.epp10 = equilibrate(par.epp10);
% soleq.epp20 = equilibrate(par.epp20);
% soleq.epp30 = equilibrate(par.epp30);

soleq.epp10.ion.par.mue(3) = 0;
soleq.epp10.ion.par.muh(3) = 0;
soleq.epp10.ion.par.dev = pc.builddev(soleq.epp10.ion.par);

%% Do a 20 mV jump forward and then record the decay
% Input arguments: jumptoV(sol_ini, Vjump, tdwell, mobseti, Int, stabilise, accelerate)
sol_relax.epp10 = jumptoV(soleq.epp10.ion, 20e-3, 1, 1, 0, 1, 0);
% % sol_relax.epp20 = jumptoV(soleq.epp20.ion, 20e-3, 1, 1, 0, 1, 0);
% % sol_relax.epp30 = jumptoV(soleq.epp30.ion, 20e-3, 1, 1, 0, 1, 0);
% 
% %% Extract active layer properties from params
% al = par.epp10.active_layer;
% pcum0 = par.epp10.pcum0;
% pmid = pcum0(al) + round((pcum0(al+1)-pcum0(al))/2);
% 
% %% Fit the decay of the cation current
% Jepp10 = dfana.calcJ(sol_relax.epp10);
% 
% fit_epp10 = fit(sol_relax.epp10.t(10:180)',log(Jepp10.c(10:180, pmid)),'poly1');
% figure;plot(fit_epp10,sol_relax.epp10.t,log(Jepp10.c(:,pmid)));
% 
% % Jepp20 = dfana.calcJ(sol_relax.epp20);
% % 
% % fit_epp20 = fit(sol_relax.epp20.t(10:180)',log(Jepp20.c(10:180, pmid)),'poly1');
% % figure;plot(fit_epp20,sol_relax.epp20.t,log(Jepp20.c(:,pmid)));
% % 
% % Jepp30 = dfana.calcJ(sol_relax.epp30);
% % 
% % fit_epp30 = fit(sol_relax.epp30.t(10:180)',log(Jepp30.c(10:180, pmid)),'poly1');
% % figure;plot(fit_epp30,sol_relax.epp30.t,log(Jepp30.c(:,pmid)));
% 
% %% Read out the time constants DF = Driftfusion
% tau_DF_epp10 = -1/fit_epp10.p1;
% % tau_DF_epp20 = -1/fit_epp20.p1;
% % tau_DF_epp30 = -1/fit_epp30.p1;
% 
% %% Calculate the time constants based on the two different circuit models (RC)
% [tau_RC_epp10, tau_RC_dash_10, ~, ~, ~] = depletion_approx_modelX_numeric(par.epp10, 1, 0, 1, 100, 0.1, 0);
% [tau_RC_epp20, tau_RC_dash_20, ~, ~, ~] = depletion_approx_modelX_numeric(par.epp20, 1, 0, 1, 100, 0.1, 0);
% [tau_RC_epp30, tau_RC_dash_30, ~, ~, ~] = depletion_approx_modelX_numeric(par.epp30, 1, 0, 1, 100, 0.1, 0);
% 
% %% Get time constants from Depletion Approximation using 20 mV step forward in Voltage DA = Depletion Approximation
% [~, ~, rhomat, Fmat, Phimat, Q_epp10, tout_epp10] = depletion_approx_modelX_Vjump(par.epp10, 0.1, 0, 20e-3, 200, [0,0.01, 0.02, 0.04], 1);
% [~, ~, rhomat, Fmat, Phimat, Q_epp20, tout_epp20] = depletion_approx_modelX_Vjump(par.epp20, 0.1, 0, 20e-3, 200, [0,0.01, 0.02, 0.04], 1);
% [~, ~, rhomat, Fmat, Phimat, Q_epp30, tout_epp30] = depletion_approx_modelX_Vjump(par.epp30, 0.1, 0, 20e-3, 200, [0,0.01, 0.02, 0.04], 1);
% 
% deltaQ_epp10 = Q_epp10- min(Q_epp10);
% fit_DA_epp10 = fit(tout_epp10(1:100), log(deltaQ_epp10(1:100)'), 'poly1');
% tau_DA_epp10 = -1/(fit_DA_epp10.p1);
% 
% deltaQ_epp20 = Q_epp20- min(Q_epp20);
% fit_DA_epp20 = fit(tout_epp20(1:100), log(deltaQ_epp20(1:100)'), 'poly1');
% tau_DA_epp20 = -1/(fit_DA_epp20.p1);
% 
% deltaQ_epp30 = Q_epp30- min(Q_epp30);
% fit_DA_epp30 = fit(tout_epp30(1:100), log(deltaQ_epp30(1:100)'), 'poly1');
% tau_DA_epp30 = -1/(fit_DA_epp30.p1);
% 
% %% Plot currents at 1us
% dfplot.Jx(sol_relax.epp10, 1e-6);
% 
% %% Get effective cation density
% c_eff_epp10 = getc_eff(sol_relax.epp10, 300e-7);


