function [t, Ft_f, Ft_r] = BMJV_4cap_numeric(par, ss, Vstart, Vend, figson)

%% Equilibrium
% At equilibrium (from Mott Schottky Capacitance)
%syms C1 C2 Vint1 Vint2 CT k1 k2 kper VT

%% Potential drops at equilibrium
% eqn = (VT*CT/C1) - Vint1 == 0;
% solVint1 = solve(eqn, Vint1)
% Space charge layer widths in double heterojunction
%syms x1 x2 x3 x4 N1 N2 N3 N4 epp1 epp2 epp3 epp4 Vint1 Vint2 Vint3 Vint4 Vbi Vapp

%% Potential at V1 and V2 as defined by Moia and Barnes
%syms V1 V2 fc

%% Forward scan Input values
A = 1;

% For the voltage drop expressions
t = 0:(Vend/ss)/1000:Vend/ss;      % time array
Vbi = par.Vbi;
epp1 = par.epp(1)*par.epp0;
epp2 = par.epp(3)*par.epp0;
epp3 = par.epp(3)*par.epp0;
epp4 = par.epp(5)*par.epp0;
N1 = par.NA(1);
N2 = par.Ncat(3);
N3 = par.Ncat(3);
N4 = par.ND(5);
q = par.e;
Vapp = ss*t; 
Vbi = par.Vbi;

% For capcaitances
epp0 = 8.8541878128e-14;         % F cm-1
k1 = 2/(par.e*par.epp(1)*epp0*par.NA(1));
k2 = 2/(par.e*par.epp(end)*epp0*par.ND(end));
kper = 2/(par.e*par.epp(3)*epp0*par.Ncat(3));
VT = par.Vbi;

Rion = par.dcell(3)/(par.e*par.Ncat(3)*par.mucat(3));       % length dimensions cancel here to give Ohms
Q0 = 0;
Vini = Vstart;
V_f = ss*t;                    % V here is defined as the applied voltage (does not include Vbi component)
s = ss;

x1 = ((N1./(2*(Vbi-Vapp))).*((1/epp1) + (2*N1/(epp2*N2)) + N1/(epp4*N4))).^(-1/2);
x2 = N1*x1/N2;
x3 = N1*x1/N3;
x4 = N1*x1/N4;

%Voltage drops
Vint1 = (N1*x1.^2)./(2*epp1);
Vint2 = (N2*x2.^2)./(2*epp2);
Vint3 = (N3*x3.^2)./(2*epp3);
Vint4 = (N4*x4.^2)./(2*epp4);

% Equilibrium capacitances
Ccon1 = (1./(k1*Vint1)).^0.5;
Cper1 = (1./(kper*Vint2)).^0.5;
Cper2 = (1./(kper*Vint3)).^0.5;
Ccon2 = (1./(k2*Vint4)).^0.5;

C1 = 1./(1./Ccon1 + 1./Cper1);
C2 = 1./(1./Ccon2 + 1./Cper2);

C1 = ((q*epp0*par.epp(1)*par.NA(1))./(2*Vint1)).^0.5;
C2 = ((q*epp0*par.epp(5)*par.ND(5))./(2*Vint4)).^0.5;

CT = 1./(1./C1 + 1./C2);

fc1 = C1./Ccon1;
fc2 = C2./Ccon2;
Cion_f = CT;
%% Ionic charge accumulation during voltage sweep
% Expression from Moia 2019 SI p. 21
Q_f = (Cion_f*Vini/2) - ((s*Rion).*(Cion_f/2).^2) + (s*Cion_f.*t/2) +...
    (((s*Rion).*(Cion_f/2).^2)+Q0-(Vini*Cion_f/2)).*exp(-2*t./(Rion.*Cion_f));

V1_f = V_f - fc1.*Q_f./Cion_f;
V2_f = fc2.*Q_f./Cion_f;

% V1 = double(subs(V1));
% V2 = double(subs(V2));
Ft_f = (V2_f-V1_f)./par.dcell(3);

%% Reverse scan
Q0 = Q_f(end);
Vini = V_f(end);
s = -ss;
V_r = V_f(end)-ss*t;
Vapp = V_f(end)-ss*t;

x1 = ((N1./(2*(Vbi-Vapp))).*((1/epp1) + (2*N1/(epp2*N2)) + N1/(epp4*N4))).^(-1/2);
x2 = N1*x1/N2;
x3 = N1*x1/N3;
x4 = N1*x1/N4;

%Voltage drops
Vint1 = (N1*x1.^2)./(2*epp1);
Vint2 = (N2*x2.^2)./(2*epp2);
Vint3 = (N3*x3.^2)./(2*epp3);
Vint4 = (N4*x4.^2)./(2*epp4);

% Equilibrium capacitances
Ccon1 = (1./(k1*Vint1)).^0.5;
Cper1 = (1./(kper*Vint2)).^0.5;
Cper2 = (1./(kper*Vint3)).^0.5;
Ccon2 = (1./(k2*Vint4)).^0.5;

C1 = 1./(1./Ccon1 + 1./Cper1);
C2 = 1./(1./Ccon2 + 1./Cper2);
CT = 1./(1./C1 + 1./C2);

fc1 = C1./Ccon1;
fc2 = C2./Ccon2;
Cion_r = CT;        % Could just flip matrix

%% Ionic charge accumulation during voltage sweep
% Expression from Moia 2019 SI p. 21
Q_r = (Cion_r*Vini/2) - ((s*Rion).*(Cion_r/2).^2) + (s*Cion_r.*t/2) +...
    ((((s*Rion).*(Cion_r/2).^2)+Q0-(Vini*Cion_r/2)).*exp(-2*t./(Rion.*Cion_r)));

V1_r = V_r - fc1.*Q_r./Cion_r ;
V2_r = fc2.*Q_r./Cion_r;

Ft_r = (V2_r-V1_r)./par.dcell(3);

tcat = [t, t+t(end)];
V1cat = [V1_f, V1_r];
V2cat = [V2_f, V2_r];
Vcat = [V_f, V_r];
Ft_cat = [Ft_f, Ft_r];

if figson
figure(50)
plot(tcat, Ft_cat)
xlabel('Time')
ylabel('Field [V cm-1]')
xlim([tcat(1), tcat(end)])
% figure(51)
% plot(t, V1_f, t, V2_f)
% xlabel('Time [s]')
% ylabel('V1f, V2f [V]')
% legend('V1f', 'V2f')
% 
% figure(52)
% plot(t, V1_r, t, V2_r)
% xlabel('Time [s]')
% ylabel('V1r, V2r [V]')
% legend('V1r', 'V2r')

figure(53)
plot(tcat, V1cat, tcat, V2cat, tcat, Vcat)
xlabel('Time [s]')
ylabel('V [V]')
legend('V1', 'V2', 'Vapp')
xlim([tcat(1), tcat(end)])

end

end