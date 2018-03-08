function [amp, maxmep,minmep]=MEPamplitude_human(trace, moptions)
%function amp=MEPamplitude(trace, moptions)
%
%computes amplitude from motor evekod potential EMG signal (as evoked by
%TMS)
%
% amp   :   computed amplitude returned
% trace :   EMG traces, assuming TMS is at sample 1. Matrix with N rows of
%           data for multiple trials are also allowed (amp output above will then be
%           a Nx1 vector, 1 entry for each trial)
%
% moptions provides several options for computing amplitude:
%moptions.timewindow   :    vector [t1  t2] indicating time window (in 
%                           samples) in which to look for MEP response. 
%                           Signal outside of this scope is ignored. 
%                           In case this value is not provided, the entire
%                           range is used.


if ~isfield(moptions,'timewindow')
    moptions.timewindow=[1:length(trace)];
end

twin=moptions.timewindow(1):moptions.timewindow(2);

maxmep=zeros(size(trace,1),1);
minmep=zeros(size(maxmep));
amp=zeros(size(maxmep));


for trialcount=1:size(trace,1)
    maxmep(trialcount)=max(trace(trialcount,twin));
    minmep(trialcount)=min(trace(trialcount,twin));
    amp(trialcount)=maxmep(trialcount)-minmep(trialcount);
end