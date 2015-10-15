function experiment = ParseHDF5(filepathname)

%Open the file for I/O
%filepathname = 'C:\Users\Owner\Documents\mice_predictions_sparkle\data\Mouse1580\20150909.hdf5'; % 'C:\Users\Owner\Documents\mice_predictions_sparkle\data\20150708.hdf5';
hdf5Info = hdf5info(filepathname);
% ----------

%display(filepathname) %added
%fid = fopen(filepathname);
%Scan each line into a cell array
%file = textscan(fid, '%s', 'delimiter', '\n');
%display(file) %added
%Get the first column of the cell array (the lines)
%lines = file{1};
%display(lines) %added
%Close the file for I/O
%fclose(fid);

%Static strings
test_aborted = 'Test aborted.';
end_id = 'End of ID information';
end_test_parameters = 'End of test parameters';
end_spike_data = 'End of spike data';
end_auto_test = 'End of auto test';

test_types = {'tone',...
              'fmsweep',....
              'synthesized_batsound',....
              'amsound',....
              'broad_band_noise',....
              'narrow_band_noise',....
              'click',....
              'vocalization',....
              'high_pass_noise',....
              'low_pass_noise',....
              'sine_wave_modulation',....
              'square_wave_modulation'};

%Indicates the current line being read.
%line_num = 1;
%Total lines in the PST file
%num_lines = length(lines);
%Offset into the raw data file
%raw_pos = 0;

%Collect experiment-wide data from ID section
experiment.pst_filename = hdf5Info.Filename;
experiment.date = hdf5Info.GroupHierarchy(1).Attributes(1).Value(1).Data;
experiment.title = hdf5Info.GroupHierarchy(1).Name;
experiment.who = hdf5Info.GroupHierarchy(1).Attributes(2).Value(1).Data;
experiment.computername = hdf5Info.GroupHierarchy(1).Attributes(3).Value(1).Data;
experiment.program_date = 'unknown';

%Scan past the ID section
%while ~strcmp(lines{line_num},end_id)
%    line_num = line_num + 1;
%end
%line_num = line_num + 1;

% ---
% For each test

% Calibrations/Segments = Groups
% Tests = Datasets

[~, groups] = size(hdf5Info.GroupHierarchy(1).Groups);

