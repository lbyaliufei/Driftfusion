% Creates a single carrier device and then applies a 20 mV periodic
% potential for 2 cycles

% par.singlecar = pc('input_files/1 layer single carrier.csv');
% 
% sol_ini = equilibrate(par.singlecar);
sol_ini = soleq.ng15.ion;
par = soleq.ng15.ion.par;

% tmax is the period (seconds)
tmax = 1;
Nperiods = 4;   % Number of periods
%coeff = [20e-3, Nperiods*(2*pi)/tmax,0];
coeff = [1, Nperiods*(2*pi)/tmax,0];
Vapp_func = @(coeff, t) coeff(1)*sin(coeff(2)*t + coeff(3));

% Vapp_function(sol_ini, Vapp_func, tmax, tpoints, logtime)
sol_Vapp_func = Vapp_function(sol_ini, Vapp_func, coeff, tmax, 400, 0);

% Plot outputs
dfplot.Vappt(sol_Vapp_func)
% Current at mid-point
dfplot.Jt(sol_Vapp_func, round(par.pcum(end)/2))
% JV plot
dfplot.JVapp(sol_Vapp_func, round(par.pcum(end)/2))
% Energy level diagrams at t=0 and max amplitude
dfplot.ELx(sol_Vapp_func, [0, tmax/(4*Nperiods)]);