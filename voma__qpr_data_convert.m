%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Function: qpr_data_convert_v5.m
%
%  Description: This function takes in seperate data files and converts
%  them to a structure compatible with my 'qpr / vor_analysis_gui'
%  analysis routines.
%
%  Input:
%    
%
%  Output:
%           - Data_QPR: Formated data structure ready to be loaded and
%                       analyzed in 'qpr_vl.m'!!
%
%
%
%  Version Control (This is the version history for 'qpr_data_convert_v5')
%
%           - v1: Original Code
%           - v2: Added code to process two (i.e., left and right) dual 
%                 coil signals
%           - v3: Added code to process RAW data, Position traces, and
%                 Angular Velocity
%           - v4: Added a parameter to include data processing software
%                 version notes
%           - v5: Cleaned up the QPR file format to avoid old, confusing
%                 parameter names
%
%   - Peter J. Boutros, November 2015
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Data_QPR] = voma__qpr_data_convert(Fs,Stimulus,Stim_t,stim_ind,Data_LE_Pos_X,Data_LE_Pos_Y,Data_LE_Pos_Z,Data_RE_Pos_X,Data_RE_Pos_Y,Data_RE_Pos_Z,Data_LE_Vel_X,Data_LE_Vel_Y,Data_LE_Vel_LARP,Data_LE_Vel_RALP,Data_LE_Vel_Z,Data_RE_Vel_X,Data_RE_Vel_Y,Data_RE_Vel_LARP,Data_RE_Vel_RALP,Data_RE_Vel_Z,Eye_t,Filenames,Parameters)


% Determine the number of elements in the data arrays
num = length(Data_LE_Pos_X);


% If the user did not input a parameter vector, just assign one
% parameter value to the filename and make the rest empty
if nargin<9
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
if length(Fs) == 1;
    if ~iscell(Fs{1})
        Fs = {Fs};
    end
    Fs = repmat(Fs,1,num);
else
end


% Load and format all data.
for k=1:num
    Data_QPR(k).name = Filenames{k}{1};
    Data_QPR(k).VOMA_data.Fs = Fs{k}{1};
    % Stimulus Data
    Data_QPR(k).VOMA_data.Stim_Trace = Stimulus{k}{1};
    Data_QPR(k).VOMA_data.Stim_t = Stim_t{k}{1};
    Data_QPR(k).VOMA_data.stim_ind = stim_ind{k}{1};
    % Eye Data
    Data_QPR(k).VOMA_data.Eye_t = Eye_t{k}{1};
    % Position
    % Left Eye
    Data_QPR(k).VOMA_data.Data_LE_Pos_X = Data_LE_Pos_X{k}{1};
    Data_QPR(k).VOMA_data.Data_LE_Pos_Y = Data_LE_Pos_Y{k}{1};
    Data_QPR(k).VOMA_data.Data_LE_Pos_Z = Data_LE_Pos_Z{k}{1};
    % Right Eye
    Data_QPR(k).VOMA_data.Data_RE_Pos_X = Data_RE_Pos_X{k}{1};
    Data_QPR(k).VOMA_data.Data_RE_Pos_Y = Data_RE_Pos_Y{k}{1};
    Data_QPR(k).VOMA_data.Data_RE_Pos_Z = Data_RE_Pos_Z{k}{1};
    % Velocity
    % Left Eye
    Data_QPR(k).VOMA_data.Data_LE_Vel_X = Data_LE_Vel_X{k}{1};
    Data_QPR(k).VOMA_data.Data_LE_Vel_Y = Data_LE_Vel_Y{k}{1};    
    Data_QPR(k).VOMA_data.Data_LE_Vel_LARP = Data_LE_Vel_LARP{k}{1};
    Data_QPR(k).VOMA_data.Data_LE_Vel_RALP = Data_LE_Vel_RALP{k}{1};
    Data_QPR(k).VOMA_data.Data_LE_Vel_Z = Data_LE_Vel_Z{k}{1};
    % Right Eye
    Data_QPR(k).VOMA_data.Data_RE_Vel_X = Data_RE_Vel_X{k}{1};
    Data_QPR(k).VOMA_data.Data_RE_Vel_Y = Data_RE_Vel_Y{k}{1};    
    Data_QPR(k).VOMA_data.Data_RE_Vel_LARP = Data_RE_Vel_LARP{k}{1};
    Data_QPR(k).VOMA_data.Data_RE_Vel_RALP = Data_RE_Vel_RALP{k}{1};
    Data_QPR(k).VOMA_data.Data_RE_Vel_Z = Data_RE_Vel_Z{k}{1};
    % Experiment Info
    Data_QPR(k).VOMA_data.Parameters = Parameters(k);
    
    
    if isfield(Parameters(k),'SoftwareVer')
        Data_QPR(k).SoftwareVer = Parameters(k).SoftwareVer;
    end
    Data_QPR(k).SoftwareVer.VOMAformatcode = mfilename;
    
    
end

end