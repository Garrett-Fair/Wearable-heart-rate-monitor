clear all, close all, clc;

S = load('noisyecg.mat');
noisyECG = S.noisyECG_withTrend;
plot(noisyECG)
xlabel('milliseconds')
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
xlabel('milliseconds')
ylabel('millivolts')




% Find local maxima
ismax = islocalmax(detrendedECG,'MinProminence',0.9);
% Visualize results
clf
plot(detrendedECG,'Color',[109 185 226]/255,'DisplayName','Input data')
hold on
% Plot local maxima
plot(find(ismax),detrendedECG(ismax),'^','Color',[217 83 25]/255,...
    'MarkerFaceColor',[217 83 25]/255,'DisplayName','Local maxima')
title(['Number of extrema: ' num2str(nnz(ismax))])
hold off
legend
xlabel('milliseconds')
ylabel('millivolts')




maxIndices = find(ismax) % the Indices correspond with a certain time depending on the sampling rate
msPerBeat = mean(diff(maxIndices));
heartRate = 60*(1000/msPerBeat)

j=1
for i=2:length(maxIndices)
    r_length(j) = maxIndices(i) - maxIndices(i-1)
    j = j + 1;
end







%now we want to group 30 seconds of rtor data into their own groups, average thier rmssd and see how it changes
















