% Calibrating the BOLD screen using a SpectraScan PR670

% A McLean 2016
% requirements:
% SpectraScanFunctions in working directory
% Psychtoolbox added to path

%% close and clear all

clear; close all;
Screen('Preference', 'SkipSyncTests', 1);

%% Setup for automation vs manual

% your ideal/default settings are
% Connect = 1;
% AutomatedMeasures = 1;
% ClickThroughColours = 0;
% SecondsToExecute = 120;

% do you need to connect to the SpectraScan?
% 0 if already connected
Connect = 1;

% do you need to calibrate each colour?
% 0 if you want to initiate your own measuments, i.e if looking for a
% specific colour
% 1 if automatically measuring every colour
AutomatedMeasures = 1;

% time allowed for each measurement
% this method is outdated, as can query size of logfile,
% kept option JIC
SecondsToExecute = 120;

% do you want to manually click through the colours?
% 0 if automatically changing colour
% 1 if manually changing colour
ClickThroughColours = 0;

% time to get out of the room if leaving calibration to run atuomatically!
EscapeTime = 30;

%% Measure luminance or spectra
% the code can run three possibilities
% 1: primary colours & spectra
% 2: primary colours & luminance
% 3: experiment (stimuli) colours & luminance
% these two variables will be accordingly redefined later on
% no need to change them

measureLuminance = 1;
measureSpectra = 0;

%% Make cell to save luminance results
% spectra results will be copied outof logfile

LuminanceData = {};
LuminanceData2 = struct('stimuli_name',{},'stimuli',{},'luminance',{});

%% Define colours to test and calibration screen

sizeCalsteps = 10;
whichColours = input('primary colours? or experiment colours? (1/2)?');

%% primary colours

if whichColours == 1;
    steps = input ('run gamma correct (do steps)(0/1)?');
    
    TestCal = input ('test already run calibration (0/1)?');
    if TestCal == 1
        [filename, pathname] = ...
            uigetfile({'*.mat'},'File Selector', 'Choose Calibration File');
        load(fullfile(pathname,filename));
    end
    
    if steps;
        measureLuminance = 1;
        measureSpectra = 0;
    elseif ~steps;
        measureLuminance = 1;
        measureSpectra = 0;
    end
    colours = [255 0 0; 0 255 0; 0 0 255]; %;255 255 255; 0 0 0];
    colourNames = {'red' 'green' 'blue'}; %'white' 'black'};
    
    %% experiment stimuli colours
    
elseif whichColours == 2;
    steps = 0;  % this will never need to gamma correct
    measureLuminance = 1;
    measureSpectra = 0;
    
    %% define the colours by RGB values
    
    % experiment (stimuli) colours generated on a session basis
    colours = [127,127,128;135,167,72;120,88,183;153,153,153;102,102,102;145,113,208;110,142,47;127,127,128;133,157,86;122,98,169;147,147,147;108,108,108;141,117,188;114,138,67;127,127,128;131,147,100;124,108,155;140,140,140;115,115,115;136,120,168;119,135,87;];
        
    colourNames = {'background20' 'RodEqInc20' 'RodEqDec20' 'NotEqInc20' 'NotEqDec20' 'ConEqInc20' 'ConEqDec20'...
        'background15' 'RodEqInc15' 'RodEqDec15' 'NotEqInc15' 'NotEqDec15' 'ConEqInc15' 'ConEqDec15' ...
        'background10' 'RodEqInc10' 'RodEqDec10' 'NotEqInc10' 'NotEqDec10' 'ConEqInc10' 'ConEqDec10'};
end

%% SET UP SPECTRA SCAN

if Connect;
    SpectraScanFunctions.initiateScreen

    SpectraScanFunctions.connect

    SpectraScanFunctions.echo

    SpectraScanFunctions.backlightOff

    SpectraScanFunctions.extendedMode
    
    SpectraScanFunctions.widenAperture
    
    SpectraScanFunctions.normalSpeed
       
end

%% Setup orientation  screen

nCalDots = 9;
CalDotSize = 2/2; % cm
ds.SCREENYCM = 324/10; % Screen height in cm
ds.SCREENXCM = 518.4/10; % Screen width in cm
%ds.VIEWINGDISTANCE = 29; % In cm
% 0.27 mm

%% set up display and keyboard
ds.scrnNum = max(Screen('Screens'));

% CORNER SCREEN IF DEBUGGING
[ds.wPtr, ds.wRect]=Screen('OpenWindow', ds.scrnNum, [0 0 0], [0 0 400 250], [], [], 0);

