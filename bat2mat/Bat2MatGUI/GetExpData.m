function [prefs experimentData] = GetExpData(animalPath)
%checks to see if experimentData is cached in a .mat file before parsing
%.pst and .raw files. If the given animalPath exists as a folder name,
%assumes that the .pst and .raw files reside in that folder with the same
%name as the folder.  Otherwise assumes that the animalPath is the filename
%of the .pst and .raw files, just without the extension.


    if ~isdir(animalPath)
        %given the animal name, find files that end with .pst and .raw in the
        %same folder.
        
        %remove trailing slash, if present
        if strmatch(animalPath(end), filesep)
            animalPath = animalPath(1:end-1);
        end
        [~, animalName] = fileparts(animalPath);
        animalMatFile = [animalName '_cachedData.mat'];
        
        prefs=GeneratePreferences(animalPath,0);

        cachedData=[prefs.extracted_data_folder animalMatFile];

    else %older way of doing it where the folder name and file names match
        animalMatFile = 'cachedData.mat';
        if ~isequal(animalPath(end), filesep)
            animalPath = [animalPath filesep];
        end
        cachedData = [animalPath animalMatFile];
        
        prefs = GeneratePreferences(animalPath,1);

    end
    
    if exist(cachedData, 'file')
        %load cached data, if present
        d = load(cachedData, '-mat');
        experimentData = d.experimentData;
        [~, pstFile ext] = fileparts(prefs.pst_data_filepath);
        if ~strcmp([pstFile ext], experimentData.pst_filename)
            WriteStatus(['cached data does not match. cached:' experimentData.pst_filename ', selected: ' pstFile], 'red')
        end
    else
        %otherwise read in data from raw file
        if ~exist(prefs.raw_data_filepath, 'file') || ~exist(prefs.pst_data_filepath, 'file')
            WriteStatus('Invalid animal folder selection: select the folder in which the .raw & .pst files reside; folder must bear the same name as these files', 'red');
            prefs = [];
            experimentData = [];
            return
        end
        experimentData = LoadExperimentData(prefs);
        save(cachedData, 'experimentData');
    end    
    
end