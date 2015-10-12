function AddTabContextMenu(thisTab, varargin)
%adds a context menu to plots residing in tabs

%Amy Boyle  3/24/11
%          12/28/11

    saveplot=true;
    deleteplot=true;
    changecmap=true;
    changedb = true;
    
    %these two values are hard-coded constant(at least at the time this 
    %comment was written) througout application, does not affect data, 
    %only presentation.
    plotFreqSamples = 2^10;
    plotTimeSamples = 2^10;
    
    if ~isempty(varargin)
        if rem(length(varargin),2)~=0
           disp('optional Arguments to AddTabContextMenu must be in name value pairs');
           return
        end
        for indx=1:2:length(varargin)-1
            switch(lower(varargin{indx}))
                case 'saveplot'
                    saveplot=varargin{indx+1};
                case 'delete'
                    deleteplot=varargin{indx+1};
                case 'changecolormap'
                    changecmap=varargin{indx+1};
                case 'changedb'
                    changedb =varargin{indx+1};
                case 'inputs'
                    inputs = varargin{indx+1};   
                    dbRange = inputs.values(1).dbRange;
                case 'states'
                    stateEstimates = varargin{indx+1};
                    dbRange = stateEstimates.ModelParameters.dbRange;
                case 'signal'
                    signal = varargin{indx+1};
            end
        end
        
    end
    fig = gcf;
    
    %Must create a context menu object for each tab, if you only create
    %one and assign it to all, it gets deleted with the tab if you
    %delete the tab
    hTabGroup = get(thisTab, 'parent');
    cmenu = uicontextmenu;
    if saveplot
        uimenu(cmenu, 'label', 'save plot', 'callback', @saveTabbedPlot);
    end
    if deleteplot
        uimenu(cmenu, 'label', 'delete', 'callback', @removeTab);  
    end
    if changecmap
        uimenu(cmenu, 'label', 'change colormap', 'callback', @changeColormap);  
    end
    if changedb
        uimenu(cmenu, 'label', 'change dB gain', 'callback', @changeDbGain);  
    end
    
    %set the context menu to be used for saving each figure, must set
    %separately for all figure components, even objects within axes
    %like plot lines
    allComponents = findobj(thisTab);
    set(allComponents, 'uicontextmenu', cmenu);
        
    function saveTabbedPlot(hObj, evtData)
        %saves the figure in the current tab: creates a new figure, moves
        %the axes to it, saves, then moves the axes back to the tabs and
        %closes the figure.
        fileTypes = {'*.fig'; '*.jpg'; '*.tiff'; '*.pdf'; '*.png'}; 
        [fileName filePath filterIndex] = uiputfile(fileTypes);  
        if filterIndex ~= 0
            tabs = (get(hTabGroup, 'children'));
            selectedTab = tabs(get(hTabGroup, 'SelectedIndex'));
            cmap = get(gcf, 'colormap');
            saveFig = figure('visible', 'off');
            selectedAxes = get(selectedTab, 'children');
            set(selectedAxes, 'parent', saveFig); %move to new figure
            colormap(cmap)
            saveas(saveFig, [filePath fileName]); %save figure      
            set(selectedAxes, 'parent', selectedTab); %move back
            close(saveFig)
            %saveas function clears contextmenu, so must reset
            AddTabContextMenu(selectedTab);
        end
    end

    function removeTab(hObj, evtData)
        tabs = (get(hTabGroup, 'children'));
        selectedTab = tabs(get(hTabGroup, 'SelectedIndex'));
        delete(selectedTab);
    end

    function changeColormap(hObj, evtData)
        tabs = (get(hTabGroup, 'children'));
        selectedTab = tabs(get(hTabGroup, 'SelectedIndex'));
        selectedAxes = get(selectedTab, 'children');
        cmapList = {'jet', 'bone', 'hsv', 'hot', 'cool', 'gray'};
