function  DAT(varargin)

%sSize = get(0,'screensize');

%  Create and then hide the UI as it is being constructed.
hDAT = figure('Name','DAT_Viewer','Visible','off',...
    'Position',[50,50,340,670],'Tag','DAT_Viewer');

DAT_CreateFcn(hDAT);

set(hDAT,'DeleteFcn',@(hObject,eventdata)closeViewer(hObject,eventdata,guidata(hDAT)))

DAT_OpeningFcn(hDAT, guidata(hDAT), varargin);

% set dialog to visible
set(hDAT, 'menubar', 'none');
hDAT.Visible = 'on';

% wait for closing of the main figure.
% uiwait(hDAT);
end
function openError = DAT_OpeningFcn(hObject, handles, varargin)

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
guidata(hObject,handles);
end

function DAT_CreateFcn(hObject,handles)
%-------------------------------------------------------------------------%
px = 20;
py = 580;

handles.hSystem = uicontrol('Parent',hObject,'Style','text',...
    'Position',[px,py+60,95,15],'String','OP System','HorizontalAlignment','left');

handles.hFolderName = uicontrol('Parent',hObject,'Style','edit',...
   'String','Current folder','Position',[px,py+30,300,25],'HorizontalAlignment','left',...
   'Callback',@(hObject,eventdata)hFolderName_Callback(hObject,eventdata,guidata(hObject)));

handles.hPlot = uicontrol('Parent',hObject,'Style','togglebutton',...
    'Position',[px+190,py,120,25],'String','hold loaded files',...
    'Callback',@(hObject,eventdata)hPlot_Callback(hObject,eventdata,guidata(hObject)));

%handles.hOpenAll = uicontrol('Parent',hObject,'Style','checkbox',...
%    'Position',[px+70,py,70,25],'string','load all',...
%    'Value',1);

handles.hOpenFolder = uicontrol('Parent',hObject,'Style','pushbutton',...
     'Position',[px-5,py,60,25],'String','Open',...
    'Callback',@(hObject,eventdata)hOpenFolder_Callback(hObject,eventdata,guidata(hObject)));

% handles.hClean = uicontrol('Parent',hObject,'Style','pushbutton',...
%     'Position',[px+220,py,80,25],'String','Clean',...
%     'Callback',@(hObject,eventdata)hClean_Callback(hObject,eventdata,guidata(hObject)));


handles.htext2a=uicontrol('Parent',hObject,'Style','text',...
    'Position',[px-5,py-20,340,15],'string','-------------------------------Plot Multiple Data ------------------------',...
    'HorizontalAlignment','left');

handles.hHideLoops = uicontrol('Parent',hObject,'Style','checkbox',...
    'Position',[px-5,py-40,220,15],'String','Hide Loops - Show only their average',...
    'Value',0);

handles.hPlotMult = uicontrol('Parent',hObject,'Style','pushbutton',...
    'Position',[px+230,py-80,80,25],'String','Multiple Plot',...
    'Callback',@(hObject,eventdata)hPlot_Multiple_Callback(hObject,eventdata,guidata(hObject)));

handles.sttext=uicontrol('Parent',hObject,'Style','text',...
    'Position',[px-5,py-63,110,15],'string','Experiment Type:','HorizontalAlignment','left');
handles.hFileType = uicontrol('Parent',hObject,'Style','popup',...
    'Position',[px+110,py-60,110,15],'String',{'CLAM','Bias Spec.'});

handles.artext=uicontrol('Parent',hObject,'Style','text',...
    'Position',[px-5,py-85,110,15],'string','Files: (5,9;3:7;x2,5;all)','HorizontalAlignment','left');
handles.hFiles=uicontrol('Parent',hObject,'Style','edit',...
    'Position',[px+110,py-85,110,15],'string','1,2','Callback',...
    'StrValue=get(gcbo,''String'')');
%-------------------------------------------------------------------------%
px = 20;
py = -70;

