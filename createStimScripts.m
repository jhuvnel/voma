%% Create Chinchilla/Rhesus Stimulation Scripts Automatically
%  MRC 03/05/2018
%  Right now this is only functional for some static tilt settings,
%  but as needed I will add more to this script

%% Input Parameters wanted here
directory = 'R:\Monkey Single Unit Recording\Experiment Software and Necessities\Scripts and Configs\';
filename = '20200423_GiGi_ElectrodeCurrentScan';%'MoMoStim_AllPermutations_LearnStim'; %need to concat suffix

% For GiGi
% LP = 1, 2, 3
% LA = 4, 5, 6
% LH = 7, 8, 9
% Common Crus = 11
% Distal = 10
clear parameters

%% VOR Creation

stimList = [1 2 3 4 5 6 7 8 9];
refList = [10 11];
currentList = [20 50 100 150 200];
% baseline = 200;
phaseDur = [25 50 100 200 300 400 800];
phaseGap = [0 25 50 100 200 400 600];
% freq = 2; % DOUBLE CHECK
cycleNum = 20; % DOUBLE CHECK
% mod = 200;

count = 1;

% Monopolar
for i = 1:length(refList)
    for j = 1:length(stimList)
        for k = 1:length(currentList)
            for l = 1:length(phaseDur)
                for m = 1:length(phaseGap)
                    if stimList(j) ~= refList(i)
                        parameters(count).stimE = stimList(j);
                        parameters(count).refE = refList(i);
                        parameters(count).current = currentList(k);
                        parameters(count).phaseDur = phaseDur;
                        parameters(count).phaseGap = phaseGap;
                        parameters(count).baseline = baseline;
                        parameters(count).freq = freq;
                        parameters(count).modDelta = mod;
                        parameters(count).numCycles = cycleNum;
                        count = count + 1;
                    end
                end
            end
        end
    end
end


endOfMono = count-1;


% Bipolar LP
stimList = [1 2 3];
refList = [1 2 3];

for i = 1:length(refList)
    for j = 1:length(stimList)
        for k = 1:length(currentList)
            if stimList(j) ~= refList(i)
                parameters(count).stimE = stimList(j);
                parameters(count).refE = refList(i);
                parameters(count).current = currentList(k);
                parameters(count).phaseDur = phaseDur;
                parameters(count).phaseGap = phaseGap;
                parameters(count).baseline = baseline;
                parameters(count).freq = freq;
                parameters(count).modDelta = mod;
                parameters(count).numCycles = cycleNum;
                count = count + 1;
            end
        end
    end
end

endOfBipLP = count-1;

% Bipolar LA
stimList = [4 5 6];
refList = [4 5 6];

for i = 1:length(refList)
    for j = 1:length(stimList)
        for k = 1:length(currentList)
            if stimList(j) ~= refList(i)
                parameters(count).stimE = stimList(j);
                parameters(count).refE = refList(i);
                parameters(count).current = currentList(k);
                parameters(count).phaseDur = phaseDur;
                parameters(count).phaseGap = phaseGap;
                parameters(count).baseline = baseline;
                parameters(count).freq = freq;
                parameters(count).modDelta = mod;
                parameters(count).numCycles = cycleNum;
                count = count + 1;
            end
        end
    end
end

endOfBipLA = count-1;

% Bipolar LH
stimList = [7 8 9];
refList = [7 8 9];

for i = 1:length(refList)
    for j = 1:length(stimList)
        for k = 1:length(currentList)
            if stimList(j) ~= refList(i)
                parameters(count).stimE = stimList(j);
                parameters(count).refE = refList(i);
                parameters(count).current = currentList(k);
                parameters(count).phaseDur = phaseDur;
                parameters(count).phaseGap = phaseGap;
                parameters(count).baseline = baseline;
                parameters(count).freq = freq;
                parameters(count).modDelta = mod;
                parameters(count).numCycles = cycleNum;
                count = count + 1;
            end
        end
    end
