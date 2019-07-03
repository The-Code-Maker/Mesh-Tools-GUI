function [flag] = filechecker(pathname,filename)

flag = 0;
dirinfo = dir(pathname);
for n = 3:length(dirinfo)
    if strcmp(dirinfo(n).name,filename)
        flag = 1;
        break
    end
end

end