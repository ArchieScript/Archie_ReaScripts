-- Compress  /  Arc_Function_lua
-- Version: 1.0
-- Provides: [nomain].
----------------------
    
    local 
    path,scr_file = reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions/','Arc_Function_lua.lua';
    
    
    -----------------------------------------
    local file = io.open(path..scr_file,'r');
    if not file then error("  There is no file !!! / Нет файла !!!  "..path,1)end;
    local text = file:read('a')..'\n';
    file:close();
    local header = string.match(text,".-\n%s-\n"):gsub('\n%s-\n',']]\n')..'\n';
    function s(n);return string.rep(" ",n);end;
    for i = 1,100 do;
        text = text:gsub(s(2),s(1));
    end;
    local space = "";
    for i1 = 1, 5 do;  -- " "
        local equality = "";
        for i2 = 1, 100 do; -- "="
            text = string.gsub(text,"%-%-"..space.."%["..equality.."%[.-%]"..equality.."%]",s(1));
            equality = equality.."=";
        end;
        space = space..s(1);
    end;
    text = text:gsub("%-%-.-\n","\n");
    text = text:gsub("local VersionMod.-\n","");
    text = text:gsub("\n",s(1));
    for i = 1,100 do;
        text = text:gsub(s(2),s(1));
    end;
    for var in string.gmatch (text,".") do;
        if var == s(1) then c = (c or 0)+1 else break end;
    end;
    text = text:gsub(s(1),"",c);   
    file = io.open(path..'!!! '..scr_file,"w");
    file:write(header..text);
    file:close();
    -------------