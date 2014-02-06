function varargout = test_dcgui(varargin)
% TEST_DCGUI MATLAB code for test_dcgui.fig
%      TEST_DCGUI, by itself, creates a new TEST_DCGUI or raises the existing
%      singleton*.
%
%      H = TEST_DCGUI returns the handle to a new TEST_DCGUI or the handle to
%      the existing singleton*.
%
%      TEST_DCGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEST_DCGUI.M with the given input arguments.
%
%      TEST_DCGUI('Property','Value',...) creates a new TEST_DCGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before test_dcgui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to test_dcgui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help test_dcgui

% Last Modified by GUIDE v2.5 21-Dec-2012 10:28:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @test_dcgui_OpeningFcn, ...
                   'gui_OutputFcn',  @test_dcgui_OutputFcn, ...
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


% --- Executes just before test_dcgui is made visible.
function test_dcgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to test_dcgui (see VARARGIN)

% Choose default command line output for test_dcgui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes test_dcgui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = test_dcgui_OutputFcn(hObject, eventdata, handles) 
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

[pp]=uigetdir;

%------------------------------------------------
%%% This whole cod is dependent on Soren's work
% need to understand this.
%-------------------------------------------------


%pp='/home/gsharma/Phantom_Data/MR/Goldmaps';

get_dicom_list_options=''; %can be -r

if pp ~= 0;
    dicom_struct=get_dicom_list(pp,get_dicom_list_options);
    save  dicom_struct dicom_struct
    %  
    load dicom_struct;


    poslist={dicom_struct(:).position};
    set(handles.listbox1,'string',poslist,'value',1)


    SSEtags='SeriesDescription,Columns,Rows,SeriesInstanceUID';
    temporalsort_tags='InstanceNumber';


    [SSEcodes,dicom_struct_t,humanlist]=get_dicom_SSE(dicom_struct,SSEtags); %not needed now as we supply names


    unqline=[];
    unq_codes=unique(SSEcodes);
    for test=1:length(unq_codes)
        infomat=getDCMstructinfo(dicom_struct(SSEcodes==unq_codes(test)),{'SeriesDescription','SeriesNumber','Rows','Columns'});
        infomat_debug=getDCMstructinfo(dicom_struct(SSEcodes==unq_codes(test)),{'AcquisitionDate','AcquisitionTime','InstanceNumber','ContentTime'});

        sortorder{test}=sse_sort(dicom_struct(SSEcodes==test),temporalsort_tags);

        unqline{test}=['Description: ' infomat{1,1} ' ' 'SeriesNumber:' num2str(infomat{1,2})  ' num images: ' num2str(size(infomat,1)) '. ' num2str(size(sortorder{test},1)) ' slices, ' .........
            num2str(size(sortorder{test},2)) ' reps'];
        disp(unqline{test});

    end

    handles.sortorder=sortorder;
    handles.unqline=unqline;
    handles.dicom_struct=dicom_struct;
    handles.SSEcodes=SSEcodes;

    set(handles.listbox1,'string',unqline);
    handles.sPath='/home/gsharma/PACTS/MR/MAT/';
    guidata(handles.figure1,handles);
else
    disp('Data not Selected');
end
%set(handles.SSE_listbox,'string',unqline,'value',1)



% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in sSVD_tmax_button.
function sSVD_tmax_button_Callback(hObject, eventdata, handles)
% hObject    handle to sSVD_tmax_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Tmax was pressed - retrieve the data index selected
handles=guidata(handles.figure1);

%which index was selected (which series)
indx=get(handles.listbox1,'value');
handles.sSVD_tmax = read_data(indx,handles);
if handles.sSVD_tmax == -1
    set(handles.svd_tmax_edit,'String','No data Loaded');
else
    set(handles.svd_tmax_edit,'String','Data Loaded');
end

%which indices into dicomstruct is that?
% original code written by Dr Christensen

% try 
%     seriesINDX=handles.SSEcodes==indx;
%     dicoms_structures_inseries=handles.dicom_struct(seriesINDX);
%     
%     sortorder=handles.sortorder{indx};
%     dicoms_structures_sorted=dicoms_structures_inseries(sortorder);
%     %now read data matrix
%     template_file=dicomread(dicoms_structures_sorted(1).position);
%     
%     datamatrix=zeros([size(template_file) length(dicoms_structures_sorted)],class(template_file));
%     
%     for iimg=1:length(dicoms_structures_sorted)
%         datamatrix(:,:,iimg)=dicomread(dicoms_structures_sorted(iimg).position);
%     end
%     factor = str2double(get(handles.nfactor_edit,'String'));
%     handles.sSVD_tmax = factor * datamatrix;
%     clear datamatrix;
%     set(handles.svd_tmax_edit,'String','Data Loaded');
% catch
%     disp('Please select data....');
% end
    
    %Need to update handle.
    guidata(handles.figure1,handles); 


