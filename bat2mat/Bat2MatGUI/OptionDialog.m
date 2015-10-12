function [stimPath, calPath, colormap, invertColor, colorRange, txtPath] = OptionDialog(stimPath, calPath, colormap, invertColor, colorRange, txtPath)
% function [stimPath, colormap, colorRange] = optionDialog(stimPath, colormap, colorRange, colorChoice)
%
%INPUTS
%
%stimPath          folder where stimulus files for the data reside
%colormap          string of the desired colorMap to use
%colorRange        manual selection of range of colorbar. default = []
%colorChoice       indicates which radio button to have selected for
%                  colorRange

% Author Amy Boyle November 2010
%edited 6/30/12 added tabs and calibration option

cPath = calPath;

fh = figure('position', [300 250 500 400], 'resize', 'off', 'windowstyle', 'modal');

bcolor = [0.8 0.8 0.8];

maps = {'jet', 'hot', 'gray', 'bone', 'ColorSpiral'};
mapValue = strmatch(colormap, maps);
if isempty(mapValue)
    mapValue =1;
end
uicontrol(fh, 'style', 'text', 'position', [125 350 250 30], 'string', 'Advanced Options', 'fontsize', 14, 'backgroundcolor', bcolor);

hTabGroup = uitabgroup('v0','units', 'normalized', 'position', [0 0 1 0.85], 'backgroundcolor', bcolor);
 
%stimulus files folder-----------------------------------------------------
tab1 = uitab('v0',hTabGroup, 'title', 'folders'); %v0 argument gets rid of warning, there seems to be no current version for R2010a

uicontrol(tab1, 'style', 'text', 'position', [15 250 200 20], 'string', 'Stimulus Files Location:', 'horizontalalignment', 'left', 'backgroundcolor', bcolor);
pathBox = uicontrol(tab1, 'style', 'edit', 'position', [15 225 225 25], 'string', stimPath);
uicontrol(tab1, 'style', 'pushbutton', 'position', [240 225 100 25], 'string', 'Browse...', 'callback', @browseFun);

uicontrol(tab1, 'style', 'text', 'position', [15 150 200 20], 'string', 'Speaker Calibration File:', 'horizontalalignment', 'left', 'backgroundcolor', bcolor);
calPathBox = uicontrol(tab1, 'style', 'edit', 'position', [15 125 225 25], 'string', cPath);
uicontrol(tab1, 'style', 'pushbutton', 'position', [240 125 100 25], 'string', 'Browse...', 'callback', @calBrowse);

%colormap options----------------------------------------------------------
tab2 = uitab('v0',hTabGroup, 'title', 'colormap');

uicontrol(tab2, 'style', 'text', 'position', [150 250 200 30], 'string', 'Test Color Options', 'horizontalalignment', 'center', 'backgroundcolor', bcolor, 'fontsize', 14);

uicontrol(tab2, 'style', 'text', 'position', [15 185 75 20], 'string', 'colormap', 'horizontalalignment', 'left', 'backgroundcolor', bcolor);
mapMenu = uicontrol(tab2, 'style', 'popupmenu', 'position', [15 165 120 20], 'string', maps, 'value', mapValue);
invertBox = uicontrol(tab2, 'style', 'checkbox', 'position',[15 130 120 20], 'string', 'invert colormap', 'backgroundcolor', bcolor, 'value', invertColor);

bgh = uibuttongroup('parent', tab2,  'units', 'pixels','position', [160 75 300 150], 'backgroundcolor', bcolor, 'title', 'colorbar range', 'selectionchangefcn', @selectionFun);

defColorButton = uicontrol(bgh, 'style', 'radiobutton', 'string', 'Default colorbars', 'position', [10 110 175 20], 'backgroundcolor', bcolor);

symColorButton = uicontrol(bgh, 'style', 'radiobutton', 'string', 'Symmetric at 0', 'position', [10 80 175 20], 'backgroundcolor', bcolor);

manColorButton = uicontrol(bgh, 'style', 'radiobutton', 'string', 'Manual colorbar range', 'position', [10 50 175 20], 'backgroundcolor', bcolor);

minBox = uicontrol(bgh, 'style', 'edit', 'position', [50 25 50 20]);
maxBox = uicontrol(bgh, 'style', 'edit', 'position', [150 25 50 20]);

uicontrol(bgh, 'style', 'text', 'string', 'to', 'position', [115 25 20 20], 'backgroundcolor', bcolor);

if length(colorRange) == 2
    set(bgh, 'selectedobject', manColorButton);   
    set(minBox, 'string', colorRange(1));
    set(maxBox, 'string', colorRange(2));
