function g_add_chipod_paths

% G_ADD_CHIPOD_PATHS Add paths to OSU chipod processing software
%
%   Gunnar Voet
%   gvoet@ucsd.edu
%
%   Created: 2017-04-28

GitToolboxPath = '/Users/gunnar/Projects/matlab/toolboxes_git/';

addpath(fullfile(GitToolboxPath,'FromOtherDevelopers/mixingsoftware/CTD_Chipod'))
addpath(fullfile(GitToolboxPath,'FromOtherDevelopers/mixingsoftware/CTD_Chipod/mfiles'))
addpath(fullfile(GitToolboxPath,'FromOtherDevelopers/mixingsoftware/general'))
addpath(fullfile(GitToolboxPath,'FromOtherDevelopers/mixingsoftware/marlcham'))
addpath(fullfile(GitToolboxPath,'FromOtherDevelopers/mixingsoftware/adcp'))

addpath(fullfile(GitToolboxPath,'FromOtherDevelopers/mixingsoftware/chipod'))
addpath(fullfile(GitToolboxPath,'FromOtherDevelopers/mixingsoftware/chipod/compute_chi'))
addpath(fullfile(GitToolboxPath,'FromOtherDevelopers/mixingsoftware/chipod/inertial_subrange'))
addpath(fullfile(GitToolboxPath,'FromOtherDevelopers/mixingsoftware/chipod/transfer_function'))

fprintf(1,'\n chipod paths added!\n')