% For each Calibration/Segment (Group)
for group = 1:groups
    fprintf('GROUP %d\n', group);
    [~, datasets] = size(hdf5Info.GroupHierarchy(1).Groups(group).Datasets);
    % For each test (Dataset)
    for dataset = 1:datasets
        fprintf('Group %d : DATASET %d\n', group, dataset);
        % Get test number
        group_name = hdf5Info.GroupHierarchy(1).Groups(group).Name;
        test_name = hdf5Info.GroupHierarchy(1).Groups(group).Datasets(dataset).Name;
        
        if strfind(group_name, 'segment')
        
            test_num = str2double(strrep(test_name, [group_name '/test_'], ''));
            fprintf('\ntest_num: %d\n', test_num)
            experiment.test(test_num).testname = test_name;
            experiment.test(test_num).testnum = test_num;
        
            % Test type
            % TODO

            test_data = hdf5read(filepathname, test_name);
            [samples, channels, reps, traces] = size(test_data);
        
            % Number of Traces
            num_traces = traces;
        
            % Offset in raw file
            % Not needed for HDF5
            
            % Testing Data Here
            [~, attrs] = size(hdf5Info.GroupHierarchy(1).Groups(group).Datasets(dataset).Attributes);
            for attr = 1:attrs
                if strcmp(hdf5Info.GroupHierarchy(1).Groups(group).Datasets(dataset).Attributes(attr).Shortname, 'stim')
                    data = ParseHDF5Stimulus(hdf5Info.GroupHierarchy(1).Groups(group).Datasets(dataset).Attributes(attr).Value.Data);
                end
            end
            % End Here
        
            for trace_num = 1:traces
                fprintf('Group %d : Dataset %d : TRACE %d\n', group, dataset, trace_num);
                % Number of sweeps == Number of reps ???
                num_sweeps = reps; 
            
                % Samplerate_ad
                [~, attrs] = size(hdf5Info.GroupHierarchy(1).Groups(group).Attributes);
                for attr = 1:attrs
                    if strcmp(hdf5Info.GroupHierarchy(1).Groups(group).Attributes(attr).Shortname, 'samplerate_ad')
                        samplerate_ad = hdf5Info.GroupHierarchy(1).Groups(group).Attributes(attr).Value;
                    end
                end
            
                duration = data{1,1}{1,trace_num}.components{1}.duration * 100;
                points = samples;
                experiment.test(test_num).trace(trace_num).record_duration = duration;
                %experiment.test(test_num).trace(trace_num).samplerate_da = samplerate_da;
                experiment.test(test_num).trace(trace_num).samplerate_ad = samplerate_ad;
                experiment.test(test_num).trace(trace_num).num_samples = num_sweeps;
            
                % Not needed in HDF5
                %experiment.test(test_num).trace(trace_num).offset_in_raw_file = raw_pos;
                %experiment.test(test_num).trace(trace_num).length_in_raw_file = trace_raw_data_length;
            
                for channel_num = 1:channels
                    fprintf('Group %d : Dataset %d : Trace %d : CHANNEL %d\n', group, dataset, trace_num, channel_num);
                    % Check for attrubute 'stim' only
                    [~, attrs] = size(hdf5Info.GroupHierarchy(1).Groups(group).Datasets(dataset).Attributes);
                    for attr = 1:attrs
                        if strcmp(hdf5Info.GroupHierarchy(1).Groups(group).Datasets(dataset).Attributes(attr).Shortname, 'stim')
                            %
                            %data = ParseHDF5Stimulus(hdf5Info.GroupHierarchy(1).Groups(group).Datasets(dataset).Attributes(attr).Value.Data);
                        
                            stimulus = struct('attenuation', [],... 
                                            'duration', [],...
                                            'delay', [],...
                                            'frequency', [],...
                                            'rise_fall', [],...
                                            'soundtype_name', [],...
                                            'reverse_vocal_call', [],...
                                            'vocal_call_file', []);
                        
                            %display(data{1,1}{1,trace_num}.components{1}.stim_type)
                            fprintf('stim_type: %s\n\n', data{1,1}{1,trace_num}.components{1}.stim_type);
                                        
                            stimulus.attenuation = data{1,1}{1,trace_num}.overloaded_attenuation;
                            stimulus.duration = data{1,1}{1,trace_num}.components{1}.duration * 100;
                            stimulus.delay = [];
                            if ~strcmp(data{1,1}{1,trace_num}.components{1}.stim_type, 'silence') && ...
                                    ~strcmp(data{1,1}{1,trace_num}.components{1}.stim_type, 'White Noise') && ...
                                    ~strcmp(data{1,1}{1,trace_num}.components{1}.stim_type, 'Vocalization')
                                stimulus.frequency = data{1,1}{1,trace_num}.components{1}.frequency;
                            end
                            stimulus.rise_fall = data{1,1}{1,trace_num}.components{1}.risefall * 100;
                            stimulus.soundtype_name = data{1,1}{1,trace_num}.components{1}.stim_type;
                            stimulus.reverse_vocal_call = [];
                            stimulus.vocal_call_file = [];
                        
                            % TODO Add missing fields
                            % TODO Add mulit channel support
                        
                            experiment.test(test_num).trace(trace_num).stimulus(channel_num) = stimulus;
                        
                            stim_type = data{1,1}{1,trace_num}.components{1}.stim_type;
                        
                            switch(stim_type)
                                case 'silence'
                                    test_type = 'control';
                                case 'Pure Tone'
                                    test_type = 'tone';
                                case 'FM Sweep'
                                    test_type = 'fmsweep';
                                case 'White Noise'
                                    test_type = 'broad_band_noise';
                                case 'Band Noise'
                                    test_type = 'narrow_band_noise';
                                case 'Vocalization';
                                    test_type = 'vocalization';
                                case 'Square Wave'
                                    test_type = 'square_wave_modulation';
                                otherwise
                                    test_type = stim_type;
                            end
                            experiment.test(test_num).testtype = test_type;
                            experiment.test(test_num).full_testtype = test_type;
                        
                            % Check if control or not control
                            if stim_type > 0
                                experiment.test(test_num).trace(trace_num).is_control = 0;
                            else
                                %If there is no stimulus present in the trace, then label it as a contol.
                                experiment.test(test_num).trace(trace_num).is_control = 1;
                            end
                            %
                        end
                    end
                end 
            end  
            
        end
        
    end
    %Get the test comment
    [~, attrs] = size(hdf5Info.GroupHierarchy(1).Groups(group).Attributes);
    for attr = 1:attrs
        if strcmp(hdf5Info.GroupHierarchy(1).Groups(group).Attributes(attr).Shortname, 'comment')
            experiment.test(test_num).comment = hdf5Info.GroupHierarchy(1).Groups(group).Attributes(attr).Value.Data;
        end
    end
end

