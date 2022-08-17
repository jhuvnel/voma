function [Data_QPR] = coil_seg__qpr_data_convert(Fs,Stimulus,Stim_t,stim_ind,Data_LE_Pos_X,Data_LE_Pos_Y,Data_LE_Pos_Z,Data_RE_Pos_X,Data_RE_Pos_Y,Data_RE_Pos_Z,Data_LE_Vel_X,Data_LE_Vel_Y,Data_LE_Vel_LARP,Data_LE_Vel_RALP,Data_LE_Vel_Z,Data_RE_Vel_X,Data_RE_Vel_Y,Data_RE_Vel_LARP,Data_RE_Vel_RALP,Data_RE_Vel_Z,Eye_t,Filenames,Parameters,RawFileName)

% Note: the 'RawFileName' variable is optional. For data coming from the
% MVI clinical trial Lab. Dev. VOG system, data files are given a simple 
% name which singals the DATE and TIME the file was created on. After the 
% is segmented, it is often given a more accurate description. We would
% like to still save that file name with all future analysis files.
if exist('RawFileName','var')
    rawfilename_flag = true;
else
    rawfilename_flag = false;
end

% Determine the number of elements in the data arrays
num = length(Data_LE_Pos_X);


% If the user did not input a parameter vector, just assign one
% parameter value to the filename and make the rest empty
if nargin<23

    for k = 1:num
        Parameters(k).Stim_Info.Stim_Type = Filenames{k};
        Parameters(k).Stim_Info.ModCanal = {''};
        Parameters(k).Stim_Info.Freq = {''};
        Parameters(k).Stim_Info.Max_Vel = {''};
        Parameters(k).Stim_Info.Phase = {''};
        Parameters(k).Stim_Info.Cycles = {''};
        Parameters(k).Stim_Info.PhaseDir = {''};
        Parameters(k).Stim_Info.Notes = {''};
        Parameters(k).Mapping.Type = {''};
        Parameters(k).Mapping.Compression = {''};
        Parameters(k).Mapping.Max_PR = {''};
        Parameters(k).Mapping.Baseline = {''};
    end
end
% Check if only one Fs value was used as an input. If so, assume all
% files use the same sampling rate.
if length(Fs) == 1
    if ~iscell(Fs{1})
        Fs = {Fs};
    end
    Fs = repmat(Fs,1,num);
else
end


% Load and format all data.
for k=1:num
    Data_QPR(k).name = Filenames{k};
    Data_QPR(k).VOMA_data.Fs = Fs{k};
    % Stimulus Data
    Data_QPR(k).VOMA_data.Stim_Trace = Stimulus{k};%All stim traces lrz;
    Data_QPR(k).VOMA_data.Stim_t = Stim_t{k};
    Data_QPR(k).VOMA_data.stim_ind = stim_ind{k};
    % Eye Data
    Data_QPR(k).VOMA_data.Eye_t = Eye_t{k};
    % Position
    % Left Eye
    Data_QPR(k).VOMA_data.Data_LE_Pos_X = Data_LE_Pos_X{k};
    Data_QPR(k).VOMA_data.Data_LE_Pos_Y = Data_LE_Pos_Y{k};
    Data_QPR(k).VOMA_data.Data_LE_Pos_Z = Data_LE_Pos_Z{k};
    % Right Eye
    Data_QPR(k).VOMA_data.Data_RE_Pos_X = Data_RE_Pos_X{k};
    Data_QPR(k).VOMA_data.Data_RE_Pos_Y = Data_RE_Pos_Y{k};
    Data_QPR(k).VOMA_data.Data_RE_Pos_Z = Data_RE_Pos_Z{k};
    % Velocity
    % Left Eye
    Data_QPR(k).VOMA_data.Data_LE_Vel_X = Data_LE_Vel_X{k};
    Data_QPR(k).VOMA_data.Data_LE_Vel_Y = Data_LE_Vel_Y{k};    
    Data_QPR(k).VOMA_data.Data_LE_Vel_LARP = Data_LE_Vel_LARP{k};
    Data_QPR(k).VOMA_data.Data_LE_Vel_RALP = Data_LE_Vel_RALP{k};
    Data_QPR(k).VOMA_data.Data_LE_Vel_Z = Data_LE_Vel_Z{k};
    % Right Eye
    Data_QPR(k).VOMA_data.Data_RE_Vel_X = Data_RE_Vel_X{k};
    Data_QPR(k).VOMA_data.Data_RE_Vel_Y = Data_RE_Vel_Y{k};    
    Data_QPR(k).VOMA_data.Data_RE_Vel_LARP = Data_RE_Vel_LARP{k};
    Data_QPR(k).VOMA_data.Data_RE_Vel_RALP = Data_RE_Vel_RALP{k};
    Data_QPR(k).VOMA_data.Data_RE_Vel_Z = Data_RE_Vel_Z{k};
    % Experiment Info

    Data_QPR(k).VOMA_data.Parameters.Stim_Info.Stim_Type = Filenames(k);
    Data_QPR(k).VOMA_data.Parameters.Stim_Info.ModCanal = Parameters.Stim_Info.ModCanal(k);
    Data_QPR(k).VOMA_data.Parameters.Stim_Info.Freq = Parameters.Stim_Info.Freq(k);
    Data_QPR(k).VOMA_data.Parameters.Stim_Info.Max_Vel = Parameters.Stim_Info.Max_Vel(k);
    Data_QPR(k).VOMA_data.Parameters.Stim_Info.Cycles = Parameters.Stim_Info.Cycles(k);
    Data_QPR(k).VOMA_data.Parameters.Stim_Info.Notes = Parameters.Stim_Info.Notes{k};
    Data_QPR(k).VOMA_data.Parameters.Stim_Info.Seg_Directory = Parameters.Stim_Info.Seg_Directory{k};
    Data_QPR(k).VOMA_data.Parameters.Mapping.Type = Parameters.Mapping.Type{k};
    Data_QPR(k).VOMA_data.Parameters.Mapping.Compression = Parameters.Mapping.Compression{k};
    Data_QPR(k).VOMA_data.Parameters.Mapping.Max_PR = Parameters.Mapping.Max_PR{k};
    Data_QPR(k).VOMA_data.Parameters.Mapping.Baseline = Parameters.Mapping.Baseline{k};
    Data_QPR(k).VOMA_data.Parameters.SoftwareVer.SegSoftware = Parameters.SoftwareVer.SegSoftware{k};
    Data_QPR(k).VOMA_data.Parameters.SoftwareVer.QPRconvGUI = Parameters.SoftwareVer.QPRconvGUI{k};
    Data_QPR(k).VOMA_data.Parameters.DAQ = Parameters.DAQ{k};
    Data_QPR(k).VOMA_data.Parameters.DAQ_code = Parameters.DAQ_code{k};
    
    
    if isfield(Parameters,'SoftwareVer')
        Data_QPR(k).SoftwareVer = Data_QPR(k).VOMA_data.Parameters.SoftwareVer;
    end
    Data_QPR(k).SoftwareVer.VOMAformatcode = mfilename;
    
    if rawfilename_flag
        Data_QPR(k).RawFileName = RawFileName{k};
    else
    end
    
    
end

end