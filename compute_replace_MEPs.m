defines

if ~thisismatlab  %load the required octave packages
   pkg load control
   pkg load signal
end
%load(fullfile(DataPath,'data'));  %load scirun export from Petar
%load(fullfile(DataPath,'emg_traces'));  %load scirun export from Petar

subsel=[1:7];
exptlist={'cross','grid_ort','grid_par'};

fc1 = 400; % Lowpass pass filter cutoff frequency
fs = 20000; % Sampling frequency EMG
[b,a]=butter(3,fc1/(fs/2)); %define lowpass butterworth filter
mopt.timewindow=[200 800];

for tsub=1:length(subsel),
    subj=subsel(tsub);
    
        for texp=1:length(exptlist)    %check all the combinatorics

          switch (texp) %select real MEPs for the current experiment
             case 1
                 MEPamp_ns=data(subj).cross.MEP;
                 emgtraces=traces(subj).cross;
                 emgtracesf=filtfilt(b,a,emgtraces')'; %filter it
                 MEPamp_ours=MEPamplitude_human(emgtracesf,mopt);
                 data(subj).cross.MEP_ours=MEPamp_ours';
             case 2
                 MEPamp_ns=data(subj).grid_ort.MEP;
                 emgtraces=traces(subj).grid_ort;
                 emgtracesf=filtfilt(b,a,emgtraces')'; %filter it
                 MEPamp_ours=MEPamplitude_human(emgtracesf,mopt);
                 data(subj).grid_ort.MEP_ours=MEPamp_ours';
             case 3
                 MEPamp_ns=data(subj).grid_par.MEP;
                 emgtraces=traces(subj).grid_par;
                 emgtracesf=filtfilt(b,a,emgtraces')'; %filter it
                 MEPamp_ours=MEPamplitude_human(emgtracesf,mopt);
                 data(subj).grid_par.MEP_ours=MEPamp_ours';
          end
%           subplot(3,1,1);
%           plot(emgtraces');
%           title([exptlist(texp),',',sprintf('subj %i',tsub)]);
%           subplot(3,1,2);
%           plot(emgtracesf');
%           subplot(3,1,3);
%           plot(MEPamp_ns,MEPamp_ours,'x');
%           s=input('key');
        end
end
