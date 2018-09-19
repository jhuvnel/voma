function [offset,mag,sinphase,cosphase,THD] = SingleFreqDFT(tt,data,freq)
% SingleFreqDFT(tt,dat,freq)
%   Uses single frequency trigonometric cosine series (Lathi: Signals,
%   Systems & Controls) to calc offset, mag & phase for best fit sine 
%   (not cosine!) using the trigonometric Fourier series defintion.
%   
%   tt=time vector with evenly spaced times of data points, in seconds, 
%      e.g. [0:1:100]' is for time 0 to 100 secs in 1 sec steps. 
%      tt can be either a column or row vector
%      NOTE: If the duration of tt is not exactly an integer multiple of 
%      (1/freq), i.e. the period of the sinusoid, data and tt are trimmed
%      and this routine ignores the last partial cycle of the data
%      NOTE: If only a subset of your data vector holds sinusoidal data,
%        plot it and use ginput() then find() to determine the indices of 
%        tt for which the data are sinusoidal. Fitting to the whole trace,
%        including the nonsinusoidal preamble and post-stimulus time, 
%        will give bad results.
%   dat = data points for those times; can be column or row vector
%   freq = frequency of the sinusoid you want to fit
%       Note that by calling this routine with fN=N*freq, you'd get the 
%       mag and phase of the Nth harmonic, the the THD would
%   offset = DC offset (i.e., the zeroth harmonic term in the series)
%   mag = magnitude of the best fit sinusoid (i.e., first harmonic)
%   phase = phase, in RADIANS, of best fit sinusoid (NOT cosinusoid.
%      phase=+pi/4 means a 45 degree phase lead re upward t=0 zero crossing
%   THD = total harmonic distortion = power in residual / power in data,
%      where residual = data - (offset + best fit sinusoid)
%
%   Background: Trigonometric Fourier Series for waveform f(t) is:
%   f(t) = c0 + sum for n=0 to inf of cn cos(n*2*pi*f0*t + phasen), where
%     c0=a0=mean of data averaged over an integer number of cycles
%     cn = sqrt (an*an + bn*bn) for n>0
%     an = (2/T) integral from to -> to+T of f(t)cos(n*2*pi*f*t)dt  for n>0
%     bn = (2/T) integral from to -> to+T of f(t)sin(n*2*pi*f*t)dt  for n>0
%     NOTE: T must be an integer multiple of sinusoid period (1/freq)

if (isrow(tt))
    tt=tt';
end %if
if (isrow(data))
    data=data';
end %if
dt=abs(tt(2)-tt(1));
% if sum(abs(tt(2:end)-tt(1:(end-1))-dt)) %confirm tt monotonic and dt=const
%     beep;beep;beep;
%     disp ('ERROR in SingleFreqDFT: tt must be monotonic, equal time steps');
%     offset=NaN;
%     sinmag=NaN;
%     sinphase=NaN;
%     THD=NaN;
% end %if
dataduration=abs(tt(end)-tt(1)); %in case tt(1)<>0
%ensure tt and data are exactly an integer number of (1/freq) period cycles
% excesstimebeyondNcycles= mod(dataduration,1/freq);
% if excesstimebeyondNcycles>0
%     beep;beep;beep;
%     disp ('ERROR in SingleFreqDFT: ignoring excess data beyond N cycles');
%     excesslength=floor(excesstimebeyondNcycles/dt)
%     tt=tt(1:(end-excesslength));
%     data=data(1:(end-excesslength));
%     dataduration=abs(tt(end)-tt(1));
% end%if

offset=mean(data);
a1=(2/dataduration)*sum(data.*cos(2*pi*freq*tt))*dt;
b1=(2/dataduration)*sum(data.*sin(2*pi*freq*tt))*dt;
mag=sqrt(a1*a1+b1*b1);
cosphase= -atan2(b1,a1);
%Lathi defines the trigonometric Fourier series using cosines; we want a
sinphase=cosphase+0.5*pi;% trig identity to get phse for sin output not cos
% THD is a signal power (really energy) goodness of fit metric, 
% similar to variance accounted for. THD=1 = terrible fit, 0 = perfect
sinfit=offset+mag*sin(2*pi*freq*tt+sinphase);
THD=sum((data-sinfit).^2)/sum((data).^2);
end%function
