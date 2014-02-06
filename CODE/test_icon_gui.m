function varargout = test_icon_gui(varargin)
% TEST_ICON_GUI MATLAB code for test_icon_gui.fig
%      TEST_ICON_GUI, by itself, creates a new TEST_ICON_GUI or raises the existing
%      singleton*.
%
%      H = TEST_ICON_GUI returns the handle to a new TEST_ICON_GUI or the handle to
%      the existing singleton*.
%
%      TEST_ICON_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEST_ICON_GUI.M with the given input arguments.
%
%      TEST_ICON_GUI('Property','Value',...) creates a new TEST_ICON_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before test_icon_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to test_icon_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help test_icon_gui

% Last Modified by GUIDE v2.5 23-Nov-2012 11:22:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @test_icon_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @test_icon_gui_OutputFcn, ...
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


% --- Executes just before test_icon_gui is made visible.
function test_icon_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to test_icon_gui (see VARARGIN)

% Choose default command line output for test_icon_gui
handles.output = hObject;
RGB=imread('/home/gsharma/Programming/Matlab/Mypaper/html/gui_pic/create.jpg');
set(handles.pushbutton1,'cdata', imresize(RGB,[64,NaN]));
RGB=imread('/home/gsharma/Programming/Matlab/Mypaper/html/gui_pic/contrast.jpg');
set(handles.pushbutton2,'cdata', imresize(RGB,[64,NaN]));
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes test_icon_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = test_icon_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes1);
imshow(imread('/home/gsharma/Programming/Matlab/Mypaper/html/gui_pic/create.jpg'))



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
imcontrast(gca);