%         cmapIdx = find(strcmp(cmapList, inputs.colormap));
%         [cmapIdx, ok] = listdlg('liststring', cmapList, 'selectionmode', 'single', 'listsize', [150 105], 'name', 'Select colomap');
        [cmapIdx, invCmap] = ColormapDlg('liststring', cmapList,'name', 'Select Colormap');  
        if ~isempty(cmapIdx)
%             unfreezeColors
            if invCmap
                colormap(flipud(eval(cmapList{cmapIdx})));
            else
                colormap(cmapList{cmapIdx});
            end
%             for ax = selectedAxes'
%                 if strcmp(get(ax, 'tag'), 'Colorbar')
%                      cbfreeze(ax);
%                 else
%                    freezeColors(ax);              
%                 end
%             end     
        end
    end

    function changeDbGain(hObj, evtData)
        tabs = (get(hTabGroup, 'children'));
        selectedTab = tabs(get(hTabGroup, 'SelectedIndex'));
        name = get(selectedTab, 'title');
        dbRange = inputdlg('New Db range: ', 'Db Range', 1, {num2str(dbRange)});
        
        if ~isempty(dbRange)
            dbRange = str2num(dbRange{1});
            if exist('stateEstimates', 'var')
                boolFields = fieldnames(inputs.bools);
                for boolField = boolFields'
                    bools.(boolField{1}) = 0;
                end
                switch(lower(name))
                    case 'original signal'
                        bools.sigSpec = 1;
                        if inputs.bools.sigSpecHarm
                            bools.sigSpecHarm = 1;
                        end
                    case 'synthesized signal'
                        bools.synSpec = 1;
                        if inputs.bools.synSpecHarm
                            bools.synSpecHarm = 1;
                        end
                    case 'residuals'
                        bools.plotRes = 1;
                    case 'signal comparison'
                        bools.signalComp = 1;
                    case 'amplitudes and phases'
                        bools.ampPhase = 1;
                end

                [plotHandle, synthSignal] = PlotHarmonicStates(stateEstimates,...
                                   'spectrogramType',2, ...
                                   'dbRange', dbRange, ...
                                   'stateType', inputs.stateType,...
                                   'trackedSignal',signal,...
                                   'windowDuration', inputs.windowDuration,...
                                   'frequencyRange',stateEstimates.ModelParameters.frequencyRange,...
                                   'plotSyntheticSpectrogram',bools.synSpec,...
                                   'plotSyntheticSpectrogramHarmonics',bools.synSpecHarm,...
                                   'plotSignalCompare',bools.signalComp,...
                                   'plotAmplitudesAndPhases',bools.ampPhase,...
                                   'plotSignalSpectrogram',bools.sigSpec,...
                                   'plotSignalSpectrogramHarmonics',bools.sigSpecHarm,...
                                   'plotResiduals',bools.plotRes); 

            else
                [s, t ,f, specHandles] = NonparametricSpectrogram(signal, ...
                                                 inputs.sampleRate, ...
                                                 'nTimes',plotTimeSamples, ...
                                                 'nFrequencies',plotFreqSamples, ...
                                                 'windowDuration',inputs.windowDuration, ...
                                                 'plotType',1,...
                                                 'spectrogramType',2, ...
                                                 'dbRange', dbRange,...
                                                 'frequencyRange', inputs.values(1).frequencyRange, ...
                                                 'visible', 'off');
                title(specHandles.haSpectrogram,['Morphed Signal (' inputs.stateType ')'])
                plotHandle = specHandles.figure;
            end
            figure(fig)
            %delete old plot
            kids = get(selectedTab, 'children');
            delete(kids);
            %move over new plot to tab
            kids = get(plotHandle, 'children'); %all components from plot figure
            set(kids, 'parent', selectedTab) %place them on a tab
            %set context menu
            if exist('stateEstimates', 'var')
                AddTabContextMenu(selectedTab,'states', stateEstimates, 'inputs', inputs, 'signal', signal);
            else
                AddTabContextMenu(selectedTab,'inputs', inputs, 'signal', signal);
            end
            close(plotHandle);
        end
        
    end
end