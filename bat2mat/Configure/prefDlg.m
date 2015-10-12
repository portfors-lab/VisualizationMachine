function uPrefs = prefDlg(uPrefs)

import javax.swing.JScrollPane;
import javax.swing.JPanel;

headerLabels = {'Options used for speaker callibration and dB SPL normalization', 'Options for Spectrogram calculation', ...
    'Options for Spike Time calculation','Options for Spike Rate calculation', 'Options for spectrogram peak finding calculation',...
    'Options for model data generation', 'Options for Histogram generation', ...
    'Options for the calculation of the frequency intervals to integrate over', 'Options for VR metric calculation', ...
    'Options for Spike Train Filtering (Gaussian kernal)'};
txtLabels = {'dB SPL ref', 'dB range', 'dB max', 'dB Min', 'Model data dB min', 'spectrogram dB max', 'spectrogram dB min', ...
    'spectrogram abs scaling', 'spectrogram freq samples', 'spectrogram time samples', 'spectrogram window len', 'spike time filter cutoff', ...
    'spike time power exp', 'spike time peak threshold', 'spike time refractory period', 'spike rate sampling freq', 'spike rate cutoff freq',... 
    'no. harmonics','harmonic peak detection noise floor', 'freq cutoff ratio', 'model no. data rows per cell', 'model time samples', ...
    'model spectral integration', 'histogram bin width', 'max interval width', 'exponential decay', 'filtered exp sample freq',... 
    'filtered gaussian sample freq', 'filtered gaussian stdev'};

nlabels = length(txtLabels) + length(headerLabels) +3;

szy = (nlabels*25)+100;
szx = 450;
lblen = 225;
lbht = 20;
edlen = 150;
col1 = 10;
col2 = 250;

% bcolor = [0.8 0.8 0.8];
bcolor = [0.702 0.702 0.702];

fszy = min(szy, 550);
fh = figure('position', [100 100 szx fszy], 'menubar', 'none', 'toolbar', 'none', 'windowstyle', 'modal');

panel1 = uipanel('Parent',fh);
panel2 = uipanel('Parent',panel1);
set(panel1,'Position',[0 0 0.95 1]);
set(panel2,'Position',[0 -1 1 1]);

s = uicontrol('Style','Slider','Parent',fh,...
'Units','normalized','Position',[0.95 0 0.05 1],...
'Value',1,'Callback',{@slider_callback1,panel2});

% [jhandle2 panel2] = javacomponent('javax.swing.JPanel');
% scrollPane = JScrollPane(jhandle2);

% [jhandle hpane] = javacomponent(scrollPane, [0 0 szx fszy], fh);

% 
% % panel2 = JPanel;
% jhandle.setViewportView(panel2)

iheader = 1;
itxt = 1;

inputFields = fieldnames(uPrefs);
inputHandles=[];

uicontrol(panel2, 'style', 'text', 'position', [col1 ((nlabels-(iheader+itxt))*25)+50 450 30], 'string', 'Analysis Parameters', 'fontsize', 18,'backgroundcolor', bcolor);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Options used for speaker callibration and dB SPL normalization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
uicontrol(panel2, 'style', 'text', 'position', [col1 (nlabels-(iheader+itxt))*25 450 lbht], 'string', headerLabels{iheader}, 'backgroundcolor', bcolor); iheader = iheader + 1;

for i=1:7
    uicontrol(panel2, 'style', 'text', 'position', [col1 (nlabels-(iheader+itxt))*25 lblen lbht], 'string', txtLabels{itxt}, 'backgroundcolor', bcolor);
    inputHandles(itxt) = uicontrol(panel2, 'style', 'edit', 'position', [col2 (nlabels-(iheader+itxt))*25 edlen lbht], 'string', uPrefs.(inputFields{itxt}), 'backgroundcolor', bcolor); itxt = itxt + 1;
