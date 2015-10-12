function [X Y] = calibrateSpeakers(unique_frequencies,unique_attenuations,speaker_calibration)

if isempty(speaker_calibration)
    [X Y] = meshgrid(unique_frequencies,unique_attenuations);
    Y = 100-Y;
else
    attenAdjustments = interp1(speaker_calibration(:,1),speaker_calibration(:,2),unique_frequencies);    
    [X Y] = meshgrid(unique_frequencies,unique_attenuations);
    adjustedAttens = zeros(size(Y));
    Y = 100-Y;
    for irow = 1:size(Y,1)
        adjustedAttens(irow,:) = Y(irow,:).*attenAdjustments';
%         adjustedAttens(irow,:) = attenAdjustments' - Y(irow,:);
    end
    Y=adjustedAttens;
end