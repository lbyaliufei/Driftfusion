% An example script to demonstrate how to run a parameter exploration using
% the parallel computing toolbox
% Users will likely need to modify explore.explore2par
% Obtain the base parameters
par.base = pc('input_files/1 layer Nanogap15nm base.csv');

% For the first example we will run JV and steady-state Voc for 3 different
% active layer thicknesses and light intensities 
% exsol_mucat_scanrate_5_4 = explore.explore2par(par.base, {'mucat','scan_rate'},...
%        {linspace(1e-11,1e-10,5), logspace(-2,1,4)}, 200);

% exsol_dcell_int_6_7 = explore.explore2par(par.base, {'dcell(1)','Int'},...
%        {linspace(10e-7,15e-7,6), [0,40,80,160,320,640,1280]}, 200);

% exsol_Nion19_muion_scanrate_5_5 = explore.explore2par(par.base, {'muion','scan_rate'},...
%        {logspace(-14,-10,5), logspace(-3,1,5)}, 200);

% exsol_PhiC_muan_10_9 = explore.explore2par(par.base, {'PhiC','mucat'},...
%        {-4.9:0.1:-4.8, [1e-10,1e-11]}, 200);
%  

exsol_PhiC_scanrate_5_6 = explore.explore2par(par.base, {'PhiC','scan_rate'},...
       {-5.1:0.1:-4.7, logspace(-3,2,6)}, 200);
   
save('Nanogap_explore_ws.mat') % Save workspace