end
inputHandles(itxt) = uicontrol(panel2, 'style', 'checkbox', 'position', [col1 (nlabels-(iheader+itxt))*25 lblen lbht], 'string', txtLabels{itxt}, 'value', uPrefs.(inputFields{itxt}), 'backgroundcolor', bcolor); itxt = itxt + 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Options for Spectrogram calculation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
uicontrol(panel2, 'style', 'text', 'position', [col1 (nlabels-(iheader+itxt))*25 450 lbht], 'string', headerLabels{iheader}, 'backgroundcolor', bcolor); iheader = iheader + 1;

for i = 1:3
    uicontrol(panel2, 'style', 'text', 'position', [col1 (nlabels-(iheader+itxt))*25 lblen lbht], 'string', txtLabels{itxt}, 'backgroundcolor', bcolor);
    inputHandles(itxt) = uicontrol(panel2, 'style', 'edit', 'position', [col2 (nlabels-(iheader+itxt))*25 edlen lbht], 'string', uPrefs.(inputFields{itxt}), 'backgroundcolor', bcolor); itxt = itxt + 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Options for Spike Time calculation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
uicontrol(panel2, 'style', 'text', 'position', [col1 (nlabels-(iheader+itxt))*25 450 lbht], 'string', headerLabels{iheader}, 'backgroundcolor', bcolor); iheader = iheader + 1;

for i = 1:4
    uicontrol(panel2, 'style', 'text', 'position', [col1 (nlabels-(iheader+itxt))*25 lblen lbht], 'string', txtLabels{itxt}, 'backgroundcolor', bcolor);
    inputHandles(itxt) = uicontrol(panel2, 'style', 'edit', 'position', [col2 (nlabels-(iheader+itxt))*25 edlen lbht], 'string', uPrefs.(inputFields{itxt}), 'backgroundcolor', bcolor); itxt = itxt + 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Options for Spike Rate calculation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
uicontrol(panel2, 'style', 'text', 'position', [col1 (nlabels-(iheader+itxt))*25 450 lbht], 'string', headerLabels{iheader}, 'backgroundcolor', bcolor); iheader = iheader + 1;

for i = 1:2
    uicontrol(panel2, 'style', 'text', 'position', [col1 (nlabels-(iheader+itxt))*25 lblen lbht], 'string', txtLabels{itxt}, 'backgroundcolor', bcolor);
    inputHandles(itxt) = uicontrol(panel2, 'style', 'edit', 'position', [col2 (nlabels-(iheader+itxt))*25 edlen lbht], 'string', uPrefs.(inputFields{itxt}), 'backgroundcolor', bcolor); itxt = itxt + 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Options for spectrogram peak finding calculation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
uicontrol(panel2, 'style', 'text', 'position', [col1 (nlabels-(iheader+itxt))*25 450 lbht], 'string', headerLabels{iheader}, 'backgroundcolor', bcolor); iheader = iheader + 1;

for i = 1:3
    uicontrol(panel2, 'style', 'text', 'position', [col1 (nlabels-(iheader+itxt))*25 lblen lbht], 'string', txtLabels{itxt}, 'backgroundcolor', bcolor);
    inputHandles(itxt) = uicontrol(panel2, 'style', 'edit', 'position', [col2 (nlabels-(iheader+itxt))*25 edlen lbht], 'string', uPrefs.(inputFields{itxt}), 'backgroundcolor', bcolor); itxt = itxt + 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Options for model data generation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
uicontrol(panel2, 'style', 'text', 'position', [col1 (nlabels-(iheader+itxt))*25 450 lbht], 'string', headerLabels{iheader}, 'backgroundcolor', bcolor); iheader = iheader + 1;

for i = 1:3
    uicontrol(panel2, 'style', 'text', 'position', [col1 (nlabels-(iheader+itxt))*25 lblen lbht], 'string', txtLabels{itxt}, 'backgroundcolor', bcolor);
    inputHandles(itxt) = uicontrol(panel2, 'style', 'edit', 'position', [col2 (nlabels-(iheader+itxt))*25 edlen lbht], 'string', uPrefs.(inputFields{itxt}), 'backgroundcolor', bcolor); itxt = itxt + 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Options for Histogram generation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