end

endOfBipLH = count-1;


%% Script Creation - do not edit beyond this point

% Open the File and create Title
fileID = fopen(strcat(directory,strcat(filename,'_VOR.txt')),'wt');
fprintf(fileID,'%s\n','% Stim Script of GiGi Sinusoidal');
fprintf(fileID,'%s\n\n',char(strcat({'%Script Created '},datestr(datetime('today')))));

fprintf(fileID,'%s\n','keithley_init com32');
fprintf(fileID,'%s\n','teensy_open com33');
fprintf(fileID,'%s\n\n','pause');
fprintf(fileID,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n','%Command','StimDur_msec','StimGap_msec','StimRate_pps','NumPulseTrains','PhaseDur_usec','PhaseGap_usec','StimE','RefE','Amp_uA');
fprintf(fileID,'%s\t%s\t%s\t%s\n\n','%Command','SineFreq','DeltaPulseFreq','NSineCycles');


for i = 1:length(parameters)
    if i == 1
        fprintf(fileID,'%s\n\n','% Monopolar Stimulation');
    end
    if parameters(i).stimE < 4
        canal = '_LP';
    elseif parameters(i).stimE < 7
        canal = '_LA';
    else
        canal = '_LH';
    end
    fprintf(fileID,'%s\t%s%i%s%i%s%i%s%i%s%s\n','startrecording', 'stim', parameters(i).stimE,'ref',parameters(i).refE,'amp',parameters(i).current,'baseline',parameters(i).baseline,'_adaptation',canal);
    fprintf(fileID,'%s %i\n','delay_sec',3);
    fprintf(fileID,'%s\t%i\t%i\t%i\t%i\t%i\t%i\t%i\t%i\t%i\n','keithley_stim',1,1,0,1,parameters(i).phaseDur,parameters(i).phaseGap,parameters(i).stimE,parameters(i).refE,parameters(i).current);
    fprintf(fileID,'%s %i\n','baseline',parameters(i).baseline);
    fprintf(fileID,'%s\n','pause');
    fprintf(fileID,'%s\n\n%','stoprecording');
    fprintf(fileID,'%s\t%s%i%s%i%s%i%s%i%s%i%s%i%s%s\n','startrecording', 'stim', parameters(i).stimE,'ref',parameters(i).refE,'amp',parameters(i).current,'baseline',parameters(i).baseline,'freq',parameters(i).freq,'delta',parameters(i).modDelta,'_sinusoidal',canal);
    fprintf(fileID,'%s %i\n','delay_sec',3);
    fprintf(fileID,'%s\t%i\t%i\t%i\n','Sinemod',parameters(i).freq,parameters(i).modDelta,parameters(i).numCycles);
    fprintf(fileID,'%s %i\n','delay_sec',3);
    fprintf(fileID,'%s\n%','stoprecording');
    fprintf(fileID,'%s %i\n\n','delay_sec',2);
    if (i == length(parameters))|| (i == endOfMono) || (i == endOfBipLH) || (i == endOfBipLA) || (i == endOfBipLP) || (parameters(i).current == 200)
        fprintf(fileID,'%s\t%s%i%s%i%s%i%s%i%s%s\n','startrecording', 'stim', parameters(i).stimE,'ref',parameters(i).refE,'amp',parameters(i).current,'baseline',0,'_adaptation',canal);
        fprintf(fileID,'%s %i\n','baseline',0);
        fprintf(fileID,'%s %i\n\n','delay_sec',2);
        fprintf(fileID,'%s\n','pause');
        fprintf(fileID,'%s\n\n%','stoprecording');
        fprintf(fileID,'%s %i\n\n','delay_sec',2);
    end
    if i == endOfMono
        fprintf(fileID,'\n%s\n\n','% Bipolar Stimulation');
    end
    
end

fclose(fileID);