% nFactor = str2double(get(handles.aifs_edit,'String'));
% 


% --- Executes on button press in sSVD_mtt_button.
function sSVD_mtt_button_Callback(hObject, eventdata, handles)
% hObject    handle to sSVD_mtt_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=guidata(handles.figure1);
indx=get(handles.listbox1,'value');
handles.sSVD_mtt = read_data(indx,handles);
 
%Need to update handle.

if handles.sSVD_mtt == -1
    set(handles.svd_mtt_edit,'String','No data Loaded');
else
    set(handles.svd_mtt_edit,'String','Data Loaded');
end
guidata(handles.figure1,handles); 




function svd_tmax_edit_Callback(hObject, eventdata, handles)
% hObject    handle to svd_tmax_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of svd_tmax_edit as text
%        str2double(get(hObject,'String')) returns contents of svd_tmax_edit as a double


% --- Executes during object creation, after setting all properties.
function svd_tmax_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to svd_tmax_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function svd_mtt_edit_Callback(hObject, eventdata, handles)
% hObject    handle to svd_mtt_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of svd_mtt_edit as text
%        str2double(get(hObject,'String')) returns contents of svd_mtt_edit as a double


% --- Executes during object creation, after setting all properties.
function svd_mtt_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to svd_mtt_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in oSVD_tmax_button.
function oSVD_tmax_button_Callback(hObject, eventdata, handles)
% hObject    handle to oSVD_tmax_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles=guidata(handles.figure1);
indx=get(handles.listbox1,'value');
handles.oSVD_tmax = read_data(indx,handles);

if handles.oSVD_tmax == -1
    set(handles.osvd_tmax_edit,'String','No data Loaded');
else
    set(handles.osvd_tmax_edit,'String','Data Loaded');
end

%Need to update handle.
guidata(handles.figure1,handles); 

function osvd_tmax_edit_Callback(hObject, eventdata, handles)
% hObject    handle to osvd_tmax_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of osvd_tmax_edit as text
%        str2double(get(hObject,'String')) returns contents of osvd_tmax_edit as a double


% --- Executes during object creation, after setting all properties.
function osvd_tmax_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to osvd_tmax_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in oSVD_mtt_button.
function oSVD_mtt_button_Callback(hObject, eventdata, handles)
% hObject    handle to oSVD_mtt_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=guidata(handles.figure1);
indx=get(handles.listbox1,'value');

handles.oSVD_mtt = read_data(indx,handles);
if handles.oSVD_mtt == -1
    set(handles.osvd_mtt_edit,'String','No data Loaded');
else
    set(handles.osvd_mtt_edit,'String','Data Loaded');
end
guidata(handles.figure1,handles); 


function osvd_mtt_edit_Callback(hObject, eventdata, handles)
% hObject    handle to osvd_mtt_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of osvd_mtt_edit as text
%        str2double(get(hObject,'String')) returns contents of osvd_mtt_edit as a double


% --- Executes during object creation, after setting all properties.
function osvd_mtt_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to osvd_mtt_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in report_button.
function report_button_Callback(hObject, eventdata, handles)
% hObject    handle to report_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=guidata(handles.figure1);
%% all I need now is to read my phantom data. 

% If the values are not defined then I am giving them -1
% Should I publish sSVD report differently and oSVD report differently
% If its -1 then there is not point of going to report page.

 
% Now what is the best way to read, the phantom data. Structure base data

