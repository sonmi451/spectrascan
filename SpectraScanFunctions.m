classdef SpectraScanFunctions
    
    % Calibrating with SpectraScan PR670
    % A McLean 2016
    % aishamclean451@gmail.com
    % These functions allow you to interface with the SpectraScan
    % in remote mode using GNU screen
    
    methods (Static)
        
        %% initiate screen session
        
        % Setting up remote mode in GNU screen requires some user input
        % these instructions will guide you through the first bit
        
        function [] = initiateScreen
            disp('1: plug in your SpectraScan to the computer via the USB cable!');
            pause;
            disp('2: open a bash terminal');
            pause;
            disp('3: type "ls /dev/cu.usbmodem*"into your terminal');
            disp('   you might need to keep unplugging/replugging the SpectraScan');
            disp('   and repeating this step');
            pause
            disp('4: once the SpectraScan has been found by the computer, type "screen -L /dev/cu.usbmodem*"');
            pause
            disp('5: do not type anything into this terminal anymore, you just need it open');
            pause
            disp('6: wait patiently for a few moments ...');
        end
        
        %% connect to SpectraScan
        
        % this initiates Remote mode on the SpectraScan
        
        function [] = connect
            commandP = sprintf('screen -X stuff ''P''');
            commandH = sprintf('screen -X stuff ''H''');
            commandO = sprintf('screen -X stuff ''O''');
            commandT = sprintf('screen -X stuff ''T''');
            commandReturn = sprintf('screen -X stuff ''%s''', char(hex2dec('0D')));
            system(eval('commandP'));
            WaitSecs(1);
            system(eval('commandH'));
            WaitSecs(1);
            system(eval('commandO'));
            WaitSecs(1);
            system(eval('commandT'));
            WaitSecs(1);
            system(eval('commandO'));
            WaitSecs(1);
            system(eval('commandReturn'));
            WaitSecs(1);
            disp('remote mode initiated');
            
        end
        
        %% set echo mode
        
        % This allows you to see the output on the console
        
        function [] = echo
            commandE = sprintf('screen -X stuff ''E''');
            commandReturn = sprintf('screen -X stuff ''%s''', char(hex2dec('0D')));
            system(eval('commandE'));
            WaitSecs(1);
            system(eval('commandReturn'));
            WaitSecs(1);
            disp('set echo mode on');
            
        end
        
        %% Turn backlight off
        
        % Turns off the backlongh of the SpectraScan
        
        function [] = backlightOff
            commandB = sprintf('screen -X stuff ''B''');
            commandReturn = sprintf('screen -X stuff ''%s''', char(hex2dec('0D')));
            system(eval('commandB'));
            WaitSecs(1);
            system(eval('commandReturn'));
            WaitSecs(1);
            disp('turned SpectraScan backlight off');
            
        end
        
        %% set aperture to 1 deg
        
        function [] = widenAperture
            commandF = sprintf('screen -X stuff ''F''');
            commandS = sprintf('screen -X stuff ''S''');
            command0 = sprintf('screen -X stuff ''0''');
            commandReturn = sprintf('screen -X stuff ''%s''', char(hex2dec('0D')));
            system(eval('commandS'));
            WaitSecs(1);
            system(eval('commandF'));
            WaitSecs(1);
            system(eval('command0'));
            WaitSecs(1);
            system(eval('commandReturn'));
            WaitSecs(1);
            disp('set SpectraScan aperture to 1 deg');
            
        end
        
        %% set aperture to 0.5 deg
        
        function [] = aperture05Deg
            commandF = sprintf('screen -X stuff ''F''');
            commandS = sprintf('screen -X stuff ''S''');
            command1 = sprintf('screen -X stuff ''1''');
            commandReturn = sprintf('screen -X stuff ''%s''', char(hex2dec('0D')));
            system(eval('commandS'));
            WaitSecs(1);
            system(eval('commandF'));
            WaitSecs(1);
            system(eval('command1'));
            WaitSecs(1);
            system(eval('commandReturn'));
            WaitSecs(1);
            disp('set SpectraScan aperture to 0.5 deg');
            
        end
        
        %% set aperture to 0.25 deg
        
        function [] = aperture025Deg
            commandF = sprintf('screen -X stuff ''F''');
            commandS = sprintf('screen -X stuff ''S''');
            command2 = sprintf('screen -X stuff ''2''');
            commandReturn = sprintf('screen -X stuff ''%s''', char(hex2dec('0D')));
            system(eval('commandS'));
            WaitSecs(1);
            system(eval('commandF'));
            WaitSecs(1);
            system(eval('command2'));
            WaitSecs(1);
            system(eval('commandReturn'));
            WaitSecs(1);
            disp('set SpectraScan aperture to 0.25 deg');
            
        end
        
        %% Turn on normal speed mode
        
        function [] = normalSpeed
            commandG = sprintf('screen -X stuff ''G''');
            commandS = sprintf('screen -X stuff ''S''');
            command0 = sprintf('screen -X stuff ''0''');
            commandReturn = sprintf('screen -X stuff ''%s''', char(hex2dec('0D')));
            system(eval('commandS'));
            WaitSecs(1);
            system(eval('commandG'));
            WaitSecs(1);
            system(eval('command0'));
            WaitSecs(1);
            system(eval('commandReturn'));
            WaitSecs(1);
            disp('turned SpectraScan onto normal speed mode');
            
        end
        
        %% Turn on extended sensitivity mode
        
        function [] = extendedMode
            commandH = sprintf('screen -X stuff ''H''');
            commandS = sprintf('screen -X stuff ''S''');
            command1 = sprintf('screen -X stuff ''1''');
            commandReturn = sprintf('screen -X stuff ''%s''', char(hex2dec('0D')));
            system(eval('commandS'));
            WaitSecs(1);
            system(eval('commandH'));
            WaitSecs(1);
            system(eval('command1'));
            WaitSecs(1);
            system(eval('commandReturn'));
            WaitSecs(1);
            disp('turned SpectraScan onto extended sensitivity mode');
            
        end
        
        %% Turn on standard sensitivity mode
        
        function [] = standardMode
            commandH = sprintf('screen -X stuff ''H''');
            commandS = sprintf('screen -X stuff ''S''');
            command0 = sprintf('screen -X stuff ''0''');
            commandReturn = sprintf('screen -X stuff ''%s''', char(hex2dec('0D')));
            system(eval('commandS'));
            WaitSecs(1);
            system(eval('commandH'));
            WaitSecs(1);
            system(eval('command0'));
            WaitSecs(1);
            system(eval('commandReturn'));
            WaitSecs(1);
            disp('turned SpectraScan onto standard sensitivty mode');
            
        end
        
        %% measure Luminance
        
        % make the system wait after shunting commands
        % to screen, otherwise log will update too early
        
        function [] = luminance
            commandM = sprintf('screen -X stuff ''M''');
            command1 = sprintf('screen -X stuff ''1''');
            commandReturn = sprintf('screen -X stuff ''%s''', char(hex2dec('0D')));
            system(eval('commandM'));
            WaitSecs(1);
            system(eval('command1'));
            WaitSecs(1);
            system(eval('commandReturn'));
            WaitSecs(5);
            disp('please wait: measuring luminance');
            
        end
        
        %% measure Spectra
        
        % make the system wait after shunting commands
        % to screen, otherwise log will update too early
        
        function [] = spectra
            commandM = sprintf('screen -X stuff ''M''');
            command5 = sprintf('screen -X stuff ''5''');
            commandReturn = sprintf('screen -X stuff ''%s''', char(hex2dec('0D')));
            system(eval('commandM'));
            WaitSecs(1);
            system(eval('command5'));
            WaitSecs(1);
            system(eval('commandReturn'));
            WaitSecs(5);
            disp('please wait: measuring spectra');
            
        end
        
        %% query logfile
        
        % query when the logfile was last updated in order to determine
        % if a measure has been taken.
        % ALT QUERY to find numlines
        % cat ~/screenlog.0 | wc -l
        
        function [] = checkMeasure
            WaitSecs(2);
            screenlog1 = dir('~/screenlog.0');
            screenlogEdit1 = screenlog1.date;
            screenlogEdit2 = screenlogEdit1;
            
            while screenlogEdit2 <= screenlogEdit1;
                disp('Waiting for measure...');
                WaitSecs(10);
                screenlog2 = dir('~/screenlog.0');
                screenlogEdit2 = screenlog2.date;
            end
        end
        
        %% some notes on quitting
        
        % the spectroradiometer needs to be quit first out of remote mode
        % before you close the screen terminal because otherwise it will
        % think it is still in remote mode when you try to reconnect and it
        % will not allow you to initiate remote mode.
        
        % if you have accidentaly not closed a screen session like Tessa by
        % clicking the relevant terminal away rathter than closing screen specifically or any
        % other reason for not doing that, you can't use screen commands
        % because you will have two sessions open and need to specify which
        % one.
        % you need to close one session by typing: screen -X -S 3272 quit
        % (obvs replacing numbers with correct session number)
        
        %% exit the SpectraScan
        
        % this exits remote mode from the SpectraScan
        
        function [] = quitRemoteMode
            commandQ = sprintf('screen -X stuff ''Q''');
            commandReturn = sprintf('screen -X stuff ''%s''', char(hex2dec('0D')));
            system(eval('commandQ'));
            WaitSecs(1);
            system(eval('commandReturn'));
            WaitSecs(1);
            disp('quit remote mode');
        end
        
        %% close screen and save logfile
        
        % this exits the screen session and saves the logfile with a
        % timestamp
        
        function [] = exitScreen
            system('screen -X quit');
            TIMESTAMP = strrep(strrep(datestr(now),' ',''),':','');
            ToSave = sprintf('mv ~/screenlog.0 ~/BOLDscreenCalibration%s.txt',TIMESTAMP);
            system(ToSave);
            sprintf('Renamed logfile to BOLDscreenCalibration%s.txt',TIMESTAMP')
        end
        
    end
end