clear all, close all, clc;

noisyECG = load('oreva_ECG_not_timed.log');
plot(noisyECG)
xlabel('timesteps')
ylabel('millivolts')

% Remove trend from data
detrendedECG = detrend(noisyECG,3);
% Visualize results
clf
plot(noisyECG,'Color',[109 185 226]/255,'DisplayName','Input data') 
hold on

plot(detrendedECG,'Color',[0 114 189]/255,'LineWidth',1.5,...
    'DisplayName','Detrended data')

plot(noisyECG-detrendedECG,'Color',[217 83 25]/255,'LineWidth',1,...
    'DisplayName','Trend')
hold off
legend
xlabel('timesteps')
ylabel('millivolts')







%Figuring out how long each timestep is
%the timed ECG data gave us a total of 7359 total points in 60 seconds
time_tot = 60; %seconds
steps_total = 5282; %steps 
%step_time = 60/7359; %.0082 seconds per step
step_time = .0082;


% Find local *maxima, ecg data is upside down, so local finding local min first
ismax = islocalmax(detrendedECG,"MinProminence", 0.1);



% 1/.0082 = 121.95122
heart_rate_steps_conversion = 1/step_time
maxIndices = find(ismax) % the Indices correspond with a certain time depending on the sampling rate
stepsPerBeat = mean(diff(maxIndices));
heartRate = 60*(heart_rate_steps_conversion/stepsPerBeat)