function [data] = ParseHDF5Stimulus(json)
    %set(0, 'RecursionLimit', 2000);
    %json = '[{"time_stamps": [1436387880.878, 1436387881.129, 1436387881.376, 1436387881.625, 1436387881.874, 1436387882.124, 1436387882.374, 1436387882.624, 1436387882.874, 1436387883.124, 1436387883.374, 1436387883.624, 1436387883.874, 1436387884.124, 1436387884.374, 1436387884.624, 1436387884.874, 1436387885.124, 1436387885.374, 1436387885.624, 1436387885.874, 1436387886.124, 1436387886.374, 1436387886.624, 1436387886.875, 1436387887.124, 1436387887.374, 1436387887.624, 1436387887.874, 1436387888.124, 1436387888.374, 1436387888.623, 1436387888.874, 1436387889.124, 1436387889.374, 1436387889.624, 1436387889.874, 1436387890.124, 1436387890.374, 1436387890.624, 1436387890.874, 1436387891.124, 1436387891.374, 1436387891.624, 1436387891.874, 1436387892.124, 1436387892.374, 1436387892.624, 1436387892.874, 1436387893.124, 1436387893.374, 1436387893.624, 1436387893.874, 1436387894.124, 1436387894.374, 1436387894.624, 1436387894.874, 1436387895.124, 1436387895.374, 1436387895.624, 1436387895.874, 1436387896.124, 1436387896.374, 1436387896.624, 1436387896.875, 1436387897.124, 1436387897.372, 1436387897.623, 1436387897.874, 1436387898.124, 1436387898.374, 1436387898.624, 1436387898.874, 1436387899.124, 1436387899.374, 1436387899.624, 1436387899.874, 1436387900.124, 1436387900.374, 1436387900.624, 1436387900.874, 1436387901.124, 1436387901.374, 1436387901.624, 1436387901.874, 1436387902.124, 1436387902.374, 1436387902.624, 1436387902.874, 1436387903.124, 1436387903.374, 1436387903.634, 1436387903.883, 1436387904.132, 1436387904.381, 1436387904.631, 1436387904.881, 1436387905.131, 1436387905.381, 1436387905.631], "overloaded_attenuation": 0, "components": [{"risefall": 0, "index": [0, 0], "stim_type": "silence", "intensity": 0, "duration": 0, "start_s": 0}], "samplerate_da": 500000},{"time_stamps": [1436387905.882, 1436387906.128, 1436387906.379, 1436387906.631, 1436387906.881, 1436387907.13, 1436387907.38, 1436387907.629, 1436387907.878, 1436387908.127, 1436387908.376, 1436387908.627, 1436387908.877, 1436387909.127, 1436387909.376, 1436387909.625, 1436387909.874, 1436387910.123, 1436387910.373, 1436387910.622, 1436387910.871, 1436387911.12, 1436387911.369, 1436387911.618, 1436387911.867, 1436387912.116, 1436387912.365, 1436387912.614, 1436387912.863, 1436387913.112, 1436387913.361, 1436387913.646, 1436387913.897, 1436387914.146, 1436387914.395, 1436387914.644, 1436387914.893, 1436387915.142, 1436387915.391, 1436387915.64, 1436387915.889, 1436387916.139, 1436387916.388, 1436387916.638, 1436387916.888, 1436387917.137, 1436387917.386, 1436387917.635, 1436387917.884, 1436387918.133, 1436387918.382, 1436387918.655, 1436387918.906, 1436387919.155, 1436387919.404, 1436387919.653, 1436387919.903, 1436387920.154, 1436387920.403, 1436387920.652, 1436387920.901, 1436387921.15, 1436387921.399, 1436387921.648, 1436387921.897, 1436387922.146, 1436387922.396, 1436387922.645, 1436387922.894, 1436387923.143, 1436387923.392, 1436387923.66, 1436387923.91, 1436387924.159, 1436387924.408, 1436387924.657, 1436387924.906, 1436387925.155, 1436387925.404, 1436387925.653, 1436387925.902, 1436387926.151, 1436387926.4, 1436387926.649, 1436387926.899, 1436387927.15, 1436387927.399, 1436387927.648, 1436387927.897, 1436387928.146, 1436387928.395, 1436387928.67, 1436387928.92, 1436387929.169, 1436387929.418, 1436387929.667, 1436387929.916, 1436387930.166, 1436387930.416, 1436387930.666], "overloaded_attenuation": 0, "components": [{"risefall": 0.003, "index": [0, 0], "stim_type": "Pure Tone", "intensity": 50.0, "frequency": 39000.0, "duration": 0.05, "start_s": 0}], "samplerate_da": 500000}]';
    
    data = cell(0);

    while ~isempty(json)   
        [value json] = parseValue(json);
        data{end+1} = value;
    end
    
    %celldisp(data)
    %display(data{1}{1}.components)
    %celldisp(data{1}{1}.components)
    %size(data)
    %display(data{1,1}{1,2})
    %display(data{1,1}{1,2}.components{1})
    
    stimulus = struct('attenuation', [],... 
                      'duration', [],...
                      'delay', [],...
                      'frequency', [],...
                      'rise_fall', [],...
                      'soundtype_name', [],...
                      'reverse_vocal_call', [],...
                      'vocal_call_file', []);
                  
    stimulus.soundtype_name = 'tuna';
    %display(stimulus)
    %display(data{1,1}{1,1}.components{1}.stim_type)
    
