function  DAT(varargin)

%sSize = get(0,'screensize');

%  Create and then hide the UI as it is being constructed.
hDAT = figure('Name','DAT_Viewer','Visible','off',...
    'Position',[50,50,340,655],'Tag','DAT_Viewer');

DAT_CreateFcn(hDAT);

set(hDAT,'DeleteFcn',@(hObject,eventdata)closeViewer(hObject,eventdata,guidata(hDAT)))

DAT_OpeningFcn(hDAT, guidata(hDAT), varargin);

% set dialog to visible
set(hDAT, 'menubar', 'none');
hDAT.Visible = 'on';

% wait for closing of the main figure.
% uiwait(hDAT);

function openError = DAT_OpeningFcn(~, handles, varargin)

openError = false; 

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


function DAT_CreateFcn(hObject,handles)
%-------------------------------------------------------------------------%
px = 20;
py = 570;

handles.hSystem = uicontrol('Parent',hObject,'Style','text',...
    'Position',[px,py+60,95,15],'String','OP System','HorizontalAlignment','left');

handles.hFolderName = uicontrol('Parent',hObject,'Style','edit',...
    'String','actualfolder','Position',[px,py+30,300,25],'HorizontalAlignment','left',...
    'Callback',@(hObject,eventdata)hFolderName_Callback(hObject,eventdata,guidata(hObject)));

handles.hPlot = uicontrol('Parent',hObject,'Style','togglebutton',...
    'Position',[px+200,py,100,25],'String','hold exported',...
    'Callback',@(hObject,eventdata)hPlot_Callback(hObject,eventdata,guidata(hObject)));

handles.hOpenAll = uicontrol('Parent',hObject,'Style','checkbox',...
    'Position',[px+70,py,70,25],'string','load all',...
    'Value',1);

handles.hOpenFolder = uicontrol('Parent',hObject,'Style','pushbutton',...
    'Position',[px-5,py,60,25],'String','Open',...
    'Callback',@(hObject,eventdata)hOpenFolder_Callback(hObject,eventdata,guidata(hObject)));

% handles.hClean = uicontrol('Parent',hObject,'Style','pushbutton',...
%     'Position',[px+220,py,80,25],'String','Clean',...
%     'Callback',@(hObject,eventdata)hClean_Callback(hObject,eventdata,guidata(hObject)));


%-------------------------------------------------------------------------%
px = 20;
py = 20;

handles.hFileList = uicontrol('Parent',hObject,'Style','listbox',...
    'Position',[px,py+300,300,240],'String','Files list','Min',1,'Max',10,...
    'Callback',@(hObject,eventdata)hFileList_Callback(hObject,eventdata,guidata(hObject)));

handles.hInfoList = uicontrol('Parent',hObject,'Style','listbox',...
    'Position',[px,py,300,280],'String','Files info list');

% Choose default command line output for DAT_Combine_Channels
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
folderName = uigetdir(startFolderName,'Select DAT folder');
if isequal(folderName,0)
    fprintf('user choose cancel.\n');
    return
end
folderName = sprintf('%s%s',folderName,handles.hSystem.UserData);
handles.hFolderName.String = folderName;

loadFiles(hObject,handles)

% --- Executes on selection change in hFileList.
function hFileList_Callback(hObject, eventdata, handles)
% hObject    handle to hFileList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns hFileList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from hFileList
%hDATLoad_Callback(hObject, eventdata, handles)
showFiles(hObject,eventdata,handles);

% ------------------------------ USER FUNCTIONS ---------------------------

function loadFiles(~,handles)

folderName = handles.hFolderName.String;
handles.hFolderName.UserData = fileparts(handles.hFolderName.String(1:end-1));

% get all dat
fileNames = dir(sprintf('%s*.dat',folderName));
% remove hidden files
fileNames = fileNames(~strncmpi('.', {fileNames.name}, 1));
if isempty(fileNames)
    str = 'no dat files found in dir.';
    fprintf('%s\n',str);
    handles.hFileList.String = str;
    return
end

