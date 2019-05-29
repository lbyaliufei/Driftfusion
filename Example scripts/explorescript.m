% An example script to demonstrate how to run a parameter exploration using
% the parallel computing toolbox
% Users will likely need to modify explore.explore2par
% Obtain the base parameters
par = pc('input_files/3 layer test.csv');

exsol = explore.explore2par(par, {'PhiC','scan_rate'},...
       {-0.75, logspace(-3,2,12)}, 200);
   
save('HysteresisII_ws.mat') % Save workspace

% Plot hysteresis index
explore.plotJV(exsol, 1, [1,1,1,1,1,1], 0, 0, 0)