end

function [value json] = parseValue(json)
    value = [];
    
    %display(json)
    temp = json(1);
    json(1) = [];
    
    switch lower(temp)
        case '{'
            % Object
            [value json] = parseObject(json);
        case '['
            % Array
            [value json] = parseArray(json);
        case '"'
            % String
            [value json] = parseString(json);
        case 't'
            % True
            value = true;
            if (length(json) >= 3)
                json(1:3) = [];
            end % TODO add exception
        case 'f'
            % False
            value = false;
            if (length(json) >= 4)
                json(1:4) = [];
            end % TODO add exception
        case 'n'
            % Null
            value = [];
            if (length(json) >= 3)
                json(1:3) = [];
            end % TODO add exception
        otherwise
            % Number
            [value json] = parseNumber([temp json]);
    end
end

function [object json] = parseObject(json)
    object = [];
    while ~isempty(json)
        temp = json(1);
        json(1) = [];
        
        switch temp
            case '"'
                % start string
                [string value extraJson] = parseStringValue(json);
                if isempty(string)
                    %TODO cannot have empty string name
                end
                object.(string) = value;
                json = extraJson;
            case '}'
                % end of object
                return
            otherwise
                % Other
        end
    end
end

function [array json] = parseArray(json)
    array = cell(0,1);
    while ~isempty(json)
        % If end of array
        if strcmp(json(1), ']')
            json(1) = [];
            return
        end
        
        [value json] = parseValue(json);
        
        % Check if value is empty, throw exception if true
        % TODO
        
        array{end+1} = value;
        
        % Skip spaces and commas
        while ~isempty(json) && ~isempty(regexp(json(1), '[\s,]', 'once'))
            json(1) = [];
        end
    end
end

function [string json] = parseString(json)
    string = [];
    while ~isempty(json)
        char = json(1);
        json(1) = [];
        
        switch lower(char)
            case '\'
                % Escaped Characters
                % TODO
            case '"'
                % End of string
                return
            otherwise
                % Add char to string
                newChar = char;
        end
        % Append newChar to string
        string = [string newChar];
    end
end

function [num json] = parseNumber(json)
    num = [];
    if ~isempty(json)
        [s e] = regexp(json, '^[\w]?[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?[\w]?', 'once');
        if ~isempty(s)
            numStr = json(s:e);
            json(s:e) = [];
            num = str2double(strtrim(numStr));
        end
    end
end

function [string value json] = parseStringValue(json)
    string = [];
    value = [];
    if ~isempty(json)
        [string json] = parseString(json);
        
        % Skip spaces and colons
        while ~isempty(json) && ~isempty(regexp(json(1), '[\s:]', 'once'))
            json(1) = [];
        end
        
        [value json] = parseValue(json);
    end
end