%Second screen i.e BOLD screen
%[ds.wPtr, ds.wRect]=Screen('OpenWindow', ds.scrnNum, [0 0 0], [], [], [], 0);

ds.PIXPERCM = ds.wRect(3)/ds.SCREENXCM;
ds.MidX = ds.wRect(3)/2;
ds.MidY = ds.wRect(4)/2;

%kb = setupKeyboard;

%% draw orientation screen
CalDotSizePix = CalDotSize*ds.PIXPERCM;

% compute quadrants
XCompartments = ds.wRect(1):(1/sqrt(nCalDots))*ds.wRect(3):ds.wRect(3);
YCompartments = ds.wRect(2):(1/sqrt(nCalDots))*ds.wRect(4):ds.wRect(4);

% compute dot coords
XCoords = repmat((XCompartments(2:end)+XCompartments(1:end-1))/2,sqrt(nCalDots),1);
YCoords = repmat((YCompartments(2:end)+YCompartments(1:end-1))/2,sqrt(nCalDots),1)';
Coords = cat(3,XCoords,YCoords);

% compute circle edges
left = Coords(:,:,1)-CalDotSizePix;
up = Coords(:,:,2)-CalDotSizePix;
right = Coords(:,:,1)+CalDotSizePix;
bottom = Coords(:,:,2)+CalDotSizePix;
circLocs = [left(:) up(:) right(:) bottom(:)];

Screen(ds.wPtr,'FillRect', [255 255 255]);
for colour = 1:nCalDots
    Screen('FillOval',ds.wPtr,0,round(circLocs(colour,:)))
end
Screen('Flip', ds.wPtr);

%% Leave room

disp('Waiting for enter keypress');
pause
GetOut = sprintf('you have %s seconds now',EscapeTime);
disp('get out!');
WaitSecs(EscapeTime);

%% Loop through colours and do calibration

% This loop controls either
% 1: primary colours & spectra
% 3: experiment (stimuli) colours & luminance

if ~steps;
    for colour = 1:size(colours,1);
        
        fprintf('%s\n',colourNames{colour});
        disp(colours(colour,:));
        Screen(ds.wPtr,'FillRect', colours(colour,:));
        Screen('Flip', ds.wPtr);
        WaitSecs(1)
        
        %% AutomatedMeasures Spectra
        if AutomatedMeasures;
            if measureSpectra;
                
                % queue measure spectra
                SpectraScanFunctions.spectra
                
                % allow time for measurement
                if ~ClickThroughColours;
                    %WaitSecs(SecondsToExecute)
                    SpectraScanFunctions.checkMeasure
                elseif ClickThroughColours;
                    disp('Wait for measurement and then press enter');
                    pause;
                end
                
                % view logged output
                WaitSecs(3)
                [SysOut,outputSpectra] = system('tail -402 ~/screenlog.0');
                disp(outputSpectra)
                
            end
            
            %% AutomatedMeasures Luminance
            
            if measureLuminance;
                
                % queue measure luminance
                SpectraScanFunctions.luminance
                
                if ~ClickThroughColours;
                    %WaitSecs(SecondsToExecute);
                    SpectraScanFunctions.checkMeasure
                elseif ClickThroughColours;
                    disp('Waiting for measurement and then press enter');
                    pause;
                end
                
                % view log output
                WaitSecs(3)
                [SysOut,outputLuminance] = system('tail -2 ~/screenlog.0');
                disp(outputLuminance);
                
                % save readout in structure
                LuminanceData2(colour).luminance = outputLuminance;
                LuminanceData2(colour).stimuli = colours(colour,:);
                LuminanceData2(colour).stimuli_name = colourNames{colour};
                LuminanceData{colour,1} = colourNames{colour};
                LuminanceData{colour,2} = colours(colour,:);
                
                if strcmp(outputLuminance(1:5),'00000');
                    LuminanceData{colour,3} = 'No Error';
                else
                    LuminanceData{colour,3} = 'Error';
                end
                LuminanceData{colour,4} = sprintf(outputLuminance(9:17));
                
            end
        elseif ~AutomatedMeasures
            pause;
        end
    end
end


%% Loop through colours and do calibration

% 2: primary colours & luminance

