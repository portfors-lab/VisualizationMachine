function prefs = preferenceDefaults

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Options used for speaker callibration and dB SPL normalization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%20 micro-Pascals for dB SPL conversion
prefs.dB_SPL_ref = 0.00002;
%16-bit audio dynamic range
prefs.dbRange = 96.3296;
%Approximate maximum output of speaker in dB SPL
prefs.dbMax = 115;
%Approximate maximum output of speaker in dB SPL minus maximum dynamic range of 16 bit audio.
% prefs.dbMin = dbMax-dbRange;
prefs.dbMin = 0;
%This allows the setting of a threshold below which everything is set to zero.
prefs.model_data_dbMin = prefs.dbMin;
%Approximate maximum output of speaker in dB SPL/Hz
prefs.spectrogram_dbMax = 84.5665;
%Approximate maximum output of speaker in dB SPL/Hz minus maximum dynamic range of 16 bit audio.
prefs.spectrogram_dbMin = prefs.spectrogram_dbMax-prefs.dbRange;
% prefs.spectrogram_dbMin = 0;
%Decide whether to use absolute or relative color scaling when plotting the spectrogram.
prefs.spectrogram_absolute_scaling = false;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Options for Spectrogram calculation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The number of times to evaluate the spectrogram in the frequency domain.
prefs.spectrogram_freq_samples = 2^10;
%The density of sampling in the time domain
% prefs.spectrogram_time_samples_per_millisecond = 1/2;
% prefs.spectrogram_time_samples_per_millisecond = 2;
prefs.spectrogram_time_samples_per_millisecond = 5;
%Frequency range for spectrogram
% prefs.spectrogram_range = [0 110000];
%Window length (in seconds)
% prefs.spectrogram_window_length = 0.0001;
% prefs.spectrogram_window_length = 0.0005;
% prefs.spectrogram_window_length = 0.0015; %Happy medium? Default
prefs.spectrogram_window_length = 0.002; %Best so far
% prefs.spectrogram_window_length = 0.0025;
% prefs.spectrogram_window_length = 0.003;
% prefs.spectrogram_window_length = 0.05;

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
prefs.num_harmonics = 1;
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
%Options for Histogram generation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% prefs.histogram_bin_width = 1; 
prefs.histogram_bin_width = 4; %Default
% prefs.histogram_bin_width = 10;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Options for the calculation of the frequency intervals to integrate over
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
prefs.max_interval_width = 4000;
% prefs.default_intervals = [10000:2000:98000 ; 12000:2000:100000]';
% prefs.default_sampled_frequencies = [11000:2000:99000];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Options for harmonic peak calculation as a fraction of the highest peak
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Options for VR metric calculation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
prefs.exponential_decay = 10; %Milliseconds
%The sample frequency of the signal reconstituted from thespike times
prefs.filtered_exponential_sample_frequency = 1000; %Hz

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Options for Spike Train Filtering (Gaussian kernal)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
prefs.filtered_gaussian_sample_frequency = 1000; %Hz
% prefs.filtered_gaussian_stdev = 2; %In milliseconds
prefs.filtered_gaussian_stdev = 3; %In milliseconds