uicontrol(panel2, 'style', 'text', 'position', [col1 (nlabels-(iheader+itxt))*25 450 lbht], 'string', headerLabels{iheader}, 'backgroundcolor', bcolor); iheader = iheader + 1;

for i = 1:1
    uicontrol(panel2, 'style', 'text', 'position', [col1 (nlabels-(iheader+itxt))*25 lblen lbht], 'string', txtLabels{itxt}, 'backgroundcolor', bcolor);
    inputHandles(itxt) = uicontrol(panel2, 'style', 'edit', 'position', [col2 (nlabels-(iheader+itxt))*25 edlen lbht], 'string', uPrefs.(inputFields{itxt}), 'backgroundcolor', bcolor); itxt = itxt + 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Options for the calculation of the frequency intervals to integrate over
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
uicontrol(panel2, 'style', 'text', 'position', [col1 (nlabels-(iheader+itxt))*25 450 lbht], 'string', headerLabels{iheader}, 'backgroundcolor', bcolor); iheader = iheader + 1;

for i = 1:1
    uicontrol(panel2, 'style', 'text', 'position', [col1 (nlabels-(iheader+itxt))*25 lblen lbht], 'string', txtLabels{itxt}, 'backgroundcolor', bcolor);
    inputHandles(itxt) = uicontrol(panel2, 'style', 'edit', 'position', [col2 (nlabels-(iheader+itxt))*25 edlen lbht], 'string', uPrefs.(inputFields{itxt}), 'backgroundcolor', bcolor); itxt = itxt + 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Options for VR metric calculation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
uicontrol(panel2, 'style', 'text', 'position', [col1 (nlabels-(iheader+itxt))*25 450 lbht], 'string', headerLabels{iheader}, 'backgroundcolor', bcolor); iheader = iheader + 1;

for i = 1:2
    uicontrol(panel2, 'style', 'text', 'position', [col1 (nlabels-(iheader+itxt))*25 lblen lbht], 'string', txtLabels{itxt}, 'backgroundcolor', bcolor);
    inputHandles(itxt) = uicontrol(panel2, 'style', 'edit', 'position', [col2 (nlabels-(iheader+itxt))*25 edlen lbht], 'string', uPrefs.(inputFields{itxt}), 'backgroundcolor', bcolor); itxt = itxt + 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Options for Spike Train Filtering (Gaussian kernal)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
uicontrol(panel2, 'style', 'text', 'position', [col1 (nlabels-(iheader+itxt))*25 450 lbht], 'string', headerLabels{iheader}, 'backgroundcolor', bcolor); iheader = iheader + 1;

for i = 1:2
    uicontrol(panel2, 'style', 'text', 'position', [col1 (nlabels-(iheader+itxt))*25 lblen lbht], 'string', txtLabels{itxt}, 'backgroundcolor', bcolor);
    inputHandles(itxt) = uicontrol(panel2, 'style', 'edit', 'position', [col2 (nlabels-(iheader+itxt))*25 edlen lbht], 'string', uPrefs.(inputFields{itxt}), 'backgroundcolor', bcolor); itxt = itxt +1;
end

uicontrol(panel2, 'style', 'pushbutton', 'position', [col1 (nlabels-(iheader+itxt+1))*25 edlen lbht], 'string', 'OK', 'callback', @okFun);
uicontrol(panel2, 'style', 'pushbutton', 'position', [col2 (nlabels-(iheader+itxt+1))*25 edlen lbht], 'string', 'Cancel', 'callback', 'close(gcf)');

uiwait(fh)

    function okFun(~,~)
        for iinput = 1:itxt-1
            if strcmp(get(inputHandles(iinput), 'style'),'edit')
                val = str2num(get(inputHandles(iinput), 'string'));
            else
                val = get(inputHandles(iinput), 'value');
            end
            if isempty(val)
                disp('warning: empty field input in analysis parameters, reverting')
            else
                uPrefs.(inputFields{iinput}) = val;
            end
        end
        close(fh)
    end

    function slider_callback1(src,eventdata,arg1)
        val = get(src,'Value');
        pos = get(arg1,'Position');
        set(arg1,'Position',[0 -val 1 1])
    end
end