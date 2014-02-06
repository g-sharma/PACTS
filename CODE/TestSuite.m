function varargout = TestSuite(varargin)
% TESTSUITE MATLAB code for TestSuite.fig
%      TESTSUITE, by itself, creates a new TESTSUITE or raises the existing
%      singleton*.
%
%      H = TESTSUITE returns the handle to a new TESTSUITE or the handle to
%      the existing singleton*.
%
%      TESTSUITE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TESTSUITE.M with the given input arguments.
%
%      TESTSUITE('Property','Value',...) creates a new TESTSUITE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TestSuite_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TestSuite_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TestSuite

% Last Modified by GUIDE v2.5 23-Nov-2012 14:40:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TestSuite_OpeningFcn, ...
                   'gui_OutputFcn',  @TestSuite_OutputFcn, ...
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
% End initialization code - DO NOT EDITht


% --- Executes just before TestSuite is made visible.
function TestSuite_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TestSuite (see VARARGIN)


RGB=imread('/home/gsharma/Programming/Matlab/Mypaper/pacts/CODE/html/gui_pic/create.jpg');
set(handles.cphantom_button,'cdata', imresize(RGB,[115,NaN]));

RGB=imread('/home/gsharma/Programming/Matlab/Mypaper/pacts/CODE/html/gui_pic/edit.png');
set(handles.pproperties_button,'cdata', imresize(RGB,[115,NaN]));


RGB=imread('/home/gsharma/Programming/Matlab/Mypaper/pacts/CODE/html/gui_pic/report.png');
set(handles.testreport_button,'cdata', imresize(RGB,[115,NaN]));

RGB=imread('/home/gsharma/Programming/Matlab/Mypaper/pacts/CODE/html/gui_pic/uni.png');
set(handles.unimage,'cdata', imresize(RGB,[80,NaN]));


if isappdata(0,'phantom_data')
    rmappdata(0,'phantom_data')
end

% Choose default command line output for TestSuite
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TestSuite wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TestSuite_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in testreport_button.
function testreport_button_Callback(hObject, eventdata, handles)
% hObject    handle to testreport_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
test_dcgui

% --- Executes on button press in pproperties_button.
function pproperties_button_Callback(hObject, eventdata, handles)
% hObject    handle to pproperties_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    phantom_data_values

% --- Executes on button press in cphantom_button.
function cphantom_button_Callback(hObject, eventdata, handles)
% hObject    handle to cphantom_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if isappdata(0,'phantom_data');
        structure_recieved = getappdata(0,'phantom_data')
        calPhan_param(structure_recieved);
    else
        structure_recieved = default_Phantom_Properties();
        calPhan_param(structure_recieved);
    end


function [aif_structure] = default_Phantom_Properties()

    P.TA_rows = 256; % Number of rows in phantom 
    P.TA_col = 256;  % Number of columns in phantom.
    P.TA_slices = 3; % Total number of slices in phantom.
    P.TAtp = 200;    % Total time(200/sampling time = 100 sampling time)
    P.samplTime = 1.8; 
    P.upSamptime = 10;
    P.aifscaleF = 1;
    P.curvS = 10;
    P.aifR = 1.5;
    P.aifb = 3;
    P.timevec = (0:(P.samplTime/P.upSamptime):P.TAtp); %this is my higher res
    P.CBV=[0.04 0.02];
    P.MTT =[24 12 8 6 4.8 4 3.4286];
    P.resD = 0; %% soren's want it to be zero, but initally we had 2 
    P.hpad = 8;
    P.tRC = 7;

    P.TAtp = round(P.TAtp/P.samplTime); %this is my lower res.
    
    %Need to understand this.
    
    P.baseline = round(P.curvS/P.samplTime)-1;
    
    P.sSVD = 1;
    P.oSVD = 1;
    P.Modal=1; % 1 for MR 2 for CT and 3 for both.
    aif_structure = P;
    clear P;


% --- Executes on button press in unimage.
function unimage_Callback(hObject, eventdata, handles)
% hObject    handle to unimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
