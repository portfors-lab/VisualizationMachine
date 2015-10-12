function prefs = GeneratePreferences(animalPath, isFolder)
%
%function prefs = GeneratePreferences(animal_number,
%                                     experiment_letter,
%                                     cell_depth)
%
%   INPUT ARGUMENTS
%   animalPath          The location/name of the experimental data or
%   folder
%
%   isFolder            Whether the animalPath is the name of the folder
%                       that contains the data, or the name of the data 
%                       itself
%
%   OUTPUT ARGUMENTS
%   prefs               The preferences used throughout the Bat2Matlab
%                       execution.
%
%GeneratePreferences generates a structure containing all of the
%global preferences used throughout the execution of Bat2Matlab.

    %Test description
    cell_string = '';

    %remove trailing /
    if strcmp(animalPath(end), filesep)
        animalPath(end) = [];
    end
    [parentDir animalName]=fileparts(animalPath);
    
    if isFolder
        if ~exist(animalPath, 'dir')
            disp('invalid base data path')
            prefs = [];
            return
        end
        parentDir = animalPath;
    end
    
    if ~isempty(parentDir)
        parentDir=[parentDir filesep];
    end
    prefs.bat2matlab_directory = parentDir;
    
    prefs.extracted_data_folder = [parentDir 'Extracted Data' filesep];
    if ~exist(prefs.extracted_data_folder, 'file')
        mkdir(prefs.extracted_data_folder);
    end

    prefs.Bat2Matlab_data_filepath = [parentDir 'Extracted Data' filesep animalName '.mat'];
    prefs.raw_data_filepath = [parentDir animalName '.raw'];
    prefs.xml_data_filepath = [parentDir animalName '-alltests-nospikes.xml'];
    prefs.pst_data_filepath = [parentDir animalName '.pst'];
    prefs.output_data_filepath = [prefs.bat2matlab_directory 'Output' filesep];

    if ~isempty(cell_string)
        prefs.output_data_filepath = [prefs.output_data_filepath '_' cell_string];
    end
    prefs.cache_dir = [prefs.output_data_filepath 'cache'];
    if ~exist(prefs.cache_dir, 'file')
        mkdir(prefs.cache_dir);
    end
    prefs.cell_id = [animalName '_' cell_string];
    prefs.cell_id4_plot = prefs.cell_id; prefs.cell_id4_plot(strfind(prefs.cell_id4_plot,'_')) = '.';

%Added from "GeneratePreferencesNew.m" [EM] 
%%%Trying to debug error that  spike_time_fikter_cutoff does not exist when trying to run correlation matrix code  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Options for Spike Time calculation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% prefs.spike_time_filter_cutoff = 600;
% filter cutoff reduces amplitude of spikes which have higher frequency
prefs.spike_time_filter_cutoff = 50000; %This will find all spikes
prefs.spike_time_power_exponent = 2;
prefs.spike_time_peak_threshold = 0.11; %Default
prefs.spike_time_refractory_period = 2.0; %Milliseconds

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Options for Spike Rate calculation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% prefs.spike_rate_sampling_frequency = NaN; %defaults to trace.samplerate_ad;
prefs.spike_rate_sampling_frequency = 8000;
prefs.spike_rate_cutoff_frequency = 200;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Options for spectrogram peak finding calculation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
prefs.num_harmonics = 6;
%Peak detection noise floor as a fraction of the highest peak
prefs.harmonic_peak_detection_noise_floor = 0.2;
prefs.frequency_cutoff_ratio = 175; %Higher values smooth more

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Options for model data generation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
prefs.model_num_data_rows_per_cell = 2^7;
prefs.model_time_samples_per_millisecond = 1/2; %Default
% prefs.model_time_samples_per_millisecond = 1; %Default
prefs.model_spectral_integration = 0; %0:Rectangular 1:Gaussian

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Options for Spike Train Filtering (Gaussian kernal)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
prefs.filtered_gaussian_sample_frequency = 1000; %Hz
% prefs.filtered_gaussian_stdev = 2; %In milliseconds
prefs.filtered_gaussian_stdev = 3; %In milliseconds



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %Options used for speaker callibration and dB SPL normalization
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
prefs.speaker_calibration_file = 'speaker_calibration_8_27_06';

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %Options for Spectrogram calculation
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %Frequency range for spectrogram
prefs.spectrogram_range = [0 110000];

% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %Options for the calculation of the frequency intervals to integrate over
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% prefs.max_interval_width = 4000;
prefs.default_intervals = [10000:2000:98000 ; 12000:2000:100000]'; %used in CreateModel.m (which is used in Predictions code)
prefs.default_sampled_frequencies = [11000:2000:99000]; %used in CreateModel.m (which is used in Predictions code)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Global options for plotting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Note: Calling the colormap functions creates a figure if there is not
%already one created. Here we check to see if a figure exists already.
%If not, delete the figure generated by the colormap function.
figure_exists = get(0,'CurrentFigure');
prefs.force_plot_visible = false;
prefs.colormap = jet;prefs.colormap_name = 'jet';
prefs.invert_color = false;
% prefs.colormap = hot;prefs.colormap_name = 'hot';
% prefs.colormap = gray;prefs.colormap_name = 'gray';
% prefs.colormap = gray;prefs.colormap_name = 'bone';
% prefs.colormap = colorspiral;prefs.colormap_name = 'colorspiral';
% prefs.colormap = flipud(prefs.colormap); %Use this to reverse colormap
% prefs.colormap = brighten(prefs.colormap,0.3);
if isempty(figure_exists)
    close;
end