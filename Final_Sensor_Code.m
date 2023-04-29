clear all, close all, clc;

noisyECG = load('tylerexcecise.txt'); %loading in ECG data
plot(noisyECG)
xlabel('timesteps')
ylabel('millivolts')




% Remove trend from data
detrendedECG = detrend(noisyECG, 1);

%Visualize results, original ecg, detrended ecg, and the trend
clf
plot(noisyECG,'Color',[109 185 226]/255,'DisplayName','Input data') %raw
hold on

plot(detrendedECG,'Color',[0 114 189]/255,'LineWidth',1.5,'DisplayName','Detrended data') %detrended

plot(noisyECG-detrendedECG,'Color',[217 83 25]/255,'LineWidth',1,'DisplayName','Trend') %trend
hold off

legend
xlabel('timesteps')
ylabel('millivolts')




%Figuring out how long each timestep is
%the timed ECG data for this specific file that Oreva gave us a total of 7359 readings in 60 seconds
time_tot = 60; %seconds
steps_total = length(detrendedECG); %steps 
step_time = time_tot/steps_total; %.0082 seconds per step




% Find local maxima
ismax = islocalmax(detrendedECG,"MinProminence", .17); %Prominence takes a lot of values below a certain threshold out

%Get rid of values that are too close together - This is done specific for the inconsistensies seen in our ECG sensor
for i=1:length(ismax)
    if ismax(i) == 1
        ismax(i+1:(i+70)) = 0;
    end
end

% Visualize results of maxima
clf
plot(detrendedECG,'Color',[109 185 226]/255,'DisplayName','Input data')
hold on
% Plot local maxima
plot(find(ismax),detrendedECG(ismax),'^','Color',[217 83 25]/255,'MarkerFaceColor',[217 83 25]/255,'DisplayName','Local maxima')
title(['Number of extrema: ' num2str(nnz(ismax))])
hold off
legend
xlabel('timesteps')
ylabel('millivolts')



%% Static Data - averages



% 1/.0082 = 121.95122
heart_rate_steps_in_a_second = 1/step_time;

maxIndices = find(ismax); % the Indices correspond with a certain time depending on the sampling rate
stepsPerBeat = mean(diff(maxIndices));
avg_heartRate = 60*(heart_rate_steps_in_a_second/stepsPerBeat)


j=1;
for i=2:length(maxIndices)
    r_to_r(j) = maxIndices(i) - maxIndices(i-1);
    j = j + 1;
end



fix_rate = mean(diff(r_to_r));
for i=2:length(r_to_r)
    if (r_to_r(i-1) - r_to_r(i)) > (fix_rate+15) || (r_to_r(i-1) - r_to_r(i)) > (fix_rate-15) % if the difference between r peaks are much 
                                                                                              % greater/less than the mean difference between r_to_r peaks
                                                                                              % replace with the mean r_to_r difference
        r_to_r(1) = r_to_r(1) + (fix_rate)^2;
    else
        r_to_r(1) = r_to_r(1) + (r_to_r(i-1) - r_to_r(i))^2;
    end

end

avg_RMSSD = sqrt(r_to_r(1))




%% Dynamic Data


%Dynamic heart rate
stepper = round((length(maxIndices))/10);
dynamic_stepsPerBeat(stepper,1) = 0;
steps_in_10_seconds = round(heart_rate_steps_in_a_second*10);
k=1;
j=1;
for i = 1:length(maxIndices)
    if i <= k*stepper && i < length(maxIndices) - stepper
        dynamic_stepsPerBeat(k,1) = mean(diff(maxIndices(j:(stepper*k))));
        dynamic_heart_rate(1,k) = 60*(heart_rate_steps_in_a_second/dynamic_stepsPerBeat(k,1))
    else
        k = k+1;
        j = i;
    end

end



%Dynamic RMSSD - r_to_r waves
stepper = round((length(maxIndices))/10);
j=1;
k=1; %this variable is a multiplier
dynamic_r_to_r(stepper,10) = 0;
for i=2:length(maxIndices)

    if i <= k*stepper
        dynamic_r_to_r(j,k) = maxIndices(i) - maxIndices(i-1);
        j = j+1;
    else
        k = k+1;
        j=1;
    end

end


k=1;
j=1;
jj = 2;
%Getting the dynamic RMSSD
for i=2:length(maxIndices)
    if i <= k*stepper
        dynamic_r_to_r(1,k) = dynamic_r_to_r(j,k) + (dynamic_r_to_r(j+1,k) - dynamic_r_to_r(j,k))^2;
        %jj = jj+1;
        j = j+1;
    else
        %jj=2;
        j = 1;
        k = k+1;
    end

end

k=1;
for k=1:10 %final step take sqrt of every important value
    dynamic_RMSSD(1,k) = sqrt(dynamic_r_to_r(1,k))
    k = k+1;
end














