function varargout = DCSAS(varargin)
% DCSAS MATLAB code for DCSAS.fig
%      DCSAS, by itself, creates a new DCSAS or raises the existing
%      singleton*.
%
%      H = DCSAS returns the handle to a new DCSAS or the handle to
%      the existing singleton*.
%
%      DCSAS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DCSAS.M with the given input arguments.
%
%      DCSAS('Property','Value',...) creates a new DCSAS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DCSAS_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DCSAS_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DCSAS

% Last Modified by GUIDE v2.5 19-Jun-2019 12:25:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DCSAS_OpeningFcn, ...
                   'gui_OutputFcn',  @DCSAS_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before DCSAS is made visible.
function DCSAS_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DCSAS (see VARARGIN)

% Choose default command line output for DCSAS
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DCSAS wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DCSAS_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in segment.
function segment_Callback(hObject, eventdata, handles)
% hObject    handle to segment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
voma__seg_data()

% --- Executes on button press in convert.
function convert_Callback(hObject, eventdata, handles)
% hObject    handle to convert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
voma__convert_raw2qpr

% --- Executes on button press in analysis.
function analysis_Callback(hObject, eventdata, handles)
% hObject    handle to analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Monkey_Voma_Processing

% --- Executes on button press in summary.
function summary_Callback(hObject, eventdata, handles)
% hObject    handle to summary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
generateSubplotFigures