Measurement=0;
if steps;
    disp('Stepping through primary colours');
    if TestCal == 1;
        for colour = 1:size(colours,1)-2;
            for colourStep = 1:length(Cal{colour}.newVoltagetoTest);
                Measurement=Measurement+1;
                Screen(ds.wPtr,'FillRect', (colours(colour,:)./255)*Cal{colour}.newVoltagetoTest(colourStep));
                RGBvalues = (colours(colour,:)./255)*Cal{colour}.newVoltagetoTest(colourStep);
                fprintf('%s\n',colourNames{colour});
                disp((colours(colour,:)./255)*Cal{colour}.newVoltagetoTest(colourStep));
                Screen('Flip', ds.wPtr);
                
                %% AutomatedMeasures Luminance
                if AutomatedMeasures;
                    
                    if measureLuminance;
                        
                        % queue measure luminance
                        SpectraScanFunctions.luminance
                        
                        if ~ClickThroughColours;
                            %WaitSecs(SecondsToExecute);
                            SpectraScanFunctions.checkMeasure
                        elseif ClickThroughColours;
                            disp('Waiting for measurement and then press enter');
                            pause;
                        end
                        
                        % view log output
                        WaitSecs(3)
                        [SysOut,outputLuminance] = system('tail -2 ~/screenlog.0');
                        disp(outputLuminance);
                        
                        % save readout in structure
                        LuminanceData2(Measurement).luminance = outputLuminance;
                        LuminanceData2(Measurement).stimuli = colours(colour,:);
                        LuminanceData2(Measurement).stimuli_name = colourNames{colour};
                        LuminanceData{Measurement,1} = colourNames{colour};
                        LuminanceData{Measurement,2} = RGBvalues;
                        
                        if strcmp(outputLuminance(1:5),'00000');
                            LuminanceData{Measurement,3} = 'No Error';
                        else
                            LuminanceData{Measurement,3} = 'Error';
                        end
                        LuminanceData{Measurement,4} = sprintf(outputLuminance(9:17));
                    end
                elseif ~AutomatedMeasures
                    pause;
                end
            end
        end
        
    elseif TestCal == 0;
        for colour = 1:size(colours,1);
            for colourStep = 1:sizeCalsteps+1
                Measurement = Measurement + 1;
                Screen(ds.wPtr,'FillRect', colours(colour,:)*(sizeCalsteps-(colourStep-1))./(sizeCalsteps));
                RGBvalues = colours(colour,:)*(sizeCalsteps-(colourStep-1))./(sizeCalsteps);
                fprintf('%s\n',colourNames{colour});
                disp(RGBvalues);
                Screen('Flip', ds.wPtr);
                
                
                %% AutomatedMeasures Luminance
                if AutomatedMeasures;
                    
                    if measureLuminance;
                        
                        % queue measure luminance
                        SpectraScanFunctions.luminance
                        
                        if ~ClickThroughColours;
                            %WaitSecs(SecondsToExecute);
                            SpectraScanFunctions.checkMeasure
                        elseif ClickThroughColours;
                            disp('Waiting for measurement and then press enter');
                            pause;
                        end
                        
                        % view log output
                        WaitSecs(3)
                        [SysOut,outputLuminance] = system('tail -2 ~/screenlog.0');
                        disp(outputLuminance);
                        
                        % save readout in structure
                        LuminanceData2(Measurement).luminance = outputLuminance;
                        LuminanceData2(Measurement).stimuli = colours(colour,:);
                        LuminanceData2(Measurement).stimuli_name = colourNames{colour};
                        LuminanceData{Measurement,1} = colourNames{colour};
                        LuminanceData{Measurement,2} = RGBvalues;
                        
                        if strcmp(outputLuminance(1:5),'00000');
                            LuminanceData{Measurement,3} = 'No Error';
                        else
                            LuminanceData{Measurement,3} = 'Error';
                        end
                        LuminanceData{Measurement,4} = sprintf(outputLuminance(9:17));
                    elseif ~AutomatedMeasures
                        pause;
                    end
                end
            end
        end
    end
end

%% clear screen

disp('calibration done!');
sca;

%% Disconnect (run this manually if it crashes)

if Connect;
    
    SpectraScanFunctions.quitRemoteMode
    SpectraScanFunctions.exitScreen
    
end

WaitSecs(2);

%% save luminance measures (run this manually if it crashes)

TIMESTAMP = strrep(strrep(datestr(now),' ',''),':','');
SaveLoc = sprintf('../Calibration_Data/Luminances%s',TIMESTAMP);
save(SaveLoc,'LuminanceData','LuminanceData2');