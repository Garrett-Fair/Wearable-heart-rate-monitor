clear all, close all, clc;

noisyECG = load('oreva_ECG_timed_60seconds');
plot(noisyECG)
xlabel('timesteps')
ylabel('millivolts')


% Remove trend from data
% detrendedECG = detrend(noisyECG, 5);
% 
% plot(detrendedECG,'Color',[217 83 25]/255,'LineWidth',1,'DisplayName','Trend') %plots the detrended ECG data
% legend
% xlabel('milliseconds')
% ylabel('millivolts')


% Remove trend from data
detrendedECG = detrend(noisyECG,5);
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