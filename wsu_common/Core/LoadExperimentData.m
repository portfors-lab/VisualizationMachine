function experiment_data = LoadExperimentData(prefs)
%
%function experiment_data = LoadExperimentData(prefs)
%
%   INPUT ARGUMENTS
%   prefs               Bat2Matlab preferences
%   force_create        If set to true, the Bat2Matlab
%                       experiment data structure will be
%                       created from scratch from the Batlab
%                       XML metadata file.
%
%   OUTPUT ARGUMENTS
%   experiment_data     Bat2Matlab data structure

% if exist(prefs.Bat2Matlab_data_filepath,'file')
%     load(prefs.Bat2Matlab_data_filepath);
%     return
% end

if ~exist(prefs.hdf5_data_filepath, 'file') && ~exist(prefs.raw_data_filepath, 'file') && ~exist(prefs.pst_data_filepath, 'file')
    error(['Cannot find hdf5 data file: ' prefs.raw_data_filepath]);
end

if ~exist(prefs.raw_data_filepath, 'file') && ~exist(prefs.hdf5_data_filepath, 'file')
    error(['Cannot find raw data file: ' prefs.raw_data_filepath]);
end
if ~exist(prefs.pst_data_filepath, 'file') && ~exist(prefs.hdf5_data_filepath, 'file')
    error(['Cannot find PST metadata file: ' prefs.pst_data_filepath]);
end

if exist(prefs.hdf5_data_filepath, 'file')
    % Parsing a .hdf5 file
    fprintf('Parsing HDF5\n');
    experiment_data = ParseHDF5(prefs.hdf5_data_filepath);
else
    % Parsing a .pst and .raw file
    fprintf('Parsing PST & raw\n');
    experiment_data = ParsePST(prefs.pst_data_filepath);
end

save(prefs.Bat2Matlab_data_filepath, 'experiment_data')