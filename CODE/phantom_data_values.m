function varargout = phantom_data_values(varargin)
% PHANTOM_DATA_VALUES MATLAB code for phantom_data_values.fig
%      PHANTOM_DATA_VALUES, by itself, creates a new PHANTOM_DATA_VALUES or raises the existing
%      singleton*.
%
%      H = PHANTOM_DATA_VALUES returns the handle to a new PHANTOM_DATA_VALUES or the handle to
%      the existing singleton*.
%
%      PHANTOM_DATA_VALUES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PHANTOM_DATA_VALUES.M with the given input arguments.
%
%      PHANTOM_DATA_VALUES('Property','Value',...) creates a new PHANTOM_DATA_VALUES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before phantom_data_values_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to phantom_data_values_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help phantom_data_values

% Last Modified by GUIDE v2.5 22-Jan-2013 15:38:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @phantom_data_values_OpeningFcn, ...
                   'gui_OutputFcn',  @phantom_data_values_OutputFcn, ...
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


% --- Executes just before phantom_data_values is made visible.
function phantom_data_values_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to phantom_data_values (see VARARGIN)

% Choose default command line output for phantom_data_values
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

if isappdata(0,'phantom_data')
    t = getappdata(0,'phantom_data');
    
    %aif values
    
    set(handles.aifs_edit,'String',t.aifscaleF);
    set(handles.curvshift_edit,'String',t.curvS);
    set(handles.aifR_edit,'String',t.aifR);
    set(handles.aifb_edit,'String',t.aifb);
    
    %tissue concentration values
    set(handles.mtt_edit,'String',num2str(t.MTT));
    set(handles.cbv_edit,'String',num2str(t.CBV));
    set(handles.delay_edit,'String',t.resD)
    set(handles.upsampling_edit,'String',t.upSamptime);
    set(handles.sampling_edit,'String',t.samplTime);
    
    %Tile Array Values
    set(handles.phantom_image_rows_edit,'String',t.TA_rows);
    set(handles.phantom_image_col_edit,'String',t.TA_col);
    set(handles.phantom_image_slices_edit,'String',t.TA_slices);
    set(handles.padding_edit,'String',t.hpad);
    set(handles.timescale_edit,'String',round(t.TAtp*t.samplTime));
    set(handles.tile_rows_cols_edit,'String',t.tRC);
    set(handles.ssvd_radio,'Value',t.sSVD);
    set(handles.osvd_radio,'Value',t.oSVD);
    if t.Modal == 1
        set(handles.MR_checkbox,'Value',1);
        set(handles.CT_checkbox,'Value',0);
    elseif t.Modal == 2
        set(handles.CT_checkbox,'Value',1);
        set(handles.MR_checkbox,'Value',0);
    end
    clear t;
    
end



% UIWAIT makes phantom_data_values wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = phantom_data_values_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);cur
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function delay_edit_Callback(hObject, eventdata, handles)
% hObject    handle to delay_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of delay_edit as text
%        str2double(get(hObject,'String')) returns contents of delay_edit as a double


% --- Executes during object creation, after setting all properties.
function delay_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to delay_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function upsampling_edit_Callback(hObject, eventdata, handles)
% hObject    handle to upsampling_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of upsampling_edit as text
%        str2double(get(hObject,'String')) returns contents of upsampling_edit as a double


% --- Executes during object creation, after setting all properties.
function upsampling_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to upsampling_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sampling_edit_Callback(hObject, eventdata, handles)
% hObject    handle to sampling_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sampling_edit as text
%        str2double(get(hObject,'String')) returns contents of sampling_edit as a double


% --- Executes during object creation, after setting all properties.
function sampling_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sampling_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mtt_edit_Callback(hObject, eventdata, handles)
% hObject    handle to mtt_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mtt_edit as text
%        str2double(get(hObject,'String')) returns contents of mtt_edit as a double