handles.hFileList = uicontrol('Parent',hObject,'Style','listbox',...
    'Position',[px,py+320,300,240],'String','File list','Min',1,'Max',10,...
    'Callback',@(hObject,eventdata)hFileList_Callback(hObject,eventdata,guidata(hObject)));

handles.hInfoList = uicontrol('Parent',hObject,'Style','listbox',...
    'Position',[px,py+20,300,280],'String','File info list');


% Choose default command line output for DAT_Combine_Channels
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

end
% ------------------------------ GUI CALL BACK ----------------------------

function hFolderName_Callback(hObject, eventdata, handles)
% hObject    handle to hFolderName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of hFolderName as text
%        str2double(get(hObject,'String')) returns contents of hFolderName as a double
loadFiles(hObject,handles)
showFiles(hObject,eventdata,handles)
guidata(hObject,handles);
end
% --- Executes on button press in hOpenFolder.
function hOpenFolder_Callback(hObject, eventdata, handles)
% hObject    handle to hOpenFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% input file names

startFolderName = sprintf('%s%s',handles.hFolderName.UserData,handles.hSystem.UserData);
%startFolderName = sprintf('%s%s',handles.hOpenFolder.UserData,handles.hSystem.UserData);

folderName = uigetdir(startFolderName,'Select DAT folder');
if isequal(folderName,0)
    fprintf('no folder selected \n');
    return
end
folderName = sprintf('%s%s',folderName,handles.hSystem.UserData);
handles.hFolderName.String = folderName;

guidata(hObject,handles);
loadFiles(hObject,handles)
end
% --- Executes on selection change in hFileList.
function hFileList_Callback(hObject, eventdata, handles)
% hObject    handle to hFileList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns hFileList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from hFileList
%hDATLoad_Callback(hObject, eventdata, handles)
showFiles(hObject,eventdata,handles);
end
% ------------------------------ USER FUNCTIONS ---------------------------

function loadFiles(hObject,handles)

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
%check if hold loaded files button is active
%if yes append data using ll=numel(files)
%else set replace string of file names and set ll=0
if handles.hPlot.Value 
    ll=numel(handles.hFileList.UserData);
else
    % clear listbox
    handles.hFileList.String = '';
    userData = struct('datFile',[]);
    ll=0;
end
progress = linspace(1/numel(fileNames),1,numel(fileNames));
wbar = waitbar(0,'searching DAT measurements');
kk = 1;
s = cell(numel(fileNames),1);
for ii = 1:numel(fileNames)
    wbar = waitbar(progress(ii),wbar);
    datFile = dat.load.loadProcessedDat (...
            sprintf('%s%s',folderName,fileNames(ii).name));
        
    userData(ll+kk).datFile = datFile;
    s{kk} = strcat(handles.hFolderName.String(end-10:end),fileNames(ii).name);
    kk = kk +1;
end
if ll>0 %reload data into userData.datFile
    for ii=1:ll
        userData(ii).datFile=handles.hFileList.UserData(ii).datFile;
    end
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
handles.hFileList.String = vertcat(handles.hFileList.String,s);
guidata(hObject, handles);
end

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

allFig = findobj('Tag',handles.hFileList.String{handles.hFileList.Value});
if ~isempty(allFig) && ~newLoad % if already loaded show already created plots
    figure(allFig);
    return
end

f = figure('Tag',handles.hFileList.String{handles.hFileList.Value},...
    'WindowStyle','Docked');

nCh = numel(userData.datFile.channels);
[nRow,nCol] = utility.fitFig2Screen(nCh-1,f);


for iCh = nCh:-1:2
    sp = subplot(nCol,nRow,iCh-1);
    sp_outPos =  get(gca,'OuterPosition');
    
    p = dat.plot.plotChannel(userData.datFile,userData.datFile.channels(iCh));
    
    set(sp,'OuterPosition',sp_outPos);
    set(sp,'FontSize',9)
    
    set(p,'ButtonDownFcn',@(hObject,eventdata)plotThis(hObject,eventdata,handles,userData,iCh,1,1))
    set(sp,'ButtonDownFcn',@(hObject,eventdata)plotThis(hObject,eventdata,handles,userData,iCh,1,1))
