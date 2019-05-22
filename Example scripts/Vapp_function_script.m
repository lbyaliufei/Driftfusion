% Creates a single carrier device and then applies a 20 mV periodic
% potential for 2 cycles

par = pc('input_files/memristor.csv');

soleq = equilibrate(par);

% tmax is the period (seconds)
% tmax = 10;
% Nperiods = 4;   % Number of periods
% coeff = [1, Nperiods*(2*pi)/tmax,0];
% Vapp_func = @(coeff, t) coeff(1)*sin(coeff(2)*t + coeff(3));
%

tmax = 4;
Nperiods = 1;   % Number of periods
coeff = [2.5, Nperiods*(2*pi)/tmax,0];
%Vapp_func = @(coeff, t) coeff(1)*sin(coeff(2)*t + coeff(3));
Vapp_func = @(coeff, t) coeff(1)*sawtooth((t*coeff(2)+0.5*pi),0.5);

% Vapp_function(sol_ini, Vapp_func, tmax, tpoints, logtime)
sol_Vapp_func = Vapp_function(sol_ini, Vapp_func, coeff, tmax, 400, 0);

% Plot outputs
dfplot.Vappt(sol_Vapp_func)
% Current at mid-point
dfplot.Jt(sol_Vapp_func, round(par.pcum(end)/2))
% JV plot
dfplot.JVapp(sol_Vapp_func, round(par.pcum(end)/2))
% Mod log J vs V
dfplot.logJVapp(sol_Vapp_func, round(par.pcum(end)/2))

% Energy level diagrams at t=0 and max amplitude
dfplot.ELx(sol_Vapp_func, [0, tmax/(4*Nperiods)]);
