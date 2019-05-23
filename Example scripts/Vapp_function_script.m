% Creates a single carrier device and then applies a 20 mV periodic
% potential for 2 cycles
par = pc('input_files/1 layer Nanogap15nm.csv');

soleq = equilibrate(par);

% tmax is the period (seconds)
% tmax = 10;
% Nperiods = 4;   % Number of periods
% coeff = [1, Nperiods*(2*pi)/tmax,0];
% Vapp_func = @(coeff, t) coeff(1)*sin(coeff(2)*t + coeff(3));
%

tmax = 1e-2;
Nperiods = 1;   % Number of periods
coeff = [2, Nperiods*(2*pi)/tmax,0];
%Vapp_func = @(coeff, t) coeff(1)*sin(coeff(2)*t + coeff(3));
Vapp_func = @(coeff, t) coeff(1)*sawtooth((t*coeff(2)+0.5*pi),0.5);

% Vapp_function(sol_ini, Vapp_func, tmax, tpoints, logtime)
sol_Vapp = Vapp_function(soleq.ion, Vapp_func, coeff, tmax, 200, 0);

% Reproduce Vapp for plotting
Vapp = Vapp_func(coeff, sol_Vapp.t);

% Plot outputs
dfplot.Vappt(sol_Vapp)
% Current at mid-point
dfplot.Jt(sol_Vapp, par.pcum(end))
% JV plot
dfplot.JVapp(sol_Vapp, par.pcum(end))
% Mod log J vs V
dfplot.logJVapp(sol_Vapp, par.pcum(end))
% Energy level diagrams at t=0 and max amplitude
dfplot.ELx(sol_Vapp, [0, tmax/(4*Nperiods)]);