elseif length(colorRange) == 1
    set(bgh, 'selectedobject', symColorButton);
    set(minBox, 'enable', 'off');
    set(maxBox, 'enable', 'off');
else
    set(bgh, 'selectedobject', defColorButton);
    set(minBox, 'enable', 'off');
    set(maxBox, 'enable', 'off');
end
%matchColorButton = uicontrol(bgh, 'style', 'radiobutton', 'string','Matchcolorbar ranges', 'position', [10 150 175 20], 'backgroundcolor', bcolor);

% text file output---------------------------------------------------------
tab3 = uitab('v0',hTabGroup, 'title', 'text output');

if isempty(txtPath)
    chkValue = 0;
    enabled = 'off';
else
    chkValue = 1;
    enabled = 'on';
end
txtCheckBox = uicontrol(tab3, 'style', 'checkbox', 'position',[15 225 200 20], 'string', 'send output to text file', 'backgroundcolor', bcolor, 'callback', @checkFun, 'value', chkValue);
uicontrol(tab3, 'style', 'text', 'position', [35 200 200 20], 'string', 'output location:', 'horizontalalignment', 'left', 'backgroundcolor', bcolor);
txtPathBox = uicontrol(tab3, 'style', 'edit', 'position', [35 175 225 25], 'string', txtPath, 'enable', enabled);
txtPathButton = uicontrol(tab3, 'style', 'pushbutton', 'position', [260 175 100 25], 'string', 'Browse...', 'callback', @txtBrowseFun, 'enable', enabled);

uicontrol(fh, 'style', 'pushbutton', 'position', [275 10 90 30], 'string', 'OK', 'callback', @okFun);

uicontrol(fh, 'style', 'pushbutton', 'position', [375 10 90 30], 'string', 'Cancel', 'callback', 'close(gcf)' );

uiwait(fh);

    function browseFun(hobject, eventdata)
        thisPath = uigetdir(stimPath, 'Find Stimulus Folder');
        set(pathBox, 'string', [thisPath filesep]);
    end

    function calBrowse(~,~)
        if isempty(cPath)
            calFilter = '*.*';
        else
            calFilter = cPath;
        end
        [calFile calFolder] = uigetfile(calFilter, 'Select Calibration File');
        if ~isempty(calFile) && ischar(calFile)
            cPath = [calFolder calFile];
            set(calPathBox, 'string', cPath);
            
        end
    end

    function txtBrowseFun(hObj, eventdata)
        thisPath = uigetdir(txtPath, 'Output text files location');
        set(txtPathBox, 'string', [thisPath filesep]);
    end

    function selectionFun(hObj, eventdata)
        if eventdata.NewValue == defColorButton || eventdata.NewValue == symColorButton
            set(minBox, 'enable', 'off');
            set(maxBox, 'enable', 'off');
        elseif eventdata.NewValue == manColorButton
            set(minBox, 'enable', 'on');
            set(maxBox, 'enable', 'on'); 
        end
    end

    function checkFun(hObj, eventdata)
        if(get(hObj, 'value'))
            set(txtPathBox, 'enable', 'on');
            set(txtPathButton, 'enable', 'on');
        else
            set(txtPathBox, 'enable', 'off');
            set(txtPathButton, 'enable', 'off');
        end
    end

    function okFun(hobject, eventdata)
       stimPath = get(pathBox, 'string');
       if ~isempty(stimPath) && ~exist(stimPath, 'dir')
           errordlg('designated folder does not exist, please re-enter');
           return
       elseif ~isempty(stimPath)
           if ~isequal(stimPath(end), filesep)
               stimPath = [stimPath filesep];
           end
       end
       
       cPath = get(calPathBox, 'string');
       if ~isempty(cPath) 
           if ~exist(cPath, 'file')
               errordlg('designated calibration file does not exist, please re-enter');
               return
           end 
       end
       calPath =cPath;
       
       colormap = maps{get(mapMenu, 'value')};
       invertColor = get(invertBox, 'value');
       selectedRadio = get(bgh, 'selectedobject');
       if selectedRadio == manColorButton
           min = str2num(get(minBox, 'string'));
           max = str2num(get(maxBox, 'string'));
           colorRange = [min max];
           if length(colorRange) ~= 2
               colorRange = [];
           end
       elseif selectedRadio == symColorButton
           colorRange = 1;
       else
           colorRange = [];
       end
       if(get(txtCheckBox, 'value'))
           txtPath = get(txtPathBox, 'string');
           if ~exist(txtPath, 'dir')
               errordlg('designated folder does not exist, please re-enter');
               return
           end
       else
           txtPath = '';
       end
       close(fh);
    end
end