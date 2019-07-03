function [] = clearfigure( figHndl )
delete(findall(allchild(figHndl),'Type','UIControl'));
delete(findall(allchild(figHndl),'Type','UIPanel'));
delete(findall(allchild(figHndl),'Type','UIButtonGroup'));
delete(findall(allchild(figHndl),'Type','UIToolBar'));
delete(findall(allchild(gcf),'Type','Axes'))
end

