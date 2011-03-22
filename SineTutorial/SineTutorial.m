%------------------------------------------------------------------------
% SineTutorial.m
%------------------------------------------------------------------------
% 
% script to demonstrate TDT input and output
% 
%------------------------------------------------------------------------

%------------------------------------------------------------------------
% Sharad J. Shanbhag
% sharad.shanbhag@einstein.yu.edu
%------------------------------------------------------------------------
% Created: 22 March, 2010 (SJS)
%
% Revisions:
%------------------------------------------------------------------------


% first, setup TDT device interface options.
iodev.C = [];
iodev.Circuit_Path = 'H:\Code\TytoLogy\working\SineTutorial';
iodev.Circuit_Name = 'SineTutorial';
iodev.Dnum = 2;
iodev.status = 0;

% then initialize the device
% Initialize RX8 device 1
tmpdev = RX8init('GB', iodev.Dnum);
iodev.C = tmpdev.C;
iodev.handle = tmpdev.handle;
iodev.status = tmpdev.status;

% set up zBUS interface
zBUS.C = [];
zBUS.status = 0;
% initialize zBUS
tmpdev = zBUSinit('GB');
zBUS.C = tmpdev.C;
zBUS.handle = tmpdev.handle;
zBUS.status = tmpdev.status;

%Set zBUS trigger A and B to LO
zBUStrigA_OFF(zBUS, 0, 8);
zBUStrigB_OFF(zBUS, 0, 8);

% load the circuit
iodev.rploadstatus = RPload(iodev);

% run the circuit
iodev.status = RPrun(iodev);

% get the tags and values for the circuit
tmptags = RPtagnames(iodev);
iodev.TagName = tmptags;

% get the sampling rate
iodev.Fs = RPsamplefreq(iodev);

% wait for user input
input('Press key to start I/O...')

% Set the tone frequency
disp('Setting tone frequency to 10 Hz')
RPsettag(iodev, 'Frequency', 10);

% send zBUS trigger A pulse to start output and input
zBUStrigA_PULSE(zBUS, 0, 8);

% pause for a second
pause(2);

% send zBUS trigger B pulse to end output and input
zBUStrigB_PULSE(zBUS, 0, 8);

% read the number of clock cycles
clockTime = RPgettag(iodev, 'mClock')

% get the number of points read
index1 = RPgettag(iodev, 'InputIndex');

% read in data vector
data1 = RPreadV(iodev, 'InputData', index, 0);






% Set the tone frequency
disp('Setting tone frequency to 20 Hz')
RPsettag(iodev, 'Frequency', 20);

% reset the buffer
RPtrig(iodev, 1);

% send zBUS trigger A pulse to start output and input
zBUStrigA_PULSE(zBUS, 0, 8);

% pause for a second
pause(2);

% send zBUS trigger B pulse to end output and input
zBUStrigB_PULSE(zBUS, 0, 8);

% read the number of clock cycles
clockTime = RPgettag(iodev, 'mClock')

% get the number of points read
index2 = RPgettag(iodev, 'InputIndex');

% read in data vector
data2 = RPreadV(iodev, 'InputData', index, 0);




% close the RP device
iodev.status = RPclose(iodev);

% close the zBUS device
zBUS.status = zBUSclose(zBUS);


% plot the data
figure
subplot(211)
plot( (0:index-1)./iodev.Fs, data1)
xlabel('time (seconds)')
ylabel('Volts')
title('data1')

subplot(212)
plot( (0:index-1)./iodev.Fs, data2)
xlabel('time (seconds)')
ylabel('Volts')
title('data2')