% Old Code
% --------
%{
%Iterate through each test
while line_num <= num_lines
    %Get the test type
    full_testtype = lines{line_num};
    line_num = line_num + 1;
    %Get the test number.
    test_num = textscan(lines{line_num},'%n',1);
    test_num = test_num{1};
    experiment.test(test_num).testnum = test_num;
    %This is the Batlab assigned test type, not the test type that Bat2Matlab uses
    experiment.test(test_num).full_testtype = full_testtype;
    %Store the beginning location of the test
    line_num = line_num + 1;
    %display(line_num) %added
    %Extract the test paramewters
    test_data = textscan(lines{line_num},'%n %s %n %n %n %n %s %n %n %n %n %n %n',1);
    num_traces = test_data{1};
    line_num = line_num + 1;
    
    %Not even sure what these test are. Not necessary?
%     vocal_call_io_test_number = textscan(lines{line_num},'%n');
%     line_num = line_num + 1;
%     vocal_call_io_test_number = vocal_call_io_test_number{1};
%     if vocal_call_io_test_number > 0
%         error('Handle vocal io tests');
%     end
    
    %Scan past the test parameter section
    while ~strcmp(lines{line_num},end_test_parameters)
        line_num = line_num + 1;
    end
    line_num = line_num + 1;
    
    %Get the position of the beginning of the test in the raw data file
    experiment.test(test_num).offset_in_raw_file = raw_pos;
    for trace_num = 1:num_traces % ---------------------------------------------------------
        %Get the trace data for this test
        trace_data = textscan(lines{line_num},'%n');
        %display(trace_data) %added
        trace_data = trace_data{1};
        %display(trace_data) %added
%         display(line_num);
%         display(test_num);
%         display(trace_data);
        num_sweeps = trace_data(1);
        samplerate_da = trace_data(2);
        samplerate_ad = trace_data(4);
        duration = trace_data(5);
        points = samplerate_ad/1000*duration;
        experiment.test(test_num).trace(trace_num).record_duration = duration;
        experiment.test(test_num).trace(trace_num).samplerate_da = samplerate_da;
        experiment.test(test_num).trace(trace_num).samplerate_ad = samplerate_ad;
        experiment.test(test_num).trace(trace_num).num_samples = num_sweeps;
        %The length of the trace in the raw data file
        trace_raw_data_length = points*num_sweeps*2;
        %Store the trace raw offset and length
        experiment.test(test_num).trace(trace_num).offset_in_raw_file = raw_pos;
        experiment.test(test_num).trace(trace_num).length_in_raw_file = trace_raw_data_length;
        %Increment the position in the raw data file
        raw_pos = raw_pos + trace_raw_data_length;
        
        %Collect the stimulus parameters for all 4 channels
        stimulus_num = 0;
        test_stim_type = 0; %Default
        for channel_num = 1:4
            %display('stim_text =') %added
            %display(lines{line_num - 1 + 5*channel_num}) %added
            [stimulus stim_type] = ParsePSTStimulus(lines{line_num - 1 + 5*channel_num},test_num,trace_num);
            %display(stimulus) %added
            %display(stim_type) %added
            if ~isempty(stimulus) %&& stim_type ~= 5 %FIXME. Not adding BBN stimulus
                stimulus_num = stimulus_num + 1;
                experiment.test(test_num).trace(trace_num).stimulus(stimulus_num) = stimulus;
                if test_stim_type == 0
                    test_stim_type = stim_type;
                end
            end
        end

        %If there is no stimulus
        if ~isfield(experiment.test(test_num).trace(trace_num), 'stimulus')
            experiment.test(test_num).trace(trace_num).stimulus = [];
        end
        
        %Set the test type based on the stimulus variety                   ----------
        switch test_stim_type
            case 0, %No Stimulus
                test_type = 'control';
            case 1, %tone
                switch stimulus_num
                    case 1, test_type = 'tone';
                    case 2, test_type = 'twotone';
                    case 3, test_type = 'threetone';
                    case 4, test_type = 'fourtone';
                end
            otherwise, test_type = test_types{test_stim_type};
        end
        experiment.test(test_num).testtype = test_type;
        if test_stim_type > 0
            experiment.test(test_num).trace(trace_num).is_control = 0;
        else
            %If there is no stimulus present in the trace, then label it as a contol.
            experiment.test(test_num).trace(trace_num).is_control = 1;
        end
        
        %Scan past the spike data
        while ~strcmp(lines{line_num},end_spike_data)
            line_num = line_num + 1;
        end
        line_num = line_num + 1;
    end
    
    %Assert that the spike data terminates with an end auto test statement
    if ~strcmp(lines{line_num},end_auto_test)
        error('No end of auto test found after spike data');
    end
    line_num = line_num + 1;
    
    %Get the test comment
    experiment.test(test_num).comment = lines{line_num};
    line_num = line_num + 1;
end
%}
display('--- !!! DONE !!! ---')