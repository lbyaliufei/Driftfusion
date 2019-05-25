% An example script to demonstrate how to run a parameter exploration using
% the parallel computing toolbox
% Users will likely need to modify explore.explore2par
% Obtain the base parameters
par.base = pc('input_files/1 layer Nanogap15nm base.csv');

% For the first example we will run JV and steady-state Voc for 3 different
% active layer thicknesses and light intensities 
% ptpd_parex_dactive_light_33 = explore.explore2par(par.ptpd, {'dcell(1,4)','Int'},...
%     {[40e-7, 140e-7, 340e-7, 740e-7], logspace(-1,1,3)}, 200);

exsol_PhiC_mucat_10_9 = explore.explore2par(par.base, {'PhiC','mucat'},...
       {-5:0.1:-4, linspace(1e-10,1e-14,9)}, 200);

% exsol_PhiC_mucat_10_9 = explore.explore2par(par.base, {'PhiC','mucat'},...
%        {-4.9:0.1:-4.8, [1e-10,1e-11]}, 200);
%    
save('explore_ws.mat')  % Save workspace