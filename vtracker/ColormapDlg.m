function [indx inv gain] = ColormapDlg(varargin)

indx = [];
inv= [];
gain =[];
bcolor = [0.8 0.8 0.8];

if mod(nargin,2)>0
    error('arguments must be in name value pairs')
end
for arg = 1:2:length(varargin)
    switch(lower(varargin{arg}))
        case 'liststring'
            listString = varargin{arg+1};
        case 'name'
            name = varargin{arg+1};
        case 'gain'
            gainIn = varargin{arg+1};
    end
end


dlgBox = figure('position', [300 250 185 225], 'resize', 'off', 'windowstyle', 'modal', 'name', name);
listBox = uicontrol(dlgBox, 'style', 'listbox', 'string', listString, 'position', [20 100 150 105]);
invertCheck = uicontrol(dlgBox, 'style', 'checkbox', 'string', 'invert colormap', 'position', [20 75 150 20], 'backgroundcolor', bcolor);

if exist('gainIn', 'var')
    uicontrol(dlgBox, 'style', 'text', 'string', 'Gain (%):', 'position', [20 45 75 20], 'backgroundcolor', bcolor);
    gainEdit = uicontrol(dlgBox, 'style', 'edit', 'string', gainIn, 'position', [85 45 45 20]);
end

uicontrol(dlgBox, 'style', 'pushbutton', 'position', [20 10 75 20], 'string', 'OK', 'callback', @okFun, 'max', 1, 'min', 1);
uicontrol(dlgBox, 'style', 'pushbutton', 'position', [100 10 75 20], 'string', 'Cancel', 'callback', 'close(gcf)' );

uiwait(dlgBox)

    function okFun(ho, evtd)
    indx = get(listBox, 'value');
    inv = get(invertCheck, 'value');
    if exist('gainIn', 'var')
        gain = str2double(get(gainEdit, 'string'));
    end
    close(dlgBox)
    end
end