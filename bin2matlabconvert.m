% [Data]=bin2matlabconvert(FileName,DAQFs)
% 
% Title: bin2matlabconvert
%
% Function: Converts the binary dumps for the laser experiments. This is
% done by importing Laser, Velocity, and Trigger Spike Time binary dump. The Spike
% Rate is calculated by the Spike Times and upsampled to the sampling rate
% of the Laser trace. These files are then combined into one data structure
% and saved.
%
%
% Assumptions:
%   - This routine was originally created in Oct 2002 to input and save the
%   bin-dumps from Spike2 into Matlab. The work being done used three
%   traces : 
%               - "Laser": The laser trigger
%               - "Velocity": The chair velocity from the chair motor
%               - "Trigger": The spike times as calculated from the Mentor
%               Spike Discriminator
%
%   - This routine assumes you are trying to convert ALL of these
%   values for a particular base file (see: 'FileName' under 'Input
%   Parameters' for base filename details.)
%
%   
%
% Input Parameters: 
%
%   - 'FileName': This is a string containing the BASE file name needed to
%                 be analysed. For example, if the files are: 'Data1_Las'
%                 and 'Data1_Tri', the input for this parameter would be
%                 'Data1'
%   - 'DAQFs':    This is the sampling rate for the Laser binary trace.
%
% Output Parameters:
%   - 'Data':     Data structure containing the following parameters:
%                       - 'ST':    Array of spike times
%                       - 'SR':    Array of instantanous spike rate at each
%                                  spike time
%                       - 'Laser': Array of values representing the laser
%                                  trace for the sampled time interval (as 
%                                  determined
%                                  by 'DAQFs' above.
%                       - 'Vel':   Array of velocity data points
%                       - 't':     Sampled time interval
%                       - 'SRup':  Upsampled array of spike rate trace
%
%
%  By Peter J. Boutros (October 2012)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Data]=bin2matlabconvert(FileName,DAQFs)

% (!!) NOTE the function 'cell2str' and 'cell2char' are not inherent MATLAB functions. 
% They were found online in the 'MatlabCentral' database:
% cell2str = (http://www.mathworks.com/matlabcentral/fileexchange/23229-cell2str)
% cell2char = (http://www.mathworks.com/matlabcentral/fileexchange/27910)

% Load laser trigger


    filename = cell2char(strcat(FileName,'_Las'));
    fid = fopen(filename, 'r');
    Laser = fread(fid,'double')';
    fclose(fid);


% Load velocity


    filename = cell2char(strcat(FileName,'_Vel')); 
    fid = fopen(filename, 'r');
    Vel = fread(fid,'double')'; % This transpose is used in order to have all vectors in terms of '1xlength'
    fclose(fid);



% Load spike time points


    filename = cell2char(strcat(FileName,'_Tri')); 
    fid = fopen(filename, 'r');
    ST = fread(fid,'double')'; % This transpose is used in order to have all vectors in terms of '1xlength'
    fclose(fid);


% Calc spike rate

SR = 1./diff(ST);

% Assign each value to the midpoint btwn each ST
for i=1:(length(ST)-1)
    SR_t(i)=(ST(i+1)+ST(i))/2;
end

% Time axis for the specified sampling rate
t=(1/DAQFs:1/DAQFs:length(Laser)/DAQFs);

% Interpolate the spike rate vector. We need to have both 'SR' and 'Laser'
% on the same sampled time scale

SRup= interp1(SR_t,SR,t);

% Smooth the laser and spike rate data





% Code to extract the time points of the laser stimulus

mask=zeros(1,length(Laser));

for i=1:length(Laser)
    if Laser(i)>=25
        mask(i)=1;
    end
end

a=find(mask);

delay=0.5*2000;



for r=1:(length(a)-1)
    if (a(r+1)-a(r))<delay
        mask(a(r):a(r+1))=1;
    end
    

end

b=find(mask==0);
stim=[];
count=0;
for r=1:(length(b)-1)

    if (b(r+1)-b(r))>delay
        count=count+1;
        stim=[stim ; b(r),b(r+1)];
    end 
    
    
end




% Storing parameters
file=cell2str(FileName);
Data.Name=file;
Data.ST=ST;
Data.SR=SR;
Data.SR_t=SR_t;
Data.SRup=SRup;
Data.Laser=Laser;
Data.Vel=Vel;
Data.t=t;
Data.stimtime=stim;
Data.mask=mask;



%save(strcat(file,'.mat'),'Data')

end


