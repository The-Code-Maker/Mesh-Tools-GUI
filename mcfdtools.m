function [] = mcfdtools()
%MCFD 基于MATLAB的计算流体力学工具

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
    workpath = [cd,'\workpath'];      %默认工作目录
end

%
figHndl = figure('Name','MCFDTools','NumberTitle','off',...
    'Resize','off',...
    'Color',192/255*[1 1 1],...
    'CloseRequestFcn','quitfun()');
delete(allchild(figHndl));

mfileHndl = uimenu(figHndl,'Label','文件');
uimenu(mfileHndl,'Label','设置工作目录','Callback','setworkpath()');
uimenu(mfileHndl,'Label','退出','Callback','global figHndl;close(figHndl)',...
    'Separator','on');

mfunHndl = uimenu(figHndl,'Label','功能');
uimenu(mfunHndl,'Label','质量计算','Callback','masssolver()');
uimenu(mfunHndl,'Label','网格划分工具','Callback','gridsolver()',...
    'Separator','on');

uimenu(mfunHndl,'Label','仿真输出分析','Callback','simanalyzer()',...
    'Separator','on');

end