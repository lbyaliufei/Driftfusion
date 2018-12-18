function [pulse]=pulseJVexp(sol_ini, Bias_V, pulse_t, pulse_number, mui, Vstart, Vend)
% A procedure for running a pulsed voltage experiment that is used to
% reconstruct JV curve which can, theoretically, remove all ionic
% contributions --- dark only. Forward only at the moment. 

% Generate a stable solution for the pre-bias stages using
% Vapp_structs_PC(solini,Vapp_arr) <- use as initial condition for each
% pulse. 

% use function called Vpulse to do a fast J-V to reach a new voltage and
% then apply the volatge and look at the solution

%% Biased Equilibrium Setup and Pulse Cycle

[pulse_dk_f] = deal(0);
   
VappStruct = genVappStructs_PC(sol_ini, Bias_V);

i=0;

pulse_analyse{pulse_number} = 0 ;

while (i <= pulse_number ) %% cycles through integers to create each voltage pulse and do a JV scan to simulate the voltage increase.
    
    i=i+1;
    
%     [pulse_dk_f, ~, ~, ~] = doJV(VappStruct, abs(((i*((Vend - Vstart)./pulse_number))- Bias_V)/((7/10)*pulse_t)), 100, mui, Bias_V, i*(Vend - Vstart)./pulse_number, 1);
% 
%     pulse{i} = pulse_dk_f; 
    
    [Vapp_pulse] = i*(Vend - Vstart)./pulse_number;
    
    %Vapp_pulse = Vapp.pulse{i};  %%change this so it extracts only the final element of Vapp in pulse...! 
    
    [dark_pulse] = Vpulse(VappStruct, Vapp_pulse(i), pulse_t, mui);
    
    
    pulse_analyse{i} = dark_pulse ; %puts each Vpulse solution into a cell array to be used in J-V reconstruction
    
end

%% reconstruct J-V here 


%This line needs changing to match the comment 
[Jpulse] = Jtotr.pulse_analyse ;   %% take the final Jtotr value from each iteration of pulse loop and makes an array of (hopefully) the same size as Vapp_pulse
%


Plot(Vapp_pulse , Jpulse);  %% makes the J-V reconstruction to have a look


end
