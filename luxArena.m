function luxArena(fileDirectory, numTrials, stimStart, trialFrequency, stimDuration, recordingDuration)
%   luxArena('C:\Users\Ginty Lab\Desktop\luxArena', 20, 5, 10, 1,20)
%   Pilot routine for video acquisition in open arena with timed
%   stimulation using the Neurolux system.

    FPS = 30;
    vid = videoinput('pointgrey', 1, 'F7_Mono8_1920x1200_Mode0');
    vid.FramesPerTrigger = recordingDuration * FPS;
    vid.LoggingMode = 'disk';
    s = daq.createSession('ni'); 
    ch = addDigitalChannel(s,'Dev3','Port0/Line0:0','OutputOnly');
    
    for i = 1:numTrials
        ITI = poissrnd(trialFrequency); 
        pause(ITI);
        % make new directory
        trialStr = strcat('trial', num2str(i));
        mkdir(fileDirectory, trialStr);
        diskLogger = VideoWriter(strcat(fileDirectory, filesep, trialStr, filesep, 'ms.avi'), 'Grayscale AVI');
        vid.DiskLogger = diskLogger;
        % start camera
        start(vid);
        % pause for baseline
        pause(stimStart);
        % output neurolux control pulse
        outputSingleScan(s,[1]);
        pause(stimDuration);
        outputSingleScan(s,[0]);
        pause(recordingDuration - stimStart);
    end
        
    s1.fileDirectory = fileDirectory;
    s1.numTrials = numTrials;
    s1.stimStart = stimStart;
    s1.trialFrequency = trialFrequency;
    s1.stimDuration = stimDuration;
    s1.recordingDuration = recordingDuration;
    save(strcat('s1_',datestr(now, 'yymmdd HHMM SS'),'.mat'), '-struct', 's1');    
end

