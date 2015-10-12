function TCDiff

%function TCD : an interface for finding the difference between two tuning
%curves.
%
% choose the folder in which your .pst and .raw files reside,
% this folder must have the SAME NAME as the .pst and .raw files
% you must also choose a range of test numbers over which to do the
% correlation. 
%
%The difference the absoulute value of the difference between two tuning
%curves, element-for-element.

%Amy Boyle Jan 2011, Nov 2012

animalPath = [];
rootPath = pwd;
outPath = '';

tableIcon = imread('table.jpg');
%tableIcon = imresize(tableIcon, 0.8);

fh = figure('position', [300 250 425 450], 'resize', 'off', 'windowstyle', 'normal', 'menu', 'none');
%fh = figure('position', [500 500 375 225], 'resize', 'off', 'windowstyle', 'modal');
bcolor = [0.8 0.8 0.8];

uicontrol(fh, 'style', 'text', 'position',  [25 400 350 30], 'string', 'Difference between two tuning curves', 'fontsize', 14, 'backgroundcolor', bcolor);

uicontrol(fh, 'style', 'text', 'position', [15 350 200 20], 'string', 'Animal folder', 'horizontalalignment', 'left', 'backgroundcolor', bcolor);

pathBox = uicontrol(fh, 'style', 'edit', 'position', [15 325 225 25], 'string', animalPath);
uicontrol(fh, 'style', 'pushbutton', 'position', [240 325 100 25], 'string', 'Browse...', 'callback', @browseFun);

uicontrol(fh, 'style', 'pushbutton', 'position', [270 275 25 25],'CData', tableIcon, 'callback', @exploreFun);

uicontrol(fh, 'style', 'text', 'position', [15 275 100 20], 'string', 'Test numbers:', 'horizontalalignment', 'left', 'backgroundcolor', bcolor);
minBox = uicontrol(fh, 'style', 'edit', 'position', [15 250 50 20]);
maxBox = uicontrol(fh, 'style', 'edit', 'position', [115 250 50 20]);

uicontrol(fh, 'style', 'text', 'string', '&', 'position', [80 250 20 20], 'backgroundcolor', bcolor);
hints(1) = uicontrol(fh, 'style', 'text', 'string', '(control)', 'position', [12 228 60 20], 'backgroundcolor', bcolor, 'horizontalalignment', 'left');
hints(2) = uicontrol(fh, 'style', 'text', 'string', '(test)', 'position', [118 228 50 20], 'backgroundcolor', bcolor, 'horizontalalignment', 'left');

% uicontrol(fh, 'style', 'text', 'position', [300 275 100 20], 'string', 'Trace:', 'horizontalalignment', 'left', 'backgroundcolor', bcolor);
% traceBox = uicontrol(fh, 'style', 'edit', 'position', [350 275 50 20]);

uicontrol(fh, 'style', 'text', 'position', [15 195 125 20], 'string', 'Spike Threshold:', 'horizontalalignment', 'left', 'backgroundcolor', bcolor);
threshBox = uicontrol(fh, 'style', 'edit', 'position', [135 195 50 20], 'string', '0.2');

mspptLabel = uicontrol(fh, 'style', 'text', 'position', [15 165 280 20], 'string', 'Mean spikes per presentation threshold:', 'horizontalalignment', 'left', 'backgroundcolor', bcolor);
mspptBox = uicontrol(fh, 'style', 'edit', 'position', [300 165 50 20], 'string', '0.5');

sptCheck = uicontrol(fh, 'style', 'checkbox', 'position', [15 135 250 20], 'string', 'Spontaneous spike threshold:', 'backgroundcolor', bcolor, 'value', 1);
sptBox = uicontrol(fh, 'style', 'edit', 'position', [255 135 50 20], 'string', '0.5');

% txtCheckBox = uicontrol(fh, 'style', 'checkbox', 'position',[15 125 250 20], 'string', 'output data matrix to text file', 'backgroundcolor', bcolor, 'callback', @checkFun);
% uicontrol(fh, 'style', 'text', 'position', [35 100 200 20], 'string', 'output location:', 'horizontalalignment', 'left', 'backgroundcolor', bcolor);
% txtPathBox = uicontrol(fh, 'style', 'edit', 'position', [35 75 225 25], 'string', outPath, 'enable', 'off');
% txtPathButton = uicontrol(fh, 'style', 'pushbutton', 'position', [260 75 100 25], 'string', 'Browse...', 'callback', @txtBrowseFun, 'enable', 'off');

