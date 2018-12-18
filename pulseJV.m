function [Jpulse, dark_pulse_sol, Vapp, pulse_analyse]=pulseJV(sol_ini, sol_iniJV, Bias_V, pulse_t, pulse_number, mui, Vstart, Vend)
% A proceedure for running a pulsed voltage experiment that is used to
% reconstruct JV curve which can, theoretically, remove all ionic
% contributions --- dark only. There are 2 initial conditions used in the
% inputs, the first os fro the pulse experiment, thes second is for the JV
% to compare it two 

% Generate a stable solution for the pre-bias stages using
% Vapp_structs_PC(solini,Vapp_arr) <- use as initial condition for each
% pulse. 

% uses function called Vpulse to do a fast J-V to reach a new voltage and
% then apply the volatge and look at the solution

% Read parameters structure into structure p
p = sol_ini.p ; 
p = sol_iniJV.p ; 

%% Biased Equilibrium Setup and Pulse Cycle
if sol_ini.p.mui == 0
    % if ions are not mobile in the solution then do not equilibrate with
    % ions
    VappStruct = sol_ini;
else
    % equilibrate with ions
    VappStruct = genVappStructs_PC(sol_ini, Bias_V);   % generates a solution that is equivalen to the equilibrium state at bias V and verify stability
end

i=0; %initiate the cyclic variable 

pulse_analyse{pulse_number} = 0 ;   %create the solution cell 

[Vapp_pulse] = deal(0); %create the Voltage array

[Jpulse] = deal(0); %create the current array 

while (i <= pulse_number ) %% cycles through integers to create each voltage pulse and do a JV scan to simulate the voltage increase.
              
    i=i+1; % cyclic variable increase every loop
            
    Vapp_pulse= Vstart + (i-1)*(Vend - Vstart)./pulse_number;  % applied voltage pulse variable
    
    Vapp = Vstart : ((Vend - Vstart)/pulse_number) : Vend ; % array of applied voltages
     
    dark_pulse_sol = Vpulse(VappStruct, Vapp_pulse, pulse_t, mui);  % find the state of device for each applied pulse
       
    pulse_analyse{i} = dark_pulse_sol ; % puts each Vpulse solution into a cell array to be used in J-V reconstruction
    
    J_pulsetot = pulse_analyse{1,i}.Jtotr;  % fetch a solution every iteration and extract the current 
    
    A = J_pulsetot(end-19 : end) ;  % extract the last 20 current values in time 
    
    Jpulse(:,i) = (sum(A) / numel(A));  % average the current over the last 10 time points of the pulse and use this to create the J-V
    
    Jt(:,i) = J_pulsetot(:,1) ; % keep the whole time series of the current for each loop iteration for the spacial centre of the device
    
end

%% reconstruct J-V here 

% Makes a J-V from the pulses 
figure(2)
plot(Vapp , Jpulse) ;
title("Reconstructed J-V") ;
xlabel("Vpulse [V]");
ylabel("Jpulse [mA]");
grid on 
hold on

%%Analyse here 

gradJV = gradient(log(Jpulse), log(Vapp));

% Mobility calculation based on Mott-Gurney law
mu_MG = gradient(Jpulse, (Vapp.^2))*(8/9)*(p.ti^3)/(p.eppi*p.e);

% Makes a J-V from the pulses on a loglog
figure(3)
loglog(Vapp, Jpulse);
xlabel('Vapp [V]');
ylabel('J [mA cm^-2]');    
grid on
hold off 

% Plots the current transients so we can check everything is reasonable
% during the pulses
figure(4)
plot(dark_pulse_sol.t , Jt(:,1)) 
xlabel('t')
ylabel('Jfast')
hold on 
plot(dark_pulse_sol.t , Jt(:,2));
hold on
plot(dark_pulse_sol.t , Jt(:,round(pulse_number/2 , 0)))
hold on 
plot( dark_pulse_sol.t , Jt(:,pulse_number))
hold off

%Plots the gradient of the loglog so that we can see where the regimes
%change

figure(5)
semilogx(Vapp, gradJV)
xlabel('V_{app} [V]')
ylabel('d[log(J)]/[d[log(V)]')
hold off 

% plots the mobility assuming MG is correct at all points 
figure(6)
semilogx(Vapp, mu_MG)
xlabel('Vapp [V]')
ylabel('Calculated mobility')
hold off
%{
%% Compare to equivalent J-V scans here
 mui = 0 ;         


    JV = doJV(sol_iniJV, 0.2, 1000, mui, Vstart, Vend, 1);

    close(figure(11))
   
   
figure(2)
plot(JV.dk_f.Vapp , JV.dk_f.Jtotr,'--') ;
hold on 
plot (JV.dk_r.Vapp , JV.dk_r.Jtotr,'--')
legend('pulsed','scan forward','scan reverse')
hold off   
%}
  
end