% clear listbox
handles.hFileList.String = '';
% fill listbox
progress = linspace(1/numel(fileNames),1,numel(fileNames));
wbar = waitbar(0,'searching DAT measurements');
kk = 1;
userData = struct('datFile',[]);
s = cell(numel(fileNames),1);
for ii = 1:numel(fileNames)
    wbar = waitbar(progress(ii),wbar);
    if ii == 1 || handles.hOpenAll.Value
        datFile = dat.load.loadProcessedDat (...
            sprintf('%s%s',folderName,fileNames(ii).name));
            
    else
        datFile = struct('header',[],'channels',[]);
    end
        
    userData(kk).datFile = datFile;
    s{kk} = fileNames(ii).name;
    kk = kk +1;
end
close(wbar)

if ~exist('userData','var')
    str = {'no dat files';'files found in dir.'};
    fprintf('%s%s\n',str{:});
    handles.hFileList.String = str;
    return
end

% save values to list
handles.hFileList.UserData= userData;
handles.hFileList.String = s;


function showFiles(hObject,eventdata,handles)

newLoad = false;

% check if user data is empty. if yes, load data
if isempty(handles.hFileList.UserData(handles.hFileList.Value).datFile.header)
    folderName = handles.hFolderName.String;
    fileName = handles.hFileList.String{handles.hFileList.Value};
    hdlg = helpdlg(sprintf('open: %s',fileName));
    datFile = dat.load.loadProcessedDat (...
        sprintf('%s%s',folderName,fileName));
    handles.hFileList.UserData(handles.hFileList.Value).datFile = datFile;
    newLoad = true;
    close(hdlg);
    
end

userData = handles.hFileList.UserData(handles.hFileList.Value);

handles.hInfoList.String = '';


fields = fieldnames(userData.datFile.header);
s = cell(numel(fields),1);
for i = 1:numel(fields)
    cc = userData.datFile.header.(fields{i});
    if ischar(cc)
        s{i} = sprintf('%s = %s',fields{i},cc);
    elseif iscell(cc)
        ccstr = sprintf(' %s,',cc{:});
        s{i} = sprintf('%s =%s',fields{i},ccstr(1:end-1));
    else
        s{i} = sprintf('%s = %s',fields{i},mat2str(cc));
    end
end
handles.hInfoList.String = s;

%%

allFig = findobj('Tag',userData.datFile.header.file);
if ~isempty(allFig) && ~newLoad
    figure(allFig);
    return
end

f = figure('Tag',userData.datFile.header.file,...
    'WindowStyle','Docked');

nCh = numel(userData.datFile.channels);
[nRow,nCol] = utility.fitFig2Screen(nCh-1,f);

for iCh = nCh:-1:2
    sp = subplot(nCol,nRow,iCh-1);
    sp_outPos =  get(gca,'OuterPosition');
    
    p = dat.plot.plotChannel(userData.datFile,userData.datFile.channels(iCh));
    
    set(sp,'OuterPosition',sp_outPos);
    set(sp,'FontSize',9)
    
    set(p,'ButtonDownFcn',@(hObject,eventdata)plotThis(hObject,eventdata,handles,userData.datFile,iCh))
    set(sp,'ButtonDownFcn',@(hObject,eventdata)plotThis(hObject,eventdata,handles,userData.datFile,iCh))
end

function hPlot_Callback(hObject, eventdata, handles)
if hObject.Value
    hObject.ForegroundColor=[0,0,1];
    hObject.String = 'HOLD EXPORTED';
else
    hObject.ForegroundColor=[0,0,0];
    hObject.String = 'hold exported';
end

function closeViewer(hObject,eventdata,handles)

fprintf('close all windows\n');
delete(hObject);

function plotThis(~,~,handles,datFile,channel)


f = findobj('Tag','ExportFig');
if ~isempty(f) && handles.hPlot.Value
    f = f(1);
    figure(f); hold on;
else
    f = figure;
    set(f,'Position',[400 100 512 512],'PaperUnits','Points',...
        'PaperSize',[512,512],'PaperPosition',[0,0,512,512],'Tag','ExportFig');
end
p = dat.plot.plotChannel(datFile,datFile.channels(channel));
p.Parent.FontSize = 10;

print(f,'-clipboard','-dbitmap')
disp('copied to clipboard')