try
    %Reading Gold standard Maps, in the .mat format.
    sSVD_flag=0;
    if isfield(handles,'sSVD_mtt')
        sSVD_flag=1;
    else
        handles.sSVD_mtt = -1;
    end
    
    if isfield(handles,'sSVD_tmax')
        sSVD_flag=1;
    else
        handles.sSVD_tmax = -1; 
    end
        
    if sSVD_flag
        load([handles.sPath '/' 'sSVD_maps.mat']);
    end
         
      
    if handles.sSVD_mtt ~= -1
        % Read third party software MTT maps.
        results.sSVD_mtt =  handles.sSVD_mtt;
        % Gold Standard MTT maps.
        results.pha_sSVD_mtt = results.sSVD_mtt;
        results.sSVD.mtt_tileValues_slice_one = fetch_tile_values(results.pha_sSVD_mtt(:,:,1),1);
        results.sSVD.mtt_tileValues_slice_two = fetch_tile_values(results.pha_sSVD_mtt(:,:,2),1);
    else
        results.sSVD_mtt = -1;
    end

    if  handles.sSVD_tmax ~= -1
        results.sSVD_tmax =  handles.sSVD_tmax;
        results.pha_sSVD_tmax = sSVD_tmax;
        results.sSVD.tmax_tileValues_slice_one = fetch_tile_values(results.pha_sSVD_tmax(:,:,1),2);
        results.sSVD.tmax_tileValues_slice_two = fetch_tile_values(results.pha_sSVD_tmax(:,:,2),2);
    else
        results.sSVD_tmax = -1;
    end

    oSVD_flag=0;
    if isfield(handles,'oSVD_mtt')
        oSVD_flag=1;
    else
        handles.oSVD_mtt = -1;
    end
    
    if isfield(handles,'oSVD_tmax')
        oSVD_flag=1;
    else
        handles.oSVD_tmax = -1; 
    end
        
    
    if oSVD_flag
        load([handles.sPath '/' 'oSVD_maps.mat']);
    end
    
        
    if handles.oSVD_tmax ~= -1
        results.oSVD_tmax =  handles.oSVD_tmax;
        results.pha_oSVD_tmax = oSVD_tmax;
        results.oSVD.tmax_tileValues_slice_one = fetch_tile_values(results.pha_oSVD_tmax(:,:,1),2);
        results.oSVD.tmax_tileValues_slice_two = fetch_tile_values(results.pha_oSVD_tmax(:,:,2),2);
    else
        results.oSVD_tmax = -1;
    end

    if handles.oSVD_mtt ~= -1
        results.oSVD_mtt =  handles.oSVD_mtt;
        results.pha_oSVD_mtt = oSVD_mtt;
        results.oSVD.mtt_tileValues_slice_one = fetch_tile_values(results.pha_oSVD_mtt(:,:,1),1);
        results.oSVD.mtt_tileValues_slice_two = fetch_tile_values(results.pha_oSVD_mtt(:,:,2),1);
    else
        results.oSVD_mtt = -1;
    end
    
    save(['~/PACTS/MR/MAT/' 'results.mat'],'-struct','results')
    options_doc_nocode.format = 'html';
    options_doc_nocode.showCode = false;
    publish('createReport.m',options_doc_nocode);
    publish('createReport.m',options_doc_nocode);
    %close all;
   
catch
    disp('Please load the data Phantom Maps, Perfusion Maps in one folder');
end
 
 function nfactor_edit_Callback(hObject, eventdata, handles)
% hObject    handle to nfactor_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nfactor_edit as text
%        str2double(get(hObject,'String')) returns contents of nfactor_edit as a double


% --- Executes during object creation, after setting all properties.
function nfactor_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nfactor_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function [matrix] = read_data(index,handles)
handles=guidata(handles.figure1);
try 
    seriesINDX=handles.SSEcodes==index;
    dicoms_structures_inseries=handles.dicom_struct(seriesINDX);
    
    sortorder=handles.sortorder{index};
    dicoms_structures_sorted=dicoms_structures_inseries(sortorder);
    %now read data matrix
    template_file=dicomread(dicoms_structures_sorted(1).position);
    
    datamatrix=zeros([size(template_file) length(dicoms_structures_sorted)],class(template_file));
    
    for iimg=1:length(dicoms_structures_sorted)
        datamatrix(:,:,iimg)=dicomread(dicoms_structures_sorted(iimg).position);
    end
    factor = str2double(get(handles.nfactor_edit,'String'));
    matrix = factor * datamatrix;
    clear datamatrix;
catch
    disp('Please select data....');
    matrix=-1;
end
    guidata(handles.figure1,handles); 


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=guidata(handles.figure1);
if isfield(handles,'sSVD_tmax') 
    handles=rmfield(handles,{'sSVD_tmax'});
    set(handles.svd_tmax_edit,'String','');
end   

if isfield(handles,'sSVD_mtt') 
    handles=rmfield(handles,{'sSVD_mtt'});
    set(handles.svd_mtt_edit,'String','');
end

if isfield(handles,'oSVD_mtt') 
    handles=rmfield(handles,{'oSVD_mtt'});
    set(handles.osvd_mtt_edit,'String','');
end

if isfield(handles,'oSVD_tmax') 
    handles=rmfield(handles,{'oSVD_tmax'});
    set(handles.osvd_tmax_edit,'String','');
end

guidata(handles.figure1,handles);   