% --- Executes during object creation, after setting all properties.
function mtt_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mtt_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cbv_edit_Callback(hObject, eventdata, handles)
% hObject    handle to cbv_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cbv_edit as text
%        str2double(get(hObject,'String')) returns contents of cbv_edit as a double


% --- Executes during object creation, after setting all properties.
function cbv_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cbv_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function aifR_edit_Callback(hObject, eventdata, handles)
% hObject    handle to aifR_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of aifR_edit as text
%        str2double(get(hObject,'String')) returns contents of aifR_edit as a double


% --- Executes during object creation, after setting all properties.
function aifR_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to aifR_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function aifb_edit_Callback(hObject, eventdata, handles)
% hObject    handle to aifb_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of aifb_edit as text
%        str2double(get(hObject,'String')) returns contents of aifb_edit as a double


% --- Executes during object creation, after setting all properties.
function aifb_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to aifb_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function curvshift_edit_Callback(hObject, eventdata, handles)
% hObject    handle to curvshift_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of curvshift_edit as text
%        str2double(get(hObject,'String')) returns contents of curvshift_edit as a double


% --- Executes during object creation, after setting all properties.
function curvshift_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to curvshift_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function aifs_edit_Callback(hObject, eventdata, handles)
% hObject    handle to aifs_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of aifs_edit as text
%        str2double(get(hObject,'String')) returns contents of aifs_edit as a double


% --- Executes during object creation, after setting all properties.
function aifs_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to aifs_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function phantom_image_rows_edit_Callback(hObject, eventdata, handles)
% hObject    handle to phantom_image_rows_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of phantom_image_rows_edit as text
%        str2double(get(hObject,'String')) returns contents of phantom_image_rows_edit as a double


% --- Executes during object creation, after setting all properties.
function phantom_image_rows_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to phantom_image_rows_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function phantom_image_col_edit_Callback(hObject, eventdata, handles)
% hObject    handle to phantom_image_col_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of phantom_image_col_edit as text
%        str2double(get(hObject,'String')) returns contents of phantom_image_col_edit as a double


% --- Executes during object creation, after setting all properties.
function phantom_image_col_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to phantom_image_col_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function phantom_image_slices_edit_Callback(hObject, eventdata, handles)
% hObject    handle to phantom_image_slices_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of phantom_image_slices_edit as text
%        str2double(get(hObject,'String')) returns contents of phantom_image_slices_edit as a double


% --- Executes during object creation, after setting all properties.
function phantom_image_slices_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to phantom_image_slices_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function padding_edit_Callback(hObject, eventdata, handles)
% hObject    handle to padding_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of padding_edit as text
%        str2double(get(hObject,'String')) returns contents of padding_edit as a double


% --- Executes during object creation, after setting all properties.
function padding_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to padding_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function timescale_edit_Callback(hObject, eventdata, handles)
% hObject    handle to timescale_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of timescale_edit as text
%        str2double(get(hObject,'String')) returns contents of timescale_edit as a double


% --- Executes during object creation, after setting all properties.
function timescale_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timescale_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tile_rows_cols_edit_Callback(hObject, eventdata, handles)
% hObject    handle to tile_rows_cols_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tile_rows_cols_edit as text
%        str2double(get(hObject,'String')) returns contents of tile_rows_cols_edit as a double


