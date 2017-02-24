SPECTRASCAN FUNCTIONS README

type as SpectraScanFunction.functions into MATLAB console if using this way

initiateScreen
 - this prints you out a list of steps you must do to allow spectrascan connection, the screen terminal needs to be attached for this game.
connect
 - once your screen terminal is ready to go, this initiates the remote mode connection on the spectrascan
echo
 - echos commands and measures to console - vital for logging
backlightOff
 - turns the backlight off - important in dark room
widenAperture
 - if measuring in mesopic conditions, want aperture to be wide.
aperture05Deg
 - this is normal, call this if you don't want the aperture to 1 deg
aperture025Deg
 - small aperture
normalSpeed
 - defult measuremnt speed
extendedMode
 - extended sensitivity - needed for dark connect
standardMode
 - call this instead if you don't want it on extended mode
luminance
 - measure the luminance
spectra
 - measure the spectra
checkMeasure
 - in automatic progression this queries the logfile every 10 seconds to see if a measurement has been made, if a measurment has been made, it allows the loop to progress to the next color
quitRemoteMode
 - when finished measuring, this is vital to safelt disconnect from teh spectrascan
exitScreen
 - this is important for exiting screen properly and saving the logfile. if this step is skipped and you run the script again, MATLAB might have trouble knowing which screen session to attach to
 - if screen fails to close, type into the bash terminal 'screen -ls' to find the session number
 - then type screen -X -S sessionnumber quit
