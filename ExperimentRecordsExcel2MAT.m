%% Experiment Records Excel 2 MAT Converter
% This function exists to help turn existing Experimental Records Excel
% Spreadsheets into .mat files containing the same data. This helps the
% file I/O on Mac computers while still maintaining an up to date Excel
% Spreadsheet

%The function either takes in a string with a full path of an excel file to
%be converted or takes no input arguments in and allows the use to select
%the file from a file explorer.
%A .mat file containing a struct called ExperimentRecords with fields for
%each sheet and tables within those fields is made in the same directory
%and with the same name as the selected Excel spreadsheet.

function ExperimentRecords = ExperimentRecordsExcel2MAT(varargin)
if nargin==0
    [FileName,PathName] = uigetfile('*.xlsx','Please choose the experimental batch spreadsheet where the data will be exported');
    full_path = [PathName,FileName];
elseif nargin > 1
    error('Too many input arguments. Only one string array with the full path to a file (including the file name) is wanted.')
else
    full_path = varargin{:};
end
if(~isempty(full_path)&&ischar(full_path))
    [~,sheets,~] = xlsfinfo(full_path);
    if(isempty(sheets))
        f = warndlg('Either this file has no sheets, you have a path problem, or you are on a Mac. If you are on a Mac, open and close the excel spreadsheet and try again.');
        uiwait(f);
        ExperimentRecords = [];
    else
        sheets2 = strrep(sheets,'-','_');
        sheets2 = strrep(sheets2,' ','');
        labels = {'File_Name','Date','Subject','Implant','Eye_Recorded','Compression','Max_PR_pps','Baseline_pps','Function','Mod_Canal','Mapping_Type','Frequency_Hz','Max_Velocity_dps','Phase_degrees','Cycles','Phase_Direction','Notes'};
        for i = 1:length(sheets)
            [~,~,raw1] = xlsread(full_path,sheets{i});
            rawSize = size(raw1);
            %Change Unwanted NaNs to empty arrays
            for col = 1:rawSize(2)
                for row = 1:rawSize(1)
                    if any(isnan(raw1{row,col})) && (col~=12) && (col~=13)
                        raw1{row,col} = [];
                    end
                end
            end
            %Make sure the table is right size
            if rawSize(2) > length(labels) %Puts anything that would be cut off in the 'Notes' column
                disp(labels)
                f = warndlg(['There are more columns than expected in ',sheets{i},' found in ',full_path,'. They were appended into the "Notes" column of the .mat file.']);
                uiwait(f);
                for row = 1:rawSize(1)
                    raw1{row,length(labels)} = {strjoin(raw1{row,length(labels):rawSize(2)})};
                end
            elseif rawSize(2) < length(labels) %Makes empty arrays to ensure every row has the same number of columns as there are labels
                disp(labels)
                f = warndlg(['There are less columns than expected in ',sheets{i},' found in ',full_path,'. Please confirm you have the right column headers.']);
                uiwait(f);
                raw1(1,(rawSize(2)+1):length(labels)) = cell2table(cell(1,length((rawSize(2)+1):length(labels))));
            end
            tab = cell2table(raw1(2:end,1:length(labels)));
            tab.Properties.VariableNames = labels;
            ExperimentRecords.(sheets2{i}) = tab;
        end
        save([full_path(1:end-4),'mat'],'ExperimentRecords');
    end
else
    error('Path is empty or is not a character array')
end
end