function [] = hintbox(str)
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
    'String',str,...
    'FontSize',10,...
    'Fontname','Microsoft YaHei',...
    'Units','normalized', ...
    'Position',[0.01,0.65,0.98,0.2],...
    'BackgroundColor',192/255*[1 1 1]);
uicontrol('Style','pushbutton',...
    'String','ȷ��',...
    'FontSize',10,...
    'Fontname','Microsoft YaHei',...
    'Units','normalized', ...
    'Position',[0.35,0.2,0.3,0.3],...
    'Callback','close(gcf)');
end