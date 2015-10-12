function GenerateSynthFigures(signal, sampleRate, sectPoints, inputs)

    waitbar(0,'creating plots...');
    ntabs = length(inputs.values);
    
    
    %section of the signal for the current parameters
    if ntabs > 1
        for a = 1:ntabs
            if a == ntabs
                b=0;    %final section, include last point
            else
                b=1;    %minus 1 from section so no dulpicate points
            end                     
            trackModelParameters = inputs.values(a);
            sectSignal = signal(sectPoints(a):sectPoints(a+1)-b);
            segmented_EKFStateEstimates{a} = TrackHarmonicsEKF(sectSignal,sampleRate,trackModelParameters, inputs.values(1).nHarmonics,'smoother',true);
        end
        EKFStateEstimates = MergeEKFStateEstimates(segmented_EKFStateEstimates);
    else
        trackModelParameters = inputs.values;
        EKFStateEstimates = TrackHarmonicsEKF(signal,sampleRate,trackModelParameters, trackModelParameters.nHarmonics,'smoother',true);
    end
    
    duration = length(signal)/sampleRate;

    if trackModelParameters.frequencyMean*trackModelParameters.nHarmonics>sampleRate/2, warning('Sampling theorem violated.'); end;
  
    windowDuration = 70/trackModelParameters.frequencyMean;

    bools = inputs.bools;
    fn= fieldnames(bools);
    waitbar(1/(length(fn)+2));
    
%     EKFStateEstimates.Filtered.frequency = abs(EKFStateEstimates.Filtered.frequency)
%         EKFStateEstimates.Predicted.frequency = abs(EKFStateEstimates.Predicted.frequency)
%     EKFStateEstimates.Smoothed.frequency = abs(EKFStateEstimates.Smoothed.frequency)

    try
        
        [plotHandlesVect synthSignal] = PlotHarmonicStates(EKFStateEstimates,...
                           'spectrogramType',2, ...
                           'dbRange', trackModelParameters.dbRange, ...
                           'stateType', inputs.stateType,...
                           'trackedSignal',signal,...
                           'colormap', inputs.colormap,...
                           'windowDuration', inputs.windowDuration,...
                           'frequencyRange',trackModelParameters.frequencyRange,...
                           'plotSyntheticSpectrogram',bools.synSpec,...
                           'plotSyntheticSpectrogramHarmonics',bools.synSpecHarm,...
                           'plotSignalCompare',bools.signalComp,...
                           'plotAmplitudesAndPhases',bools.ampPhase,...
                           'plotSignalSpectrogram',bools.sigSpec,...
                           'plotSignalSpectrogramHarmonics',bools.sigSpecHarm,...
                           'plotResiduals',bools.plotRes,...
                           'windowlines', inputs.wlines);       
        
        ManipulateSynthFigures(plotHandlesVect, ntabs, inputs, EKFStateEstimates,signal)
    catch e %version 10
        errordlg({e.message;' '; 'Plotting error, try checking input values'}) %version 10
        %errordlg('Plotting error, try checking input values') %version 7
        rethrow(e)
    end
end