% --- Executes during object creation, after setting all properties.
function tile_rows_cols_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tile_rows_cols_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in update_button.
function update_button_Callback(hObject, eventdata, handles)
% hObject    handle to update_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%aif Properties

    P.aifscaleF = str2double(get(handles.aifs_edit,'String'));
    P.curvS = str2double(get(handles.curvshift_edit,'String'));
    P.aifR = str2double(get(handles.aifR_edit,'String'));
    P.aifb = str2double(get(handles.aifb_edit,'String'));


    P.MTT=str2num(get(handles.mtt_edit,'String'));
    P.CBV=str2num(get(handles.cbv_edit,'String'));
    P.resD = str2double(get(handles.delay_edit,'String'));
    P.upSamptime = str2double(get(handles.upsampling_edit,'String'));
    P.samplTime = str2double(get(handles.sampling_edit,'String'));



    %Tiled Array value
    P.TA_rows = str2double(get(handles.phantom_image_rows_edit,'String'));
    P.TA_col = str2double(get(handles.phantom_image_col_edit,'String'));
    P.TA_slices = str2double(get(handles.phantom_image_slices_edit,'String'));
    P.TAtp = str2double(get(handles.timescale_edit,'String'));
    P.hpad = str2double(get(handles.padding_edit,'String'));
    P.tRC = str2double(get(handles.tile_rows_cols_edit,'String'));


    % Calculated from above
    P.timevec = (0:(P.samplTime/P.upSamptime):P.TAtp); %this is my higher res
    P.TAtp = round(P.TAtp/P.samplTime); %this is my lower res.
    P.baseline = round(P.curvS/P.samplTime)-1;


    %map 1 is linear SVD
    %map 2 is circular SVD

    P.sSVD = get(handles.ssvd_radio,'Value');
    P.oSVD = get(handles.osvd_radio,'Value');
   
    if get(handles.MR_checkbox,'Value') == 1
        P.Modal = 1;
    elseif get(handles.CT_checkbox,'Value') == 1
        P.Modal = 2;
    end
    
    setappdata(0,'phantom_data',P);
    clear P
    close


% --- Executes on button press in default_edit.
function default_edit_Callback(hObject, eventdata, handles)
% hObject    handle to default_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%% Resetting value to Default.

if isappdata(0,'phantom_data')
      
    %aif values
    
    set(handles.aifs_edit,'String',1);
    set(handles.curvshift_edit,'String',10);
    set(handles.aifR_edit,'String',1.5);
    set(handles.aifb_edit,'String',3);
    
    %tissue concentration values
    set(handles.mtt_edit,'String','24 12 8 6 4.8 4 3.4286');
    set(handles.cbv_edit,'String','0.04 0.02');
    set(handles.delay_edit,'String',2)
    set(handles.upsampling_edit,'String',10);
    set(handles.sampling_edit,'String',1.8);
    
    %Tile Array Values
    set(handles.phantom_image_rows_edit,'String',256);
    set(handles.phantom_image_col_edit,'String',256);
    set(handles.phantom_image_slices_edit,'String',3);
    set(handles.padding_edit,'String',8);
    set(handles.timescale_edit,'String',200);
    set(handles.tile_rows_cols_edit,'String',7);
    
    %Algorithms
    set(handles.osvd_radio,'Value',1);
    set(handles.ssvd_radio,'Value',1);
    set(handles.MR_checkbox,'Value',1);
    set(handles.CT_checkbox,'Value',0);
    
    % Now read it in to the latest guidata
 
else
    disp('Already Default values')
    
    
end

% --- Executes on button press in ssvd_radio.
function ssvd_radio_Callback(hObject, eventdata, handles)
% hObject    handle to ssvd_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ssvd_radio


% --- Executes on button press in osvd_radio.
function osvd_radio_Callback(hObject, eventdata, handles)
% hObject    handle to osvd_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of osvd_radio


% --- Executes on button press in MR_checkbox.
function MR_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to MR_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of MR_checkbox
if get(handles.MR_checkbox,'Value') == 0
    set(handles.CT_checkbox,'Value',1);
elseif get(handles.MR_checkbox,'Value') == 1
    set(handles.CT_checkbox,'Value',0);
end

% --- Executes on button press in CT_checkbox.
function CT_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to CT_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CT_checkbox
if get(handles.CT_checkbox,'Value') == 0
    set(handles.MR_checkbox,'Value',1);
elseif get(handles.CT_checkbox,'Value') == 1
    set(handles.MR_checkbox,'Value',0);
end


