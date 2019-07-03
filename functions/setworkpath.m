function [] = setworkpath()
global workpath
workpath = uigetdir(workpath, '选择工作目录');
if workpath ~= 0
    save([cd,'\workpath\global_configuration.mat'],'workpath')
else
    workpath = cd;
end
end