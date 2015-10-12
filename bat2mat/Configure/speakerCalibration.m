function calData = speakerCalibration(calPath)
%     [calFile calPath]= uigetfile('*.*');
    if exist(calPath, 'file')
        calData = importdata(calPath);
        if ~isempty(calData)
            calData = calData.data; %get numerical data
            calData = calData(:,1:2); %get first two columns only (fundamental)
            calData(:,2) = calData(:,2)/100; %percentage
        else
            WriteStatus('Cannot load calibration data file', err)
        end
    else
        calData=[];
    end
end
