% Creates a single carrier device and then applies a 20 mV periodic
% potential for 2 cycles
par = pc('input_files/1 layer Nanogap15nm base.csv');

soleq = equilibrate(par);

% tmax is the period (seconds)
% tmax = 10;
% N_period = 4;   % Number of periods
% coeff = [1, N_period*(2*pi)/tmax,0];
% Vapp_func = @(coeff, t) coeff(1)*sin(coeff(2)*t + coeff(3));
%

t_period = 0.5e-2;
N_period = 2;   % Number of periods
tmax = t_period*N_period;
coeff = [2, (2*pi)/t_period,0];
%Vapp_func = @(coeff, t) coeff(1)*sin(coeff(2)*t + coeff(3));
Vapp_func = @(coeff, t) coeff(1)*sawtooth((t*coeff(2)+0.5*pi),0.5);

% Vapp_function(sol_ini, Vapp_func, tmax, tpoints, logtime)
sol_Vapp = Vapp_function(soleq.ion, Vapp_func, coeff, tmax, 200, 0);

% Reproduce Vapp for plotting
Vapp = Vapp_func(coeff, sol_Vapp.t);

pos = round(par.pcum(end)/2);
% Plot outputs
dfplot.Vappt(sol_Vapp)
% Current at mid-point
dfplot.Jt(sol_Vapp, pos)
% JV plot
dfplot.JVapp(sol_Vapp, pos)
% Mod log J vs V
dfplot.logJVapp3D(sol_Vapp, pos, 1)
% Energy level diagrams at t=0 and max amplitude
dfplot.ELx(sol_Vapp, [0, t_period/4]);

