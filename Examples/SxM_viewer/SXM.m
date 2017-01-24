function  SXM(varargin)

%sSize = get(0,'screensize');

%  Create and then hide the UI as it is being constructed.
hSXM = figure('Name','SXM_Viewer','Visible','off',...
    'Position',[50,0,340,655],'Tag','SXM_Viewer');

SXM_CreateFcn(hSXM);

set(hSXM,'DeleteFcn',@(hObject,eventdata)closeViewer(hObject,eventdata,guidata(hSXM)))

SXM_OpeningFcn(hSXM, guidata(hSXM), varargin);

% set dialog to visible
set(hSXM, 'menubar', 'none');
hSXM.Visible = 'on';

% wait for closing of the main figure.
% uiwait(hSXM);

function SXM_OpeningFcn(~, handles, varargin)

if exist('localSettings.txt','file')==2
    flist = importdata('localSettings.txt','\t');
    flist = cellfun(@(x) strsplit(x,'\t'),{flist{:}},'UniformOutput',false);
    allPath = cellfun(@(x) x{2},flist,'UniformOutput',false);
    nanoLib = allPath{1};
    dataPath = allPath{2};
else
    [nanoLib,dataPath]=utility.setSettings();
end

addpath(nanoLib);
handles.hFolderName.UserData = dataPath;

handles.hSystem.UserData = '/';
handles.hSystem.String = 'OS X';
if ispc
    handles.hSystem.String = 'Windows';
    handles.hSystem.UserData = '\';
end

function SXM_CreateFcn(hObject,handles)
%-------------------------------------------------------------------------%
px = 20;
py = 570;

handles.hSystem = uicontrol('Parent',hObject,'Style','text',...
    'Position',[px,py+60,95,15],'String','OP System','HorizontalAlignment','left');

handles.hFolderName = uicontrol('Parent',hObject,'Style','edit',...
    'String','actualfolder','Position',[px,py+30,300,25],'HorizontalAlignment','left',...
    'Callback',@(hObject,eventdata)hFolderName_Callback(hObject,eventdata,guidata(hObject)));

handles.hProcessType = uicontrol('Parent',hObject,'Style','popup',...
    'Position',[px-5,py+7,150,15],'String',{'Raw','Mean','PlaneLineCorrection','Median'},...
    'HorizontalAlignment','left',...
    'Callback',@(hObject,eventdata)hProcessType_Callback(hObject,eventdata,guidata(hObject)));

handles.hOpenAll = uicontrol('Parent',hObject,'Style','checkbox',...
    'Position',[px+155,py-2,70,25],'string','load all',...
    'Value',1);

handles.hOpenFolder = uicontrol('Parent',hObject,'Style','pushbutton',...
    'Position',[px+240,py,60,25],'String','Open',...
    'Callback',@(hObject,eventdata)hOpenFolder_Callback(hObject,eventdata,guidata(hObject)));


%-------------------------------------------------------------------------%
px = 20;
py = 20;

handles.hFileList = uicontrol('Parent',hObject,'Style','listbox',...
    'Position',[px,py+300,300,240],'String','Files list',...
    'Callback',@(hObject,eventdata)hFileList_Callback(hObject,eventdata,guidata(hObject)));

handles.hInfoList = uicontrol('Parent',hObject,'Style','listbox',...
    'Position',[px,py,300,280],'String','Files info list');

% Choose default command line output for SXM_Combine_Channels
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% ------------------------------ GUI CALL BACK ----------------------------

function hFolderName_Callback(hObject, eventdata, handles)
% hObject    handle to hFolderName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of hFolderName as text
%        str2double(get(hObject,'String')) returns contents of hFolderName as a double
loadFiles(hObject,handles)
showFiles(hObject,eventdata,handles)

% --- Executes on button press in hOpenFolder.
function hOpenFolder_Callback(hObject, eventdata, handles)
% hObject    handle to hOpenFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% input file names
startFolderName = sprintf('%s%s',handles.hFolderName.UserData,handles.hSystem.UserData);
folderName = uigetdir(startFolderName,'Select SXM folder');
if isequal(folderName,0)
    fprintf('user choose cancel.\n');
    return
end
folderName = sprintf('%s%s',folderName,handles.hSystem.UserData);
handles.hFolderName.String = folderName;

loadFiles(hObject,handles)

% --- Executes on button press in hOpenFolder.
function hProcessType_Callback(~, ~, handles)
% hObject    handle to hOpenFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

userData = handles.hFileList.UserData;
fileNames = handles.hFileList.String;
if ~strcmp(fileNames,'Files list')
    progress = linspace(1/numel(fileNames),1,numel(fileNames));
    wbar = waitbar(0,'searching SXM measurements');
    for ii = 1:numel(fileNames)
        wbar = waitbar(progress(ii),wbar);
        if ~isempty(userData(ii).sxmFile.header)
            userData(ii).sxmFile = loadSXM(fileNames{ii},handles);
        end
    end
    close(wbar);