diffChoiceGrp = uibuttongroup(fh, 'units', 'pixels', 'position', [15 65 400 65], 'title', 'Difference type', 'backgroundcolor', bcolor, 'SelectionChangeFcn', @hideTestHints);

d = uicontrol('Style','Radio','String','Difference', 'parent', diffChoiceGrp, 'units', 'pixels', 'position', [10 10 100 30], ...
        'enable', 'on','tooltipstring', 'Straight difference between tests', 'backgroundcolor', bcolor);
    
s = uicontrol('Style','Radio','String','Control/Surround', 'parent', diffChoiceGrp, 'units', 'pixels', 'position', [150 10 150 30], 'value', 1, ...
        'enable', 'on','tooltipstring', 'Preserve control response, and subtract remaining test response', 'backgroundcolor', bcolor);
    
uicontrol(fh, 'style', 'pushbutton', 'position', [200 10 90 30], 'string', 'OK', 'callback', @okFun);

uicontrol(fh, 'style', 'pushbutton', 'position', [300 10 90 30], 'string', 'Close', 'callback', 'close(gcf)');

%progress bar
jProgressBar = javax.swing.JProgressBar(0,100);
jProgressBar.setValue(0);
jProgressBar.setBackground(java.awt.Color(0.8,0.8,0.8));
jProgressBar.setForeground(java.awt.Color.BLUE);
[~, pgcontainer] = javacomponent(jProgressBar, [15 15 100 15], fh);

prefs =[];
experiment_data = [];

    function browseFun(jObj,evtdata)
        animalPath = uigetdir(rootPath, 'folder containing data');
        if animalPath ~= 0
           set(pathBox, 'string', [animalPath filesep]);
           experiment_data = [];
        end
    end

    function exploreFun(hObj, eventData)
        %view file contents, get test numbers
        if isempty(animalPath)
            errordlg('! Must select animal file first, before able to select test numbers')
            return
        end
        if isempty(experiment_data)
            [prefs experiment_data] = GetExpData(animalPath);
            if isempty(prefs)
                return
            end
        end
        %ExploreTestData(experiment_data);
        testNums = SelectTestNumbers(experiment_data);
        if ~isempty(testNums)
            if length(testNums) ~= 2
                warndlg('you must select exactly 2 tests to find difference')
            else
                set(minBox, 'string', num2str(testNums(1)));
                set(maxBox, 'string', num2str(testNums(2)));
            end
        end
    end

    function okFun(oh,evtd)
        test1 = str2double(get(minBox, 'string'));
        test2 = str2double(get(maxBox, 'string'));
    
        animalPath = get(pathBox, 'string');
        if isempty(animalPath)
            disp('! You must enter a filepath for the data you wish to compare');
            return
        end            

        if isempty(experiment_data)
            [prefs experiment_data] = GetExpData(animalPath);
            if isempty(prefs)
                return
            end
        end
        
        if isnan(test1) || isnan(test2)
            disp('! Test range must inlcude numbers');
            return
        end
        if any([test1 test2] > length(experiment_data.test))
            disp('! Entered test range exceeds file contents')
            return
        end
        
        uprefs = preferenceDefaults;
        
        prefs = catstruct(prefs,uprefs);
        prefs.speaker_calibration = speakerCalibration(prefs.speaker_calibration_file);
        prefs.spike_presentation_threshold = str2double(get(mspptBox, 'string'));
        prefs.spike_time_peak_threshold = str2num(get(threshBox, 'string'));
        
        if get(d, 'value')
            prefs.diff_type = 'diff';
        else
            prefs.diff_type = 'surround';
        end
        if get(sptCheck, 'value')
            prefs.sptThresh = str2double(get(sptBox, 'string'));
        else
            prefs.sptThresh = 0;
        end
        try
            jProgressBar.setIndeterminate(true)
            TuningCurveDifference(experiment_data, prefs, test1, test2);
            jProgressBar.setIndeterminate(false)
        catch e
            jProgressBar.setIndeterminate(false)
            rethrow(e)
        end
    end

    function hideTestHints(~,~)
        if get(d, 'value')
            set(hints, 'visible', 'off')
            set([mspptBox mspptLabel], 'enable', 'off')
        else
            set(hints, 'visible', 'on')
            set([mspptBox mspptLabel], 'enable', 'on')
        end     
    end
end