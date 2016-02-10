%%  About
%   Script:        Class_D_Amp_Control
%   Author(s):     Eric Bauer
%   Date:          2/10/2016
%   Description:   This script enumerates all variables used in the
%                  simulation of a Class D amplifier
%                  
%                  This script also controls the simulink execution and
%                  displays the results.

%%  Variable Definitions
clear, close all
% Carrier Wave Characteristics - Symmetric Triangle Wave
f_tri = 100e3; % frequency of the +1 to -1 triangle wave
Ktri = 1; % gain on the triangle wave
% Input Characteristics
DC = 0; % DC bias on sine wave
A = .5; % Amplitude of the sine wave
f_input = 10e3; % frequency of input AC component
% Gain & Filtering Characteristics
Kamp = 5; % Signal gain through amplifier
f3dB = 22000; % cut off frequency of low pass filter
zeta = 1; % damping coefficient (critically damped = 1)
L = 1e-3; % Low pass (series) inductance
C = (1/(2*pi*f3dB)^2)*(1/L); % Low pass (parallel) capacitance
R = zeta/pi*sqrt(L/C); % damping resistance


%%  Simulink Control
open('Class_D_Amp.slx');
sim('Class_D_Amp.slx');

%%  Simulink Results - Processing
% retrieve signals from simout block
t = simout.time; % time in seconds
input = simout.signals.values(:,1); % modulating waveform
carrier = simout.signals.values(:,2); % carrier waveform
PWM = simout.signals.values(:,3); % PWM waveform
PWM_Amp = simout.signals.values(:,4); % amplified PWM waveform
output = simout.signals.values(:,5); % class D amplifier output

% find all values for N periods of the input signal
N = 3; % number of periods to plot
t_search = find(t<=2*N/f_input);
t = t(t_search);
input = input(t_search);
carrier = carrier(t_search);
PWM = PWM(t_search);
PWM_Amp = PWM_Amp(t_search);
output = output(t_search);


%%  Simulink Results - Plotting
conditionStr = [' (Input = ',num2str(A),'*sin(2\pi*',num2str(f_input),'*t)+',num2str(DC),')'];
subplot(3,1,1);
plot(t, input, 'r', t, carrier, 'b');
title(strcat('Input & Carrier vs. Time',conditionStr));
xlabel('time (seconds)');
ylabel('Amplitude');
%axis ([xmin xmax ymin ymax]);
legend('input','carrier')
subplot(3,1,2);
plot(t, PWM, 'r', t, PWM_Amp, 'b');
title(strcat('PWM & Amplified PWM vs. Time',conditionStr));
xlabel('time (seconds)');
ylabel('Amplitude');
%axis ([xmin xmax ymin ymax]);
legend('PWM','Amplified')
subplot(3,1,3);
plot(t, input, 'r', t, output, 'b');
title(strcat('Input & Output vs. Time',conditionStr));
xlabel('time (seconds)');
ylabel('Amplitude');
%axis ([xmin xmax ymin ymax]);
legend('input','output')