end
% save values to list
handles.hFileList.UserData= userData;


% --- Executes on selection change in hFileList.
function hFileList_Callback(hObject, eventdata, handles)
% hObject    handle to hFileList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns hFileList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from hFileList
%
showFiles(hObject,eventdata,handles)

% ------------------------------ USER FUNCTIONS ---------------------------

function loadFiles(~,handles)

folderName = handles.hFolderName.String;
handles.hFolderName.UserData = fileparts(handles.hFolderName.String(1:end-1));

% get all sxm
fileNames = dir(sprintf('%s*.sxm',folderName));
if isempty(fileNames)
    str = 'no sxm files found in dir.';
    fprintf('%s\n',str);
    handles.hFileList.String = str;
    return
end

% clear listbox
handles.hFileList.String = '';
% fill listbox
progress = linspace(1/numel(fileNames),1,numel(fileNames));
wbar = waitbar(0,'searching SXM measurements');
kk = 1;
userData = struct('sxmFile',[]);
s = cell(numel(fileNames),1);
for ii = 1:numel(fileNames)
    wbar = waitbar(progress(ii),wbar);
    if ii == 1 || handles.hOpenAll.Value
        sxmFile = loadSXM(fileNames(ii).name,handles);
    else
        sxmFile = struct('header',[],'channels',[]);
    end
         
    userData(kk).sxmFile = sxmFile;
    s{kk} = fileNames(ii).name;
    kk = kk +1;
end
close(wbar)

if ~exist('userData','var')
    str = {'no sxm files';'files found in dir.'};
    fprintf('%s%s\n',str{:});
    handles.hFileList.String = str;
    return
end

% save values to list
handles.hFileList.UserData= userData;
handles.hFileList.Value = 1;
handles.hFileList.String = s;

function sxmFile = loadSXM(fileName,handles)
folderName = handles.hFolderName.String;
sxmFile = sxm.load.loadProcessedSxM(...
    sprintf('%s%s%s',folderName,handles.hSystem.UserData,fileName),...
    handles.hProcessType.String{handles.hProcessType.Value});

function showFiles(hObject,eventdata,handles)

newLoad = false;
% check if user data is empty. if yes, load data
if isempty(handles.hFileList.UserData(handles.hFileList.Value).sxmFile.header)
    fileName = handles.hFileList.String{handles.hFileList.Value};
    hdlg = helpdlg(sprintf('open: %s',fileName));
    sxmFile = loadSXM(fileName,handles);
    handles.hFileList.UserData(handles.hFileList.Value).sxmFile = sxmFile;
    newLoad = true;
    close(hdlg);
end

userData = handles.hFileList.UserData(handles.hFileList.Value);

handles.hInfoList.String = '';

fields = fieldnames(userData.sxmFile.header);
s = cell(numel(fields),1);
for i = 1:numel(fields)
  cc = userData.sxmFile.header.(fields{i});
  if ischar(cc)
      s{i} = sprintf('%s = %s',fields{i},cc);
  else
      s{i} = sprintf('%s = %s',fields{i},mat2str(cc));
  end
end
handles.hInfoList.String = s;
%%
tagString = sprintf('%d: %s',handles.hProcessType.Value,userData.sxmFile.header.scan_file);
allFig = findobj('Tag',tagString);
if ~isempty(allFig) && ~newLoad
    figure(allFig);
    return
end

% retrive screensize
sSize = get(0,'screensize');

nCh = numel(userData.sxmFile.channels);

[nRow,nCol,~] = utility.fitFig2Screen(nCh,[380,50,sSize(3)-380,sSize(4)-200]);
figure('Position',[380,50,(sSize(4)-100)*nRow/nCol,sSize(4)-200],...
    'Tag',tagString,...
    'WindowStyle','Docked');

for iCh = nCh:-1:1
    sp = subplot(nCol,nRow,iCh);
    
    p = sxm.plot.plotChannel(userData.sxmFile.channels(iCh),userData.sxmFile.header,...
        'holdPosition','Units','nm');
    colormap(sxm.op.nanonisMap(128))
    
    % plotData automatically sets
    set(sp,'FontSize',9)
    
    set(p,'ButtonDownFcn',@(hObject,eventdata)plotThis(hObject,eventdata,userData.sxmFile,iCh))
end


function closeViewer(hObject,eventdata,handles)

fprintf('close all windows\n');
delete(hObject);

function plotThis(~,~,sxmFile,channel)
f = figure;
set(f,'Position',[400 100 512 512],'PaperUnits','Points','PaperSize',[512,512],'PaperPosition',[0,0,512,512]);
p = sxm.plot.plotChannel(sxmFile.channels(channel),sxmFile.header);
p.Parent.FontSize = 10;
colormap(sxm.op.nanonisMap(128))
print(f,'-clipboard','-dbitmap')
disp('copied to clipboard')