function [] = mcfdtools()
%MCFD ����MATLAB�ļ���������ѧ����

%
%close all
%
warning off
addpath([cd,'\tools'])
addpath([cd,'\functions'])
addpath(cd)

global workpath figHndl
filename = 'global_configuration.mat';
if filechecker([cd,'\workpath'],filename)
    load([cd,'\workpath\',filename])
else
    if isempty(dir([cd,'\workpath']))
        mkdir(cd,'workpath')
    end
    workpath = [cd,'\workpath'];      %Ĭ�Ϲ���Ŀ¼
end

%
figHndl = figure('Name','MCFDTools','NumberTitle','off',...
    'Resize','off',...
    'Color',192/255*[1 1 1],...
    'CloseRequestFcn','quitfun()');
delete(allchild(figHndl));

mfileHndl = uimenu(figHndl,'Label','�ļ�');
uimenu(mfileHndl,'Label','���ù���Ŀ¼','Callback','setworkpath()');
uimenu(mfileHndl,'Label','�˳�','Callback','global figHndl;close(figHndl)',...
    'Separator','on');

mfunHndl = uimenu(figHndl,'Label','����');
uimenu(mfunHndl,'Label','��������','Callback','masssolver()');
uimenu(mfunHndl,'Label','���񻮷ֹ���','Callback','gridsolver()',...
    'Separator','on');

uimenu(mfunHndl,'Label','�����������','Callback','simanalyzer()',...
    'Separator','on');

end