function diff = TuningCurveDifference(experiment_data, prefs, test1, test2)
% element-for-element difference of two tuning curves

%Amy Boyle Jan 2011
scale_colorbar = true;
testtype = prefs.diff_type;

    %get tuning curves
    [freqs, attenuations, data, classes, hands] = VisualizeTestData(experiment_data, prefs, [test1 test2], [1 0 0 1 0], [], [], []);
    
    for idata = 1:length(data)
        temp = data{idata};
        temp(temp < prefs.sptThresh) = 0;
        data{idata} = temp;
    end
    
    %find difference    
    switch testtype
        case 'diff'
            diff = abs(data{2} - data{1});
        case 'surround'
            controlData = data{1};
            controlIdx = data{1} > 0.5;
            
            diff = -data{2};
            
            diff(controlIdx) = controlData(controlIdx);
    end
   
    handles = hands;
    
    if scale_colorbar
%         max_spikes = max(max([data{1} data{2}]));
        max_spikes = max(max(diff));
        min_spikes = min(min(diff));
%         colorRange = [min_spikes max_spikes];
        maxcolor = max(max(abs(diff)));
        colorRange = [-maxcolor maxcolor];
    else
        colorRange = [];
    end
    plot_images = {};
    for ihandle = 1:length(handles)
        fig = get(handles(ihandle), 'parent');
        figname = get(fig, 'name');
        if ~isempty(strfind(figname, prefs.cell_id))
            figure(fig)
            SetColorbar('Mean spikes per presentation', colorRange)
            f = getframe(handles(ihandle));
            plot_images{end+1} = frame2im(f);
        end
    end
        
    %plot difference
    plot_loudness = 1;
    
    colorbar_label = 'Mean spikes per presentation difference';
    
    unique_frequencies = freqs{1};
    unique_attenuations = attenuations{1};
    test_data = diff;
    [X Y] = meshgrid(unique_frequencies,unique_attenuations);
    f = figure;
    c = contourf(X,Y,test_data');
    view(2);
    colormap(prefs.colormap);
    xlim([min(unique_frequencies) max(unique_frequencies)]);
    ylim([min(unique_attenuations) max(unique_attenuations)]);
    xlabel('Frequency (kHz)');
    ylabel('Intensity (dB SPL)');
    set(gca,'YDir','reverse');
    if length(unique_frequencies) <= 10
        set(gca,'XTick',unique_frequencies);
    end
    
    if length(unique_attenuations) <= 10
        set(gca,'YTick',unique_attenuations);
        if plot_loudness
            set(gca,'YTickLabel',num2str(100 - unique_attenuations));
        end
    end
    
    figureName = [prefs.cell_id num2str(test1) '_' num2str(test2) '_tuning_curve_difference'];
    set(f, 'name',  figureName);
    if exist('colorRange', 'var') && ~isempty(colorRange)
        SetColorBar(colorbar_label, colorRange);
    elseif strcmp(testtype,'diff')
        SetColorBar(colorbar_label,2);
    else
        SetColorBar(colorbar_label,1);
    end