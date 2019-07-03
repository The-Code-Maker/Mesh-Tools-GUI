function [] = simanalyzer(arg1,arg2)

%工作路径
global workpath figHndl
%主程序
if nargin < 1
    arg1 = 'start';
end
k1 = 560/1200;
k2 = 420/700;
if strcmp(arg1,'start')
    %清空图形界面
    scrsize = get(0,'ScreenSize');
    scrweidth = scrsize(3)-scrsize(1);
    scrheigth = scrsize(4)-scrsize(2);
    w = 1200;
    h = 700;
    set(figHndl,'Position',[(scrweidth-w)/2,(scrheigth-h)/2,w,h]);
    clearfigure(figHndl)
    %----------------设置主界面-------------------%
    toolHndl = uitoolbar(figHndl,...
        'Tag','ToolBar');
    tfHndl = figure('Visible','off');
    ttHndl = findall(allchild(tfHndl),'Type','UITool');
    tzHndl = findall(allchild(ttHndl),'Tag','Exploration.ZoomIn');
    uitoggletool(toolHndl,'TooltipString','缩放',...
        'CData',tzHndl.CData,...
        'ClickedCallback',tzHndl.ClickedCallback)
    delete(tfHndl)
    set(figHndl,'Name','MCFDTools-仿真输出分析')
    %%
    %--------------------------------侧边控制按钮--------------------------------
    uicontrol( ...
        'Style','frame', ...
        'Units','normalized', ...
        'Position',[1-0.03-0.19*k1,0.03,0.19*k1,0.94], ...
        'BackgroundColor',[0.50 0.50 0.50]);
    uicontrol(...
        'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',[0.89,0.85,0.15*k1,0.1*k2], ...
        'String','分析', ...
        'FontSize',10, ...
        'FontName','Microsoft YaHei', ...
        'Callback', 'simanalyzer(''analyze'')');
    uicontrol(...
        'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',[0.89,0.2,0.15*k1,0.1*k2], ...
        'String','关于', ...
        'FontSize',10, ...
        'FontName','Microsoft YaHei', ...
        'Callback', 'simanalyzer(''about'')');
    uicontrol(...
        'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',[0.89,0.1,0.15*k1,0.1*k2], ...
        'String','退出', ...
        'FontSize',10, ...
        'FontName','Microsoft YaHei', ...
        'Callback', 'simanalyzer(''quit'')');
    %%
    %设置
    panelHndl = uipanel(...
        'Visible','on',...
        'Position',[0.02 0.85 0.4*k1 0.2*k2],...
        'BackgroundColor',192/255*[1 1 1],...
        'Title','设置',...
        'FontSize',10,...
        'ForegroundColor','b',...
        'FontName','Microsoft YaHei');
    h = 0.4;
    w = 0.4;
    starth = 0.5;
    space = 0.01;
    uicontrol(panelHndl,...
        'Style','text',...
        'String','输出文件个数',...
        'Units','normalized', ...
        'BackgroundColor',192/255*[1 1 1],...
        'FontSize',10,...
        'ForegroundColor','k',...
        'FontName','Microsoft YaHei', ...
        'Position',[0.05,starth,w,h],...
        'HorizontalAlignment','Left')
    uicontrol(panelHndl,...
        'Style','popupmenu',...
        'String',{'1';'2';'3';'4';'5';'6'},...
        'Units','normalized', ...
        'BackgroundColor','w',...
        'FontSize',10,...
        'ForegroundColor','k',...
        'FontName','Microsoft YaHei', ...
        'Position',[0.05,starth-h-space,w,h],...
        'HorizontalAlignment','Left',...
        'Callback','simanalyzer(''num'')',...
        'Tag','Num')
    %%
    filename = 'analyze_configuration.mat';
    if filechecker(workpath,filename)
        load([workpath,'\',filename])
    else
        path = cell(6,1);
        for n = 1:6
            path{n} = cd;
        end
        label = 1;
    end
    uicontrol(panelHndl,...
        'Style','text',...
        'String','数据起始下标',...
        'Units','normalized', ...
        'BackgroundColor',192/255*[1 1 1],...
        'FontSize',10,...
        'ForegroundColor','k',...
        'FontName','Microsoft YaHei', ...
        'Position',[0.05+w+5*space,starth,w,h],...
        'HorizontalAlignment','Left')
    uicontrol(panelHndl,...
        'Style','edit',...
        'String',num2str(label),...
        'Units','normalized', ...
        'BackgroundColor','w',...
        'FontSize',10,...
        'ForegroundColor','k',...
        'FontName','Microsoft YaHei', ...
        'Position',[0.05+w+5*space,starth-h-space,w,h],...
        'HorizontalAlignment','Left',...
        'Callback','simanalyzer(''num'')',...
        'Tag','Label')
    
    %%    
    panelHndl = uipanel(...
        'Visible','on',...
        'Position',[0.02 0.4 0.4*k1 0.73*k2],...
        'BackgroundColor',192/255*[1 1 1],...
        'Title','文件选择',...
        'FontSize',10,...
        'ForegroundColor','b',...
        'FontName','Microsoft YaHei');
    h = 0.11;
    w = 0.38;
    starth = 0.86;
    space = 0.05;
    uicontrol(panelHndl,...
        'Style','edit',...
        'String',path{1},...
        'Units','normalized', ...
        'BackgroundColor','w',...
        'FontSize',10,...
        'ForegroundColor','k',...
        'FontName','Microsoft YaHei', ...
        'Position',[0.05,starth,w*1.85,h],...
        'HorizontalAlignment','Left',...
        'Tag','Path1')
    uicontrol(panelHndl,...
        'Style','pushbutton',...
        'String','选择',...
        'Units','normalized',...
        'FontSize',10,...
        'ForegroundColor','k',...
        'FontName','Microsoft YaHei', ...
        'Position',[0.05+1.8*w+space,starth,w/2,h],...
        'HorizontalAlignment','Left',...
        'Callback','simanalyzer(''choose'',''1'')')
    
    %%
    uipanel( ...
        'Title','可视化窗口', ...
        'FontSize',10,...
        'Units','normalized', ...
        'Position',[0.22,0.03,0.65,0.94], ...
        'BackgroundColor',192/255*[1 1 1],...
        'ForegroundColor','b',...
        'FontName','Microsoft YaHei');
elseif strcmp(arg1,'choose')
    temp = findall(allchild(figHndl),'Tag',['Path',arg2]);
    path = temp.String;
    pos = regexp(path,'\');
    curpath = cd;
    cd(path(1:pos(end)))
    [filename, pathname] = uigetfile('*.dat', '选择一个数据文件');
    if ~isequal(filename,0)
        temp.String = [pathname,filename];
    end
    cd(curpath)
elseif strcmp(arg1,'analyze')
    delete(findall(allchild(gcf),'Type','Axes'))
    temp = findall(allchild(figHndl),'Tag','Num');
    num = str2double(temp.String{temp.Value});
    temp = findall(allchild(figHndl),'Tag','Label');
    label = str2double(temp.String);
    data = cell(num,1);
    path = cell(num,1);
    for n = 1:num
        temp = findall(allchild(figHndl),'Tag',['Path',num2str(n)]);
        path{n} = temp.String;
        try
            data{n} = load(path{n});
        catch
            scrsize = get(0,'ScreenSize');
            scrweidth = scrsize(3)-scrsize(1);
            scrheigth = scrsize(4)-scrsize(2);
            w = 224;
            h = 100;
            figure('Position',[(scrweidth-w)/2,(scrheigth-h)/2,w,h],...
                'Menubar','none',...
                'NumberTitle','off',...
                'Name','MCFDTools',...
                'Color',192/255*[1 1 1],...
                'Resize','off');
            uicontrol('Style','text',...
                'String',['读取第',num2str(n),'个数据失败!'],...
                'FontSize',10,...
                'Fontname','Microsoft YaHei',...
                'Units','normalized', ...
                'Position',[0.01,0.65,0.98,0.2],...
                'BackgroundColor',192/255*[1 1 1]);
            uicontrol('Style','pushbutton',...
                'String','确认',...
                'FontSize',10,...
                'Fontname','Microsoft YaHei',...
                'Units','normalized', ...
                'Position',[0.35,0.2,0.3,0.3],...
                'Callback','close(gcf)');
            return
        end
    end
    col = size(data{1},2);
    for n = 2:num
        if size(data{n},2) ~= col
            scrsize = get(0,'ScreenSize');
            scrweidth = scrsize(3)-scrsize(1);
            scrheigth = scrsize(4)-scrsize(2);
            w = 224;
            h = 100;
            figure('Position',[(scrweidth-w)/2,(scrheigth-h)/2,w,h],...
                'Menubar','none',...
                'NumberTitle','off',...
                'Name','MCFDTools',...
                'Color',192/255*[1 1 1],...
                'Resize','off');
            uicontrol('Style','text',...
                'String',['第',num2str(n),'个数据大小异常!'],...
                'FontSize',10,...
                'Fontname','Microsoft YaHei',...
                'Units','normalized', ...
                'Position',[0.01,0.65,0.98,0.2],...
                'BackgroundColor',192/255*[1 1 1]);
            uicontrol('Style','pushbutton',...
                'String','确认',...
                'FontSize',10,...
                'Fontname','Microsoft YaHei',...
                'Units','normalized', ...
                'Position',[0.35,0.2,0.3,0.3],...
                'Callback','close(gcf)');
            return
        end
    end
    temp = findall(allchild(figHndl),'Title','可视化窗口');
    for n = 1:col-1
        w = 0.25;
        h = 0.36;
        space = 0.06;
        starth = 0.57;
        if n <= 3
            axHndl{n} = axes(temp,'Units','normalized', ...
                'Position',[space+(n-1)*(w+space),starth,w,h]);
            box on; grid on; hold on;
        elseif n <= 6
            axHndl{n} = axes(temp,'Units','normalized', ...
                'Position',[space+(n-4)*(w+space),starth-h-2*space,w,h]);
            box on; grid on; hold on;
        end
    end
    colorscheme = ['b';'g';'r';'c';'m';'y';'k';'w'];
    %linestyle = ['.';'o';'x';'+';'s';'d';'v';'^'];
    leg = {'数据1'};
    for m = 2:num
       leg =  {leg{1:end},['数据',num2str(m)]};
    end
    for n = 1:col-1
        if n > 6
            break
        end
        for m = 1:num
            plot(axHndl{n},data{m}(label:end,1),data{m}(label:end,n+1),'Color',colorscheme(m),'LineWidth',1.2)
            %plot(axHndl{n},data{n}(:,n),'Color',colorscheme(m),'Marker',linestyle(m))
        end
        legend(axHndl{n},leg{1:end});
        title(axHndl{n},['分析窗口',num2str(n)])
    end
    filename = 'analyze_configuration.mat';
    save([workpath,'\',filename],'path','label');
    figure(figHndl)
elseif strcmp(arg1,'quit')
    clearfigure(figHndl)
    figHndl.Name = 'MCFDTools';
elseif strcmp(arg1,'num')
    filename = 'analyze_configuration.mat';
    if filechecker(workpath,filename)
        load([workpath,'\',filename])
    else
        path = cell(6,1);
        for n = 1:6
            path{n} = cd;
        end
    end
    delete(findall(allchild(figHndl),'Title','文件选择'));
    temp = findall(allchild(figHndl),'Tag','Num');
    num = str2double(temp.String{temp.Value});
    panelHndl = uipanel(...
        'Visible','on',...
        'Position',[0.02 0.4 0.4*k1 0.73*k2],...
        'BackgroundColor',192/255*[1 1 1],...
        'Title','文件选择',...
        'FontSize',10,...
        'ForegroundColor','b',...
        'FontName','Microsoft YaHei');
    h = 0.11;
    w = 0.38;
    starth = 0.86;
    space = 0.05;
    if length(path) < num
        for n = length(path)+1:num
            path{n}  = cd;
        end
    end
    switch num
        case 1
            uicontrol(panelHndl,...
                'Style','edit',...
                'String',path{1},...
                'Units','normalized', ...
                'BackgroundColor','w',...
                'FontSize',10,...
                'ForegroundColor','k',...
                'FontName','Microsoft YaHei', ...
                'Position',[0.05,starth-(1-1)*(h+space),w*1.85,h],...
                'HorizontalAlignment','Left',...
                'Tag',['Path',num2str(1)])
            uicontrol(panelHndl,...
                'Style','pushbutton',...
                'String','选择',...
                'Units','normalized',...
                'FontSize',10,...
                'ForegroundColor','k',...
                'FontName','Microsoft YaHei', ...
                'Position',[0.05+1.8*w+space,starth-(1-1)*(h+space),w/2,h],...
                'HorizontalAlignment','Left',...
                'Callback','simanalyzer(''choose'',''1'')')
        case 2
            uicontrol(panelHndl,...
                'Style','edit',...
                'String',path{1},...
                'Units','normalized', ...
                'BackgroundColor','w',...
                'FontSize',10,...
                'ForegroundColor','k',...
                'FontName','Microsoft YaHei', ...
                'Position',[0.05,starth-(1-1)*(h+space),w*1.85,h],...
                'HorizontalAlignment','Left',...
                'Tag',['Path',num2str(1)])
            uicontrol(panelHndl,...
                'Style','pushbutton',...
                'String','选择',...
                'Units','normalized',...
                'FontSize',10,...
                'ForegroundColor','k',...
                'FontName','Microsoft YaHei', ...
                'Position',[0.05+1.8*w+space,starth-(1-1)*(h+space),w/2,h],...
                'HorizontalAlignment','Left',...
                'Callback','simanalyzer(''choose'',''1'')')
            uicontrol(panelHndl,...
                'Style','edit',...
                'String',path{2},...
                'Units','normalized', ...
                'BackgroundColor','w',...
                'FontSize',10,...
                'ForegroundColor','k',...
                'FontName','Microsoft YaHei', ...
                'Position',[0.05,starth-(2-1)*(h+space),w*1.85,h],...
                'HorizontalAlignment','Left',...
                'Tag',['Path',num2str(2)])
            uicontrol(panelHndl,...
                'Style','pushbutton',...
                'String','选择',...
                'Units','normalized',...
                'FontSize',10,...
                'ForegroundColor','k',...
                'FontName','Microsoft YaHei', ...
                'Position',[0.05+1.8*w+space,starth-(2-1)*(h+space),w/2,h],...
                'HorizontalAlignment','Left',...
                'Callback','simanalyzer(''choose'',''2'')')
        case 3
            uicontrol(panelHndl,...
                'Style','edit',...
                'String',path{1},...
                'Units','normalized', ...
                'BackgroundColor','w',...
                'FontSize',10,...
                'ForegroundColor','k',...
                'FontName','Microsoft YaHei', ...
                'Position',[0.05,starth-(1-1)*(h+space),w*1.85,h],...
                'HorizontalAlignment','Left',...
                'Tag',['Path',num2str(1)])
            uicontrol(panelHndl,...
                'Style','pushbutton',...
                'String','选择',...
                'Units','normalized',...
                'FontSize',10,...
                'ForegroundColor','k',...
                'FontName','Microsoft YaHei', ...
                'Position',[0.05+1.8*w+space,starth-(1-1)*(h+space),w/2,h],...
                'HorizontalAlignment','Left',...
                'Callback','simanalyzer(''choose'',''1'')')
            uicontrol(panelHndl,...
                'Style','edit',...
                'String',path{2},...
                'Units','normalized', ...
                'BackgroundColor','w',...
                'FontSize',10,...
                'ForegroundColor','k',...
                'FontName','Microsoft YaHei', ...
                'Position',[0.05,starth-(2-1)*(h+space),w*1.85,h],...
                'HorizontalAlignment','Left',...
                'Tag',['Path',num2str(2)])
            uicontrol(panelHndl,...
                'Style','pushbutton',...
                'String','选择',...
                'Units','normalized',...
                'FontSize',10,...
                'ForegroundColor','k',...
                'FontName','Microsoft YaHei', ...
                'Position',[0.05+1.8*w+space,starth-(2-1)*(h+space),w/2,h],...
                'HorizontalAlignment','Left',...
                'Callback','simanalyzer(''choose'',''2'')')
            uicontrol(panelHndl,...
                'Style','edit',...
                'String',path{3},...
                'Units','normalized', ...
                'BackgroundColor','w',...
                'FontSize',10,...
                'ForegroundColor','k',...
                'FontName','Microsoft YaHei', ...
                'Position',[0.05,starth-(3-1)*(h+space),w*1.85,h],...
                'HorizontalAlignment','Left',...
                'Tag',['Path',num2str(3)])
            uicontrol(panelHndl,...
                'Style','pushbutton',...
                'String','选择',...
                'Units','normalized',...
                'FontSize',10,...
                'ForegroundColor','k',...
                'FontName','Microsoft YaHei', ...
                'Position',[0.05+1.8*w+space,starth-(3-1)*(h+space),w/2,h],...
                'HorizontalAlignment','Left',...
                'Callback','simanalyzer(''choose'',''3'')')
        case 4
            uicontrol(panelHndl,...
                'Style','edit',...
                'String',path{1},...
                'Units','normalized', ...
                'BackgroundColor','w',...
                'FontSize',10,...
                'ForegroundColor','k',...
                'FontName','Microsoft YaHei', ...
                'Position',[0.05,starth-(1-1)*(h+space),w*1.85,h],...
                'HorizontalAlignment','Left',...
                'Tag',['Path',num2str(1)])
            uicontrol(panelHndl,...
                'Style','pushbutton',...
                'String','选择',...
                'Units','normalized',...
                'FontSize',10,...
                'ForegroundColor','k',...
                'FontName','Microsoft YaHei', ...
                'Position',[0.05+1.8*w+space,starth-(1-1)*(h+space),w/2,h],...
                'HorizontalAlignment','Left',...
                'Callback','simanalyzer(''choose'',''1'')')
            uicontrol(panelHndl,...
                'Style','edit',...
                'String',path{2},...
                'Units','normalized', ...
                'BackgroundColor','w',...
                'FontSize',10,...
                'ForegroundColor','k',...
                'FontName','Microsoft YaHei', ...
                'Position',[0.05,starth-(2-1)*(h+space),w*1.85,h],...
                'HorizontalAlignment','Left',...
                'Tag',['Path',num2str(2)])
            uicontrol(panelHndl,...
                'Style','pushbutton',...
                'String','选择',...
                'Units','normalized',...
                'FontSize',10,...
                'ForegroundColor','k',...
                'FontName','Microsoft YaHei', ...
                'Position',[0.05+1.8*w+space,starth-(2-1)*(h+space),w/2,h],...
                'HorizontalAlignment','Left',...
                'Callback','simanalyzer(''choose'',''2'')')
            uicontrol(panelHndl,...
                'Style','edit',...
                'String',path{3},...
                'Units','normalized', ...
                'BackgroundColor','w',...
                'FontSize',10,...
                'ForegroundColor','k',...
                'FontName','Microsoft YaHei', ...
                'Position',[0.05,starth-(3-1)*(h+space),w*1.85,h],...
                'HorizontalAlignment','Left',...
                'Tag',['Path',num2str(3)])
            uicontrol(panelHndl,...
                'Style','pushbutton',...
                'String','选择',...
                'Units','normalized',...
                'FontSize',10,...
                'ForegroundColor','k',...
                'FontName','Microsoft YaHei', ...
                'Position',[0.05+1.8*w+space,starth-(3-1)*(h+space),w/2,h],...
                'HorizontalAlignment','Left',...
                'Callback','simanalyzer(''choose'',''3'')')
            uicontrol(panelHndl,...
                'Style','edit',...
                'String',path{4},...
                'Units','normalized', ...
                'BackgroundColor','w',...
                'FontSize',10,...
                'ForegroundColor','k',...
                'FontName','Microsoft YaHei', ...
                'Position',[0.05,starth-(4-1)*(h+space),w*1.85,h],...
                'HorizontalAlignment','Left',...
                'Tag',['Path',num2str(4)])
            uicontrol(panelHndl,...
                'Style','pushbutton',...
                'String','选择',...
                'Units','normalized',...
                'FontSize',10,...
                'ForegroundColor','k',...
                'FontName','Microsoft YaHei', ...
                'Position',[0.05+1.8*w+space,starth-(4-1)*(h+space),w/2,h],...
                'HorizontalAlignment','Left',...
                'Callback','simanalyzer(''choose'',''4'')')
        case 5
            uicontrol(panelHndl,...
                'Style','edit',...
                'String',path{1},...
                'Units','normalized', ...
                'BackgroundColor','w',...
                'FontSize',10,...
                'ForegroundColor','k',...
                'FontName','Microsoft YaHei', ...
                'Position',[0.05,starth-(1-1)*(h+space),w*1.85,h],...
                'HorizontalAlignment','Left',...
                'Tag',['Path',num2str(1)])
            uicontrol(panelHndl,...
                'Style','pushbutton',...
                'String','选择',...
                'Units','normalized',...
                'FontSize',10,...
                'ForegroundColor','k',...
                'FontName','Microsoft YaHei', ...
                'Position',[0.05+1.8*w+space,starth-(1-1)*(h+space),w/2,h],...
                'HorizontalAlignment','Left',...
                'Callback','simanalyzer(''choose'',''1'')')
            uicontrol(panelHndl,...
                'Style','edit',...
                'String',path{2},...
                'Units','normalized', ...
                'BackgroundColor','w',...
                'FontSize',10,...
                'ForegroundColor','k',...
                'FontName','Microsoft YaHei', ...
                'Position',[0.05,starth-(2-1)*(h+space),w*1.85,h],...
                'HorizontalAlignment','Left',...
                'Tag',['Path',num2str(2)])
            uicontrol(panelHndl,...
                'Style','pushbutton',...
                'String','选择',...
                'Units','normalized',...
                'FontSize',10,...
                'ForegroundColor','k',...
                'FontName','Microsoft YaHei', ...
                'Position',[0.05+1.8*w+space,starth-(2-1)*(h+space),w/2,h],...
                'HorizontalAlignment','Left',...
                'Callback','simanalyzer(''choose'',''2'')')
            uicontrol(panelHndl,...
                'Style','edit',...
                'String',path{3},...
                'Units','normalized', ...
                'BackgroundColor','w',...
                'FontSize',10,...
                'ForegroundColor','k',...
                'FontName','Microsoft YaHei', ...
                'Position',[0.05,starth-(3-1)*(h+space),w*1.85,h],...
                'HorizontalAlignment','Left',...
                'Tag',['Path',num2str(3)])
            uicontrol(panelHndl,...
                'Style','pushbutton',...
                'String','选择',...
                'Units','normalized',...
                'FontSize',10,...
                'ForegroundColor','k',...
                'FontName','Microsoft YaHei', ...
                'Position',[0.05+1.8*w+space,starth-(3-1)*(h+space),w/2,h],...
                'HorizontalAlignment','Left',...
                'Callback','simanalyzer(''choose'',''3'')')
            uicontrol(panelHndl,...
                'Style','edit',...
                'String',path{4},...
                'Units','normalized', ...
                'BackgroundColor','w',...
                'FontSize',10,...
                'ForegroundColor','k',...
                'FontName','Microsoft YaHei', ...
                'Position',[0.05,starth-(4-1)*(h+space),w*1.85,h],...
                'HorizontalAlignment','Left',...
                'Tag',['Path',num2str(4)])
            uicontrol(panelHndl,...
                'Style','pushbutton',...
                'String','选择',...
                'Units','normalized',...
                'FontSize',10,...
                'ForegroundColor','k',...
                'FontName','Microsoft YaHei', ...
                'Position',[0.05+1.8*w+space,starth-(4-1)*(h+space),w/2,h],...
                'HorizontalAlignment','Left',...
                'Callback','simanalyzer(''choose'',''4'')')
            uicontrol(panelHndl,...
                'Style','edit',...
                'String',path{5},...
                'Units','normalized', ...
                'BackgroundColor','w',...
                'FontSize',10,...
                'ForegroundColor','k',...
                'FontName','Microsoft YaHei', ...
                'Position',[0.05,starth-(5-1)*(h+space),w*1.85,h],...
                'HorizontalAlignment','Left',...
                'Tag',['Path',num2str(5)])
            uicontrol(panelHndl,...
                'Style','pushbutton',...
                'String','选择',...
                'Units','normalized',...
                'FontSize',10,...
                'ForegroundColor','k',...
                'FontName','Microsoft YaHei', ...
                'Position',[0.05+1.8*w+space,starth-(5-1)*(h+space),w/2,h],...
                'HorizontalAlignment','Left',...
                'Callback','simanalyzer(''choose'',''5'')')
        case 6
            uicontrol(panelHndl,...
                'Style','edit',...
                'String',path{1},...
                'Units','normalized', ...
                'BackgroundColor','w',...
                'FontSize',10,...
                'ForegroundColor','k',...
                'FontName','Microsoft YaHei', ...
                'Position',[0.05,starth-(1-1)*(h+space),w*1.85,h],...
                'HorizontalAlignment','Left',...
                'Tag',['Path',num2str(1)])
            uicontrol(panelHndl,...
                'Style','pushbutton',...
                'String','选择',...
                'Units','normalized',...
                'FontSize',10,...
                'ForegroundColor','k',...
                'FontName','Microsoft YaHei', ...
                'Position',[0.05+1.8*w+space,starth-(1-1)*(h+space),w/2,h],...
                'HorizontalAlignment','Left',...
                'Callback','simanalyzer(''choose'',''1'')')
            uicontrol(panelHndl,...
                'Style','edit',...
                'String',path{2},...
                'Units','normalized', ...
                'BackgroundColor','w',...
                'FontSize',10,...
                'ForegroundColor','k',...
                'FontName','Microsoft YaHei', ...
                'Position',[0.05,starth-(2-1)*(h+space),w*1.85,h],...
                'HorizontalAlignment','Left',...
                'Tag',['Path',num2str(2)])
            uicontrol(panelHndl,...
                'Style','pushbutton',...
                'String','选择',...
                'Units','normalized',...
                'FontSize',10,...
                'ForegroundColor','k',...
                'FontName','Microsoft YaHei', ...
                'Position',[0.05+1.8*w+space,starth-(2-1)*(h+space),w/2,h],...
                'HorizontalAlignment','Left',...
                'Callback','simanalyzer(''choose'',''2'')')
            uicontrol(panelHndl,...
                'Style','edit',...
                'String',path{3},...
                'Units','normalized', ...
                'BackgroundColor','w',...
                'FontSize',10,...
                'ForegroundColor','k',...
                'FontName','Microsoft YaHei', ...
                'Position',[0.05,starth-(3-1)*(h+space),w*1.85,h],...
                'HorizontalAlignment','Left',...
                'Tag',['Path',num2str(3)])
            uicontrol(panelHndl,...
                'Style','pushbutton',...
                'String','选择',...
                'Units','normalized',...
                'FontSize',10,...
                'ForegroundColor','k',...
                'FontName','Microsoft YaHei', ...
                'Position',[0.05+1.8*w+space,starth-(3-1)*(h+space),w/2,h],...
                'HorizontalAlignment','Left',...
                'Callback','simanalyzer(''choose'',''3'')')
            uicontrol(panelHndl,...
                'Style','edit',...
                'String',path{4},...
                'Units','normalized', ...
                'BackgroundColor','w',...
                'FontSize',10,...
                'ForegroundColor','k',...
                'FontName','Microsoft YaHei', ...
                'Position',[0.05,starth-(4-1)*(h+space),w*1.85,h],...
                'HorizontalAlignment','Left',...
                'Tag',['Path',num2str(4)])
            uicontrol(panelHndl,...
                'Style','pushbutton',...
                'String','选择',...
                'Units','normalized',...
                'FontSize',10,...
                'ForegroundColor','k',...
                'FontName','Microsoft YaHei', ...
                'Position',[0.05+1.8*w+space,starth-(4-1)*(h+space),w/2,h],...
                'HorizontalAlignment','Left',...
                'Callback','simanalyzer(''choose'',''4'')')
            uicontrol(panelHndl,...
                'Style','edit',...
                'String',path{5},...
                'Units','normalized', ...
                'BackgroundColor','w',...
                'FontSize',10,...
                'ForegroundColor','k',...
                'FontName','Microsoft YaHei', ...
                'Position',[0.05,starth-(5-1)*(h+space),w*1.85,h],...
                'HorizontalAlignment','Left',...
                'Tag',['Path',num2str(5)])
            uicontrol(panelHndl,...
                'Style','pushbutton',...
                'String','选择',...
                'Units','normalized',...
                'FontSize',10,...
                'ForegroundColor','k',...
                'FontName','Microsoft YaHei', ...
                'Position',[0.05+1.8*w+space,starth-(5-1)*(h+space),w/2,h],...
                'HorizontalAlignment','Left',...
                'Callback','simanalyzer(''choose'',''5'')')
            uicontrol(panelHndl,...
                'Style','edit',...
                'String',path{6},...
                'Units','normalized', ...
                'BackgroundColor','w',...
                'FontSize',10,...
                'ForegroundColor','k',...
                'FontName','Microsoft YaHei', ...
                'Position',[0.05,starth-(6-1)*(h+space),w*1.85,h],...
                'HorizontalAlignment','Left',...
                'Tag',['Path',num2str(6)])
            uicontrol(panelHndl,...
                'Style','pushbutton',...
                'String','选择',...
                'Units','normalized',...
                'FontSize',10,...
                'ForegroundColor','k',...
                'FontName','Microsoft YaHei', ...
                'Position',[0.05+1.8*w+space,starth-(6-1)*(h+space),w/2,h],...
                'HorizontalAlignment','Left',...
                'Callback','simanalyzer(''choose'',''6'')')
    end
end

end