end
guidata(hObject, handles);
end
%%
%CLAM process functions
function [fit]=qr_fit(A,b)
[q,r]=qr(A);
disp('qr')
size(q)
size(b)
fit=linsolve(r,transpose(q)*b.');
end

function [indexes]=energy_index(range,energy)
n=size(energy,1);
indexes=[];
for i=1:n
    if (energy(i,1)>=range(1) && energy(i,1)<=range(2))
    indexes=[indexes,i];
    end
end
end

function [indexes]=same_current_index(range,current)
n=size(current,2);
indexes=[];
for i=1:n
    if (current(i)>=range(1) && current(i)<=range(2))
    indexes=[indexes,i];
    end
end
end

function [xdata,av_data]=average_data(energy,data)
%averages ydata for each energy (xdata)
%xdata,ydata in any order
n=size(data,2);
[x,index]=sort(energy);
data=data(index);
xdata=[x(1)];
for i=2:n
    if(x(i)>x(i-1))
        xdata=[xdata,x(i)];
    end
end
av_data=[];
m=length(xdata);
for i=1:m
    amount=0.0;
    sum=0;
    for j=1:n
        if(x(j)==xdata(i))
            amount=amount+1;
            sum=sum+data(j);
        end
    end
    av_data=[av_data,sum/amount];
end
end

function [indexes]=remove_zeros(data)
n=size(data,1);
indexes=[];
for i=1:n
    if (data(i,1)>0)
    indexes=[indexes,i];
    end
end
end

%%
function hPlot_Multiple_Callback(hObject,eventdata,handles)
%plots multiple files on same plots-similar code to showfiles fct.
files=handles.hFileList.String;
n=length(files);
expfiles=[];
exp=handles.hFileType.Value; %experiment type (clam=1,Bias-spec=2)
asked=get(handles.hFiles,'string'); %user multiple plot entry
for i=1:n %get all files with same experiment
    if (exp==1 && ~isempty(strfind(files{i},'clam')))
        expfiles=[expfiles,i];   
    elseif (exp==2 && ~isempty(strfind(files{i},'Bias')))
        expfiles=[expfiles,i];
    end
end
%Read user inputs all and x prefix
if (length(asked)==3 && ~isempty(strfind(asked,'all'))) %open all files
    fi_ind=expfiles;
elseif (asked(1)=='x')%not input i.e x4,7 means plot all files except 4&7
    ind=str2num(asked(2:end));
    expfiles(ind)=[];
    fi_ind=expfiles;
else
    asked=str2num(asked);
    fi_ind=expfiles(asked);
end
newLoad = true;
userData=[];
hdlg = helpdlg('Multiple Plot');
fi_names={};
noloops=get(handles.hHideLoops,'Value'); %check if user wants to plot loops
for i=1:length(fi_ind)    
    %folderName = handles.hFolderName.String;
    fileName =files{fi_ind(i)}; 
    userData = [userData,handles.hFileList.UserData(fi_ind)];
    [lgth,lps]=size(userData(i).datFile.channels(1).data);
    %Get string array with correct names in correct order for the legend
    if (lps>1 && noloops==0)
        for j=1:lps 
            str=strcat(fileName(1:end-4),'-l',num2str(j),'..'); 
            fi_names{end+1}= str(1:length(fileName)); 
        end
        fi_names{end+1}=strcat(fileName(1:end-4),'-avg');%average of loops
    elseif (lps>1 && noloops==1)
        fi_names{end+1}=strcat(fileName(1:end-4),'-avg');%average of loops
    else
        fi_names{end+1}=fileName; 
    end
    
end
close(hdlg);

handles.hInfoList.String = '';

fields = fieldnames(userData(1).datFile.header);
s = cell(numel(fields),1);
%get all headers etc. for the plot, here gets from first
for i = 1:numel(fields)
    cc = userData(1).datFile.header.(fields{i});
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

allFig = findobj('Tag',userData(1).datFile.header.file);
if ~isempty(allFig) && ~newLoad
    figure(allFig);
    return
end
f = figure('Tag',userData(1).datFile.header.file,...
    'WindowStyle','Docked');

nCh = numel(userData(1).datFile.channels);
[nRow,nCol] = utility.fitFig2Screen(nCh-1,f);
figure(f) 
cstring =[0         0    1.0000; 1.0000         0         0;...
         0    1.0000         0; 0         0    0.1724;...
    1.0000    0.1034    0.7241; 1.0000    0.8276         0;...
         0    0.3448         0; 0.5172    0.5172    1.0000;...
    0.6207    0.3103    0.2759; 0    1.0000    0.7586;...
         0    0.5172    0.5862; 0         0    0.4828;...
    0.5862    0.8276    0.3103; 0.9655    0.6207    0.8621;...
    0.8276    0.0690    1.0000]; %rgb colour string for plots-15 unique colours
for iCh = nCh:-1:2
    sp = subplot(nCol,nRow,iCh-1);
    set(gca, 'ColorOrder', cstring, 'NextPlot', 'replacechildren');
    sp_outPos =  get(gca,'OuterPosition');
    for j=1:length(fi_ind)
        if (noloops==0)
            p = dat.plot.plotChannel(userData(j).datFile,userData(j).datFile.channels(iCh));           
        else
            p = dat.plot.plotChannel(userData(j).datFile,userData(j).datFile.channels(iCh),'loops',0);
        end
        hold on
    end
    box on
    grid on
    hold off
    set(sp,'OuterPosition',sp_outPos);
    set(sp,'FontSize',8)
    set(p,'ButtonDownFcn',@(hObject,eventdata)plotThis(hObject,eventdata,handles,userData,iCh,fi_ind,fi_names))
    set(sp,'ButtonDownFcn',@(hObject,eventdata)plotThis(hObject,eventdata,handles,userData,iCh,fi_ind,fi_names))
end
end
%%
function hPlot_Callback(hObject, eventdata, handles)
if hObject.Value
    hObject.ForegroundColor=[1,0,0];
    hObject.String = 'HOLD LOADED FILES';
else
    hObject.ForegroundColor=[0,0,0];
    hObject.String = 'hold loaded files';
end
guidata(hObject,handles);
end

function closeViewer(hObject,eventdata,handles)

fprintf('dat viewer closed \n');
delete(hObject);
end

function plotThis(hObject,eventdata,handles,userData,channel,fi_ind,arr_)

cstring =[0         0    1.0000; 1.0000         0         0;...
         0    1.0000         0; 0         0    0.1724;...
    1.0000    0.1034    0.7241; 1.0000    0.8276         0;...
         0    0.3448         0; 0.5172    0.5172    1.0000;...
    0.6207    0.3103    0.2759; 0    1.0000    0.7586;...
         0    0.5172    0.5862; 0         0    0.4828;...
    0.5862    0.8276    0.3103; 0.9655    0.6207    0.8621;...
    0.8276    0.0690    1.0000];%rgb colour string for plots
f = findobj('Tag','ExportFig');
%if ~isempty(f) && handles.hPlot.Value
%    f = f(1);
%    figure(f); hold on;
%else
f = figure;
set(f,'Position',[400 100 512 512],'PaperUnits','Points',...
    'PaperSize',[512,512],'PaperPosition',[0,0,512,512],'Tag','ExportFig');
set(gca, 'ColorOrder', cstring, 'NextPlot', 'replacechildren');
box on
grid on
%end
noloops=get(handles.hHideLoops,'Value'); %check if user wants to plot loop
for i=1:length(fi_ind)
    if (noloops==0)
        p = dat.plot.plotChannel(userData(i).datFile,userData(i).datFile.channels(channel));
    else
        p = dat.plot.plotChannel(userData(i).datFile,userData(i).datFile.channels(channel),'loops',0);
    end
    hold on
    p.Parent.FontSize = 12;
end
if length(fi_ind)>1 %add legend
    leg1=cellstr(arr_);
    legend(leg1,'Interpreter','none');
end
hold off
print(f,'-clipboard','-dbitmap')
disp('copied to clipboard')
end