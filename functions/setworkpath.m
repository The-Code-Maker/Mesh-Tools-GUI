function [] = setworkpath()
global workpath
workpath = uigetdir(workpath, 'ѡ����Ŀ¼');
if workpath ~= 0
    save([cd,'\workpath\global_configuration.mat'],'workpath')
else
    workpath = cd;
end
end